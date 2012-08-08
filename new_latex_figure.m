function [fig, ax] = new_latex_figure(i, k)
global hist_height
global en_hist
global line_spacing
global aln_pos
global rev_xaxis
global figure_vis

%% Open a new figure window and set its size and position
fig = figure(1, 'visible', figure_vis); clf;
%set(fig, 'Visible', 'off')
%hist(val, lim)
%title(tit, 'FontSize', 14)
%if nargin > 4
%    xlabel(xlab, 'FontSize', 12)
%end
%if nargin > 5
%    ylabel(ylab, 'FontSize', 12)
%end
%xlim([lim(1), lim(end)] + [- ss, ss])
%laprint(1, fname)

%fig = figure('Visible', 'off');
%units = get(fig, 'units');
%set(fig, 'units', 'normalized', 'outerposition', im_pos);
%set(fig, 'units', units);
ax = axes;

if rev_xaxis == false
	xdir = 'normal';
else
	xdir = 'reverse';
end

heig = 0;
heig = plot_axis_offset1(heig);
heig = plot_axis_offset2(heig);
heig = plot_genes_offset(heig);
heig = plot_uniq_offset(heig, i);
heig = plot_nonuniq_offset(heig, i, k);
heig = plot_region_offset(heig, i);
heig = plot_hist_offset(heig);
if line_spacing == -1 && en_hist == false
	heig = heig - 0.5;
end

pos = get(ax, 'Position');
pos(4) = (heig + hist_height * double(en_hist)) / 50;

xlims = aln_pos(i, 1 : 2);
xlims = xlims + diff(xlims) * 0.001 * [-1, 1];
ylims = [-0.01, 1.01] * heig;

set(ax, 'XDir', xdir, 'XLim', xlims, 'YLim', ylims, 'Position', pos)
axis(ax, 'off')
