function error_msg(process, status, text)
if status ~= 0
    for i = length(text) : - 1 : 1
        if ~isempty(text{i})
            write_log(process, ['<span style="color:#0000FF">' text{i} ...
                '</span>']);
        end
    end
end
