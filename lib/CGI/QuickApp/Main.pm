package CGI::QuickApp::Main;
use Template::Quick;
use strict;
use warnings;
require Exporter;
use vars qw($DefaultClass @EXPORT  @ISA  $login $right $htmlright $template);
our $style = 'Crystal';
our $title = '';
our $size  = 16;
our $server;
@CGI::QuickApp::Main::EXPORT_OK   = qw(all initMain Header Footer);
%CGI::QuickApp::Main::EXPORT_TAGS = ('all' => [qw(initMain Header Footer)]);
@CGI::QuickApp::Main::ISA         = qw( Exporter Template::Quick);
$CGI::QuickApp::Main::VERSION     = '0.27';
$DefaultClass                     = 'CGI::QuickApp::Main' unless defined $CGI::QuickApp::Main::DefaultClass;

=head1 NAME

CGI::QuickApp::Main.pm

=head1 SYNOPSIS

use CGI::QuickApp::Main;

=head1 DESCRIPTION

load The "Main Template" for CGI::QuickApp::Blog

=head2 EXPORT

=head1 SEE ALSO

L<CGI::QuickApp::Blog> L<Template::Quick>

=head1 Public

=head2 new()

=cut

sub new {
        my ($class, @initializer) = @_;
        my $self = {};
        bless $self, ref $class || $class || $DefaultClass;
        $self->initMain(@initializer) if(@initializer);
        return $self;
}

=head2 initMain()

     my %patmeter =(

     path => "path to cgi-bin",

     style  => "style to use",

     title  => "title";

     htmlright => '',

     login  => '',

     template =>'index.html',

     );

     init(\%patmeter);

=cut

sub initMain {
        my ($self, @p) = getSelf(@_);
        my $hash = $p[0];
        $server    = $hash->{server};
        $style     = defined $hash->{style} ? $hash->{style} : 'Crystal';
        $size      = defined $hash->{size} ? $hash->{size} : 16;
        $title     = defined $hash->{title} ? $hash->{title} : '';
        $login     = defined $hash->{login} ? $hash->{login} : '';
        $right     = defined $hash->{right} ? $hash->{right} : 0;
        $htmlright = defined $hash->{htmlright} ? $hash->{htmlright} : 2;
        $template  = defined $hash->{template} ? $hash->{template} : "index.htm";
        my %template = (path => $hash->{path}, style => $style, template => $template,);
        $self->SUPER::initTemplate(\%template);
}

=head2 Header()

=cut

sub Header {
        my ($self, @p) = getSelf(@_);
        my %header = (name => 'bodyHeader', size => $size, server => $server, style => $style, title => $title, login => $login, right => $right, htmlright => $htmlright);
        $self->SUPER::appendHash(\%header);
}

=head2 Footer()

=cut

sub Footer {
        my ($self, @p) = getSelf(@_);
        my %footer = (name => 'bodyFooter', style => $style,);
        $self->SUPER::appendHash(\%footer);
}

=head1 PRIVAT

=head2 getSelf()

see L<HTML::Menu::TreeView>

=cut

sub getSelf {
        return @_ if defined($_[0]) && (!ref($_[0])) && ($_[0] eq 'CGI::QuickApp::Main');
        return (defined($_[0]) && (ref($_[0]) eq 'CGI::QuickApp::Main' || UNIVERSAL::isa($_[0], 'CGI::QuickApp::Main'))) ? @_ : ($CGI::QuickApp::Main::DefaultClass->new, @_);
}

=head1 AUTHOR

Dirk Lindner <lze@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Hr. Dirk Lindner

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public License
as published by the Free Software Foundation; 
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

=cut

1;
