function plot_latex_histogram(ylims, i, ax)
global nonuniq_vec
global aln_pos
global yoffset
global en_hist
global hist_color
global hist_height
global hylim

if en_hist == false
    return
end

%% Generate axes for histogram inside the main axes

%% Get which histogram bins are zero and which are positive
hist_bin = abs(sign(nonuniq_vec{i}));

%% Make a vector of histogram zone beginnings and ends
hist_zones = horzcat(0, hist_bin) - horzcat(hist_bin, 0);
%% Get coordinates of histogram zone ends
z_en = find(hist_zones == 1) - 1;

%% Get coordinates of histogram zone starts
z_st = find(hist_zones == -1);

%% Get histogram Y-limits
tmp = [10 15 20 30 40 50 60 70 80 90];
hylim = [2, 5, 10, tmp, 10 * tmp, 100 * tmp, 1000 * tmp, 10000 * tmp, 100000 * tmp];
hylim = [0, hylim(min(find(max(nonuniq_vec{i}) ./ hylim <= 1)))];
%% Process each histogram zone
for j = 1 : length(z_st)
    % Get values of one histogram zone
    hist_fr = [0, double(nonuniq_vec{i}(z_st(j) : z_en(j))), 0];

    % Make a vector of histogram zone changes
    hist_dif = hist_fr(1 : end - 1) - hist_fr(2 : end);

    % Point at which histogram changes
    in = find(hist_dif);

    % Get X positions of the filled area
    xv = sort([in, in]) + z_st(j) + aln_pos(i, 1) - 2;

    % Get Y positions of the filled area
    yv = hist_fr(sort([in, in + 1])) * hist_height / hylim(2) + yoffset;

    % Make a 2D area
    p = fill(xv, yv, hist_color);
    set(p, 'EdgeColor', 'none');
end

%% Draw bounding box
plot([aln_pos fliplr(aln_pos) aln_pos(1)], yoffset + [0, 0, hist_height, hist_height, 0], '-', 'LineWidth', 1, 'Color', [0, 0, 0]);
