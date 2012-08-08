function variable = check_text(process, variable, varname, def_val, list)
global config_file

% Function that checks if imported string value is part of an allowed list
% 'variable' is the variable to check
% 'varname' is the variable name
% 'def_val' is a string containing the preffered option if the variable is
% invalid
% 'lims' is a cell of strings containing the permissible options

if ~cellfun(@(x) strcmp(x, variable), list)
	in = min(find(cellfun(@(x) strcmpi(x, variable), list)));
	if ~isempty(in)
		variable = list{in};
	else
		error_msg(process, 1, {['Using ' varname ' ''' def_val ...
			''', Could not acquire ' varname ]});
		variable = def_val;
	end
end

update_conffile(config_file, varname, variable)
