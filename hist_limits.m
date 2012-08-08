function hist_limits(process)
global last_process
global folder
global hist_pos
global target_name
global nonuniq_vec

%% Load saved target sequences
if last_process >= process
    load([folder 'mats/fp' num2str(process) '.mat']);
    write_log(process, 'Limits of histograms loaded');
    write_log(process);
    return
end

%% Find limits for each contiguous region of a histogram
hist_pos = cell(1, length(target_name));
for i = 1 : length(target_name)
    hist_bin = int8(sign(nonuniq_vec{i}));
	tmp1 = [hist_bin(1) hist_bin];
    tmp2 = [hist_bin hist_bin(end)];
    tmp3 = tmp1 - tmp2;

    hist_to = find(tmp3 == 1) - 1;
    hist_from = find(tmp3 == -1);
    if hist_bin(1) == 1
        hist_from = [1 hist_from]; %#ok<AGROW>
    end
    e = length(hist_bin);
    if hist_bin(e) == 1
        hist_to = [hist_to e]; %#ok<AGROW>
    end
    hist_pos{i} = vertcat(hist_from, hist_to);
end

%% Save output
write_log(process, 'Generated limits for histogram regions');
save([folder 'mats/fp' num2str(process) '.mat'], 'hist_pos');

%% Process finished
write_log(process);