function nonun_mistargets(process)
global last_process
global aln_pos
global target_name
global query_from
global query_to
global hit_from
global hit_to
global chromosome
global nonuniq_frag_pos
global nonuniq_reg
global folder
global rep_hits

%% Check if fragments are produced
if last_process >= process
    load([folder 'mats/fp' num2str(process) '.mat']);
    write_log(process, ...
        'Find localized similar sequences to non-unique PCR fragments');
    write_log(process);
    return
end

%% Define unique fragments positions
rep_hits = cell(length(target_name), 1);

%% Split histogram contiguous regions into fragments
for i = 1 : length(target_name)
    %% Modify sequence ID to get rid of invalid escape sequence
    seq_id = regexprep(target_name{i}, '\\\\', '\');
    seq_id = regexprep(seq_id, '\\', '\\');

    write_log(process, ['Identify non-target binding of segments ' ...
        'within non-unique regions of ''' seq_id '''']);
    rep_hits{i} = cell(size(nonuniq_frag_pos{i}, 2), 1);
    for j = 1 : size(nonuniq_frag_pos{i}, 2)
        ind = find(sum(sign(mean(nonuniq_frag_pos{i}(:, j)) - ...
            nonuniq_reg{i})) == 0);
        qf = int32(query_from{i});
        qt = int32(query_to{i});
        hf = int32(hit_from{i}) - int32(aln_pos(i, 1)) + 1;
        ht = int32(hit_to{i}) - int32(aln_pos(i, 1)) + 1;
        %% Indices of alignments for which the query is entirely
        %% within the nonunique fragment  position and the hit is
        %% entirely within the non unique region
        in1 = find(qf >= int32(nonuniq_frag_pos{i}(1, j)) & ...
            qf <= int32(nonuniq_frag_pos{i}(2, j)) & ...
            qt >= int32(nonuniq_frag_pos{i}(1, j)) & ...
            qt <= int32(nonuniq_frag_pos{i}(2, j)) & ...
            hf >= int32(nonuniq_reg{i}(1, ind)) & ...
            hf <= int32(nonuniq_reg{i}(2, ind)) & ...
            ht >= int32(nonuniq_reg{i}(1, ind)) & ...
            ht <= int32(nonuniq_reg{i}(2, ind)) & ...
            chromosome{i} == chromosome{i}(1));
        %% Indices of alignments for which the hit is entirely
        %% within the nonunique fragment position and the query is
        %% entirely within the non unique region
        in2 = find(hf >= int32(nonuniq_frag_pos{i}(1, j)) & ...
            hf <= int32(nonuniq_frag_pos{i}(2, j)) & ...
            ht >= int32(nonuniq_frag_pos{i}(1, j)) & ...
            ht <= int32(nonuniq_frag_pos{i}(2, j)) & ...
            qf >= int32(nonuniq_reg{i}(1, ind)) & ...
            qf <= int32(nonuniq_reg{i}(2, ind)) & ...
            qt >= int32(nonuniq_reg{i}(1, ind)) & ...
            qt <= int32(nonuniq_reg{i}(2, ind)) & ...
            chromosome{i} == chromosome{i}(1));
        %% Vector of unique similar positions arising from the hits
        tmp1 = horzcat(hf(in1), ht(in1));
        %% Vector of unique similar positions arising from the query
        tmp2 = horzcat(qf(in2), qt(in2));
        %% Merge the unique similar positions
        tmp = vertcat(tmp1, tmp2);
        %% Find only non-repetitive unique similar positions
        tmp = unique(tmp, 'rows')';
        %        in = find(abs(tmp1(1, :) - tmp2(1, :)) + ...
        %            abs(tmp1(2, :) - tmp2(2, :)));
        rep_hits{i}{j} = tmp; %#ok<FNDSB>
    end
end

%% Save output
save([folder 'mats/fp' num2str(process) '.mat'], 'rep_hits');
write_log(process, 'Generated PCR segments for non-unique sequences');

%% Process finished
write_log(process);
