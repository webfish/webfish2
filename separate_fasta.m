function [target_name, target_seq] = ...
    separate_fasta(process, sequence, text)
global fatal_error
target_name = '';
target_seq = '';
%% Generate an error if sequence is empty
if isempty(sequence)
    starts = '';
else
    starts = find(cellfun(@numel,regexp(sequence, '^>', 'once')));
end

if isempty(starts)
    fatal_error = 1;
    fatal_msg(process, {['Your ' text ...
        ' FASTA file does not contain line starting with ">"'], ...
        ['Check that the formatting of the file which you have ' ...
        'uploaded complies with the FASTA format']});
    return
end
if starts(1) ~= 1
    fatal_error = 1;
    fatal_msg(process, {['The first line of your ' text ...
        ' FASTA file must start with ">"'], ...
        ['Check that the formatting of the file which you have ' ...
        'uploaded complies with the FASTA format']});
    return
end
seq_nr = length(starts);
if seq_nr == 1
    write_log(process, ...
        'Your target sequence file contains 1 sequence');
else
    write_log(process, ['Your target sequence file contains ' ...
        num2str(seq_nr) ' sequences']);
end
starts = vertcat(starts, length(sequence) + 1);
target_name = cell(seq_nr, 1);
target_seq = cell(seq_nr, 1);
for i = 1 : seq_nr
    target_name{i} = regexprep(sequence{starts(i)}(2 : end), ...
        '[~`?''?";<>\[\]()|&*^$%\s/,:]', '_');
    temp = sequence((starts(i) + 1) : (starts(i + 1) - 1));
    target_seq{i} = [temp{:}];
    if ~isempty(target_seq{i})
        target_seq{i} = upper(regexprep(target_seq{i}, '\s', ''));
    end
end