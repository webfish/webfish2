function OS = get_os_type(process)

[st, w] = unix('uname');
error_msg(process, st, {'Failed getting the system type', w});
if st ~= 0 || length(w) < 1
    OS = 0;
else
    if ~isempty(strfind(lower(w), 'darwin'))
        OS = 1;     % MAC OS X computer
	elseif ~isempty(strfind(lower(w), 'linux'))
        OS = 2;     % Linux computer
	else
        OS = 0;     % Unknown operating system
    end
end
