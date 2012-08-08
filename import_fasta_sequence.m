function [target_name, target_seq] = import_fasta_sequence(config_out, ...
    process)
global fatal_error
global blast_length
global folder

target_name = '';
target_seq = '';

%% Check if sequence file exists
file = dir(config_out);
if isempty(file)
    fatal_error = 1;
    fatal_msg(process, {'Your FASTA file could not be opened'});
    return
end

%% Check if sequence file is not too long
if file.bytes > blast_length * 1.1
    fatal_error = 1;
    fatal_msg(process, {['Target sequence is too long (' num2str(tsl) ...
        ' bp)'], ['Maximum target sequence length is ' ...
        num2str(blast_length) ' bp']});
    return
end

%% textread takes forever if the lines are too long, therefore we
%% need to wrap the lines before processing. The wrapping depends
%% on the length of the longest target sequence name
unix_cmd = sprintf(['fold -w`grep "^>" %s | awk "BEGIN {max=100} ' ...
                    'length>max {max=length} END {print max}"` %s ' ...
                    '| sed "/^>/ s/ /_/g"> /dev/shm/tmp.fa'], ...
                   config_out, config_out);

[st, w] = unix(unix_cmd);
if st ~= 0
    fatal_error = 1;
    fatal_msg(process, ...
        {['Failed trying to wrap lines in ''' config_out ''''], w});
    return
end
%% Extract names and sequences from the fasta file
sequence = textread('/dev/shm/tmp.fa', '%s');
delete('/dev/shm/tmp.fa');
%fid = fopen(config_out, 'r');
%if fid == -1
%    fatal_error = 1;
%    fatal_msg(process, {'Your FASTA file could not be opened'});
%    return
%end
%sequence = textscan(fid, '%s', 'delimiter', '\n', ...
%    'bufsize', round(blast_length * 1.1));
%fclose(fid);
%sequence = sequence{1};

%% Separate FASTA file into names and sequences
[target_name, target_seq] = ...
    separate_fasta(process, sequence, 'target sequence');
if fatal_error > 0; return; end

%% Check that names are existent and make new names is necessary
target_name = check_fasta_names(process, target_name);

%% Check if sequences are not empty
check_fasta_seqs(process, target_seq, 'target sequences')
if fatal_error > 0; return; end

%% Check that sequences contain only allowed characters
check_allowed_chars(process, target_seq, 'target sequences')
if fatal_error > 0; return; end
