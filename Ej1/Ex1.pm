#!/bin/perl -w
# Usar 'perl ex1.pm [nombre_del_archivo]'
# nombre_del_archivo es opcional, si no se especifica entonces usa 'sequence.gb'

use strict;
use warnings;
use Bio::Seq;
use Bio::SeqIO;
use Bio::PrimarySeqI;

my $file_name = shift || 'sequence.gb';     # Obtiene el nombre del archivo por línea de comandos, o usa 'sequence.gb' por default. 
my $input_file = Bio::SeqIO->new(-file => $file_name,   # Abre el archivo GenBank
                                 -format => 'genbank'
                                );
my $output_file = Bio::SeqIO->new( -file => ">$file_name.fas",  # Genera el archivo Fasta de resultado
                                   -format => 'fasta',
                                 );

while (my $seq = $input_file->next_seq) {   # Lee cada secuencia del archivo Input
    if(!$seq->validate_seq($seq->seq)) {    # Valida la secuencia
        print "SECUENCIA INVALIDA";
        die;
    }
    my $traduccion = $seq->translate(-orf => 1, complete => 1, -start => 'atg', -throw => 1); # Traduce a amino ácidos
    $output_file->write_seq($traduccion);   # Escribe la traducción en el archivo
    print $trad->seq, "\n";     # Imprime por pantalla cada traducción
}