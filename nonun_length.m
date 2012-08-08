function nonun_length(process)
global last_process
global folder
global aln_pos
global query_from
global query_to
global hit_from
global hit_to
global target_name
global nonuniq_vec
global nonuniq_reg
global uniq_reg
global min_uniq_length
global min_nonuniq_length

%% Load saved target sequences
if last_process >= process
    load([folder 'mats/fp' num2str(process) '.mat']);
    write_log(process, 'Long enough non-unique sequences selected');
    write_log(process);
    return
end

%% Select long enough non-unique regions
write_log(process, 'Selecting long enough non-unique regions');
for i = 1 : length(target_name)
    j = 1;
    while j <= size(nonuniq_reg{i}, 2)
        if nonuniq_reg{i}(2, j) - nonuniq_reg{i}(1, j) <= ...
                min_nonuniq_length
            nonuniq_reg{i}(:, j) = [];
        else
            j = j + 1;
        end
    end
end

%% Write report
for i = 1 : length(target_name)
    %% Modify sequence ID to get rid of invalid escape sequence
    seq_id = regexprep(target_name{i}, '\\\\', '\');
    seq_id = regexprep(seq_id, '\\', '\\');

    write_log(process, sprintf('"%s" non-unique regions: %d', seq_id, ...
                               size(nonuniq_reg{i}, 2)))
end

%% Save output
write_log(process, 'Selected long enough non-unique regions');
save([folder 'mats/fp' num2str(process) '.mat'], 'nonuniq_reg');

%% Process finished
write_log(process);