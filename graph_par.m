function graph_par(process)
global last_process
global folder
global xaxis_sigdig
global yaxis_sigdig
%global im_pos
global dpi_res
global gformat
global hist_color
global unregun_color
global unregrep_color
global repregun_color
global repregrep_color
global unrep_color
global genes_color
global unseq_color
global nonunseq_color
global mistarget_color
global axis_color
global restrict_color
global text_color
global title_fsize
global axis_fsize
global laxis_fsize
global axis_num_fsize
global genes_fsize
global segment_fsize
global region_fsize
global fontname
%global genes_ypos
%global unseg_ypos
%global nonunseg_ypos
%global unreg_ypos
%global nonunreg_ypos
global rev_xaxis
global en_hist
global en_histback
global hist_height
global en_area
global backgroundarea
global en_genes
global en_unseg
global en_nonunseg
global en_unreg
global en_nonunreg
global en_mistarget
global en_labels
global en_axis
global axis_offset
global axis_topbottom
global square_width
global line_spacing
global use_latex
global title_lfsize
global axis_lfsize
global laxis_lfsize
global axis_num_lfsize
global genes_lfsize
global segment_lfsize
global region_lfsize
global config_file
global fatal_error
global matlaboroctave

%% Load saved target sequences
if last_process >= process
    load([folder 'mats/fp' num2str(process) '.mat']);
    write_log(process, 'Analysis parameters loaded');
    write_log(process);
    return
end

%% Import target sequences from fasta file
xaxis_sigdig = read_config('xaxis_sig_digits', process, false);
yaxis_sigdig = read_config('yaxis_sig_digits', process, false);
%im_pos = ...
%    str2num(read_config('image_position', process)); %#ok<ST2NM>
dpi_res = read_config('dpi_res', process, false);
gformat = lower(read_config('graph_format', process, true));
hist_color = read_config('hist_color', process, false);
hist_height = read_config('hist_height', process, false);
unregun_color = read_config('uniq_color', process, false, ...
                            'unique_color');
unregrep_color = read_config('sim_color', process, false, ...
                             'nonunique_color');
repregun_color = read_config('tint_uniq_color', process, false, ...
                             'shade_unique_color');
repregrep_color = read_config('tint_sim_color', process, ...
                              false, 'shade_nonunique_color');
unrep_color = read_config('uniq_sim_color', process, false, ...
                          'unique_repetitive_color');
genes_color = read_config('genes_color', process, false);
unseq_color = read_config('uniq_pcr_color', process, false, ...
                          'unique_segment_color');
nonunseq_color = read_config('sim_pcr_color', process, ...
                             false, 'nonunique_segment_color');
mistarget_color = read_config('mistarget_color', process, false);
restrict_color = read_config('restrict_color', process, false);
axis_color = read_config('axis_color', process, false);
text_color = read_config('text_color', process, false);
%title_fsize = str2double(read_config('title_size', process));
%axis_fsize = str2double(read_config('axis_size', process));
%laxis_fsize = str2double(read_config('laxis_size', process));
%axis_num_fsize = str2double(read_config('axis_num_size', process));
%genes_fsize = str2double(read_config('genes_size', process));
%segment_fsize = str2double(read_config('segment_size', process));
%region_fsize = str2double(read_config('region_size', process));
title_lfsize = read_config('title_size_latex', process, true);
axis_lfsize = read_config('axis_size_latex', process, true);
laxis_lfsize = read_config('laxis_size_latex', process, true);
axis_num_lfsize = read_config('axis_num_size_latex', process, true);
genes_lfsize = read_config('genes_size_latex', process, true);
segment_lfsize = read_config('segment_size_latex', process, true);
region_lfsize = read_config('region_size_latex', process, true);
fontname = read_config('fontname', process, true);

%genes_ypos = str2double(read_config('genes_ypos', process));
%unseg_ypos = str2double(read_config('unseg_ypos', process));
%nonunseg_ypos = str2num(read_config('nonunseg_ypos', process)); %#ok<ST2NM>
%unreg_ypos = str2double(read_config('unreg_ypos', process));
%nonunreg_ypos = str2double(read_config('nonunreg_ypos', process));
rev_xaxis = read_config('rev_xaxis', process, false);
en_hist = read_config('plot_hist', process, false);
en_histback = read_config('plot_hist_background', process, false);
en_area = read_config('plot_area', process, false);
backgroundarea = read_config('background_area', process, false);
en_genes = read_config('plot_genes', process, false);
en_unseg = read_config('plot_uniq_pcr', process, false, 'plot_unseg');
en_nonunseg = read_config('plot_sim_pcr', process, false, 'plot_nonunseg');
en_unreg = read_config('plot_uniq_reg', process, false, 'plot_unreg');
en_nonunreg = read_config('plot_sim_reg', process, false, 'plot_nonunreg');
en_mistarget = read_config('plot_mistarget', process, false);
en_labels = read_config('plot_labels', process, false);
en_axis = read_config('plot_axis', process, false);
axis_offset = round(read_config('axis_offset', process, false));
axis_topbottom = read_config('axis_topbottom', process, false);
line_spacing = read_config('line_spacing', process, false);
square_width = read_config('square_width', process, false);
use_latex = read_config('use_latex', process, false);
if matlaboroctave == false
	use_latex = false;
end

%% Check values
xaxis_sigdig = check_value(process, xaxis_sigdig, 'xaxis_sig_digits', ...
    [5, 5, 5], [1, 10]);
yaxis_sigdig = check_value(process, yaxis_sigdig, 'yaxis_sig_digits', ...
    [1, 1, 1], [1, 10]);
%if length(im_pos) ~= 4
%    im_pos = [0.05, 0.1, 0.4, 0.8];
%	error_msg(process, 1, {'Using im_pos of [0.05, 0.1, 0.4, 0.8]', ...
%        'Could not acquire im_pos'});
%else
%    def_val = [0, 0, 0; 0, 0, 0; 1, 1, 1; 1, 1, 1];
%    for i = 1 : length(im_pos)
%        im_pos(i) = check_value(process, im_pos(i), ...
%            ['impos(' num2str(i) ')'], def_val(i, :), [0, 1]);
%    end
%end
dpi_res = check_value(process, dpi_res, 'dpi_res', ...
    [150, 50, 1200], [50, 1200]);
gformats = {'-dpng', '-djpeg', '-dtiff', '-dpgmraw', '-dpgm', ...
            '-dpbmraw', '-dpbm', '-dppmraw', '-dppm'};
if ~cellfun(@(x) strcmp(x, gformat), gformats)
	error_msg(process, 1, {'Using graph_format ''-dpng''', ...
        'Could not acquire graph_format'});
    gformat = '-dpng';
end
update_conffile(config_file, 'graph_format', gformat)
hist_color = check_color(process, hist_color, 'hist_color', [0, 178, 0]);
unregun_color = check_color(process, unregun_color, ...
    'uniq_color', [255, 255, 255]);
unregrep_color = check_color(process, unregrep_color, ...
    'sim_color', [250, 250, 205]);
repregun_color = check_color(process, repregun_color, ...
    'tint_uniq_color', [255, 235, 205]);
repregrep_color = check_color(process, repregrep_color, ...
    'tint_sim_color', [238, 232, 205]);
unrep_color = check_color(process, unrep_color, ...
    'uniq_sim_color', [205, 255, 255]);
genes_color = check_color(process, genes_color, 'genes_color', ...
    [255, 0, 0]);
unseq_color = check_color(process, unseq_color, 'uniq_pcr_color', ...
                          [255, 0, 255]);
nonunseq_color = check_color(process, nonunseq_color, 'sim_pcr_color', ...
                             [0, 0, 255]);
mistarget_color = check_color(process, mistarget_color, ...
    'mistarget_color', [127, 127, 255]);
restrict_color = check_color(process, restrict_color, ...
    'restrict_color', [255, 204, 153]);
axis_color = check_color(process, axis_color, 'axis_color', [0, 0, 0]);
text_color = check_logical(process, text_color, 'text_color', true);

%title_fsize = check_value(process, title_fsize, 'title_size', ...
%    [14, 6, 20], [2, 30]);
%axis_fsize = check_value(process, axis_fsize, 'axis_size', ...
%    [12, 6, 20], [2, 30]);
%laxis_fsize = check_value(process, laxis_fsize, 'laxis_fsize', ...
%    [8, 5, 20], [2, 30]);
%axis_num_fsize = check_value(process, axis_num_fsize, 'axis_num_size', ...
%    [10, 6, 20], [2, 30]);
%genes_fsize = check_value(process, genes_fsize, 'genes_size', ...
%    [8, 5, 20], [2, 30]);
%segment_fsize = check_value(process, segment_fsize, 'segment_size', ...
%    [6, 5, 20], [2, 30]);
%region_fsize = check_value(process, region_fsize, 'region_size', ...
%    [8, 5, 20], [2, 30]);

lfonts = {'tiny', 'scriptsize', 'footnotesize', 'small', 'normalsize', ...
    'large', 'Large', 'LARGE', 'huge', 'Huge'};
title_lfsize = check_text(process, title_lfsize, 'title_size_latex', ...
    'normalsize', lfonts);
title_fsize = fsize_latex2nr(title_lfsize);
axis_lfsize = check_text(process, axis_lfsize, 'axis_size_latex', ...
    'small', lfonts);
axis_fsize = fsize_latex2nr(axis_lfsize);
laxis_lfsize = check_text(process, laxis_lfsize, 'laxis_size_latex', ...
    'tiny', lfonts);
laxis_fsize = fsize_latex2nr(laxis_lfsize);
axis_num_lfsize = check_text(process, axis_num_lfsize, ...
    'axis_num_size_latex', 'scriptsize', lfonts);
axis_num_fsize = fsize_latex2nr(axis_num_lfsize);
genes_lfsize = check_text(process, genes_lfsize, 'genes_size_latex', ...
    'tiny', lfonts);
genes_fsize = fsize_latex2nr(genes_lfsize);
segment_lfsize = check_text(process, segment_lfsize, ...
    'segment_size_latex', 'tiny', lfonts);
segment_fsize = fsize_latex2nr(segment_lfsize);
region_lfsize = check_text(process, region_lfsize, 'region_size_latex', ...
    'tiny', lfonts);
region_fsize = fsize_latex2nr(region_lfsize);
 
fontnames = {'Helvetica', 'Helvetica-Bold', 'Helvetica-Oblique', ...
	'Helvetica-BoldOblique', 'Helvetica-Narrow', ...
	'Helvetica-Narrow-Bold', 'Helvetica-Narrow-Oblique', ...
	'Helvetica-Narrow-BoldOblique', 'Times-Roman', ...
	'Times-Bold', 'Times-Italic', 'Times-BoldItalic', 'Symbol', ...
	'Courier', 'Courier-Bold', 'Courier-Oblique', ...
	'Courier-BoldOblique'};
fontname = check_text(process, fontname, 'fontname', ...
    'Helvetica', fontnames);

%genes_ypos = check_value(process, genes_ypos, 'genes_ypos', ...
%    [0.1, 0, 1], [-1, 1]);
%unseg_ypos = check_value(process, unseg_ypos, 'unseg_ypos', ...
%    [0.1, 0, 1], [-1, 1]);
%if length(nonunseg_ypos) ~= 2
%    nonunseg_ypos = [0.4, 0.4];
%	error_msg(process, 1, {'Using nonunseg_ypos of [0.4, 0.4]', ...
%        'Could not acquire nonunseg_ypos'});
%else
%    def_val = [0.4, 0.4, 0.4; 0.4, 0.4, 0.4];
%    for i = 1 : length(nonunseg_ypos)
%        nonunseg_ypos(i) = check_value(process, nonunseg_ypos(i), ...
%            ['impos(' num2str(i) ')'], def_val(i, :), [-1, 1]);
%    end
%end
%unreg_ypos = check_value(process, unreg_ypos, 'unreg_ypos', ...
%    [0.1, 0, 1], [-1, 1]);
%nonunreg_ypos = check_value(process, nonunreg_ypos, 'nonunreg_ypos', ...
%    [0.1, 0, 1], [-1, 1]);

rev_xaxis = check_logical(process, rev_xaxis, 'rev_xaxis', false);
en_hist = check_logical(process, en_hist, 'plot_hist', true);
en_histback = check_logical(process, en_histback, 'plot_hist_background', true);
hist_height = check_value(process, hist_height, 'hist_height', ...
    [2, 0, 5], [0, 10]);
en_area = check_logical(process, en_area, 'plot_area', true);
backgroundarea = ...
    check_logical(process, backgroundarea, 'background_area', true);
en_genes = check_logical(process, en_genes, 'plot_genes', true);
en_unseg = check_logical(process, en_unseg, 'plot_uniq_pcr', true);
en_nonunseg = check_logical(process, en_nonunseg, 'plot_sim_pcr', true);
en_unreg = check_logical(process, en_unreg, 'plot_uniq_reg', true);
en_nonunreg = check_logical(process, en_nonunreg, 'plot_sim_reg', true);
en_mistarget = check_logical(process, en_mistarget, 'plot_mistarget', true);
en_labels = check_logical(process, en_labels, 'plot_labels', true);
en_axis = check_logical(process, en_axis, 'plot_axis', true);
axis_topbottom = check_logical(process, axis_topbottom, ...
    'axis_topbottom', true);
axis_offset = check_value(process, axis_offset, 'axis_offset', ...
    [0, 0, 0], [-Inf, Inf]);
square_width = check_value(process, square_width, 'square_width', ...
    [0, 0.1, 0.2], [0, 0.5]);
line_spacing = check_value(process, line_spacing, 'line_spacing', ...
    [-1, -1, 2], [-1, 5]);
use_latex = check_logical(process, use_latex, 'use_latex', false);

% Set the text interpreter for the figures
if use_latex == true
    set(0, 'defaulttextinterpreter', 'none')
else
    set(0, 'defaulttextinterpreter', 'tex')
end
if fatal_error == 1
    return
end

%% Save output
save([folder 'mats/fp' num2str(process) '.mat'], 'xaxis_sigdig', ...
    'yaxis_sigdig', 'dpi_res', 'gformat', 'hist_color', ...
    'unregun_color', 'unregrep_color', 'repregun_color', ...
    'repregrep_color', 'genes_color', 'unseq_color', 'nonunseq_color', ...
    'unrep_color', 'mistarget_color', 'restrict_color', ...
    'title_fsize', 'axis_fsize', 'axis_num_fsize', 'genes_fsize', ...
    'segment_fsize', 'region_fsize', 'fontname', 'rev_xaxis', ...
    'en_hist', 'en_histback', 'hist_height', 'en_area', ...
    'backgroundarea', 'en_genes', 'en_unseg', 'en_nonunseg', ...
    'en_unreg', 'en_nonunreg', 'en_mistarget', 'en_labels', 'en_axis', ...
    'square_width', 'use_latex', 'title_lfsize', 'axis_lfsize', ...
    'axis_num_lfsize', 'genes_lfsize', 'segment_lfsize', ...
    'region_lfsize', 'laxis_fsize', 'laxis_lfsize', 'text_color', ...
    'axis_color', 'axis_offset', 'axis_topbottom', 'line_spacing');
%% Process finished
write_log(process);
