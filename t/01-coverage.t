use Test::More;
eval 'use Test::Pod::Coverage 0.55';
plan skip_all => 'Test::Pod::Coverage 0.55 is required to run this test' if $@;
plan tests => 1;
pod_coverage_ok("CGI::QuickApp::Blog", "CGI::QuickApp::Blog is covered");
