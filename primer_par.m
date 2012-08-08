function primer_par(process)
global last_process
global folder
global primer_opt_size
global primer_min_size
global primer_max_size
global primer_opt_temp
global primer_min_temp
global primer_max_temp
global primer_max_tm_diff
global primer_salt
global primer_gc_clamp
global primer_min_gc
global primer_max_gc
global config_file
global fatal_error
global primer3_dir

%% Load saved target sequences
if last_process >= process
    load([folder 'mats/fp' num2str(process) '.mat']);
    write_log(process, 'Analysis parameters loaded');
    write_log(process);
    return
end

%% Import target sequences from fasta file
primer_opt_size = ...
    round(read_config('primer_opt_size', process, false));
primer_min_size = ...
    round(read_config('primer_min_size', process, false));
primer_max_size = ...
    round(read_config('primer_max_size', process, false));
primer_opt_temp = read_config('primer_opt_temp', process, false);
primer_min_temp = read_config('primer_min_temp', process, false);
primer_max_tm_diff = read_config('primer_max_tm_diff', process, false);
primer_max_temp = read_config('primer_max_temp', process, false);
primer_salt = ...
    round(read_config('primer_salt_corrections', process, false));
primer_gc_clamp = ...
    round(read_config('primer_gc_clamp', process, false));
primer_min_gc = ...
    round(read_config('primer_min_gc', process, false));
primer_max_gc = ...
    round(read_config('primer_max_gc', process, false));

%% Check values
primer_opt_size = check_value(process, primer_opt_size, ...
    'primer_opt_size', [18, 13, 32], [12, 35]);
primer_min_size = check_value(process, primer_min_size, ...
    'primer_min_size', [15, 12, 33], [12, 35]);
primer_max_size = check_value(process, primer_max_size, ...
    'primer_max_size', [21, 14, 35], [12, 35]);
if primer_min_size >= primer_opt_size
    primer_min_size = primer_opt_size - 1;
end
update_conffile(config_file, 'primer_min_size', num2str(primer_min_size))
if primer_max_size <= primer_opt_size
    primer_max_size = primer_opt_size + 1;
end
update_conffile(config_file, 'primer_max_size', num2str(primer_max_size))

primer_opt_temp = check_value(process, primer_opt_temp, ...
    'primer_opt_temp', [60, 51, 71], [30, 80]);
primer_min_temp = check_value(process, primer_min_temp, ...
    'primer_min_temp', [57, 50, 70], [30, 80]);
primer_max_temp = check_value(process, primer_max_temp, ...
    'primer_max_temp', [63, 52, 72], [30, 80]);
primer_max_tm_diff = check_value(process, primer_max_tm_diff, ...
    'primer_max_tm_diff', [1, 4, 100], [1, 100]);
if primer_min_temp >= primer_opt_temp
    primer_min_temp = primer_opt_temp - 0.1;
end
update_conffile(config_file, 'primer_min_temp', num2str(primer_min_temp))
if primer_max_temp <= primer_opt_temp
    primer_max_temp = primer_opt_temp + 0.1;
end
update_conffile(config_file, 'primer_max_temp', num2str(primer_max_temp))

primer_salt = check_value(process, primer_salt, ...
    'primer_salt_corrections', [1, 1, 1], [0, 2]);

primer_gc_clamp = check_value(process, primer_gc_clamp, ...
    'primer_gc_clamp', [1, 0, 3], [0, primer_min_size]);

primer_min_gc = check_value(process, primer_min_gc, ...
    'primer_min_gc', [30, 10, 70], [0, 99]);
primer_max_gc = check_value(process, primer_max_gc, ...
    'primer_max_gc', [70, 30, 90], [2, 100]);
if primer_min_gc >= primer_max_gc
    primer_min_gc = primer_max_gc - 1;
end
update_conffile(config_file, 'primer_min_gc', num2str(primer_min_gc))

%% Make sure primer3_dir ends with a slash
if ~isempty(primer3_dir)
    if primer3_dir(end) ~= '/'
        primer3_dir = [primer3_dir '/'];
    end
end

if fatal_error == 1
    return
end

%% Save output
save([folder 'mats/fp' num2str(process) '.mat'], 'primer_opt_size', ...
    'primer_min_size', 'primer_max_size', 'primer_opt_temp', ...
    'primer_min_temp', 'primer_max_temp', 'primer_salt', ...
    'primer_gc_clamp', 'primer_min_gc', 'primer_max_gc', ...
    'primer_max_tm_diff', 'primer3_dir');
write_log(process, 'Imported analysis parameters');

%% Process finished
write_log(process);