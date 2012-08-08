function load_log(process)
global last_process
global log_file
global folder
global tasks
%global outtasks

%% Identify root of config_file name
%dot_pos = strfind(config_file, '.');
%if isempty(dot_pos)
%    folder = [config_file '/'];
%    log_file = [folder config_file '.log'];
%else
%    dot_pos = strfind(config_file, '.');
%    log_file = config_file(1:(dot_pos(end) - 1));
%    dot_pos = strfind(config_file, '/');
%    if isempty(dot_pos)
%        dot_pos = 0;
%    end
%    log_file = log_file(dot_pos + 1 : end);
%    folder = ['tasks/' outtask{1} '/'];
%    log_file = [folder log_file '.log'];
%    clear dot_pos;
%end

%folder = ['tasks/' outtasks{1} '/'];
%log_file = [folder outtasks{1} '.log'];

folder = ['tasks/' tasks{1} '/'];
log_file = [folder tasks{1} '.log'];

%% Find log file
files = dir(log_file);

%% Create log file if it does not exist
if isempty(files) || last_process == -1
    % create necessary folders
    [st, w] = mkdir(folder);
    error_msg(process, st - 1, {['Failed creating directory ' folder], w});
    [st, w] = mkdir([folder 'mats']);
    error_msg(process, st - 1, {['Failed creating directory ' folder ...
        'mats'], w});
    %mkdir([folder 'images']);
    %mkdir([folder 'mummer']);
    write_log(process, 'Log file created', 'w');
    last_process = 0;
    write_log(process);
    return
end

%% Start adding to the existing log file
if isempty(files) == 0
    % read progress of the last run if last_process is zero
    if last_process == 0
        unix_cmd = ['sed ''$!D'' ' log_file];
        [st, w] = unix(unix_cmd);
        error_msg(process, st, {['Failed loading log file ' log_file], w});
        if st ~= 0
        	last_process = 0;
		write_log(process);
        	return
       	end
        last_line = textscanO(w, 9);
        if numel(last_line) < 3
            error_msg(process, 1, {['Log file ' log_file 'corrupted'], w});
            write_log(process, 'Log file created', 'w');
            last_process = 0;
        else
            if strcmp(last_line{3}, 'Finished')
                last_process = str2double(last_line{1});
            else
                last_process = max([0 str2double(last_line{1}) - 1]);
            end
        end
        clear last_line
        delete([folder 'tmp']);
    end
    write_log(process, 'Program restarted');
end

%% Process finished
write_log(process);