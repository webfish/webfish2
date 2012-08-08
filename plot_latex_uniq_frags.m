function plot_latex_uniq_frags(i, k)
global uniq_frag_pos_clone
global sel_nonun_frags
global uniq_frag_name
global aln_pos
global en_unseg
global en_nonunseg
global en_unreg
global unseq_color
global fontname
global segment_fsize
global segment_lfsize
global yoffset
global line_spacing
global use_latex
global matlaboroctave
global square_width

if en_unseg == false
    return
end

alph = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

%% Plot unique fragments
for j = find(sum(~isnan(uniq_frag_pos_clone{i})) == 2)
    text_label = uniq_frag_name{i}{j};

    %    if isnan(str2double(text_label(end)))
    c = uniq_frag_pos_clone{i}(:, j)' + aln_pos(i, 1);
    frag_mid = mean(c);
    drawsquare(c, [0, k] + yoffset, unseq_color)
%        plot(c, ylims(2) * ([unseg_ypos, unseg_ypos] - 0.05), '-', ...
%            'LineWidth', 2, 'Color', unseq_color)
%        yc = ylims(2) * (unseg_ypos + [0, -0.05]);
%     	plot([c(1), c(1)], yc, '-', 'LineWidth', 0.1, 'Color', unseq_color);
%    	plot([c(2), c(2)], yc, '-', 'LineWidth', 0.1, 'Color', unseq_color);
        %[v, e] = num2eng(c(2) - c(1) + 1, 2);
        %text_label = [uniq_frag_name{i}{j} '\ '];
    if use_latex == true
        txt = ['\' segment_lfsize '{' text_label(end) '}'];
        ty = k / 2 + yoffset + 0.1;
    else
        txt = text_label(end);
        ty = k / 2 + yoffset;
    end
    %% If unuwie region is plotted, show the names at the top,
    %% otherwise middle
    if en_unreg
        ty = ty + 0.5 * k - square_width - segment_fsize / 22.5;
        %% if there is only a single PCR in the region, use the
        %% same name for the PCR fragment otherwise use only
        %% the ending
        if isnan(str2double(text_label(end)))
            txt = find(isstrprop(text_label, 'alpha'));
            txt = txt(txt > find(isstrprop(text_label, 'digit'), ...
                                 1, 'first'));
            txt = text_label(txt);
        else
            txt = text_label;
        end
    else
        % v_al = 'middle';
        txt = text_label(2 : end);
    end
    txt = ['\color[rgb]{' conv_col(unseq_color) '}{' txt '}']; %#ok<AGROW>
    p = text(frag_mid, ty, txt);
    set(p, 'HorizontalAlignment', 'center', 'FontName', fontname, ...
           'FontSize', segment_fsize, 'Color', conv_col(unseq_color, 1));
        
        
        %text_label = [text_label(1 : end - 1)];
    end
	%text(frag_mid, ylims(2) * unseg_ypos, text_label, ...
%        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
%        'Color', [0, 0, 0], 'FontName', fontname, ...
%        'FontSize', segment_fsize);
end

yoffset = plot_uniq_offset(yoffset, i);
