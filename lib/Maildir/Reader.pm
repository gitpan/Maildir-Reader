
package Maildir::Reader;

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;
require AutoLoader;

@ISA    = qw(Exporter AutoLoader);
@EXPORT = qw();

use strict;
use warnings;

use vars qw($VERSION);
our $VERSION = "0.2";


=pod

=head1 NAME

Maildir::Iterator - Easily read the contents of a Maildir folder

=head1 SYNOPSIS

    use strict;
    use warnings;
    use Maildir::Iterator;

    my $helper = Maildir::Iterator->new( path => "~/Maildir/.foo.com/" );

    my @all = $helper->all();
    my @new = $helper->unread();
    my @read = $helper->read();

=cut


=head1 AUTHOR

Steve Kemp <steve@steve.org.uk>

=cut

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 Steve Kemp <steve@steve.org.uk>.

This library is free software. You can modify and or distribute it under
the same terms as Perl itself.

=cut


=head1 METHODS


=head2 new

The constructor.   There is only a single mandatory argument which is
the path to the folder you'll be working with:

    my $helper = Maildir::Iterator->new( maildir => "/home/steve/Maildir/.foo/" );


=cut

sub new
{
    my ( $proto, %supplied ) = (@_);
    my $class = ref($proto) || $proto;

    my $self = {};

    #
    #  Allow user supplied values to override our defaults
    #
    foreach my $key ( keys %supplied )
    {
        $self->{ lc $key } = $supplied{ $key };
    }

    bless( $self, $class );
    return $self;
}



=head2 list

Return a hashref containing entries for each message.

A typical return value would include:

          [ {
              'flags' => 'seen',
              'fullpath' => '/home/skx/Maildir/.Amazon.co.uk/cur/1279058791.20642_2.skx.xen-hosting.net:2,S',
              'size' => 7840
            }, ]

=cut

sub list
{
    my( $self ) = (@_ );

    my $ref;
    my @all = $self->all();


    foreach my $file ( @all )
    {
        my $flags = "";
        $flags = $1 if ( $file =~ /:2,([A-Z]+)/ );

        $flags = "passed" if ( $flags eq "P" );
        $flags = "replied" if ( $flags eq "R" );
        $flags = "seen" if ( $flags eq "S" );
        $flags = "trashed" if ( $flags eq "T" );
        $flags = "draft" if ( $flags eq "D" );
        $flags = "flagged" if ( $flags eq "F" );

        my $size = -s $file;
        push( @$ref, { fullpath => $file,
                       size => $size,
                       flags => $flags } );
    }

    return( $ref );
}



=head2 all

Return the filenames of each message in the Maildir folder, regardless
of whether they are read or unread.

The files will be returned in date-sorted order, with the oldest files
being shown first.

=cut

sub all
{
    my ($self) = (@_);

    my @results;

    foreach my $archive (qw! /new/ /cur/ !)
    {
        foreach my $file ( glob( $self->{ 'maildir' } . $archive . "/*" ) )
        {
            push( @results, $file );
        }
    }

    return ( $self->_sort(@results) );
}




=head2 unread

Return the filenames of unread message in the Maildir folder.

The files will be returned in date-sorted order, with the oldest files
being shown first.

=cut

sub unread
{
    my ($self) = (@_);

    my @results;

    foreach my $file ( glob( $self->{ 'maildir' } . "/new/*" ) )
    {
        push( @results, $file );
    }

    return ( $self->_sort(@results) );
}



=head2 read

Return the filenames of all read messages in the Maildir folder.

The files will be returned in date-sorted order, with the oldest files
being shown first.

=cut

sub read
{
    my ($self) = (@_);

    my @results;

    foreach my $file ( glob( $self->{ 'maildir' } . "/cur/*" ) )
    {
        push( @results, $file );
    }

    return ( $self->_sort(@results) );
}




=begin doc

Given an array of filenames sort them based upon their mtimes, such that
the oldest file is the newest.

=end doc

=cut

sub _sort
{
    my ( $self, @array ) = (@_);

    #
    #  Schwartzian transform used for sorting.
    #
    my @files = map {$_->[0]}
      sort {$b->[1] <=> $a->[1]}
      map {[$_, ( -M $_ )]} @array;

    return @files;
}



1;

__END__
