function gen_nonun_frags_pcr(process)
global last_process
global target_name
global nonuniq_frag_pos
global nonuniq_frag_pos_over
global nonuniq_frag_seq
global nonuniq_frag_seq_over
global nonuniq_frag_name
global nonuniq_frag_primer
global nonuniq_frag_pos_clone
global nonuniq_frag_seq_clone
global nonuniq_reg
global folder
global target_seq
global min_rep_pcr_size
global max_rep_pcr_size
global hist_pos
global pcr_overlap
global restrict_sequence

%% Check if fragments are produced
if last_process >= process
    load([folder 'mats/fp' num2str(process) '.mat']);
    write_log(process, 'PCR fragments for non-unique sequences are ready');
    write_log(process);
    return
end

alph = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

%% Define unique fragments positions
nonuniq_frag_pos = cell(length(target_name), 1);
nonuniq_frag_pos_over = cell(length(target_name), 1);
nonuniq_frag_seq = cell(length(target_name), 1);
nonuniq_frag_seq_over = cell(length(target_name), 1);
nonuniq_frag_primer = cell(length(target_name), 1);
nonuniq_frag_pos_clone = cell(length(target_name), 1);
nonuniq_frag_seq_clone = cell(length(target_name), 1);


%% Split histogram contiguous regions into fragments
pcro = abs(pcr_overlap);
pcrpm = - (pcro / pcr_overlap - 1) / 2;
if pcro > 100
    overs = 100 : 100 : pcro;
    if overs(end) < pcro
        overs = horzcat(overs, pcro);
    end
else
    overs = pcro;
end
for i = 1 : length(target_name)
    %% Modify sequence ID to get rid of invalid escape sequence
    seq_id = regexprep(target_name{i}, '\\\\', '\');
    seq_id = regexprep(seq_id, '\\', '\\');

    m = 0;  % Variable numbering unique regions in given target
    % Index of each segment within the non-unique regions
    r = zeros(1, size(nonuniq_reg{i}, 2));
    %rep_hits{i} = cell(length(hist_map{i}), 1);
    for j = 1 : size(hist_pos{i}, 2)
        % Length of given histogram stretch
        hist_map_len = hist_pos{i}(2, j) - hist_pos{i}(1, j) + 1;
        % Histogram position in non-unique region
        ind = find(sum(sign(mean(hist_pos{i}(:, j)) - ...
            nonuniq_reg{i})) == 0);
        % Process long enough histogram stretches only
        if hist_map_len >= min_rep_pcr_size
            % Number of fragments to cover given histogram stretch
            nr_pcrs = ceil(hist_map_len / max_rep_pcr_size);
            right_pos = 0;
            for k = 1 : nr_pcrs
                if isempty(right_pos)
                    right_pos = NaN;
                end
                m = m + 1;
                r(ind) = r(ind) + 1;
                nonuniq_frag_name{i}{m} = ['S' num2str(ind) alph(r(ind))];
                for n = overs
                    if pcrpm == 0
                        start = max([right_pos, ...
                            round(hist_map_len * (k - 1) / nr_pcrs)]) + ...
                            hist_pos{i}(1, j) + pcrpm * n;
                    else
                        start = min([right_pos, ...
                            round(hist_map_len * (k - 1) / nr_pcrs)]) + ...
                            hist_pos{i}(1, j) + pcrpm * n;
                    end
                    % Starting position of PCR fragment
                    nonuniq_frag_pos{i}(1, m) = start;
                    % Ending position of PCR fragment
                    nonuniq_frag_pos{i}(2, m) = ...
                        round(hist_map_len * k / nr_pcrs) - ...
                        1 + hist_pos{i}(1, j) - pcrpm * n;
                    % Starting position of PCR fragment with overlap; it is
                    % trimmed so that it does not span further than the
                    % unique region
                    nonuniq_frag_pos_over{i}(1, m) = ...
                        max([hist_pos{i}(1, j), ...
                        nonuniq_frag_pos{i}(1, m) - n]);
                    % Ending position of PCR fragment with overlap; it is
                    % trimmed so that it does not span further than the
                    % unique region
                    nonuniq_frag_pos_over{i}(2, m) = ...
                        min([hist_pos{i}(2, j), ...
                        nonuniq_frag_pos{i}(2, m) + n]);
                    % Sequence of the PCR fragment
                    nonuniq_frag_seq{i}{m} = ...
                        target_seq{i}((nonuniq_frag_pos{i}(1, m) : ...
                        nonuniq_frag_pos{i}(2, m)));
                    % Sequence of the PCR fragment with overlap in lower case
                    % letters
                    nonuniq_frag_seq_over{i}{m} = ...
                        lower(target_seq{i}((nonuniq_frag_pos_over{i}...
                        (1, m) : nonuniq_frag_pos_over{i}(2, m))));
                    % Capitalize letters of the non-overlapping part of the PCR
                    % fragment
                    in = (nonuniq_frag_pos{i}(1, m) - ...
                        nonuniq_frag_pos_over{i}(1, m)) + ...
                        (1 : (nonuniq_frag_pos{i}(2, m) - ...
                        nonuniq_frag_pos{i}(1, m) + 1));
                    % Capitalize letters of the non-overlapping part of the PCR
                    % fragment
                    nonuniq_frag_seq_over{i}{m}(in) = ...
                        upper(nonuniq_frag_seq_over{i}{m}(in));
                    % Generate a primer
                    [left_prim, right_prim, left_pos, right_pos] = ...
                        primer3calc(process, ...
                        nonuniq_frag_seq_over{i}{m}, ...
                        [seq_id '-' nonuniq_frag_name{i}{m}], n);
                    if ~isempty(left_prim) && ~isempty(right_prim)
                        nonuniq_frag_primer{i}{1, m} = left_prim;
                        nonuniq_frag_primer{i}{2, m} = right_prim;
                        nonuniq_frag_pos_clone{i}(1 : 2, m) = ...
                            nonuniq_frag_pos_over{i}(1, m) + ...
                            double([left_pos; right_pos]);
                        nonuniq_frag_seq_clone{i}{m} = ...
                            target_seq{i}(nonuniq_frag_pos_over{i}...
                            (1, m) + double(left_pos : right_pos));
                        break
                    else
                        nonuniq_frag_primer{i}{1, m} = '';
                        nonuniq_frag_primer{i}{2, m} = '';
                        nonuniq_frag_pos_clone{i}(1 : 2, m) = [NaN; NaN];
                        nonuniq_frag_seq_clone{i}{m} = '';
                    end
                end
                % Give fragment a name
                %nonuniq_frag_name{i}{m} = ['N' num2str(k) alph(j)];

            end
        end
    end
end

%% Delete fragments within the restricted region
%nonuniq_frag_pos{1}(:, 8 : 10) = [];
%nonuniq_frag_pos_over{1}(:, 8 : 10) = [];
%nonuniq_frag_seq{1}(:, 8 : 10) = [];
%nonuniq_frag_seq_over{1}(:, 8 : 10) = [];
%nonuniq_frag_name{1}(:, 8 : 10) = [];

for k = 1 : length(target_name)
    valIn = false(1, length(nonuniq_frag_seq{k}));
    for j = 1 : size(restrict_sequence{k}, 1)
       valInT = sum(sign(nonuniq_frag_pos_clone{k} - ...
           ones(size(nonuniq_frag_pos_clone{k})) * ...
           restrict_sequence{k}(j, 1)) .* ...
           sign(nonuniq_frag_pos_clone{k} - ...
           ones(size(nonuniq_frag_pos_clone{k})) * ...
           restrict_sequence{k}(j, 2)) - 1);
       valInT(isnan(valInT)) = 1;
       valIn = valIn | logical(valInT);
   end
   valIn = find(valIn);
   nonuniq_frag_pos_clone{k}(:, valIn) = [];
   nonuniq_frag_primer{k}(:, valIn) = [];
   nonuniq_frag_seq_clone{k}(valIn) = [];
   nonuniq_frag_pos{k}(:, valIn) = [];
   nonuniq_frag_pos_over{k}(:, valIn) = [];
   nonuniq_frag_seq{k}(valIn) = [];
   nonuniq_frag_seq_over{k}(valIn) = [];
   nonuniq_frag_name{k}(valIn) = [];
end

%% Save output
save([folder 'mats/fp' num2str(process) '.mat'], 'nonuniq_frag_pos', ...
    'nonuniq_frag_pos_over', 'nonuniq_frag_seq', ...
    'nonuniq_frag_seq_over', 'nonuniq_frag_name', ...
    'nonuniq_frag_primer', 'nonuniq_frag_pos_clone', ...
    'nonuniq_frag_seq_clone');
write_log(process, 'Generated PCR fragments for non-unique sequences');

%% Process finished
write_log(process);