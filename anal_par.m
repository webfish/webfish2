function anal_par(process)
global last_process
global folder
global min_uniq_length
global min_nonuniq_length
global max_nonuniq_gap
global min_pcr_size
global max_pcr_size
global min_rep_pcr_size
global max_rep_pcr_size
global pcr_overlap
global Apcro
global Npcro
global pcrSteps
global blast_length
global enzymes
global fatal_error

%% Load saved target sequences
if last_process >= process
    load([folder 'mats/fp' num2str(process) '.mat']);
    write_log(process, 'Analysis parameters loaded');
    write_log(process);
    return
end

%% Import target sequences from fasta file
min_uniq_length = ...
    round(read_config('min_uniq_reg', process, false));
min_nonuniq_length = ...
    round(read_config('min_sim_reg', process, false, 'min_nonuniq_length'));
max_nonuniq_gap = ...
    round(read_config('max_sim_gap', process, false, 'max_nonuniq_gap'));
min_pcr_size = round(read_config('min_uniq_pcr', process, ...
                                 false, 'min_pcr_size'));
max_pcr_size = round(read_config('max_uniq_pcr', process, false, ...
                                 'max_pcr_size'));

min_rep_pcr_size = ...
    round(read_config('min_sim_pcr', process, false, 'min_rep_pcr_size'));
max_rep_pcr_size = ...
    round(read_config('max_sim_pcr', process, false, 'max_rep_pcr_size'));
pcr_overlap = round(read_config('pcr_overlap', process, false));
enzymes = read_config('enzymes', process, true);
% connect several lines of enzymes
if iscell(enzymes)
        e = '';
        for i = 1 : numel(enzymes)
                e = horzcat(e, enzymes{i});
                if i < numel(enzymes)
                        e = horzcat(e, ',');
                end
        end
        enzymes = e;
        clear e;
end
% remove spaces and tabs from enzymes
enzymes = regexprep(enzymes, '[ \t]', '');
if ~isempty(enzymes)
    enzymes = textscanO(enzymes, 44);
end

%% Check values
min_pcr_size = check_value(process, min_pcr_size, 'min_uniq_pcr', ...
    [4000, 500, 4000], [300, blast_length]);
max_pcr_size = check_value(process, max_pcr_size, 'max_uniq_pcr', ...
    [8000, min_pcr_size + 100, 8000], [min_pcr_size, blast_length]);
min_rep_pcr_size = check_value(process, min_rep_pcr_size, 'min_sim_pcr', ...
    [4000, 500, 4000], [300, blast_length]);
max_rep_pcr_size = check_value(process, max_rep_pcr_size, 'max_sim_pcr', ...
    [8000, min_pcr_size + 100, 8000], [min_pcr_size, blast_length]);
min_uniq_length = check_value(process, min_uniq_length, ...
    'min_uniq_reg', [4000, max([1000, min_pcr_size]), 4000], ...
    [max([1000, min_pcr_size]), blast_length]);
min_nonuniq_length = check_value(process, min_nonuniq_length, ...
    'min_sim_reg', [4000, max([1000, min_pcr_size]), 4000], ...
    [max([1000, min_pcr_size]), blast_length]);
max_nonuniq_gap = check_value(process, max_nonuniq_gap, ...
    'max_sim_gap', [1000, 0, 4000], [100, blast_length]);

pcr_lim = round(min([min_pcr_size, min_rep_pcr_size]) / 2);
pcr_overlap_abs = check_value(process, abs(pcr_overlap), 'pcr_overlap', ...
    [300, 50, pcr_lim], [50, pcr_lim]);
pcr_overlap = check_value(process, sign(pcr_overlap) * pcr_overlap_abs, ...
    'pcr_overlap', [0, 0, 0], [-pcr_lim, pcr_lim]);

Apcro = abs(pcr_overlap);
Npcro = - (Apcro / pcr_overlap - 1) / 2;
if Apcro > 100
    pcrSteps = 100 : 100 : Apcro;
    if pcrSteps(end) < Apcro
        pcrSteps = horzcat(pcrSteps, Apcro);
    end
else
    pcrSteps = Apcro;
end

if fatal_error == 1
    return
end

%% Save output
save([folder 'mats/fp' num2str(process) '.mat'], 'min_uniq_length', ...
    'min_nonuniq_length', 'max_nonuniq_gap', 'min_pcr_size', ...
    'max_pcr_size', 'min_rep_pcr_size', 'max_rep_pcr_size', ...
    'enzymes', 'pcr_overlap', 'Apcro', 'Npcro', 'pcrSteps');
write_log(process, 'Imported analysis parameters');

%% Process finished
write_log(process);
