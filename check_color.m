function col = check_color(process, col, col_name, def_col)
global config_file

if isempty(col) | isnan(col) %#ok<OR2>
    col = def_col;
else
    col = round(col); %#ok<ST2NM>
end
if length(col) ~= 3
    col = def_col';
	error_msg(process, 1, {['Could not acquire ' col_name ], ...
        ['Using ' col_name ' of [' num2str(def_col(1)) ', ' ...
        num2str(def_col(2)) ', ' num2str(def_col(3)) ']']});
else
    def_val = repmat(def_col', 1, 3);
    for i = 1 : 3
        col(i) = check_value(process, col(i), ...
            ['col(' num2str(i) ')'], def_val(i, :), [0, 255], 0);
    end
end
col_str = [num2str(col(1)), ',', num2str(col(2)), ',', num2str(col(3))];
update_conffile(config_file, col_name, col_str)
col = reshape(col / 255, 1, 3);