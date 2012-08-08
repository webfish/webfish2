function label_latex_graph(i, ax)
global aln_chr
global aln_pos
global organism
global target_name
global xaxis_sigdig
global en_hist
global hist_color
global hist_height
global axis_num_fsize
global axis_fsize
global title_fsize
global axis_num_lfsize
global axis_lfsize
global title_lfsize
global rev_xaxis
global fontname
global yoffset
global en_labels
global use_latex
global hylim
global axis_topbottom
global laxis_fsize
global matlaboroctave

ylims = yoffset + hist_height * double(en_hist);
xlims = aln_pos(i, 1 : 2);
xlim_lab = cell(1, 2);
for j = 1 : 2
	[v, c] = num2eng(aln_pos(i, j), xaxis_sigdig);
    xlim_lab{j} = horzcat(v, c);
end
org = horzcat(upper(organism(1)), lower(organism(2 : end)));
in = strfind(org, '_');
org(in) = ' ';
org(in + 1) = upper(org(in + 1));
xaxis = ['Position on ' aln_chr{i} ' of ' org];
if en_hist == true
    yticks = yoffset + [0, hist_height];
	yaxis = 'Number of Similar Hits';
    ylim_lab = {num2str(hylim(1)), num2str(hylim(2))};
    %ylims = [0, yoffset + hist_height];
else
	yaxis = '';
    yticks = [];
    %ylims = [0, yoffset];
end
if matlaboroctave == 1;
	tit = [' Similar and Unique Regions in Target Region ''' ...
		regexprep(target_name{i}, '_', '\\_') ''' '];
else
	tit = [' Similar and Unique Regions in Target Region ''' ...
		regexprep(target_name{i}, '_', '\_') ''' '];
end
if rev_xaxis == false
    %xdir = 'normal';
    yposa = aln_pos(i, 1) - (axis_num_fsize / 250 + 0.03) * diff(aln_pos(i, :));
    ypost = aln_pos(i, 1) - diff(aln_pos(i, :)) / 100;
else
    %xdir = 'reverse';
    yposa = aln_pos(i, 2) + (axis_num_fsize / 250 + 0.03) * diff(aln_pos(i, :));
    ypost = aln_pos(i, 2) + diff(aln_pos(i, :)) / 100;
end

%pos = get(ax(i), 'Position');
%pos(4) = (yoffset + hist_height * double(en_hist)) / 50;
%set(ax(i), 'XDir', xdir, 'XLim', xlims, 'YLim', ylims, 'Position', pos)
%axis(ax(i), 'off')

%if en_hist == true
%    % Get the position of the old axes
%    pos = get(ax(i), 'Position');
%
%    % Calculate Y start of the histogram axes
%    pos(2) = pos(2) + pos(4) * (1 - hist_height / (yoffset + hist_height));
%
%    % Calculate height of the histogram axes
%    pos(4) = pos(4) * hist_height / (yoffset + hist_height);
%
%    % Set the axes properties
%    set(hax(i), 'Position', pos, 'Color', 'none', 'box', 'on', ...
%        'XDir', xdir, 'XLim', xlims, 'Ytick', [], 'XTick', [])
%end

mid_x = mean(aln_pos(i, :));
if en_labels == false
    return
end
axes(ax(i));
if use_latex == 1
    tit = ['\' title_lfsize '{' tit '}'];
    xaxis = ['\' axis_lfsize '{' xaxis '}'];
    yaxis = ['\' axis_lfsize '{' yaxis '}'];
    xlim_lab{1} = ['\' axis_num_lfsize '{' xlim_lab{1} '}'];
    xlim_lab{2} = ['\' axis_num_lfsize '{' xlim_lab{2} '}'];
    if en_hist == true
    	ylim_lab{1} = ['\' axis_num_lfsize '{' ylim_lab{1} '}'];
        ylim_lab{2} = ['\' axis_num_lfsize '{' ylim_lab{2} '}'];
    end
end

yaxis = ['\color[rgb]{' conv_col(hist_color) '}{' yaxis '}'];
p = text(mid_x, ylims + 1 + min(ylims * 0.1, 1), tit);
set(p, 'FontSize', title_fsize, ...
    'FontName', fontname, 'VerticalAlignment', 'bottom', ...
    'HorizontalAlignment', 'center');
p = text(mid_x, - 1.5 - laxis_fsize / 12 * (1 - double(axis_topbottom)), xaxis);
set(p, 'FontSize', axis_fsize, ...
    'FontName', fontname, 'VerticalAlignment', 'top', ...
    'HorizontalAlignment', 'center');
p = text(aln_pos(i, 1), - 0.6 - laxis_fsize / 12 * (1 - double(axis_topbottom)), xlim_lab{1});
set(p, 'FontSize', axis_num_fsize, 'FontName', fontname, ...
    'VerticalAlignment', 'top', 'HorizontalAlignment', 'center');
p = text(aln_pos(i, 2), - 0.6 - laxis_fsize / 12 * (1 - double(axis_topbottom)), xlim_lab{2});
set(p, 'FontSize', axis_num_fsize, 'FontName', fontname, ...
    'VerticalAlignment', 'top', 'HorizontalAlignment', 'center');
plot(aln_pos(i, 2) + [0, 0], [0, 0.1], 'k-')
plot(aln_pos(i, 1) + [0, 0], [0, 0.1], 'k-')
p = text(yposa, yoffset + hist_height / 2, yaxis);
set(p, 'FontSize', axis_fsize, ...
    'FontName', fontname, 'VerticalAlignment', 'bottom', ...
    'HorizontalAlignment', 'center', 'Rotation', 90, 'Color', conv_col(hist_color, 1));
if en_hist == true
    p = text(ypost, yoffset, ylim_lab{1});
    set(p, 'FontSize', axis_num_fsize, 'FontName', fontname, ...
        'VerticalAlignment', 'middle', 'HorizontalAlignment', 'right');
    p = text(ypost, ylims, ylim_lab{2});
    set(p, 'FontSize', axis_num_fsize, ...
        'FontName', fontname, 'VerticalAlignment', 'middle', ...
        'HorizontalAlignment', 'right');
end
%set(ax(i), 'XLim', xlims, 'YLim', ylim, 'XTick', xlims, 'YTick', ...
%    yticks, 'XTickLabel', xlim_lab, 'YTickLabel', ylim_lab, ...
%    'Box', 'off', 'XDir', xdir, 'FontSize', axis_num_fsize, ...
%    'FontName', fontname, 'xcolor', [1, 1, 1]);
%xlabel(xaxis, 'FontSize', axis_fsize, 'FontName', fontname);
%ylabel(yaxis, 'FontSize', axis_fsize, 'FontName', fontname, ...
%    'Color', hist_color);
%ylabh = get(gca,'YLabel');
%set(ylabh, 'Position', get(ylabh, 'Position') + [0 (ylim(2) - hist_height) / 2 0]) 
%title(tit, 'FontSize', title_fsize, 'FontName', fontname);
