function read_blast_d2(process)
global last_process
global folder
global bit_score
global query_from
global query_to
global hit_from
global hit_to
global chromosome
global chr
global target_name
global fatal_error

%% Load saved target sequences
if last_process >= process
    load([folder 'mats/fp' num2str(process) '.mat']);
    write_log(process, 'BLAST alignments imported');
    write_log(process);
    return
end

%% Import alignment positions from BLAST output file
[bit_score, query_from, query_to, hit_from, hit_to, chromosome] = ...
    load_blast(process, target_name, chr);
if fatal_error > 0; return; end

%% Save output
save([folder 'mats/fp' num2str(process) '.mat'], 'bit_score', ...
    'query_from', 'query_to', 'hit_from', 'hit_to', 'chromosome');
write_log(process, 'Imported BLAST alignments');

%% Process finished
write_log(process);