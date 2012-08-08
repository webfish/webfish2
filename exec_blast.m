function exec_blast(process, target_seq, target_name, chr)
global blast_dir
global blast_cpus
global folder
global exts
global fatal_error
global genomes_dir
global organism
global matlaboroctave
global include_haplo
global include_patch

%% Include haplotype chromosomes
if ~include_haplo
    chr(~cellfun(@isempty, strfind(chr, 'HSCHR'))) = [];
end
%% Include chromosome patches
if ~include_patch
    chr(~cellfun(@isempty, strfind(chr, 'PATCH'))) = [];
end

if matlaboroctave == true
	repstring = '\\\';
else
	repstring = '\\';
end

for i = 1 : length(chr)
    write_log(process, ['BLAST alignment on database "' chr{i} '"']);
    check_file_presence(process, [blast_dir 'megablast']);
    if fatal_error > 0; return; end
    for j = 1 : length(target_seq)
        write_log(process, ['BLAST alignment of "' ...
            regexprep(target_name{j}, '\\', repstring) '"']);
        % Write target file
        fid = fopen([folder 'target.fa'], 'w');
        if fid == -1
            fatal_error = 1;
            fatal_msg(process, {'Failed writing target file'});
            return
        end
        fprintf(fid, ['>' regexprep(target_name{j}, '\\', repstring) '\n']);
        fprintf(fid, [target_seq{j} '\n']);
        fclose(fid);

        % Perform megablast alignment
        for ext = exts
            check_file_presence(process, [genomes_dir organism '/' ...
                chr{i} '.' ext{1}]);
            if fatal_error > 0; return; end
        end
        check_file_presence(process, [folder 'target.fa']);
        if fatal_error > 0; return; end
        unix_cmd = [blast_dir 'megablast -d ' genomes_dir organism '/' ...
            chr{i} ' -i ' folder 'target.fa -F "F" -D 3 -a ' ...
            num2str(blast_cpus) ' -e 0.01 > ' folder chr{i} '.' ...
            num2str(j) '.out'];
        [st, w] =  unix(unix_cmd);
        if st ~= 0
            fatal_error = 1;
            fatal_msg(process, ...
                {['Failed running BLAST on target sequence "' ...
                target_name{j} '" using "' chr{i} '" database'], w});
            return
        end
    end
end
