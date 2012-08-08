function check_fasta_seqs(process, target_seq, text)
global fatal_error

eseqs = find(cellfun(@isempty, target_seq));
if ~isempty(eseqs)
    fatal_error = 1;
    l = length(eseqs);
    if l == 1
        t = 'is';
    else
        t = 'are';
    end
    fatal_msg(process, {[num2str(l) ' of your ' text ' ' t ' empty'], ...
        ['Check that the formatting of the file which you have ' ...
        'uploaded complies with the FASTA format']});
    return
end