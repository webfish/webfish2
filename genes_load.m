function genes_load(process)
global last_process
global folder
global genes_seq
global genes_name
global genes_file
global fatal_error
global en_genes
global config_file

%% Load saved target sequences
if last_process >= process
    load([folder 'mats/fp' num2str(process) '.mat']);
    write_log(process, 'Loaded gene sequences');
    write_log(process);
    return
end

%% Import target sequences from fasta file
genes_file = [config_file(1 : end - 8) '_genes.fa'];
if ~exist(genes_file, 'file')
    genes_file = read_config('genes', process, true);
end
if exist(genes_file, 'file')
    update_conffile(config_file, 'genes', genes_file, ...
                    'File with genes sequences');
else
    update_conffile(config_file, 'genes', '', ...
                    'File with genes sequences');
    write_log(process, 'No genes file provided');
    en_genes = false;
    save([folder 'mats/fp' num2str(process) '.mat'], 'genes_file');
    return
end

[genes_name genes_seq] = import_fasta_sequence(genes_file, process);
if fatal_error > 0; return; end

%% Save output
save([folder 'mats/fp' num2str(process) '.mat'], 'genes_file', ...
    'genes_name', 'genes_seq');
write_log(process, 'Imported gene sequences');

%% Process finished
write_log(process);
