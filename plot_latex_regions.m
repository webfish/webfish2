function plot_latex_regions(i, k)
global uniq_reg
global nonuniq_reg
global aln_pos
global unseq_color
global nonunseq_color
global en_unreg
global en_nonunreg
global fontname
global region_fsize
global region_lfsize
global yoffset
global use_latex
global matlaboroctave
global square_width

% Plot unique regions
if en_unreg == true
    for j = 1 : size(uniq_reg{i}, 2)
        drawsquare(uniq_reg{i}(:, j)' + aln_pos(i, 1), ...
            [0, k] + yoffset, unseq_color)
%    	plot([uniq_reg{i}(1, j), uniq_reg{i}(2, j)] + aln_pos(i, 1), ...
%            yc * [unreg_ypos, unreg_ypos], '-', 'LineWidth', 2, ...
%            'Color', unseq_color);
%    	plot([uniq_reg{i}(1, j), uniq_reg{i}(2, j)] + aln_pos(i, 1), ...
%            yc * ([unreg_ypos, unreg_ypos] - 0.1), '-', 'LineWidth', 2, ...
%            'Color', unseq_color);
%        plot([uniq_reg{i}(1, j), uniq_reg{i}(1, j)] + aln_pos(i, 1), ...
%            yc * (unreg_ypos + [0, -0.1]), '-', ...
%            'LineWidth', 0.1, 'Color', unseq_color);
%    	plot([uniq_reg{i}(2, j), uniq_reg{i}(2, j)] + aln_pos(i, 1), ...
%            yc * (unreg_ypos + [0, -0.1]), '-', ...
%            'LineWidth', 0.1, 'Color', unseq_color);
%        [v, e] = num2eng(uniq_reg{i}(2, j) - uniq_reg{i}(1, j) + 1, 2);
    	%text_label = {['U' num2str(j)]; [v ' ' e 'bp']};
        
        if use_latex == true
            txt = ['\' region_lfsize '{U' num2str(j) '}'];
            ty = k / 2 + yoffset - 0.4;
        else
            txt = ['U' num2str(j)];
            ty = k / 2 + yoffset;
        end
        if matlaboroctave == false
            ty = ty - k * 0.5 + square_width + region_fsize / 22.5;
            %        else
            % v_al = 'middle';
            % txt = ext;
        end
        txt = ['\color[rgb]{' conv_col(unseq_color) '}{' txt '}']; %#ok<AGROW>
        p = text(mean(uniq_reg{i}(1 : 2, j)) + aln_pos(i, 1), ty, txt);
        set(p, 'HorizontalAlignment', 'center', 'FontName', fontname, ...
               'FontSize', region_fsize, 'Color', conv_col(unseq_color, 1));

        %	if matlaboroctave == false
        %		%ty = ty - region_fsize / 26;
	%	ty = ty;
	%       	v_al = 'middle';
	%else
	%       	v_al = 'bottom';
	%end
        %txt = ['\color[rgb]{' conv_col(unseq_color) '}{' txt '}']; %#ok<AGROW>
    	%p = text(mean(uniq_reg{i}(1 : 2, j)) + aln_pos(i, 1), ty, txt);
    	%set(p, 'HorizontalAlignment', 'center', ...
	%	'VerticalAlignment', v_al, 'FontSize', region_fsize, ...
	%    'FontName', fontname, 'Color', conv_col(unseq_color, 1));
    end
end

% Plot non-unique regions
if en_nonunreg == true
    for j = 1 : size(nonuniq_reg{i}, 2)
        drawsquare(nonuniq_reg{i}(:, j)' + aln_pos(i, 1), ...
            [0, k] + yoffset, nonunseq_color)
%    	plot([nonuniq_reg{i}(1, j), nonuniq_reg{i}(1, j)] + ...
%            aln_pos(i, 1), ...
%            yc * (nonunreg_ypos + [0, -0.1]), '-', ...
%            'LineWidth', 0.1, 'Color', nonunseq_color);
%        plot([nonuniq_reg{i}(2, j), nonuniq_reg{i}(2, j)] + ...
%            aln_pos(i, 1), ...
%            yc * (nonunreg_ypos + [0, -0.1]), '-', ...
%            'LineWidth', 0.1, 'Color', nonunseq_color);
%        plot([nonuniq_reg{i}(1, j), nonuniq_reg{i}(2, j)] + ...
%            aln_pos(i, 1), ...
%            yc * [nonunreg_ypos, nonunreg_ypos], '-', ...
%            'LineWidth', 2, 'Color', nonunseq_color);
%        plot([nonuniq_reg{i}(1, j), nonuniq_reg{i}(2, j)] + ...
%            aln_pos(i, 1), ...
%            yc * ([nonunreg_ypos, nonunreg_ypos] - 0.1), '-', ...
%            'LineWidth', 2, 'Color', nonunseq_color);
%        [v, e] = ...
%            num2eng(nonuniq_reg{i}(2, j) - nonuniq_reg{i}(1, j) + 1, 2);
        %text_label = ['N' num2str(j) ' (' v ' ' e 'bp) \rightarrow'];
        
        if use_latex == true
            txt = ['\' region_lfsize '{S' num2str(j) '}'];
            ty = k / 2 + yoffset - 0.4;
        else
            txt = ['S' num2str(j)];
            ty = k / 2+ yoffset;
        end

        if matlaboroctave == false
            ty = ty - k * 0.5 + square_width + region_fsize / 22.5;
            %        else
            % v_al = 'middle';
            %    txt = ext;
            %end
            %    else
            % v_al = 'bottom';
        end
        txt = ['\color[rgb]{' conv_col(unseq_color) '}{' txt '}']; %#ok<AGROW>
        p = text(mean(nonuniq_reg{i}(1 : 2, j)) + aln_pos(i, 1), ty, txt);
        set(p, 'HorizontalAlignment', 'center', 'FontName', fontname, ...
               'FontSize', region_fsize, 'Color', conv_col(nonunseq_color, 1));


    %	if matlaboroctave == false
    %		%ty = ty - region_fsize / 26;
    %		ty = ty;
    %	       	v_al = 'middle';
    %	else
    %	       	v_al = 'bottom';
    %	end
    %   txt = ['\color[rgb]{' conv_col(nonunseq_color) '}{' txt '}']; %#ok<AGROW>
    %   p = text(mean(nonuniq_reg{i}(1 : 2, j)) + aln_pos(i, 1), ty, txt);
    %	set(p, 'HorizontalAlignment', 'center', ...
    %       'VerticalAlignment', v_al, 'FontSize', region_fsize, ...
    %       'FontName', fontname, 'Color', conv_col(nonunseq_color, 1));
    end
end

yoffset = plot_region_offset(yoffset, i);