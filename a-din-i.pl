#!usr/bin/env perl

# Copyright 2023 Alecu Ștefan-Iulian
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

use 5.036;
use warnings;
use autodie;
use utf8;
use open qw( :std :encoding(UTF-8) );
my $VERSION = 1.0;

use Readonly;
use Data::Dumper qw(Dumper);
use Getopt::Long qw(GetOptions);
Getopt::Long::Configure qw(gnu_getopt);
use Carp;
use English    qw(-no_match_vars);
use List::Util qw(any first);
use Encode;

exit main(@ARGV);

sub print_usage {
    printf {*STDERR} "Usage: $0 --in FILE [--out FILE] -a/-i\n";
    exit 1;
}

sub convert_a_to_i {
    my @line = split '\b', shift;
    for (@line) {
        tr/âÂ/îÎ/;
        s/^sunt/sînt/;
        s/^SUNT/SÎNT/;
        s/romîn/român/;
        s/ROMÎN/ROMÂN/;
    }
    return join '', @line;
}

sub convert_i_to_a {
    my @line = split '\b', shift;

    my @prefix_list = (
        'alt', 'auto',  'bine', 'de',    'ex',    'foto',
        'ne',  'nemai', 'ori',  'prea',  'pre',   'răs',
        're',  'semi',  'sub',  'super', 'supra', 'tele',
    );
    foreach my $word (@line) {
        $word =~ tr/îÎ/âÂ/;
        $word =~ s/^sînt/sunt/g;
        $word =~ s/^SÎNT/SUNT/g;
        $word =~ s/^â/î/g;
        $word =~ s/^Â/Î/g;
        $word =~ s/â$/î/g;
        $word =~ s/Â$/Î/g;

        foreach my $prefix (@prefix_list) {
            if ( index( $word, $prefix ) == 0 ) {
                if ( substr( $word, length($prefix), 1 ) eq 'â' ) {
                    substr $word, length($prefix), 1, 'î';
                }
                last;
            }
        }
    }

    return join '', @line;
}

sub main {
    my (%args) = (
        'in_filename'  => undef,
        'out_filename' => undef,
        'i-din-a'      => undef,
        'i-din-i'      => undef,
    );

    my $res = GetOptions(
        'in=s'      => \$args{'in_filename'},
        'out=s'     => \$args{'out_filename'},
        'i-din-a|a' => \$args{'i-din-a'},
        'i-din-i|i' => \$args{'i-din-i'},
    );

    print_usage() if $res == 0;

    if ( !defined $args{'in_filename'} ) {
        printf {*STDERR} "Input file required!\n";
        print_usage();
    }

    elsif ( !-f $args{'in_filename'} || !-r $args{'in_filename'} ) {
        if ( -d $args{'in_filename'} ) {
            printf {*STDERR}
              "\"$args{'in_filename'}\" is a directory; file required!\n";
        }
        else {
            printf {*STDERR}
              "File \"$args{'in_filename'}\" cannot be opened for reading!\n";
        }
        print_usage();
    }

    Readonly::Scalar my $I_DIN_A => 1;
    Readonly::Scalar my $I_DIN_I => 2;
    my $mode = 0;
    if ( defined $args{'i-din-a'} ) {
        $mode = $I_DIN_A;
    }
    elsif ( defined $args{'i-din-i'} ) {
        $mode = $I_DIN_I;
    }
    elsif ( defined $args{'out_filename'}
        && ( $args{'out_filename'} eq '-a' || $args{'out_filename'} eq '-i' ) )
    {
        printf {*STDERR} "Output file required!\n";
        print_usage();
    }

    if ( !-f $args{'out_filename'} || !-r $args{'out_filename'} ) {
        if ( -d $args{'out_filename'} ) {
            printf {*STDERR}
"\"$args{'out_filename'}\" is a directory; output file required!\n";
            print_usage();
        }
        else {
            if ( !-e $args{'out_filename'} ) {
                open my $fc, '>', $args{'out_filename'}
                  or die "Can't open \"P{$args{'out_filename'}}\" for writing!";
                close $fc;
            }
        }
    }

    if ( $mode == 0 ) {
        printf {*STDERR} "Mode has to be provided (either for î or for â!)\n";
        return 1;
    }

    open my $out, '>', $args{'out_filename'};
    open my $in,  '<', $args{'in_filename'};
    while ( my $line = <$in> ) {
        if ( $mode == $I_DIN_A ) {
            print $out convert_a_to_i($line);
        }
        else {
            print $out convert_i_to_a($line);
        }
    }
    close $in;
    close $out;
    return 0;
}

