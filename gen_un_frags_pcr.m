function gen_un_frags_pcr(process)
global last_process
global target_name
global uniq_frag_pos
global uniq_frag_pos_over
global uniq_frag_seq
global uniq_frag_seq_over
global uniq_frag_name
global uniq_reg
global folder
global target_seq
global min_pcr_size
global max_pcr_size
global log_file
global fatal_error
global uniq_frag_primer
global uniq_frag_pos_clone
global uniq_frag_seq_clone
global en_unreg
global restrict_sequence

%% Check if fragments are produced
if last_process >= process
    load([folder 'mats/fp' num2str(process) '.mat']);
    write_log(process, 'PCR fragments for unique sequences are ready');
    write_log(process);
    return
end

%% Define unique fragments positions
uniq_frag_pos = cell(length(target_name), 1);
uniq_frag_name = cell(length(target_name), 1);
uniq_frag_pos_over = cell(length(target_name), 1);
uniq_frag_seq = cell(length(target_name), 1);
uniq_frag_seq_over = cell(length(target_name), 1);
uniq_frag_primer = cell(length(target_name), 1);
uniq_frag_pos_clone = cell(length(target_name), 1);
uniq_frag_seq_clone = cell(length(target_name), 1);

%% Open a file to write the fragment sequences
[fid, w] = fopen([log_file(1 : end - 3) 'unique_segs.txt'], 'w');
if fid == -1
    fatal_error = 1;
    fatal_msg(process, {'Failed writing file with unique fragments', w});
    return
end

%% Split contiguous regions into fragments
for i = 1 : length(target_name)
    %% Modify sequence ID to get rid of invalid escape sequence
    seq_id = regexprep(target_name{i}, '\\\\', '\');
    seq_id = regexprep(seq_id, '\\', '\\');

    fprintf(fid, [repmat('*', 1, length(target_name{i}) + 8) '\n']);
    fprintf(fid, ['*   ' seq_id '   *\n']);
    fprintf(fid, [repmat('*', 1, length(target_name{i}) + 8) '\n\n']);
    
    [uniq_frag_name{i}, uniq_frag_pos{i}, uniq_frag_pos_over{i}, ...
        uniq_frag_seq{i}, uniq_frag_seq_over{i}, uniq_frag_primer{i}, ...
        uniq_frag_pos_clone{i}, uniq_frag_seq_clone{i}] = ...
        fragment_targets(process, uniq_reg{i}, min_pcr_size, ...
        max_pcr_size, 'U', target_seq{i}, seq_id, fid, en_unreg);

    if fatal_error > 0
        fclose(fid);
        return
    end
end
fclose(fid);

%% Delete fragments within the restricted region
%for k = 1 : length(target_name)
%   valIn = false(1, length(uniq_frag_seq{k}));
%   for j = 1 : size(restrict_sequence, 1)
%       valInT = logical(sum(sign(uniq_frag_pos_clone{k} - ...
%           ones(size(uniq_frag_pos_clone{k})) * ...
%           restrict_sequence(j, 1)) .* ...
%           sign(uniq_frag_pos_clone{k} - ...
%           ones(size(uniq_frag_pos_clone{k})) * ...
%           restrict_sequence(j, 2)) - 1));
%       valIn = valIn | valInT;
%   end
%   valIn = find(valIn);
%   uniq_frag_pos_clone{k}(:, valIn) = [];
%   uniq_frag_primer{k}(:, valIn) = [];
%   uniq_frag_seq_clone{k}(valIn) = [];
%   uniq_frag_pos{k}(:, valIn) = [];
%   uniq_frag_pos_over{k}(:, valIn) = [];
%   uniq_frag_seq{k}(valIn) = [];
%   uniq_frag_seq_over{k}(valIn) = [];
%   uniq_frag_name{k}(valIn) = [];
%end

%% Save output
save([folder 'mats/fp' num2str(process) '.mat'], 'uniq_frag_pos', ...
    'uniq_frag_pos_over', 'uniq_frag_seq', 'uniq_frag_seq_over', ...
    'uniq_frag_name', 'uniq_frag_primer', 'uniq_frag_pos_clone', ...
    'uniq_frag_seq_clone');
write_log(process, 'Generated PCR fragments for unique sequences');

%% Process finished
write_log(process);
