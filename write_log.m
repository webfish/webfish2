function write_log(process, text, ftype)
global log_file
global log_time
global sendhtml
global fatal_error

%% Fill in file type and text if not provided
if nargin < 3
    % make filetype 'a' to append lines
    ftype = 'a';
end
if nargin == 1
    % write a process terminator
    outtext = [num2str(process) '\tFinished\t' datestr(now) '\n'];
else
    % write a date, time and process name
    outtext = [num2str(process) '\t' datestr(now) '\t' text '\n'];
end
%% Decide which log_file to use
if process == 0 || isempty(log_file)
    lf = '/var/log/octave/error.log';
else
    lf = log_file;
end

%% Appends a line to the log file
try
	[lid, w] = fopen(lf, ftype);
	fprintf(lid, outtext);
	fclose(lid);
end
fprintf(outtext);

%% Get log_time variable going
if isempty(log_time)
    log_time = zeros(size(clock));
end

%% Check the last upload time
if etime(clock, log_time) < 10 && nargin ~= 1
    sendhtml = false;
else
    sendhtml = true;
end

%% Print log on fatal error
if fatal_error > 0
    sendhtml = true;
end

%% Modify html log
if process > 0
    if nargin == 1
        htmltext = ['<span style="color:#00FF00">' num2str(process) ...
            '/25&nbsp&nbsp&nbsp;Finished&nbsp&nbsp&nbsp&nbsp;' ...
            datestr(now) '</span><br>'];
    else
        htmltext = [num2str(process) '/25&nbsp&nbsp&nbsp;' datestr(now) ...
            '&nbsp&nbsp&nbsp;' text '<br>'];
    end
    producehtml(process, {htmltext}, 'PROCESSING YOUR QUERY', {'</div></div>'});
    log_time = clock;
end
