function update_conffile(fname, tag, value, comment)
global fatal_error

unix_cmd = ['grep ''^<' tag '>.*</' tag '>'' ' fname];
[st, w] = unix(unix_cmd); %#ok<NASGU>
if st == 0
    %    unix_cmd = ['sed ''s#<' tag '>\([^<][^<]*\)</' tag '>#<' tag '>' ...
    %    value '</' tag '>#'' ' fname ...
    %    ' > tasks/tmp; mv tasks/tmp ' fname];
    unix_cmd = sprintf(...
        'sed -i ''s#<%s>\\([^<]*\\)</%s>#<%s>%s</%s>#'' %s', ...
        tag, tag, tag, value, tag, fname);

    [st, w] = unix(unix_cmd);
    if st ~= 0
        fatal_error = 1;
        text = {['Failed modifying ' tag ' in the configuration file'], w};
        fatal_msg(process, text);
        return
    end
else
    [fid, w] = fopen(fname, 'a');
    if fid == -1
        fatal_error = 1;
        text = {'Configuration file cannot be updated', w};
        fatal_msg(process, text);
        return
    end
    if nargin == 4
        fprintf(fid, [comment '/n']);
    end
    fprintf(fid, ['<' tag '>' value '</' tag '>\n\n']);
    fclose(fid);
end