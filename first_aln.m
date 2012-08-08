function first_aln(process)
global last_process
global folder
global query_from
global query_to
global hit_from
global hit_to
global tar_pos
global aln_pos
global aln_len
global aln_chr
global target_seq
global target_name
global chromosome
global chr
global fatal_error
global blast_length

%% Load saved target sequences
if last_process >= process
    load([folder 'mats/fp' num2str(process) '.mat']);
    write_log(process, 'Target sequences localized');
    write_log(process);
    return
end

%% Read the position of the first alignment
[aln_pos, aln_chr, aln_len, tar_pos] = get_1st_alns(process, ...
    target_name, target_seq, query_from, query_to, hit_from, hit_to, ...
    chromosome, chr);

%% Check if all alignments are on single chromosome
al_chr = zeros(1, length(chromosome));
for i = 1 : length(chromosome)
    al_chr(i) = chromosome{i}(1);
end
if std(al_chr) ~= 0
    fatal_error = 1;
    text = cell(1 + length(chromosome), 1);
    text{1} = 'Target sequences are located on different chromosomes!';
    for i = 1 : length(chromosome)
        text{i + 1} = [target_name{i} '\t' aln_chr{i}];
    end
    fatal_msg(process, text);
    return
end

%% Check if all alignments are within 1 MB
if max(max(aln_pos)) - min(min(aln_pos)) > blast_length
    fatal_error = 1;
    text = cell(3 + length(chromosome), 1);
    text{1} = 'Target sequences are located too far away!';
    text{2} = ['Maximum total target sequence span is ' ...
        num2str(blast_length) ' bp.'];
    text{3} = ['Your target sequence spans over ' ...
        num2str(max(max(aln_pos)) - min(min(aln_pos))) ' bp.'];
    for i = 1 : length(chromosome)
        text{i + 3} = [target_name{i} '\t' num2str(aln_pos(i, 1)) ...
            '\tto\t' num2str(aln_pos(i, 1))];
    end
    fatal_msg(process, text);
    return
end


%% Save output
save([folder 'mats/fp' num2str(process) '.mat'], 'tar_pos', 'aln_pos', ...
    'aln_chr', 'aln_len', 'fatal_error');
write_log(process, 'Localized all target sequences');

%% Process finished
write_log(process);