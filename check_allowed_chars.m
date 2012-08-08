function check_allowed_chars(process, target_seq, text)
global fatal_error

allowed_chars = '[ACGTURYKMSWBDHVNX-]';
allowed_len = cellfun(@numel, regexp(target_seq, allowed_chars));
total_len = cellfun(@length, target_seq);
in = find(total_len - allowed_len);
if ~isempty(in)
    fatal_error = 1;
    l = length(in);
    if l == 1
        t = 'contains';
    else
        t = 'contain';
    end
    fatal_msg(process, {[num2str(l) ' of the ' text ' that you have ' ...
        'provided ' t ' illegal characters'], ...
        'Nucleotide FASTA can only contain ACGTURYKMSWBDHVNX-', ...
        ['Check that the formatting of the file which you have ' ...
        'uploaded complies with the FASTA format']});
    return
end