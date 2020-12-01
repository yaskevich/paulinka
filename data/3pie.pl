#!/usr/bin/env perl

# libjson-any-perl
use strict;
use Chart::Clicker;
use Chart::Clicker::Data::Series;
use Chart::Clicker::Data::DataSet;

my $series;
my $s = Chart::Clicker::Data::Series->new(
    keys   => [1, 2, 3, 4, 5, 6, 7 ],
    values => [1, 2, 3, 4, 5, 6, 7], 
    name   => "abc"
);
push @$series, $s;
$s = Chart::Clicker::Data::Series->new(
    keys   => [1, 2, 3, 4, 5, 6, 7 ],
    values => [7, 6, 5, 4, 3, 2, 1 ],
    name   => "abcdefghijklmnopqrstuvwxyz1234567890"
);
push @$series, $s;

my $ds = Chart::Clicker::Data::DataSet->new(series => $series );
my $cc = Chart::Clicker->new(width => 1000, height => 400, format => 'png'); 
$cc->add_to_datasets($ds);
$cc->legend_position('e');
$cc->write_output("foo.png");