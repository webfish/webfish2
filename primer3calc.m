function [left_prim, right_prim, left_pos, right_pos] = ...
    primer3calc(process, sequence, seq_id, pcr_overlap)
global folder
global primer3_dir
global primer_opt_size
global primer_min_size
global primer_max_size
global primer_opt_temp
global primer_min_temp
global primer_max_temp
global primer_max_tm_diff
global primer_salt
global primer_gc_clamp
global primer_min_gc
global primer_max_gc
global fatal_error

left_prim = '';
right_prim = '';
left_pos = NaN;
right_pos = NaN;
[fid, w] = fopen([folder 'primer'], 'w');
if fid == -1
    fatal_error = 1;
    fatal_msg(process, {'Failed writing primer input file', w});
    return
end
fprintf(fid, ['SEQUENCE_ID=' seq_id '\n']);
fprintf(fid, ['SEQUENCE_TEMPLATE=' sequence '\n']);
fprintf(fid, ['PRIMER_OPT_SIZE=' num2str(primer_opt_size) '\n']);
fprintf(fid, ['PRIMER_MIN_SIZE=' num2str(primer_min_size) '\n']);
fprintf(fid, ['PRIMER_MAX_SIZE=' num2str(primer_max_size) '\n']);
fprintf(fid, ['PRIMER_PRODUCT_SIZE_RANGE=' ...
    num2str(length(sequence) - 2 * pcr_overlap) '-' ...
    num2str(length(sequence)) '\n']);
fprintf(fid, ['SEQUENCE_EXCLUDED_REGION=' num2str(pcr_overlap) ',' ...
    num2str(length(sequence) - 2 * pcr_overlap) '\n']);
fprintf(fid, 'PRIMER_EXPLAIN_FLAG=0\n');
fprintf(fid, ['PRIMER_MIN_TM=' num2str(primer_min_temp) '\n']);
fprintf(fid, ['PRIMER_MAX_TM=' num2str(primer_max_temp) '\n']);
fprintf(fid, ['PRIMER_OPT_TM=' num2str(primer_opt_temp) '\n']);
fprintf(fid, 'PRIMER_TM_FORMULA=1\n');
fprintf(fid, ['PRIMER_SALT_CORRECTIONS=' num2str(primer_salt) '\n']);
fprintf(fid, ['PRIMER_MIN_GC=' num2str(primer_min_gc) '\n']);
fprintf(fid, ['PRIMER_MAX_GC=' num2str(primer_max_gc) '\n']);
fprintf(fid, ['PRIMER_PAIR_MAX_DIFF_TM=' num2str(primer_max_tm_diff) '\n']);
fprintf(fid, ['PRIMER_GC_CLAMP=' num2str(primer_gc_clamp) '\n']);
fprintf(fid, '=\n');
fclose(fid);

unix_cmd = [primer3_dir 'primer3_core -format_output < ' folder ...
    'primer > ' folder seq_id '.primer.txt'];
[st, w] =  unix(unix_cmd);
if st ~= 0
    fatal_error = 1;
    fatal_msg(process, ...
        {['Failed running Primer3 on target ''' seq_id ''''], w});
    return
end
unix_cmd = ['grep "^LEFT PRIMER" ' folder seq_id ...
    '.primer.txt'];
[st, left_prim] = unix(unix_cmd);
%if st ~= 0
%    fatal_error = 1;
%    fatal_msg(process, ...
%        {['Failed retrieving Primer3 output on target ''' seq_id ''''], ...
%        left_prim});
%    return
%end
unix_cmd = ['grep "^RIGHT PRIMER" ' folder seq_id ...
    '.primer.txt'];
[st, right_prim] = unix(unix_cmd);
%if st ~= 0
%    fatal_error = 1;
%    fatal_msg(process, ...
%        {['Failed retrieving Primer3 output on target ''' seq_id ''''], ...
%        right_prim});
%    return
%end
t = textscanO(right_prim, 32);
t(cellfun(@isempty, t)) = [];
if numel(t) >= 9
	right_prim = t{9};
%if ~isempty(right_prim)
%    right_prim = right_prim{:};
%end
	right_pos = str2double(t{3});
end
t = textscanO(left_prim, 32);
t(cellfun(@isempty, t)) = [];
%t = textscan(left_prim, '%d%s');
if numel(t) >= 9
	left_prim = t{9};
%if ~isempty(left_prim)
 %   left_prim = left_prim{:};
%end
	left_pos = str2double(t{3});
end