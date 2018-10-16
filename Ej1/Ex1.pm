#!/bin/perl -w
# Usar 'perl ex1.pm [nombre_del_archivo]'
# nombre_del_archivo es opcional, si no se especifica entonces usa 'sequence.gb'

use strict;
use warnings;
use Getopt::Long;
use Bio::Seq;
use Bio::SeqIO;
use Bio::PrimarySeqI;

my $file_name = 'sequence.gb';     # Nombre del archivo default = 'sequence.gb'

GetOptions ('f=s' => \$file_name);      # Si se ingresa otro nombre de archivo por linea de comandos. (Ej: --f nombre_de_archivo)

my $input_file = Bio::SeqIO->new(-file => $file_name,   # Abre el archivo GenBank
                                 -format => 'genbank'
                                );
$file_name = substr $file_name, 0, -3; 
my $output_file = Bio::SeqIO->new( -file => ">$file_name.fas",  # Genera el archivo Fasta de resultado
                                   -format => 'fasta',
                                  );

while (my $seq = $input_file->next_seq) {   # Lee cada secuencia del archivo Input
    if(!$seq->validate_seq($seq->seq)) {    # Valida la secuencia
        die "************ ERROR: SECUENCIA INVALIDA";
    }
    # ARCHIVO CON LOS 6 MARCOS DE LECTURA
    my @prots = Bio::SeqUtils->translate_6frames($seq);
    $output_file->write_seq(@prots);


    # MARCO CORRECTO
    # my $marco_correcto = $seq->translate(-orf => 1, -complete => 1, -start => 'atg', -throw => 1);
    # print "> MARCO: ", "\n", $marco_correcto->seq, "\n";     # Imprime por pantalla el marco
 }
