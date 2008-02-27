my @menu = $database->fetch_AoH("select title,action,`submenu`,target from navigation where `right` <= $right order by position");
my @t    = fetchMenu(@menu);

sub fetchMenu {
        my @actions = @_;
        my @ret;
        for(my $i = 0 ; $i <= $#actions ; $i++) {
                my $fm;
                unless ($actions[$i]->{target}) {
                        $fm = ($settings->{cgi}{mod_rewrite}) ? "/$actions[$i]->{action}.html" : "$ENV{SCRIPT_NAME}?action=$actions[$i]->{action}";
                } else {
                        $fm = $actions[$i]->{action};
                }
                if($actions[$i]->{submenu}) {
                        my @sumenu = fetchMenu($database->fetch_AoH("select * from $actions[$i]->{submenu} where `right` <= $right"));
                        push @ret, {text => $actions[$i]->{title}, href => $fm, subtree => [@sumenu],};
                } else {
                        if($actions[$i]->{action} ne "news") {
                                push @ret, {text => $actions[$i]->{title}, href => $fm,};
                        }
                }
        }
        return @ret;
        }
        my $v = 0;
        my $b = 10;
        if($action eq 'news'){
                $v = $von;
                $b = $bis;
        }
        my $v = $action eq 'news' ? $von : 0 ;

my @news = $database->readMenu('news', $right, $v, $b, $settings->{cgi}{mod_rewrite});
unshift @t, {text => $settings->{cgi}{title}, href => ($settings->{cgi}{mod_rewrite}) ? "/news.html" : "$ENV{SCRIPT_NAME}?action=news", subtree => [@news],};
loadTree($settings->{tree}{navigation});
*t1 = \@{$HTML::Menu::TreeView::TreeView[0]};
push @t, @t1;
my %parameter = (path => $settings->{cgi}{bin} . '/templates', style => $style, title => "&#160;Navigation&#160;&#160;", server => $settings->{cgi}{serverName}, id => "n1", class => "sidebar",);
my $window = new HTML::Window(\%parameter);
$window->set_closeable(1);
$window->set_moveable(1);
$window->set_resizeable(0);
print $window->windowHeader();
print Tree(\@t, $style);
print $window->windowFooter();
