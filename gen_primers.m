function gen_primers(process)
global last_process
global target_name
global uniq_frag_pos
global uniq_frag_name
global nonuniq_frag_pos
global nonuniq_frag_name
global uniq_frag_primer
global nonuniq_frag_primer
global log_file
global folder
global fatal_error

%% Check if graphics is ready
if last_process >= process
    write_log(process, 'Primers generated');
    write_log(process);
    return
end

%% Open a file to write the fragment sequences
[pid, w] = fopen([log_file(1 : end - 3) 'primers.txt'], 'w');
if pid == -1
    fatal_error = 1;
    fatal_msg(process, {'Failed writing file with primers', w});
    return
end

%% Calculate primers
for i = 1 : length(target_name)
    %% Modify sequence ID to get rid of invalid escape sequence
    seq_id = regexprep(target_name{i}, '\\\\', '\');
    seq_id = regexprep(seq_id, '\\', '\\');

    write_log(process, ['Generating primers for target region ''' ...
        seq_id '''']);
    fprintf(pid, [repmat('*', 1, length(target_name{i}) + 8) '\n']);
    fprintf(pid, ['*   ' seq_id '   *\n']);
    fprintf(pid, [repmat('*', 1, length(target_name{i}) + 8) '\n\n\n']);
    for j = 1 : size(uniq_frag_pos{i}, 2)
        write_log(process, ['Generating primers for unique segment ''' ...
            uniq_frag_name{i}{j} '''']);
        fprintf(pid, [repmat('=', 1, 56) '\n']);
        fprintf(pid, ['Primers for segment ' uniq_frag_name{i}{j} ':\n']);
        fprintf(pid, [repmat('=', 1, 56) '\n\n']);
        %if pcr_overlap > 100
        %    overs = 100 : 100 : pcr_overlap;
        %    if overs(end) < pcr_overlap
        %        overs = horzcat(overs, pcr_overlap);
        %    end
        %else
        %    overs = pcr_overlap;
        %end
        %for k = overs
        %    [left_prim, right_prim] = primer3calc(process, ...
        %        uniq_frag_seq_over{i}{j}, ...
        %        [target_name{i} '-' uniq_frag_name{i}{j}], k);
        %    if ~isempty(left_prim) && ~isempty(right_prim)
        %        break
        %    end
        %end
        fprintf(pid, ['LEFT PRIMER:  ' ...
            upper(uniq_frag_primer{i}{1, j}) '\n']);
        fprintf(pid, ['RIGHT PRIMER: ' ...
            upper(uniq_frag_primer{i}{2, j}) '\n']); 
        fprintf(pid, '\n\n');
    end
    for j = 1 : size(nonuniq_frag_pos{i}, 2)
        write_log(process, ...
            ['Generating primers for non-unique segment ''' ...
            nonuniq_frag_name{i}{j} '''']);
        fprintf(pid, [repmat('=', 1, 56) '\n']);
        fprintf(pid, ...
            ['Primers for segment ' nonuniq_frag_name{i}{j} ':\n']);
        fprintf(pid, [repmat('=', 1, 56) '\n\n']);
        %if pcr_overlap > 100
        %    overs = 100 : 100 : pcr_overlap;
        %    if overs(end) < pcr_overlap
        %        overs = horzcat(overs, pcr_overlap);
        %    end
        %else
        %    overs = pcr_overlap;
        %end
        %for k = overs
        %    [left_prim, right_prim] = primer3calc(process, ...
        %        nonuniq_frag_seq_over{i}{j}, ...
        %        [target_name{i} '-' nonuniq_frag_name{i}{j}], k);
        %    if ~isempty(left_prim) && ~isempty(right_prim)
        %        break
        %    end
        %end
        %if fatal_error > 0; return; end
        fprintf(pid, ['LEFT PRIMER:  ' ...
            upper(nonuniq_frag_primer{i}{1, j}) '\n']);
        fprintf(pid, ['RIGHT PRIMER: ' ...
            upper(nonuniq_frag_primer{i}{2, j}) '\n']);
        fprintf(pid, '\n\n');
    end
end
fclose(pid);
if exist([folder 'primer'], 'file')
    delete([folder 'primer']);
end

%% Save output
write_log(process, 'Generated primers');

%% Process finished
write_log(process);
