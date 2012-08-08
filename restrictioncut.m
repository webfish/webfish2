function sites = restrictioncut(seq)
global fatal_error
global enzymes
global emboss_dir

sites = NaN * ones(size(enzymes));
if isempty(seq)
    return
end

elist = sprintf('%s,', enzymes{:});
elist(end) = '';

fid1 = fopen('tasks/tmp', 'w');
if fid1 == -1
    fatal_error = 1;
    fatal_msg(process, ...
        {'Failed writing file for restriction digest', w});
    return
end
fprintf(fid1, seq);
fclose(fid1);
unix_cmd = [emboss_dir 'remap -notran -sequence tasks/tmp -enzymes ' elist ...
    ' -sitelen 4 -outfile tasks/tmp1; grep -A' num2str(length(enzymes)) ...
    ' ''# Enzymes that cut'' tasks/tmp1 > tasks/tmp; rm tasks/tmp1'];
[st, w] = unix(unix_cmd);
if st == 1
    error_msg(process, 1, {w, ...
        'Check ''remap'' installation in EMBOSS package', ...
        'Could not perform restriction site analysis'});
else
    for n = 1 : length(enzymes)
        unix_cmd = ...
            ['grep ''' enzymes{n} ''' tasks/tmp | awk {''print $NF''}'];
        [st, w] = unix(unix_cmd);
        if st == 1
            error_msg(process, 1, {w, ...
                'Check ''remap'' installation in EMBOSS package', ...
                'Could not perform restriction site analysis'});
        else
            if ~isempty(w)
                sites(n) = str2double(w);
            end
        end
    end
end

delete('tasks/tmp');
