function get_dbfiles(process)
global last_process
global genomes_dir
global fatal_error
global organism
global chr
global folder

%% Load saved target sequences
if last_process >= process
    load([folder 'mats/fp' num2str(process) '.mat']);
    write_log(process, 'Database file list loaded');
    write_log(process);
    return
end

%% Get the list of database files for your organism
files = dir([genomes_dir organism '/*.nhr']);
if isempty(files)
    fatal_error = 1;
    fatal_msg(process, {['The database for your organism ' organism ...
        ' cannot be loaded']});
    return
end
files = struct2cell(files);
chr = files(1, :);
for i = 1 : length(chr)
    [path, chr{i}] = fileparts(chr{i});
end

%% Save output
save([folder 'mats/fp' num2str(process) '.mat'], 'chr');
write_log(process, 'Loaded database file list');

%% Process finished
write_log(process);