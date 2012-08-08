function log = check_logical(process, log, log_name, def_log)
global config_file

if length(log) ~= 1 || isnan(log)
    log = def_log;
	error_msg(process, 1, {['Could not acquire ' log_name ], ...
        ['Using ' log_name ' of ' num2str(def_log)]});
else
    log = logical(log);
end

update_conffile(config_file, log_name, num2str(log))