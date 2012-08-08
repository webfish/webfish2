    %   WEBFISH Executes the algorithm identifying FISH probes
    %       The program defines a set of parameters and initiates the
    %       sequence analysis for the design of FISH probes.
    %   DEPENDENCIES
    %       The program runs MATLAB R2011a on MAC OS X 10.5 or Ubuntu 10.10
    %       other Matlab, MAC OS X version or Linux distributions should
    %       support this software, but were not tested. Microsoft Windows
    %       is not supported.
    %
    %       Requirement: Matlab Bioinformatics Toolbox
    %
    %       Requirement: NCBI BLAST 2.2.21. The path to the
    %       megablast executalble must be correctly defined in this file.
    %
    %       Requirement: Primer3 1.1.4. The path to the primer3_core
    %       executable must be included in the configuration file.
    %
    %       Requirement: Formatted genome database. A raw genome database
    %       can be obtained from ftp://ftp.ensembl.org/ It can be formatted
    %       using formatdb included with BLAST:
    %           formatdb -i input_fasta_file -p F -o T
    %       Save the files in a directory and include this directory in the
    %       configuration file <organism> tag replacing spaces with
    %       underscores. For instance if the tag is
    %       <organism>homo sapiens</organism>, the directory containing the
    %       formated chromosomal sequences must be called "homo_sapiens"
    %   EXAMPLE
    %       Make sure the forementioned dependencies are met and paths in
    %       this file and the tasks/ABCDEFGHxy.conf configuration file 
    %       <primer_dir> tag link to the correct directories on your
    %       computer. Then simply run the program and it will use the
    %       ABCDEFGHxy.conf, ABCDEFGHxy.seq and ABCDEFGHxy.genes as source
    %       data. If successful, it will produce a directory
    %       tasks/ABCDEFGHxy/ with images and designed primers.

global tasks
global webserver
global currenthtml
global blast_dir
global genomes_dir
global exts
global figure_vis
global matlaboroctave
global primer3_dir

%% *********************************************************
%% *       Parameters that can be varied by the user       *
%% *********************************************************
% name of the project used in the analysis run
tasks{1} = 'IJK';
% directory with installed NCBI megablast
blast_dir = '/usr/bin';
% directory with installed primer3_core
primer3_dir = '/usr/local/primer3';
% Path leading to the directory with the formated genome databases.
% Do not include the directory itself. For instance if the formatted
% databases are in directory "/genomes/homo_sapiens/" it should be:
% genomes_dir = '/genomes/'; see help for more details.
% directory with 
genomes_dir = '/home/jakub_old/genomes/blast/';
% *********************************************************



%% *********************************************************
%% *   Parameters that should not be varied by the user    *
%% *********************************************************
% empty cell to hold the content of the log report
%                      (not used in offline mode)
currenthtml = cell(0);
% directory with the website content
%                      (leave '.' for offline use)
webserver.html = '.';
% extensions of the formated database files
exts = {'nhr', 'nin', 'nsd', 'nsi', 'nsq'};
% visibility of the figure produced during the analysis
figure_vis = 'on';
% is Matlab (true) of GNU Octave (false) used as the interpreter
matlaboroctave = false;
% *********************************************************



%% Execute the processing
tarfish(['tasks/' tasks{1} '.conf'])