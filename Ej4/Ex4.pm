#!/bin/perl -w

use strict;
use warnings;
use Getopt::Long;
use Bio::SearchIO;
use Bio::DB::GenBank;

my $input = 'sequence.blast';     # Nombre del archivo por default: 'sequence.blast'. 
my $caseSensitive = 0;
my $pattern;
GetOptions ('f=s' => \$input,       # string: Nombre del archivo
            'p=s' => \$pattern,     # string: Pattern a buscar
            'cs' => \$caseSensitive);    # Boolean: CaseSensitive (Default: false)

print '- Input: ', $input, "\n";

if (!$pattern) {
    die 'No fue indicado ningun pattern';
} else { 
    print '- Pattern: ', $pattern, "\n";
}
print '- Case Sensitive: ', $caseSensitive ? 'True' : 'False', "\n";

my $input_file = Bio::SearchIO->new(
    -file => $input,
    -format => 'blast'
    );

my $db_genbank = Bio::DB::GenBank->new();

my $result = $input_file->next_result;
my $coincidencias = 0;
while (my $hit = $result->next_hit) {
    my $description = $hit->description;
    
    if (!$caseSensitive) { 
        $description = uc($description);
        $pattern = uc($pattern);
    } 
    
    if (index($description, $pattern) != -1) {
        my $acc = $hit->accession;
        print '----- Coincidencia: ', $acc, "\n";
        my $seq = $db_genbank->get_Seq_by_acc($acc);
        my $file = ">$acc.fas";
        my $output_file = Bio::SeqIO->new( -file => $file,  # Genera el archivo Fasta del accession
                                    -format => 'fasta',
                                   );
        $output_file->write_seq($seq);
        $coincidencias++;
    }
}
print 'FINALIZADO', "\n", "Coincidencias: $coincidencias", "\n";
