# $Id$

use strict;
use lib './t/lib';
use ExtUtils::MakeMaker;

my %prereq_pm = (
    'Test::More'         => undef,
);

WriteMakefile(
    NAME            => 'Maildir::Reader',
    VERSION_FROM    => 'lib/Maildir/Reader.pm',
    PREREQ_PM       => \%prereq_pm,
    ABSTRACT        => 'Easily manipulate the contents of Maildir folders',
    AUTHOR          => 'Steve Kemp <steve@steve.org.uk>',
);


package MY;
use strict;

sub postamble {
    return <<'MAKE_TEXT';
prepare_dist ::	metafile manifest dist
	$(NOECHO) $(NOOP)
MAKE_TEXT
}

sub libscan {
    my ($self, $path) = @_;
    return '' if $path =~ m/\.svn/;
    return $path;
}

