sub show {
        my %needed = (
                      action       => 'news',
                      start        => $von,
                      end          => $bis,
                      style        => $style,
                      thread       => 'news',
                      id           => 'c',
                      settingsfile => "$settings->{cgi}{bin}/config/config.pl",
                      right        => $right,
                      database     => {host => $settings->{database}{host}, user => $settings->{database}{user}, name => $settings->{database}{name}, password => $settings->{database}{password}}
        );

        use Template::Quick::Thread;
        my $newMessage = translate('newMessage');
        print
          qq(<table align ="center" border ="0" cellpadding ="0" cellspacing="0" summary="layoutMenuItem"><tr><td><img onclick="location.href='#winedit'" src="/style/$style/buttons/new.png" width="20" height="20" border="0" alt="" title="$newMessage" style='cursor:pointer;font-size:14px;vertical-align:bottom;'/></td><td><a class="link" href="#winedit"  style='font-size:14px;vertical-align:bottom;'>$newMessage</a></td></tr></table>)
          if($right >= 1);
        print showThread(\%needed);
        my $catlist = readcats('news');
        my %parameter = (
                         action    => 'addNews',
                         body      => translate('body'),
                         class     => 'max',
                         attach    => $settings->{uploads}{enabled},
                         maxlength => $settings->{news}{maxlength},
                         path      => "$settings->{cgi}{bin}/templates",
                         reply     => 'none',
                         server    => $settings->{cgi}{serverName},
                         style     => $style,
                         thread    => 'news',
                         headline  => translate('headline'),
                         title     => translate('newMessage'),
                         catlist   => $catlist,
                         right     => $right,
                         html      => 0,
        );
        use HTML::Editor;

        my $editor = new HTML::Editor(\%parameter);
        print '<div align="center">';
        print $editor->show() if($right >= 2);
        print '</div>';
}

sub addNews {
        my $sbm = param('submit') ? param('submit') : 'save';
        if(not defined $sbm or ($sbm ne translate('preview'))) {
                if(defined param('message') && defined param('headline') && defined param('thread') && defined param('catlist')) {
                        my $message = param('message');
                        my $max     = $settings->{news}{maxlength};
                        $message = ($message =~ /^(.{3,$max})$/s) ? $1 : 'Invalid body';
                        my $headline = param('headline');
                        $headline = ($headline =~ /^(.{3,100})$/s) ? $1 : 'Invalid headline';
                        my $thread = param('thread');
                        $thread = ($thread =~ /^(\w+)$/) ? $1 : 'trash';
                        my $cat = param('catlist');
                        &saveUpload();
                        my $attach = (defined param('file')) ? (split(/[\\\/]/, param('file')))[-1] : 0;
                        my $cit = (defined $attach) ? $attach =~ /^(\S+)\.[^\.]+$/ ? $1 : 0 : 0;
                        my $type = (defined $attach) ? ($attach =~ /\.([^\.]+)$/) ? $1 : 0 : 0;
                        $cit =~ s/("|'|\s| )//g;
                        my $sra = ($cit && $type) ? "$cit.$type" : undef;
                        my $format = param('format') eq 'on' ? 'html' : 'bbcode';

                        if(defined $headline && defined $message && defined $thread && $right >= 2) {
                                my %message = (title => $headline, body => $message, thread => $thread, user => $user, cat => $cat, attach => $sra, format => $format, ip => remote_addr());
                                $database->addMessage(\%message);
                                print '<div align="center">Nachricht wurde erstellt.<br/></div>';
                        }
                }
                &show();
        } else {
                &preview();
        }
}

sub saveedit {
        if(not defined param('submit') or (param('submit') ne translate('preview'))) {
                my $thread = param('thread');
                $thread = ($thread =~ /^(\w+)$/) ? $1 : 'trash';
                my $id = param('reply');
                $id = ($id =~ /^(\d+)$/) ? $1 : 0;
                my $headline = param('headline');
                $headline = ($headline =~ /^(.{3,50})$/) ? $1 : 0;
                my $body = param('message');
                $body = ($body =~ /^(.{3,$max})$/s) ? $1 : 'Invalid body';
                &saveUpload();
                my $attach = (defined param('file')) ? (split(/[\\\/]/, param('file')))[-1] : 0;
                my $cit = (defined $attach) ? $attach =~ /^(\S+)\.[^\.]+$/ ? $1 : 0 : 0;
                my $type = (defined $attach) ? ($attach =~ /\.([^\.]+)$/) ? $1 : 0 : 0;
                $cit =~ s/("|'|\s| )//g;
                my $sra = ($cit && $type) ? "$cit.$type" : undef;
                my $format  = param('format') eq 'on' ? 'html' : 'bbcode';
                my $cat     = param('catlist');
                my %message = (thread => $thread, title => $headline, body => $body, thread => $thread, cat => $cat, attach => $sra, format => $format, id => $id, user => $user, cat => $cat, ip => remote_addr());
                $database->editMessage(\%message);
                my $rid = $id;

                if($thread eq 'replies') {
                        my @tid = $database->fetch_array("select refererId from  `replies` where id = '$id'");
                        $rid = $tid[0];
                }
                &showMessage($rid);
        } else {
                &preview();
        }
}

sub editNews {
        my $id = param('edit');
        $id = ($id =~ /^(\d+)$/) ? $1 : 0;
        my $th = param('thread');
        $th = ($th =~ /^(\w+)$/) ? $1 : 'news';
        my @data    = $database->fetch_array("select title,body,date,id,user,attach,format,cat from  `$th`  where `id` = '$id'  and  (`user` = '$user'  or `right` < '$right' );") if(defined $th);
        my $catlist = readcats($data[7]);
        my $html    = $data[6] eq 'html' ? 1 : 0;
        my %parameter = (
                         action    => 'saveedit',
                         body      => $data[1],
                         class     => 'max',
                         attach    => $settings->{uploads}{enabled},
                         maxlength => $settings->{news}{maxlength},
                         path      => "$settings->{cgi}{bin}/templates",
                         reply     => $id,
                         server    => $settings->{cgi}{serverName},
                         style     => $style,
                         thread    => $th,
                         headline  => $data[0],
                         title     => translate('editMessage'),
                         right     => $right,
                         catlist   => ($th eq 'news') ? $catlist : '&#160;',
                         html      => $html,
        );
        use HTML::Editor;
        my $editor = new HTML::Editor(\%parameter);
        print '<div align="center"><br/>';
        print $editor->show();
        print '</div>';
}

sub reply {
        my $id = param('reply');
        $id = ($id =~ /^(\d+)$/) ? $1 : 0;
        my $th = param('thread');
        $th = ($th =~ /^(\w+)$/) ? $1 : 'trash';
        my %parameter = (
                         action    => 'addreply',
                         body      => translate('insertText'),
                         class     => 'max',
                         attach    => $settings->{uploads}{enabled},
                         maxlength => $settings->{news}{maxlength},
                         path      => "$settings->{cgi}{bin}/templates",
                         reply     => $id,
                         server    => $settings->{cgi}{serverName},
                         style     => $style,
                         thread    => $th,
                         headline  => translate('headline'),
                         title     => translate('reply'),
                         right     => $right,
                         catlist   => "",
                         html      => 0,
        );
        use HTML::Editor;
        my $editor = new HTML::Editor(\%parameter);
        print '<div align="center"><br/>';
        print $editor->show();
        print '</div>';
        &showMessage($id);
}

sub addReply {
        my $body     = param('message');
        my $headline = param('headline');
        my $reply    = param('reply');
        my $format   = param('format') eq 'on' ? 'html' : 'bbcode';
        if(not defined param('submit') or (param('submit') ne translate("preview"))) {
                if(param('file')) {
                        my $attach = (split(/[\\\/]/, param('file')))[-1];
                        my $cit = $attach =~ /^(\S+)\.[^\.]+$/ ? $1 : 0;
                        my $type = ($attach =~ /\.([^\.]+)$/) ? $1 : 0;
                        $cit =~ s/("|'|\s| )//g;
                        my $sra = "$cit.$type";
                        my %reply = (title => $headline, body => $body, id => $reply, user => $user, attach => $sra, format => $html,);
                        $database->reply(\%reply);
                } else {
                        my %reply = (title => $headline, body => $body, id => $reply, user => $user, format => $format, ip => remote_addr());
                        $database->reply(\%reply);
                }
                &saveUpload();
        } else {
                &preview();
        }
        &showMessage($reply);
}

sub deleteNews {
        my $th = param('thread');
        $th = ($th =~ /^(\w+)$/) ? $1 : 'trash';
        my $del = param('delete');
        $del = ($del =~ /^(\d+)$/) ? $1 : 0;
        if($th eq 'replies') {
                my @tid = $database->fetch_array("select refererId from  `replies` where id = ?", $del);
                $rid = $tid[0];
                $database->deleteMessage($th, $del);
                &showMessage($tid[0]);
        } else {
                $database->deleteMessage($th, $del);
                $database->void("DELETE FROM `replies` where `refererId`  = ?", $del) if($th eq 'news');
                &show();
        }
}

sub showMessage {
        my $id = shift;
        if(defined param('reply') && param('reply') =~ /(\d+)/) {
                $id = $1 unless (defined $id);
        }
        my $sql_read = qq/select title,body,date,id,user,attach,format from  news where `id` = $id && `right` <= $right/;
        my $ref      = $database->fetch_hashref($sql_read);
        if($ref->{id}== $id) {
                my $title = $ref->{title};
                my %parameter = (
                                 path   => $settings->{cgi}{bin} . '/templates',
                                 style  => $style,
                                 title  => qq(<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td style="white-space:nowrap">$title</td></tr></table>),
                                 server => $settings->{cgi}{serverName},
                                 id     => "n$id",
                                 class  => 'min',
                );
                my $window = new HTML::Window(\%parameter);
                $window->set_closeable(0);
                $window->set_moveable(1);
                $window->set_resizeable(1);
                BBCODE(\$ref->{body}, $right) if($ref->{format} eq 'bbcode');
                my $menu       = "";
                my $answerlink = $settings->{cgi}{mod_rewrite} ? "/replynews-$ref->{id}.html" : "$ENV{SCRIPT_NAME}?action=reply&amp;reply=$ref->{id}&amp;thread=news";
                my %reply      = (title => translate('reply'), descr => translate('reply'), src => 'reply.png', location => $answerlink, style => $style,);
                my $thread     = defined param('thread') ? param('thread') : '';
                $menu .= action(\%reply) unless ($thread =~ /.*\d$/ && $right < 5);
                my $editlink = $settings->{cgi}{mod_rewrite} ? "/edit$thread-$ref->{id}.html" : "$ENV{SCRIPT_NAME}?action=edit&amp;edit=$ref->{id}&amp;thread=news";
                my %edit = (title => translate('edit'), descr => translate('edit'), src => 'edit.png', location => $editlink, style => $style,);
                $menu .= action(\%edit) if($right >= 5);
                my $deletelink = $settings->{cgi}{mod_rewrite} ? "/delete.html&amp;delete=$ref->{id}&amp;thread=news" : "$ENV{SCRIPT_NAME}?action=delete&amp;delete=$ref->{id}&amp;thread=news";
                my %delete = (title => translate('delete'), descr => translate('delete'), src => 'delete.png', location => $deletelink, style => $style,);
                $menu .= action(\%delete) if($right >= 5);
                print "<br/>", $window->windowHeader(), qq(<table align="left" border ="0" cellpadding="0" cellspacing="0" summary ="0"  width="100%"><tr ><td align='left'>$menu</td></tr><tr ><td align='left'>$ref->{body}</td></tr>);
                print qq(<tr><td><a href="/downloads/$ref->{attach}">$ref->{attach}</a>) if(-e "$settings->{uploads}{path}/$ref->{attach}");
                print "</td></tr></table>", $window->windowFooter();
                my @rps = $database->fetch_array("select count(*) from replies where refererId = $id;");

                if($rps[0] > 0) {
                        use Template::Quick::Thread;
                        my %needed = (
                                      action       => 'showthread',
                                      start        => $von,
                                      end          => $bis,
                                      style        => $style,
                                      thread       => 'replies',
                                      replyId      => $id,
                                      id           => 'c',
                                      right        => $right,
                                      settingsfile => $settings->{config},
                                      database     => {host => $settings->{database}{host}, user => $settings->{database}{user}, name => $settings->{database}{name}, password => $settings->{database}{password}},
                        );
                        print showThread(\%needed);
                }
        } else {
                &show();
        }
}

# privat
sub readcats {
        my $selected = lc(shift);
        my @cats     = $database->fetch_AoH("select * from cats where `right` <= ?", $right);
        my $list     = '<select name="catlist" size="1">';
        for(my $i = 0 ; $i <= $#cats ; $i++) {
                my $catname = lc($cats[$i]->{name});
                $list .= ($catname eq $selected) ? qq(<option value="$catname"  selected="selected">$catname</option>) : qq(<option value="$catname">$catname</option>);
        }
        $list .= '</select>';
        return $list;
}

sub preview {
        my $thread = param('thread');
        $thread = ($thread =~ /^(\w+)$/) ? $1 : 'trash';
        my $id = param('reply');
        $id = ($id =~ /^(\d+)$/) ? $1 : 0;
        my $headline = param('headline');
        $headline = ($headline =~ /^(.{3,50})$/) ? $1 : 0;
        my $body       = param('message');
        my $selected   = param('catlist');
        my $catlist    = readcats($selected);
        my %wparameter = (path => "$settings->{cgi}{bin}/templates", style => $style, title => $headline, server => "http://localhost", id => "previewWindow", class => "min",);
        my $win        = new HTML::Window(\%wparameter);
        $win->set_closeable(1);
        $win->set_collapse(1);
        $win->set_moveable(1);
        $win->set_resizeable(1);
        print "<br/>";
        print $win->windowHeader();
        my $html = param('format') eq 'on' ? 1 : 0;
        BBCODE(\$body, $right) unless ($html);
        print qq(<table align="left" border ="0" cellpadding="0" cellspacing="0" summary ="0"  width="500"><tr ><td align='left'>$body</td></tr></table>);
        print $win->windowFooter();
        my %parameter = (
                         action    => $action,
                         body      => param('message'),
                         class     => 'max',
                         attach    => $settings->{uploads}{enabled},
                         maxlength => $settings->{news}{maxlength},
                         path      => "$settings->{cgi}{bin}/templates",
                         reply     => $id,
                         server    => $settings->{cgi}{serverName},
                         style     => $style,
                         thread    => $thread,
                         headline  => $headline,
                         title     => translate("editMessage"),
                         right     => $right,
                         catlist   => ($thread eq 'news') ? $catlist : '&#160;',
                         html      => $html,
        );
        use HTML::Editor;
        my $editor = new HTML::Editor(\%parameter);
        print '<div align="center"><br/>';
        print $editor->show();
        print '</div>';
}

sub saveUpload {
        my $ufi = param('file');
        if($ufi) {
                my $attach = (split(/[\\\/]/, param('file')))[-1];
                my $cit = $attach =~ /^(\S+)\.[^\.]+$/ ? $1 : 0;
                my $type = ($attach =~ /\.([^\.]+)$/) ? $1 : 0;
                $cit =~ s/("|'|\s| )//g;
                my $sra = "$cit.$type";
                my $up  = upload('file');
                use Symbol;
                my $fh = gensym();

                #my $ctype = uploadInfo($ufi)->{'Content-Type'};#do something with it
                open $fh, ">$settings->{uploads}{path}/$sra.bak" or warn "news.pl::saveUpload: $!";

                while(<$up>) {
                        print $fh $_;
                }
                close $fh;

                rename "$settings->{uploads}{path}/$sra.bak", "$settings->{uploads}{path}/$cit.$type" or warn "news.pl::saveUpload: $!";
                chmod("$settings->{'uploads'}{'chmod'}", "$settings->{uploads}{path}/$sra") if(-e "$settings->{uploads}{path}/$sra");
        }
}
1;
