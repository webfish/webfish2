function config_out = read_config(hit_string, process, T, old_hit)
global config_file
global folder

%% Read value from the config file
unix_cmd = ['grep ''^<' hit_string '>'' -i ' config_file];
[st, w] = unix(unix_cmd);

%% Try if the old hit string is present
if st > 0 && nargin > 3
    unix_cmd = ['grep ''^<' old_hit '>'' -i ' config_file];
    [st, w] = unix(unix_cmd);
    if st == 0
        hit_string = old_hit;
    end
end

error_msg(process, st, {['Failed reading file ' config_file ...
                    ' while searching for: "' hit_string '"'], w});

if T == true
	config_out = '';
else
	config_out = [];
end
if st ~= 0
	return
end
dat = textscanO(w);
dat(cellfun(@isempty, dat)) = [];
dat = dat{1};
if numel(dat) == 0
	error_msg(process, st, {['Failed loading config file line: "' ...
		hit_string '"'], w});
	return
end
tp1 = strfind(dat, ['<' hit_string '>']);
tp2 = length(hit_string) + 2;
tp3 = strfind(dat, ['</' hit_string '>']);
d = dat(tp1 + tp2 : tp3 - 1);
if T == true
	config_out = d;
else
	config_out = str2num(d);
end
write_log(process, [hit_string ': ' d]);
