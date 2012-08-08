
function tarfish(cf, lp)
global last_process
global config_file
global fatal_error
fatal_error = 0;

%% Identify last process
if nargin == 1
    last_process = 0;
else
    last_process = lp;
end
clear lp;

%% Config file
config_file = cf;
clear cf;

%% Load log
load_log(1);

%% Get parameters for BLAST alignment
blast_par(2)
if fatal_error > 0; return; end

%% Get parameters for analysis
anal_par(3)

%% Get parameters for graphical output
graph_par(4)

%% Get parameters for primer design
primer_par(5)

%% Load sequences
import_target(6);
if fatal_error > 0; return; end

%% Load database files
get_dbfiles(7);
if fatal_error > 0; return; end

%% Perform BLAST alignment
runblast(8);
if fatal_error > 0; return; end

%% Process and read BLAST output files
read_blast_d2(9);
if fatal_error > 0; return; end

%% Get genes file
genes_load(10);

%% Align genes to find their positions of the target chromosome
genes_aln(11);
if fatal_error > 0; return; end

%% Combine and sort alignments from all chromosomes and get the first
%% alignment to localize target region in the genome
first_aln(12);
if fatal_error > 0; return; end

%% Identify non-unique similar regions
nonun_seq(13);

%% Generate maps of uniques and non-unique regions
un_nonun_maps(14);

%% Merge non-unique regions separated by small enough gaps
nonun_gaps(15);

%% Select long enough non-unique regions
nonun_length(16);

%% Select long enough unique regions
un_length(17);

%% Generate histograms of repeats confined to each non-unique region
repeats_hist(18);

%% Find limits for each contiguous region of a histogram
hist_limits(19);

%% Generate cloning fragments for unique regions
gen_un_frags_pcr(20);
if fatal_error > 0; return; end

%% Generate cloning fragments for non-unique regions
gen_nonun_frags_pcr(21)

%% Generate localized non-target regions
nonun_mistargets(22)

%% Generate report about non-target regions
report_nonun_frags(23)
if fatal_error > 0; return; end

%% Generate graphical output
gen_latex_pix(24);

%% Produce primer pairs
gen_primers(25);
if fatal_error > 0; return; end
