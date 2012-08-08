function [aln_pos, aln_chr, aln_len, tar_pos] = ...
    get_1st_alns(process, target_name, target_seq, query_from, ...
    query_to, hit_from, hit_to, chromosome, chr, genes)
global matlaboroctave
global restrict_sequence
global fatal_error


aln_chr = cell(length(target_name), 1);
tar_pos = zeros(length(target_name), 2);
aln_pos = zeros(length(target_name), 2);
aln_len = zeros(length(target_name), 1);
for j = 1 : length(target_name)
    %% Modify sequence ID to get rid of invalid escape sequence
    seq_id = regexprep(target_name{j}, '\\\\', '\');
    seq_id = regexprep(seq_id, '\\', '\\');

    %% Check if target sequence contains undefined bases (other
    %% bases than ACGT)
    UB = false(size(target_seq{j}));
    UB(regexp(target_seq{j}, '[URYKMSWBDHVNX-]')) = true;
    %UB = target_seq{j} == 'N';

    %% Coding sequences and Undefined sequences
    [CSs, ENs] = partition_vector(UB);
    if nargin < 10
        %% Add undefined sequences to the restrict_sequences
        restrict_sequence{j} = vertcat(restrict_sequence{j}, ENs');
    end
    clear UB;

    %% Chromosome position
    CP = sort([hit_from{j}(1 : size(CSs, 2)), ...
               hit_to{j}(1 : size(CSs, 2))], 2);
    %% Query position
    QP = sort([query_from{j}(1 : size(CSs, 2)), ...
               query_to{j}(1 : size(CSs, 2))], 2);
    %% Chromosome mismatch, because the alignment can be reversed,
    %% both orientation must be tried
    CM1 = diff(CP, [], 2) - diff(CSs', [], 2);
    CM2 = diff(CP, [], 2) - flipud(diff(CSs', [], 2));
    if sum(abs(CM1)) < sum(abs(CM2))
        CM = CM1;
    else
        CM = CM2;
    end
    %% Query mismatch
    QM1 = diff(QP, [], 2) - diff(CSs', [], 2);
    QM2 = diff(QP, [], 2) - flipud(diff(CSs', [], 2));
    if sum(abs(QM1)) < sum(abs(QM2))
        QM = QM1;
    else
        QM = QM2;
    end
    %% Aligned position on the query
    tar_pos(j, :) = [min(QP(:)), max(QP(:))];
    %% Aligned position on the chromosome
    aln_pos(j, :) = [min(CP(:)), max(CP(:))];
    %% Length of the alignment
    aln_len(j) = aln_pos(j, 2) - aln_pos(j, 1) + 1;
    %% Chromosome of the alignment
    aln_chr{j} = horzcat(upper(chr{chromosome{j}(1)}(1)), ...
        lower(chr{chromosome{j}(1)}(2:end)));
    aln_chr{j} = regexprep(aln_chr{j}, '_', ' ');
    if sum([abs(CM); abs(QM)]) > 0
        error_msg(process, 1, {['Length of the target sequence "' ...
            seq_id '" and first alignment do not match']});
    end
    %% Check if the alignment length is more than 10 % different
    %% from the submitted length
    DIF = abs(sum(diff(CSs', [], 2)) - sum(diff(CP, [], 2)));
    if DIF / sum(diff(CSs', [], 2)) > 0.1
        msg = {['Length of alignment and the query sequence "' seq_id ...
                '" differ by more than 10 %%']};
        if nargin > 9
            error_msg(process, 1, msg);
        else
            fatal_error = 1;
            fatal_msg(process, msg);
        end
        return
    end
    %% Check if the multiple alignments are to the same chromosome
    if any(chromosome{j}(1 : size(CSs, 2)) ~= chromosome{j}(1))
        msg = {['Your query sequence "' seq_id ...
                '" is divided between more chromosomes']};
        if nargin > 9
            error_msg(process, 1, msg);
        else
            fatal_error = 1;
            fatal_msg(process, msg);
        end
        return
    end
    write_log(process, ['Localized target sequence "' ...
        seq_id '" on "' aln_chr{j} '"']);
end
