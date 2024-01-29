#!/usr/bin/perl

use strict;
use warnings;
use POSIX qw(strftime);
use XML::LibXML;

# Generiraj vremenski žig u formatu YYYY-MM-DD
my $timestamp = strftime("%Y-%m-%d", localtime);

# Formiraj ime datoteke s vremenskim žigom
my $filename = "podaci_$timestamp.xml";

# Izvrši xidel naredbu i spremi izlaz u XML datoteku
system("xidel https://hrportfolio.hr/prosirena-tecajnica#svi-fondovi --extract '//tr[not(contains(td, \"googletag.display\") or contains(td, \"LOGIN\"))] / string-join(td, \",\")' --output-format xml-wrapped > $filename");

# Ispitaj moguće pogreške
if ($? == -1) {
    die "Greška prilikom izvršavanja Xidel naredbe: $!\n";
} elsif ($? & 127) {
    die "Xidel naredba prekinuta signalom " . ($? & 127) . "\n";
} else {
    my $exit_code = $? >> 8;

    if ($exit_code != 0) {
        die "Xidel naredba završena s neuspjehom, izlazni kod: $exit_code\n";
    }
}

# Učitaj XML datoteku
my $parser = XML::LibXML->new;
my $doc = $parser->parse_file($filename);

# Dodaj novi redak između <e> odlomaka
for my $e_node ($doc->findnodes('//e')) {
    my $new_line = $doc->createTextNode("\n  ");
    $e_node->parentNode->insertBefore($new_line, $e_node);
}

# Spremi ažuriranu XML datoteku
$doc->toFile($filename);

print "Podatci uspješno spremljeni u $filename\n";
