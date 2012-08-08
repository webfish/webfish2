function plot_latex_areas(i, k)
global aln_pos
global uniq_map
global nonuniq_map
global nonuniq_reg
global nonuniq_vec
global en_area
global en_histback
global unregun_color
global unregrep_color
global repregun_color
global repregrep_color
global unrep_color
global yoffset
global backgroundarea
global line_spacing
global en_hist
global restrict_sequence
global restrict_color

if en_area == false
    return
end
if backgroundarea == true
    heig = yoffset;
    heig = plot_axis_offset1(heig);
    heig = plot_axis_offset2(heig);
    heig = plot_genes_offset(heig);
    heig = plot_uniq_offset(heig, i);
    heig = plot_nonuniq_offset(heig, i, k);
    heig = plot_region_offset(heig, i);
    if en_histback
	heig = plot_hist_offset(heig);
    end
    if line_spacing == -1 && en_hist == false
        heig = heig - 0.5;
    end
else
    heig = 1;
end

%% Find coordinates where any transition between unique/non-unique region
%% or mapped area appears
%if en_histback == true
    % Get which histogram bins are zero and which are positive
    %hist_bin = int8(sign(nonuniq_vec{i}));
    hist_bin = abs(sign(nonuniq_vec{i}));
    % Make a vector of histogram zone beginnings and ends
    hist_zones = horzcat(0, hist_bin) - horzcat(hist_bin, 0);
    % Get coordinates of histogram zone ends
    z_en = find(hist_zones == 1) - 1;
    % Get coordinates of histogram zone starts
    z_st = find(hist_zones == -1);
%else
%    z_en = [];
%    z_st = [];
%end
z = vertcat(z_st, z_en);
separ = sort(vertcat(uniq_map{i}(:), nonuniq_map{i}(:), ...
    nonuniq_reg{i}(:), z(:), restrict_sequence{i}(:)));

%% Check each region separated by the coordinates and decide which color it
%% should be plotted with
for j = 1 : length(separ) - 1
    % Check if the separators are not next to each other
    if separ(j + 1) - separ(j) > 1
        % mid is a number in the middle of the area confined by the
        % separators
        mid = mean(separ(j : j + 1));
        % color index
        colin = 0;
        % if mid is located in a unique map select color index 1
        if find(sum(sign(uniq_map{i} - mid)) == 0)
            colin = 1;
        end
        % if mid is located in a non-unique map increase color index by 2
        if find(sum(sign(nonuniq_map{i} - mid)) == 0)
            colin = colin + 2;
        end
        % if mid is located in a non-unique region increase color index by
        % 4
        if find(sum(sign(nonuniq_reg{i} - mid)) == 0)
            colin = colin + 4;
        end
        % if mid is in restricted, make color index 9
        if ~isempty(restrict_sequence{i})
            if find(sum(sign(restrict_sequence{i}' - mid)) == 0)
                colin = 9;
            end
        end

        % if mid is located in a unique similar region make color index 8
        if ~isempty(z)
            if find(sum(sign(z - mid)) == 0)
                colin = 8;
            end
        end
        % Generate coordinates for the fill area
        %X = [separ(j), separ(j + 1), separ(j + 1), separ(j)] + aln_pos(i, 1);
        X = [separ(j), separ(j + 1), separ(j + 1), separ(j)] + aln_pos(i, 1);
        %Y = [0, 0, ylims(2), ylims(2)];
        Y = [0, 0, heig, heig] + yoffset;
        switch colin 
          case 0
            c = [0, 0, 0];
          case 1
            c = unregun_color;            % white
          case 2
            c = unregrep_color;              % yellow
          case 3
            c = [0, 0, 0];
          case 4
            c = [0, 0, 0];
          case 5
            c = repregun_color;      % grey
          case 6
	        c = repregrep_color;        % yellow/grey
          case 7
            c = [0, 0, 0];
          case 8
            c = unrep_color;            % cyan
          case 9
            c = restrict_color;
        end
        % Generate colored area
        p = fill(X, Y, c);
        set(p, 'EdgeColor', 'none');
        %plot(X, Y, 'Color', c, 'LineWidth', 3)
    end
end

yoffset = plot_areas_offset(yoffset);