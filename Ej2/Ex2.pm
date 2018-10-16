#!/bin/perl -w

# Usar 'perl ex2.pm [--f archivo] [--db base_de_datos] [--l] 
# Todos los parametros son opcionales:
# - Archivo input default: 'sequence.fas';
# - Base de datos default: 'nr';
# - Remota

use strict;
use warnings;
use Bio::Seq;
use Bio::SeqIO;
use Bio::PrimarySeqI;
use Bio::Tools::Run::StandAloneBlastPlus;
use Getopt::Long;


my $file_name = 'sequence.fas';     # Nombre del archivo por default: 'sequence.fas'. 
my $db = 'swissprot';                    # Base de datos por default: swissprot
my $local = 0;
# Verifica opciones de línea de comandos
GetOptions ('f=s' => \$file_name,   # string: Nombre del archivo
            'db=s' => \$db,        # string: Base de datos
            'l' => \$local);      # bool: Base de datos local (1 o 0)

my $remote = 1 - $local;                     # Base de datos REMOTA por default.

print '- Archivo: ', $file_name, "\n";
print '- Base de datos: ', $db;
print $remote?' (Remota)':' (Local)', "\n";

my $output_file_name = substr $file_name, 0, -4;            # El archivo output va a ser igual al input, pero .blast
$output_file_name .= '.blast';

my $blast = Bio::Tools::Run::StandAloneBlastPlus->new(
   -db_name => $db,
   -remote => $remote,
);

print 'Procesando...';
my $result = $blast->blastp( -query => $file_name, -outfile => $output_file_name, -outformat => 7);
$blast->cleanup;
print "Terminado! \n Resultados en: $output_file_name \n";
