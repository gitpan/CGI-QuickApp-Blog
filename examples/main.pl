#!/usr/bin/perl -w
use lib qw(lib);
use strict;
use CGI::QuickApp::Blog::Main;
my %set = (path => "./templates", size => 16, style => "Crystal", title => "CGI::QuickApp::Blog::Main", server => "http://localhost", login => "",);
my $main = new CGI::QuickApp::Blog::Main(\%set);
use CGI::QuickApp qw(header);
print header;
print $main->Header();
use showsource;
&showSource("./main.pl");
print $main->Footer();
