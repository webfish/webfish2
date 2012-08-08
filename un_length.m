function un_length(process)
global last_process
global folder
global target_name
global uniq_reg
global min_uniq_length

%% Load saved target sequences
if last_process >= process
    load([folder 'mats/fp' num2str(process) '.mat']);
    write_log(process, 'Long enough unique sequences selected');
    write_log(process);
    return
end

%% Select long enough unique regions
write_log(process, 'Selecting long enough unique regions');
for i = 1 : length(target_name)
    j = 1;
    while j <= size(uniq_reg{i}, 2)
        if uniq_reg{i}(2, j) - uniq_reg{i}(1, j) <= ...
                min_uniq_length
            uniq_reg{i}(:, j) = [];
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

    write_log(process, sprintf('"%s" unique regions: %d', seq_id, ...
                               size(uniq_reg{i}, 2)))
end

%% Save output
write_log(process, 'Selected long enough unique regions');
save([folder 'mats/fp' num2str(process) '.mat'], 'uniq_reg');

%% Process finished
write_log(process);