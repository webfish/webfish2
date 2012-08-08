function report_nonun_frags(process)
global last_process
global log_file
global target_name
global nonuniq_frag_name
global nonuniq_frag_pos
global rep_hits
global rep_hits_sel
global nonuniq_frag_seq
global nonuniq_frag_seq_over
global nonuniq_frag_pos_clone
global nonuniq_frag_seq_clone
global aln_pos
global sel_nonun_frags
global fatal_error
global enzymes
global folder
global nonuniq_frag_name_sel
global nonuniq_frag_seq_sel
global nonuniq_frag_seq_over_sel
global nonuniq_frag_pos_sel
global nonuniq_frag_pos_clone_sel
global nonuniq_frag_seq_clone_sel

alph = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

%% Check if fragments are produced
if last_process >= process
    load([folder 'mats/fp' num2str(process) '.mat']);
    write_log(process, 'Report about non-unique segments finished');
    write_log(process);
    return
end

%% Open a file to write the fragment sequences
[fid, w] = fopen([log_file(1 : end - 3) 'nonunique_segs.txt'], 'w');
if fid == -1
    fatal_error = 1;
    fatal_msg(process, ...
        {'Failed writing file with non-unique fragments', w});
    return
end

%% Print the report
for i = 1 : length(target_name)
    %% Modify sequence ID to get rid of invalid escape sequence
    seq_id = regexprep(target_name{i}, '\\\\', '\');
    seq_id = regexprep(seq_id, '\\', '\\');

    fprintf(fid, [repmat('*', 1, length(target_name{i}) + 8) '\n']);
    fprintf(fid, ['*   ' seq_id '   *\n']);
    fprintf(fid, [repmat('*', 1, length(target_name{i}) + 8) '\n\n']);
    AB = false(size(nonuniq_frag_seq{i}, 2), aln_pos(i, 2) - aln_pos(i, 1));
    if isempty(nonuniq_frag_name)
        continue
    end
    for m = 1 : length(nonuniq_frag_seq{i})
        fprintf(fid, ['Target sequence: ' seq_id '\n']);
        fprintf(fid, ['Segment name: ' nonuniq_frag_name{i}{m} '\n']);
        fprintf(fid, ['Segment from: ' ...
            num2str(nonuniq_frag_pos{i}(1, m)) ' bp\n']);
        fprintf(fid, ['Segment to: ' ...
            num2str(nonuniq_frag_pos{i}(2, m)) ' bp\n']);
        fprintf(fid, ['Segment length: ' ...
            num2str(nonuniq_frag_pos{i}(2, m) - ...
            nonuniq_frag_pos{i}(1, m) + 1) ' bp\n']);
        fprintf(fid, ['Cloning segment from: ' ...
            num2str(nonuniq_frag_pos_clone{i}(1, m)) ' bp\n']);
        fprintf(fid, ['Cloning segment to: ' ...
            num2str(nonuniq_frag_pos_clone{i}(2, m)) ' bp\n']);
        fprintf(fid, ['Cloning segment length: ' ...
            num2str(nonuniq_frag_pos_clone{i}(2, m) - ...
            nonuniq_frag_pos_clone{i}(1, m) + 1) ' bp\n']);
        aln_bin = false(1, aln_pos(i, 2) - aln_pos(i, 1));
        aln_bin(nonuniq_frag_pos{i}(1, m) : nonuniq_frag_pos{i}(2, m)) ...
            = true;
        if ~isempty(rep_hits{i}{m})
            for k = 1 : size(rep_hits{i}{m}, 2)
                s = sort(rep_hits{i}{m}(1 : 2, k));
                aln_bin(s(1) : s(2)) = 1;
            end
        end
        aln_len = length(find(aln_bin));
        AB(m, :) = aln_bin;
        fprintf(fid, ['Total length covered by the segment: ' ...
            num2str(aln_len) ' bp\n']);

        %% added 24.5.2012 to report about the non-target binding %%
        tmp = [0 aln_bin 0];
        starts = find((aln_bin - [0 aln_bin(1 : end - 1)]) == 1);
        ends = find((aln_bin - [aln_bin(2 : end) 0]) == 1);
        for k = 1 : numel(starts)
            fprintf(fid, ...
                'Repetitive FISH probe binding site from %d to %d\n', ...
                starts(k), ends(k));
        end
        %% added 24.5.2012 to report about the non-target binding %%

        sites = restrictioncut(nonuniq_frag_seq_clone{i}{m});
        if fatal_error > 0
            fclose(fid);
            return
        end
        for n = find(~isnan(sites(:)))'
            fprintf(fid, ['Number of ' enzymes{n} ' sites: ' ...
                num2str(sites(n)) '\n']);
        end
        fprintf(fid, ['Segment sequence: ' nonuniq_frag_seq{i}{m} '\n']);
        fprintf(fid, ['Segment sequence with overhang: ' ...
            nonuniq_frag_seq_over{i}{m} '\n']);
        fprintf(fid, ['Cloned sequence: ' ...
            nonuniq_frag_seq_clone{i}{m} '\n\n']);
    end
end
fclose(fid);

%% Print the report for lower number of fragments

nonuniq_frag_name_sel = cell(length(target_name), 1);
nonuniq_frag_pos_sel = cell(length(target_name), 1);
nonuniq_frag_pos_over_sel = cell(length(target_name), 1);
nonuniq_frag_pos_clone_sel = cell(length(target_name), 1);
nonuniq_frag_seq_clone_sel = cell(length(target_name), 1);
nonuniq_frag_seq_sel = cell(length(target_name), 1);
nonuniq_frag_seq_over_sel = cell(length(target_name), 1);
sel_nonun_frags = cell(length(target_name), 1);
rep_hits_sel = cell(length(target_name), 1);
for i = 1 : length(target_name)
    %% Modify sequence ID to get rid of invalid escape sequence
    seq_id = regexprep(target_name{i}, '\\\\', '\');
    seq_id = regexprep(seq_id, '\\', '\\');

    combs = 1 : numel(nonuniq_frag_seq{i});
    ALN_BIN = false(1, size(AB, 2));
    sel_combs = zeros(1, min(5, length(nonuniq_frag_seq{i})));
    for n = 1 : numel(sel_combs)
        [fid, w] = fopen([log_file(1 : end - 3) 'nonunique_segs-' ...
            num2str(n) '.txt'], 'w');
        if fid == -1
            fatal_error = 1;
            fatal_msg(process, {['Failed writing file with ' num2str(n) ...
                ' non-unique fragments'], w});
            return
        end
        write_log(process, ['Checking combinations of ' num2str(n) ...
            ' non-unique segments']);
        fprintf(fid, [repmat('*', 1, length(target_name{i}) + 8) '\n']);
        fprintf(fid, ['*   ' seq_id '   *\n']);
        fprintf(fid, [repmat('*', 1, length(target_name{i}) + 8) '\n\n']);
        aln_len = zeros(size(combs));
        for p = 1 : numel(combs)
            aln_len(p) = sum(ALN_BIN | AB(combs(p), :));
        end
        [v, max_len] = max(aln_len);
        sel_combs(n) = combs(max_len);
        combs(max_len) = [];
        ALN_BIN = ALN_BIN | AB(max_len, :);
        fprintf(fid, ['Total length covered by ' num2str(n) ...
            ' segments: ' num2str(aln_len(max_len)) '\n']);
        for q = 1 : n
            nonuniq_frag_name_sel{i}{n}{q} = ...
                nonuniq_frag_name{i}{sel_combs(q)};
            if isnan(str2double(nonuniq_frag_name_sel{i}{n}{q}(end)))
                nonuniq_frag_name_sel{i}{n}{q} = ...
                    [nonuniq_frag_name_sel{i}{n}{q}(1 : end - 1) alph(q)];
            end
            nonuniq_frag_seq_sel{i}{n}{q} = ...
                nonuniq_frag_seq{i}{sel_combs(q)};
            nonuniq_frag_seq_over_sel{i}{n}{q} = ...
                nonuniq_frag_seq_over{i}{sel_combs(q)};
            nonuniq_frag_pos_sel{i}{n}(:, q) = ...
                nonuniq_frag_pos{i}(:, sel_combs(q));
            nonuniq_frag_pos_clone_sel{i}{n}(:, q) = ...
                nonuniq_frag_pos_clone{i}(:, sel_combs(q));
            nonuniq_frag_seq_clone_sel{i}{n}{q} = ...
                nonuniq_frag_seq_clone{i}{sel_combs(q)};
            sel_nonun_frags{i}{n}(q) = sel_combs(q);
            rep_hits_sel{i}{n}{q} = rep_hits{i}{sel_combs(q)};
            fprintf(fid, ['Target sequence: ' seq_id '\n']);
            fprintf(fid, ['Original segment name: ' ...
                nonuniq_frag_name{i}{sel_combs(q)} '\n']);
            fprintf(fid, ['Segment name: ' ...
                nonuniq_frag_name_sel{i}{n}{q} '\n']);
            fprintf(fid, ['Segment from: ' ...
                num2str(nonuniq_frag_pos_sel{i}{q}(1)) ' bp\n']);
            fprintf(fid, ['Segment to: ' ...
                num2str(nonuniq_frag_pos_sel{i}{q}(2)) ' bp\n']);
            fprintf(fid, ['Segment length: ' ...
                num2str(nonuniq_frag_pos_sel{i}{q}(2) - ...
                nonuniq_frag_pos_sel{i}{q}(1) + 1) ' bp\n']);
            fprintf(fid, ['Clone segment from: ' ...
                num2str(nonuniq_frag_pos_clone_sel{i}{q}(1)) ' bp\n']);
            fprintf(fid, ['Clone segment to: ' ...
                num2str(nonuniq_frag_pos_clone_sel{i}{q}(2)) ' bp\n']);
            fprintf(fid, ['Clone segment length: ' ...
                num2str(nonuniq_frag_pos_clone_sel{i}{q}(2) - ...
                nonuniq_frag_pos_clone_sel{i}{q}(1) + 1) ' bp\n']);
            sites = restrictioncut(nonuniq_frag_seq_clone_sel{i}{n}{q});
            if fatal_error > 0
                fclose(fid);
                return
            end
            for r = find(~isnan(sites(:)))'
                fprintf(fid, ['Number of ' enzymes{r} ' sites: ' ...
                    num2str(sites(r)) '\n']);
            end
            fprintf(fid, ['Segment sequence: ' ...
                nonuniq_frag_seq_sel{i}{n}{q} '\n']);
            fprintf(fid, ['Segment sequence with overhang: ' ...
                nonuniq_frag_seq_over_sel{i}{n}{q} '\n\n']);
            fprintf(fid, ['Clone segment sequence: ' ...
                nonuniq_frag_seq_clone_sel{i}{n}{q} '\n\n']);
        end
        fprintf(fid, '\n');
        fclose(fid);
    end
end


%% Save output
save([folder 'mats/fp' num2str(process) '.mat'], 'sel_nonun_frags', ...
    'rep_hits_sel', 'nonuniq_frag_name_sel', 'nonuniq_frag_seq_sel', ...
    'nonuniq_frag_seq_over_sel', 'nonuniq_frag_pos_sel', ...
    'nonuniq_frag_pos_clone_sel', 'nonuniq_frag_seq_clone_sel');
write_log(process, 'Wrote report about non-unique segments');

%% Process finished
write_log(process);
