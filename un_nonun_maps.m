function un_nonun_maps(process)
global last_process
global folder
global target_name
global nonuniq_bin
global nonuniq_map
global uniq_map
global nonuniq_reg
global uniq_reg
global restrict_sequence

%% Load saved target sequences
if last_process >= process
    load([folder 'mats/fp' num2str(process) '.mat']);
    write_log(process, 'Loaded maps of unique and non-unique sequences');
    write_log(process);
    return
end

%% Map of non-unique and unique regions
nonuniq_map = cell(1, length(target_name));
uniq_map = cell(1, length(target_name));

for i = 1 : length(target_name)
    %% Modify the nonuniq_bin to account for restricted sequences
    NUB = int8(nonuniq_bin{i});
    for j = 1 : size(restrict_sequence{i}, 1)
        rss = max(1, restrict_sequence{i}(j, 1));
        rse = min(numel(NUB), restrict_sequence{i}(j, 2));
        NUB(rss : rse) = 10;
    end
    %% Identify starts and ends of unique and similar sequences
    [uniq_map{i}, nonuniq_map{i}] = partition_vector(NUB);
    %    tmp1 = [nonuniq_bin{i}(1) nonuniq_bin{i}];
    %tmp2 = [nonuniq_bin{i} nonuniq_bin{i}(end)];
    %tmp3 = tmp1 - tmp2;
    
    %nonuniq_to = find(tmp3 == 1) - 1;
    %nonuniq_from = find(tmp3 == -1);
    %uniq_to = find(tmp3 == -1) - 1;
    %uniq_from = find(tmp3 == 1);
    %if nonuniq_bin{i}(1) == 1
    %    nonuniq_from = [1 nonuniq_from];	%#ok<AGROW>
    %else
    %    uniq_from = [1 uniq_from];          %#ok<AGROW>
    %end
    %e = length(nonuniq_bin{i});
    %if nonuniq_bin{i}(e) == 1
    %    nonuniq_to = [nonuniq_to e];        %#ok<AGROW>
    %else
    %    uniq_to = [uniq_to e];              %#ok<AGROW>
    %end
    %nonuniq_map{i} = vertcat(nonuniq_from, nonuniq_to);
    %uniq_map{i} = vertcat(uniq_from, uniq_to);
end

%% Unique and non-unique regions
nonuniq_reg = nonuniq_map;
uniq_reg = uniq_map;

%% Save output
write_log(process, 'Maps of unique and non-uniques regions generated');
save([folder 'mats/fp' num2str(process) '.mat'], 'uniq_map', ...
    'nonuniq_map', 'uniq_reg', 'nonuniq_reg');

%% Process finished
write_log(process);
