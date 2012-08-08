function nonun_gaps(process)
global last_process
global folder
global target_name
global nonuniq_reg
global max_nonuniq_gap

%% Load saved target sequences
if last_process >= process
    load([folder 'mats/fp' num2str(process) '.mat']);
    write_log(process, 'Gaps within non-unique sequences merged');
    write_log(process);
    return
end

%% Check for gaps within non-unique regions
write_log(process, ...
    'Merging non-unique regions separated by small enough gaps');
for i = 1 : length(target_name)
    j = 1;
    while j < size(nonuniq_reg{i}, 2)
        if nonuniq_reg{i}(1, j + 1) - nonuniq_reg{i}(2, j) <= ...
                max_nonuniq_gap
            nonuniq_reg{i}(2, j) = nonuniq_reg{i}(2, j + 1);
            nonuniq_reg{i}(:, j + 1) = [];
        else
            j = j + 1;
        end
    end
end

%% Save output
write_log(process, ...
    'Merged non-unique regions separated by small enough gap');
save([folder 'mats/fp' num2str(process) '.mat'], 'nonuniq_reg');

%% Process finished
write_log(process);