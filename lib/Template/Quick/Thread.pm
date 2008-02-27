package Template::Quick::Thread;
use strict;
use warnings;
use CGI::QuickApp::Blog;
use HTML::Window;
use HTML::Editor::BBCODE;
use DBI::Library::Database;
use CGI::QuickApp;
use CGI::QuickApp::Settings;
require Exporter;
use vars qw(
  $DefaultClass
  @EXPORT
  @ISA
  $action
  $database
  $end
  $length
  $right
  $start
  $style
  $thread
  $replyId
  $replylink
  $pass $user $host $dbh  $db $settings $settingsfile
);

@Template::Quick::Thread::EXPORT = qw(showThread);
@ISA                             = qw(Exporter);

$Template::Quick::Thread::VERSION = '0.27';

$DefaultClass = 'Template::Quick::Thread' unless defined $Template::Quick::Thread::DefaultClass;

=head1 NAME

Template::Quick::Thread

=head1 SYNOPSIS

use Template::Quick::Thread;

       my %needed =(

              start  => 'von',

              end    => 'bis',

              style  => 'Crystal',

              thread => 'thread',

              settingsfile => '',

       );

       print showThread(\%needed );

=head2 EXPORT

showThread

=head1 Public

=head2 Public new()

       my $thread = new Template::Quick::Thread();

=cut

sub new {
        my ($class, @initializer) = @_;
        my $self = {};
        bless $self, ref $class || $class || $DefaultClass;
        return $self;
}

=head2 showThread(\%)

       my %needed =(

              start  => 'von',

              end    => 'bis',

              style  => 'Crystal',

              thread => 'thread',

              right=> '1',

              action  => 'news',

       );

       print showThread(\%needed );

=cut

sub showThread {
        my ($self, @p) = getSelf(@_);
        my $needed = $p[0];
        $action       = $needed->{action};
        $end          = $needed->{end};
        $start        = $needed->{start};
        $thread       = $needed->{thread};
        $style        = $needed->{style};
        $right        = $needed->{right};
        $replyId      = $needed->{replyId};
        $replylink    = defined $replyId ? $replyId : '';
        $db           = $needed->{database}{name};
        $host         = $needed->{database}{host};
        $user         = $needed->{database}{user};
        $pass         = $needed->{database}{password};
        $settingsfile = $needed->{settingsfile};
        $database     = new DBI::Library::Database();
        $dbh          = $database->initDB({name => $db, host => $host, user => $user, password => $pass,});

        $length = $database->tableLength($thread, $right) unless ($thread eq 'replies');
        if(defined $needed->{replyId}) {
                my @rps = $database->fetch_array("select count(*) from replies where refererId = $needed->{replyId};");
                if($rps[0] > 0) {
                        $length = $rps[0];
                } else {
                        $length = 0;
                }
        }
        $length = 0 unless (defined $length);
        use CGI::QuickApp::Settings;
        *settings = \$CGI::QuickApp::Settings::settings;
        loadSettings($settingsfile);
        my $itht = '<table align="center" border ="0" cellpadding ="2" cellspacing="10" summary="newTopic" width="100%" >';

        if(defined $start && defined $end) {
                $start = 0       if($start < 0);
                $end   = $length if($end > $length);
                $itht .= $self->ebis() if($length > 10);
                $itht .= '<tr><td>' . $self->threadBody($thread) . '</td></tr>';
                $itht .= $self->ebis() if($length > 10);
        }
        $itht .= '</table>';
        return $itht;
}

=head1 Private

=head2 threadBody


=cut

sub threadBody {
        my ($self, @p) = getSelf(@_);
        my $th = $p[0];
        my @output;
        my ($db_clause, $table) = (" FROM $1", $2) if $th =~ /(.*)\.(.*)/;
        $dbh->quote(\$table);
        $db_clause = defined $db_clause ? $db_clause : ' ';

        if(($dbh->selectrow_array("SHOW TABLES $db_clause LIKE '$th'"))) {

                my $answers  = defined $replyId ? " && refererId ='$replyId'" : '';
                my $sql_read = qq/select title,body,date,id,user,attach,format from  `$th`  where `right` <= $right $answers order by date desc LIMIT $start,10 /;
                my $sth      = $dbh->prepare($sql_read);
                $sth->execute();
                while(my @data = $sth->fetchrow_array()) {
                        my $headline = $data[0];
                        $headline =~ s/ /&#160;/g;
                        my $body      = $data[1];
                        my $datum     = $data[2];
                        my $id        = $data[3];
                        my $username  = $data[4];
                        my $attach    = $data[5];
                        my $format    = $data[6];
                        my $replylink = $settings->{cgi}{mod_rewrite} ? "/news$id.html" : "$ENV{SCRIPT_NAME}?action=showthread&amp;reply=$id&amp;thread=$th";
                        my $answer    = CGI::QuickApp::translate('answers');
                        my @rps       = $database->fetch_array("select count(*) from replies where refererId = $id;");
                        my $reply     = (($rps[0] > 0) && $th eq 'news') ? qq(<br/><a href="$replylink" class="link" >$answer:$rps[0]</a><br/>) : '';
                        my $menu      = "";

                        if($th ne 'replies') {
                                my $answerlink = $settings->{cgi}{mod_rewrite} ? "/reply$th-$id.html" : "$ENV{SCRIPT_NAME}?action=reply&amp;reply=$id&amp;thread=$th";
                                my %reply = (title => CGI::QuickApp::translate('reply'), descr => CGI::QuickApp::translate('reply'), src => 'reply.png', location => $answerlink, style => $style,);
                                $menu .= CGI::QuickApp::Blog::action(\%reply);
                        }
                        my $editlink = $settings->{cgi}{mod_rewrite} ? "/edit$th-$id.html" : "$ENV{SCRIPT_NAME}?action=edit&amp;edit=$id&amp;thread=$th";
                        my %edit = (title => CGI::QuickApp::translate('edit'), descr => CGI::QuickApp::translate('edit'), src => 'edit.png', location => $editlink, style => $style,);
                        $menu .= CGI::QuickApp::Blog::action(\%edit) if($right > 1);
                        my $deletelink = $settings->{cgi}{mod_rewrite} ? "/delete.html&amp;delete=$id&amp;thread=$th" : "$ENV{SCRIPT_NAME}?action=delete&amp;delete=$id&amp;thread=$th";
                        my %delete = (title => CGI::QuickApp::translate('delete'), descr => CGI::QuickApp::translate('delete'), src => 'delete.png', location => $deletelink, style => $style,);
                        $menu .= CGI::QuickApp::Blog::action(\%delete) if($right >= 5);
                        my %parameter = (
                                         path   => "$settings->{cgi}{bin}/templates",
                                         style  => $style,
                                         title  => qq(<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td>$headline</td></tr></table>),
                                         server => $settings->{cgi}{serverName},
                                         id     => $id,
                                         class  => 'min',
                        );

                        my $win = new HTML::Window(\%parameter);
                        $win->set_closeable(1);
                        $win->set_collapse(1);
                        $win->set_moveable(1);
                        $win->set_resizeable(1);
                        my $h1 = $win->windowHeader();
                        BBCODE(\$body, $right) if($format eq 'bbcode');
                        $h1 .= qq(<table align="left" border ="0" cellpadding="0" cellspacing="0" summary="threadBody"  width="*"><tr ><td align="left">$menu</td></tr><tr><td align="left">$body</td></tr>);
                        $h1 .= qq(<tr><td><a href="/downloads/$attach">$attach</a></td></tr>) if(-e "$settings->{uploads}{path}/$attach");
                        $h1 .= qq(<tr><td align="center">$reply</td></tr></table>);
                        $h1 .= $win->windowFooter();
                        push @output, "$h1<br/>";
                }
        }
        return "@output";
}

=head2 ebis()

=cut

sub ebis {
        my ($self, @p) = getSelf(@_);
        my $prev  = $start- 10;
        my $next1 = $start;
        $next1 = 10 if($prev < 0);
        $prev  = 0  if($prev < 0);
        my $seiten  = CGI::QuickApp::translate('sites');
        my $ebis    = qq(<tr><td align="center"><a class="menuLink2" name ="pages">$seiten:</a>);
        my $npevbis = ($settings->{cgi}{mod_rewrite}) ? "/$prev/$next1/$action$replylink.html" : "$ENV{SCRIPT_NAME}?action=$action&amp;von=$prev&amp;bis=$next1&amp;reply=$replylink";
        $ebis .= qq(<a class="menuLink2" href="$npevbis"><img src="/style/$style/prev.png" alt="previous" border="0" title="previous" style="cursor:pointer;"/></a>&#160;) if($start- 10 >= 0);

        my $sites = (int($length/ 10)+ 1)* 10 unless ($length % 10== 0);
        $sites = (int($length/ 10))* 10 if($length % 10== 0);
        my $beginn = $start/ 10;
        $beginn = (int($start/ 10)+ 1)* 10 unless ($start % 10== 0);
        $beginn = 0 if($beginn < 0);
        my $b = ($sites >= 10) ? $beginn : 0;
        $b = ($beginn- 5 >= 0) ? $beginn- 5 : 0;
        my $end = ($sites >= 10) ? $b+ 10 : $sites;
      ECT: {

                while($b < $end) {
                        my $c = $b* 10;
                        my $d = $c+ 10;
                        $d = $length if($d > $length);
                        my $svbis = ($settings->{cgi}{mod_rewrite}) ? "/$c/$d/$action$replylink.html" : "$ENV{SCRIPT_NAME}?action=$action&amp;von=$c&amp;bis=$d&amp;reply=$replylink";
                        if($b* 10 eq $start) {
                                $ebis .= qq(<a class="menuLink3" href="$svbis">$b</a>&#160;);
                        } else {
                                $ebis .= qq(<a class="menuLink2" href="$svbis">$b</a>&#160;);
                        }
                        last ECT if($d eq $length);
                        $b++;
                }
        }
        my $v    = $start+ 10;
        my $next = $v+ 10;
        $next = $length if($next > $length);
        my $esvbis = ($settings->{cgi}{mod_rewrite}) ? "/$v/$next/$action$replylink.html" : "$ENV{SCRIPT_NAME}?action=$action&amp;von=$v&amp;bis=$next&amp;reply=$replylink";
        $ebis .= qq(<a class="menuLink2" href="$esvbis"><img src="/style/$style/next.png" border="0" alt="next" title="next" style="cursor:pointer;"/></a>&#160;) if($v < $length);
        $ebis .= '</td></tr>';
        return $ebis;
}

=head2  getSelf()

=cut

sub getSelf {
        return @_ if defined($_[0]) && (!ref($_[0])) && ($_[0] eq 'Template::Quick::Thread');
        return (defined($_[0]) && (ref($_[0]) eq 'Template::Quick::Thread' || UNIVERSAL::isa($_[0], 'Template::Quick::Thread'))) ? @_ : ($Template::Quick::Thread::DefaultClass->new, @_);
}

=head1 AUTHOR

Dirk Lindner <lze@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Hr. Dirk Lindner

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public License
as published by the Free Software Foundation; 
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

=cut

1;
