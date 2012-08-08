function plot_latex_nonuniq_frags_new(i, k)
global nonuniq_frag_pos_clone
global nonuniq_frag_name
global nonuniq_frag_pos_clone_sel
global nonuniq_frag_name_sel
global aln_pos
global rep_hits
global rep_hits_sel
global en_nonunseg
global en_mistarget
global nonunseq_color
global mistarget_color
global fontname
global segment_fsize
global segment_lfsize
global sel_nonun_frags
global yoffset
global line_spacing
global use_latex
global matlaboroctave
global square_width
global en_nonunreg
if en_nonunseg == false || isempty(sel_nonun_frags{i})
    return
end

alph = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
% Plot non-unique fragments
%ycoef = nonunseg_ypos(1);
%ycoeft = nonunseg_ypos(1) - 0.025;

if k <= length(sel_nonun_frags{i})
%    used_frag_pos = nonuniq_frag_pos{i}(:, sel_nonun_frags{i}{k});
%    used_frag_name = nonuniq_frag_name{i}(sel_nonun_frags{i}{k});
%    used_rep_hits = rep_hits{i}(sel_nonun_frags{i}{k});
    used_frag_pos = nonuniq_frag_pos_clone_sel{i}{k};
    used_frag_name = nonuniq_frag_name_sel{i}{k};
    used_rep_hits = rep_hits_sel{i}{k};

else
    in = find(sum(~isnan(nonuniq_frag_pos_clone{i})) == 2);
    used_frag_pos = nonuniq_frag_pos_clone{i}(:, in);
    used_frag_name = nonuniq_frag_name{i}(in);
    used_rep_hits = rep_hits{i}(in);
end
for j = 1 : size(used_frag_pos, 2)
    if en_mistarget == true
        aln_bin = false(1, aln_pos(i, 2) - aln_pos(i, 1));
        aln_bin(used_frag_pos(1, j) : ...
            used_frag_pos(2, j)) = true;
        if ~isempty(used_rep_hits{j})
            for m = 1 : size(used_rep_hits{j}, 2)
                s = sort(used_rep_hits{j}(1 : 2, m));
                aln_bin(s(1) : s(2)) = 1;
            end
        end
%        aln_len = length(find(aln_bin));
    end
    c = used_frag_pos(:, j)' + aln_pos(i, 1);
    frag_mid = mean(c);
    
    drawsquare(c, [-1, 0] + yoffset + j, nonunseq_color, ...
        [0.999, 0.999, 0.999])
    %	plot(c, [yc(1), yc(1)], '-', 'LineWidth', 2, ...
    %        'Color', nonunseq_color)
    %    plot(c, [yc(2), yc(2)], '-', 'LineWidth', 2, ...
    %        'Color', nonunseq_color)
    %  	plot([c(1), c(1)], yc, 'b-', 'LineWidth', 0.1, ...
    %        'Color', nonunseq_color);
    %	plot([c(2), c(2)], yc, 'b-', 'LineWidth', 0.1, ...
    %        'Color', nonunseq_color);
    %[v, e] = num2eng(c(2) - c(1) + 1, 2);
    %[v1, e1] = num2eng(aln_len, 2);
    %    if en_mistarget == true
        %text_label = ['\color{' nonunseq_color '}' ...
        %    used_frag_name{j} ' (' v ' ' e 'bp/\color{' ...
        %    mistarget_color '}' v1 ' ' e1 'bp\color{' nonunseq_color ...
        %    '}) \rightarrow'];
        %text_label = ['\color{' nonunseq_color '}' used_frag_name{j} ...
        %    ' \rightarrow'];
        %text_label = [used_frag_name{j} '\ '];

    text_label = used_frag_name{j};
    txt = find(isstrprop(text_label, 'alpha'));
    txt = txt(txt > find(isstrprop(text_label, 'digit'), 1, ...
                         'first'));
    txt = text_label(txt);

    ty = yoffset + j;
    %        if matlaboroctave == false
    %% If nonunuqie region is plotted, show the names at
    %% the top, otherwise middle
    if en_nonunreg
        ty = ty - square_width - segment_fsize / 22.5;
        %% if there is only a single PCR in the region, use
        %% the same name for the PCR fragment otherwise use
        %% only the ending
    else
        ty = ty - 0.5;
    end
    %        end
    %    else
    % v_al = 'bottom';
    %    end
    txt = ['\color[rgb]{' conv_col(nonunseq_color) '}{' txt '}']; %#ok<AGROW>
    p = text(frag_mid, ty, txt);
    set(p, 'HorizontalAlignment', 'center', 'FontName', fontname, ...
           'FontSize', segment_fsize, 'Color', conv_col(nonunseq_color, 1));






    %   text_label = used_frag_name{j}(2 : end);
    %   if use_latex == true
    %       txt = ['\' segment_lfsize '{' text_label(end) '}'];
    %       ty = yoffset + j - 0.4;
    %   else
    %       txt = text_label(end);
    %       ty = yoffset + j;
    %   end
    %	if matlaboroctave == false
    %   	%ty = ty - segment_fsize / 35;
    %   	ty = ty - 0.5;
    %   	v_al = 'middle';
    %  	else
    %   	v_al = 'bottom';
    %  	end
    %   txt = ['\color[rgb]{' conv_col(nonunseq_color) '}{' txt '}']; %#ok<AGROW>
%        sub_label = ['\tiny{' text_label(end) '}'];
%        if isnan(str2double(text_label(end)))
%            text_label = [text_label(1 : end - 1) '\ensuremath{_' ...
%                text_label(end) '}'];
%        end
%    else
        %text_label = ['\color{' nonunseq_color '}' ...
        %    used_frag_name{j} ' (' v ' ' e 'bp) \rightarrow'];
%    end
	%text(frag_mid, ylims(2) * ycoeft, text_label, ...
    %    'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle', ...
    %    'Rotation', 90, 'FontName', fontname, 'Color', nonunseq_color, ...
    %    'FontSize', segment_fsize);
    %p = text(frag_mid, ty, txt);
    %set(p, 'HorizontalAlignment', 'center', ...
    %    'VerticalAlignment', v_al, 'FontName', fontname, ...
    %    'FontSize', segment_fsize, 'Color', conv_col(nonunseq_color, 1));
    if en_mistarget == true
        if ~isempty(used_rep_hits{j})
            sim_bin = int8(zeros(size(aln_bin)));
            for m = 1 : size(used_rep_hits{j}, 2)
                sim_bin(used_rep_hits{j}(1, m) : ...
                    used_rep_hits{j}(2, m)) = 1;
            end
            sim_bin(used_frag_pos(1, j) : used_frag_pos(2, j)) = 0;
            sim_bin = [0, sim_bin] - [sim_bin, 0];
            sim_hits = [find(sim_bin == -1); find(sim_bin == 1) - 1];
            for m = 1 : size(sim_hits, 2)
                c = sim_hits(:, m)' + aln_pos(i, 1);
                drawsquare(c, [-1, 0] + yoffset + j, mistarget_color, ...
                    mistarget_color)
                %plot(c, [yc(1), yc(1)], '-', 'LineWidth', 2, ...
                %    'Color', mistarget_color)
                %plot(c, [yc(2), yc(2)], '-', 'LineWidth', 2, ...
                %    'Color', mistarget_color)
                %plot([c(1), c(1)], yc, '-', 'LineWidth', 0.1, ...
                %    'Color', mistarget_color);
            	%plot([c(2), c(2)], yc, '-', 'LineWidth', 0.1, ...
                %    'Color', mistarget_color);
            end
        end
    end
    %ycoef = ycoef + y_coef_step;
end

yoffset = plot_nonuniq_offset(yoffset, i, k);
