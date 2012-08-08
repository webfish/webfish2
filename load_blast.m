function [bit_score, query_from, query_to, hit_from, hit_to, ...
          chromosome, del_genes] = ...
        load_blast(process, target_name, chr, genes)
global folder
global fatal_error
global blast_cutoff
global matlaboroctave
global include_haplo
global include_patch

del_genes = [];

bit_score = cell(length(target_name), 1);
query_from = bit_score;
query_to = bit_score;
hit_from = bit_score;
hit_to = bit_score;
chromosome = bit_score;
if matlaboroctave == true
	repstring = '\\\';
else
	repstring = '\\';
end

%% Include haplotype chromosomes
if ~include_haplo
    chr(~cellfun(@isempty, strfind(chr, 'HSCHR'))) = [];
end
%% Include chromosome patches
if ~include_patch
    chr(~cellfun(@isempty, strfind(chr, 'PATCH'))) = [];
end


for j = 1 : length(target_name)
    if exist('/dev/shm/out.tmp', 'file')
        delete('/dev/shm/out.tmp')
    end
    for i = 1 : length(chr)
        write_log(process, ['Import BLAST alignment for "' chr{i} '"']);
        % Select alignments with bit score of more than 200
        if ~exist(sprintf('%s%s.%u.out', folder, chr{i}, j), 'file');
            fatal_error = 1;
            fatal_msg(process, ...
                {sprintf('%s%s.%u.out does not exist', folder, chr{i}, j), w});  
            return
        end
        unix_cmd = sprintf('awk -F"\t" '' $NF > %u {print %u,$7,$8,$9,$10,$12} '' %s%s.%u.out >> /dev/shm/out.tmp', blast_cutoff, i, folder, chr{i}, j);
        [st, w] =  unix(unix_cmd);
        delete([folder chr{i} '.' num2str(j) '.out']);
        if st ~= 0
            fatal_error = 1;
            fatal_msg(process, ...
                {['Failed reading bit scores of alignments from "' ...
                chr{i} '"'], w});
            return
        end
    end
    %% Check if file is not empty
    unix_cmd = 'ls -l /dev/shm/out.tmp | awk {''print $5''}';
    [st, w] =  unix(unix_cmd);
    if st ~= 0
        fatal_error = 1;
        fatal_msg(process, ...
                  {['Failed loading bit scores of alignments from "' ...
                    chr{i} '"'], w});
        return
    end

    % Import bit score, query from, query to, hit from, hit to
    if isempty(w)
        out = zeros(0, 6);
        error_msg(process, 1, {sprintf('Gene %s not be aligned', ...
                                       target_name{j})});
    else
        if str2num(w) > 0
            load('/dev/shm/out.tmp')
        else
            out = zeros(0, 6);
            error_msg(process, 1, {sprintf('Gene %s not be aligned', ...
                                           target_name{j})});
        end
    end
    delete('/dev/shm/out.tmp')
    %% Sort the loaded values
    out = flipud(sortrows(out, 6));
    %% Distribute them into cells
    bit_score{j} = out(:, 6);
    query_from{j} = out(:, 2);
    query_to{j} = out(:, 3);
    hit_from{j} = out(:, 4);
    hit_to{j} = out(:, 5);
    chromosome{j} = out(:, 1);
    clear out;
end

%% Check if alignments are loaded properly

if nargin == 4
    del_genes = cellfun(@isempty, bit_score) | ...
        cellfun(@isempty, query_from) | ...
        cellfun(@isempty, query_to) | ...
        cellfun(@isempty, hit_from) | ...        
        cellfun(@isempty, hit_to) | ...
        cellfun(@isempty, chromosome);
    bit_score(del_genes) = [];
    query_from(del_genes) = [];
    query_to(del_genes) = [];
    hit_from(del_genes) = [];
    hit_to(del_genes) = [];
    chromosome(del_genes) = [];
    if any(del_genes)
        error_msg(process, 1, {'Some genes could not be aligned'; ...
                            'Check they are found in the selected genome'});
    end
else        
    if any(cellfun(@isempty, bit_score)) && ...
            any(cellfun(@isempty, query_from)) && ...
            any(cellfun(@isempty, query_to)) && ...
            any(cellfun(@isempty, hit_from)) && ...        
            any(cellfun(@isempty, hit_to)) && ...
            any(cellfun(@isempty, chromosome))
        fatal_error = 1;
        fatal_msg(process, {'Gene alignments have not loaded properly'; ...
                            ['Check that your genes come from the ' ...
                            'selected organism']});
    end
end
