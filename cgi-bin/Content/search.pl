use HTML::Menu::Pages;

sub fulltext {
        my $search = param('query');
        print '<div align="center">';
        my @count = $search ? $database->fetch_array("SELECT count(*) FROM news  where `right` <= $right and MATCH (title,body) AGAINST('$search')") : 0;
        if($count[0] > 0) {
                my %needed = (start => $von, length => $count[0], style => $style, mod_rewrite => 1, action => "fulltext", append => "&query=$search");
                print makePages(\%needed);
                print "<br/>", $database->fulltext("$search", 'news', $right, $von, $bis);
        } else {
                print qq(<a href="http://www.google.com/search?q=$search" class="menulink">Search with Google</a>);
        }
        print '</div>';
}
1;
