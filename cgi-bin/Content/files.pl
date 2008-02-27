sub showDir {
        my $subfolder = param('subfolder') ? param('subfolder') : shift;
        $subfolder = defined $subfolder ? $subfolder : $settings->{cgi}{bin};
        my $r = 0;
        my @t = readFiles($subfolder, 0);
        columns(
                a({href => "$ENV{SCRIPT_NAME}?action=openFile&file=$subfolder&sort=1",     class => "treeviewLink$size"}, 'Name') . '&#160;',
                a({href => "$ENV{SCRIPT_NAME}?action=openFile&file=$subfolder&byColumn=0", class => "treeviewLink$size"}, 'Size') . '&#160;',
                a({href => "$ENV{SCRIPT_NAME}?action=openFile&file=$subfolder&byColumn=1", class => "treeviewLink$size"}, 'Permission') . '&#160;',
                a({href => "$ENV{SCRIPT_NAME}?action=openFile&file=$subfolder&byColumn=2", class => "treeviewLink$size"}, 'Last Modified') . '&#160;'
        );
        border(1);
        if(defined param('byColumn')) {
                orderByColumn(param('byColumn'));
        } elsif (param('sort')) {
                sortTree(1);
        }
        $subfolder =~ s?/$??g;
        my $links = $subfolder =~ ?^(.*/)[^/]+$? ? $1 : $subfolder;
        $links =~ s?//?/?g;
        my $hf = "$ENV{SCRIPT_NAME}?action=openFile&file=$links";
        print div({align => 'center'}, a({href => $hf, class => "treeviewLink$size"}, $links) . br() . Tree(\@t));
        border(0);

        sub readFiles {
                my @TREEVIEW;
                my $dir = shift;
                my $rk  = shift;
                $r++ if($rk);
                if(-d "$dir" && -r "$dir") {
                        opendir DIR, $dir or die "files.pl sub readFiles: $dir $!";
                        foreach my $d (readdir(DIR)) {
                                my $fl = "$dir/$d";
                                use File::stat;
                                my $sb = stat($fl);
                              TYPE: {
                                        last TYPE if($d =~ /^\.+$/);
                                        my $href = "$ENV{SCRIPT_NAME}?action=openFile&file=$fl";
                                        if(-d $fl) {
                                                if($r < 2) {
                                                        push @TREEVIEW,
                                                          {
                                                            text    => $d,
                                                            href    => "$href/",
                                                            subtree => [readFiles($fl, 1)],
                                                            columns => [sprintf("%s", $sb->size), sprintf("%04o", $sb->mode & 07777), sprintf("%s", scalar localtime $sb->mtime)],
                                                            addition =>
                                                              qq(<table border="0" cellpadding="0" cellspacing="0" align="right" summary="layout"><tr><td><a class="treeviewLink$size" href="$href"><img src="/style/$style/$size/mimetypes/edit.png" border="0" alt="edit"/></a></td><td><a class="treeviewLink$size" href="$ENV{SCRIPT_NAME}?action=deleteFile&amp;file=$fl"><img src="/style/$style/$size/mimetypes/editdelete.png" border="0" alt="delete"/></a></td></td></tr></table>)
                                                          };
                                                } else {
                                                        push @TREEVIEW,
                                                          {
                                                            text    => $d,
                                                            href    => "$href/",
                                                            empty   => 1,
                                                            columns => [sprintf("%s", $sb->size), sprintf("%04o", $sb->mode & 07777), sprintf("%s", scalar localtime $sb->mtime)],
                                                            addition =>
                                                              qq(<table border="0" cellpadding="0" cellspacing="0" align="right" summary="layout"><tr><td><a class="treeviewLink$size" href="$href"><img src="/style/$style/$size/mimetypes/edit.png" border="0" alt="edit"/></a></td><td><a class="treeviewLink$size" href="$ENV{SCRIPT_NAME}?action=deleteFile&amp;file=$fl"><img src="/style/$style/$size/mimetypes/editdelete.png" border="0" alt="delete"/></a></td></td></tr></table>)
                                                          };
                                                }
                                                last TYPE;
                                        }
                                        push @TREEVIEW,
                                          {
                                            text    => "$d",
                                            href    => "$href",
                                            columns => [sprintf("%s", $sb->size), sprintf("%04o", $sb->mode & 07777), sprintf("%s", scalar localtime $sb->mtime)],
                                            addition =>
                                              qq(<table border="0" cellpadding="0" cellspacing="0" align="right" summary="layout"><tr><td><a class="treeviewLink$size" href="$href"><img src="/style/$style/$size/mimetypes/edit.png" border="0" alt="edit"/></a></td><td><a class="treeviewLink$size" href="$ENV{SCRIPT_NAME}?action=deleteFile&amp;file=$fl"><img src="/style/$style/$size/mimetypes/editdelete.png" border="0" alt="delete"/></a></td></tr></table>)
                                          }
                                          if(-f $fl);
                                }
                        }
                        $r = 0;
                        return @TREEVIEW;
                }
        }
}

sub openFile {
        my $f = defined param('file') ? param('file') : '';
      SWITCH: {
                if(-d $f) {
                        &showDir($f);
                        last SWITCH;
                }
                if(-T $f) {
                        &showEditor("Edit File: $f<br/>", getFile($f), 'saveFile', $f);
                        last SWITCH;
                }
        }
}

sub newFile {
        my $d = defined param('dir') ? param('dir') : '';
        if(-d $d) {
                &showEditor(qq(Title:<input type="text" value="" name="title"/>), 'add your text', 'saveFile', $d);
        }
}

sub saveFile {
        my $txt  = param('txt');
        my $file = param('file');
        use Fcntl qw(:flock);
        use Symbol;
        my $fh = gensym();
        unless (-d $file) {
                open $fh, ">$file.bak" or warn "files.pl::saveFile $/ $! $/ $file $/";
                flock $fh, 2;
                seek $fh, 0, 0;
                truncate $fh, 0;
                print $fh $txt;
                close $fh;
                rename "$file.bak", $file or warn "files.pl::saveFile $/ $! $/" if(-e "$file.bak");
                chmod(0755, $file) if($file =~ ?\.pl?);
                showDir();
        } elsif (defined param('title') && defined param('file')) {
                my $sf = param('file') . '/' . param('title');
                open $fh, ">$sf.bak" or warn "files.pl::saveFile $/ $! $/ $sf $/";
                flock $fh, 2;
                seek $fh, 0, 0;
                truncate $fh, 0;
                print $fh $txt;
                close $fh;
                rename "$sf.bak", $sf or warn "files.pl::saveFile $/ $! $/" if(-e "$sf.bak");
                showDir();
        }
}

sub showEditor {
        my $h  = shift;
        my $t  = shift;
        my $a  = shift;
        my $fi = shift;
        print qq(</head>
<body>
<form action ="$ENV{SCRIPT_NAME}" method="post">
 <table cellspacing="5" cellpadding="0" border="0" align="center" summary="execSql">
  <tbody>
   <tr>
      <td>$h</td>
    </tr>
    <tr><td><script language="JavaScript1.5" type="text/javascript">html = 1;bbcode = false;printButtons();</script></td></tr>
    <tr>
      <td><textarea name="txt" id="txt" style="width:550px;height:600px;" >$t</textarea></td>
    </tr>
    <tr>
      <td align="right"><input type="submit" value="Save"/>
       <input type="hidden" value="$a" name="action"/>
       <input type="hidden" value="$fi" name="file"/>
      </td>
    </tr>
  </tbody>
</table>
</form>
)
}

sub getFile {
        use Fcntl qw(:flock);
        use Symbol;
        my $fh = gensym;
        my $f  = shift;
        my $err;
        if(-f $f) {
                open $fh, $f or $err = "$!: $f";
                seek $fh, 0, 0;
                my @lines = <$fh>;
                close $fh;
                return "@lines";
        } else {
                return $err;
        }
}
