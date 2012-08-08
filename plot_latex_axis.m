function plot_latex_axis(i)
global en_axis
global rev_xaxis
global aln_pos
global yoffset
global laxis_lfsize
global laxis_fsize
global fontname
global use_latex
global axis_color
global axis_offset
global axis_topbottom
global matlaboroctave

if en_axis == false
    return
end
yoffset = plot_axis_offset1(yoffset);

% Plot Genes Names
xaxis = aln_pos(i, :);
xlen = diff(xaxis);
steps = [1, 2.5, 5, 10, 25, 50, 100, 250, 500] * 1000;
[v, in] = min(abs(xlen ./ steps - 12));
step = steps(in);
ticks = step * ceil(axis_offset / step) : step : xlen + axis_offset;
if axis_offset ~= ticks(1)
    ticks = horzcat(axis_offset, ticks);
end
if xlen + axis_offset ~= ticks(end)
    ticks = horzcat(ticks, xlen + axis_offset);
end
%if rev_xaxis == true
%    ticks = fliplr(ticks);
%end

for j = 2 : length(ticks)
    if rev_xaxis == true
        xv = aln_pos(i, 2) - [ticks(j - 1), ticks(j)] + axis_offset;
    else
        xv = [ticks(j - 1), ticks(j)] + aln_pos(i, 1) - axis_offset;
    end
    drawsquare(xv, [0, 1] + yoffset, axis_color, [0.999, 0.999, 0.999])
end
tick_lab = ticks(round(ticks / step / 2) == ticks / step / 2);
tick_lab(tick_lab == ticks(end)) = [];
for j = tick_lab
    if j ~= 0
        [v, c] = num2eng(j, 2);
    else
        v = '0';
        c = '';
    end
    if use_latex == true
        txt = ['\' laxis_lfsize '{' v c '}'];
        if axis_topbottom == 1
            ty = 1 + yoffset - 0.4;
        else
            ty = yoffset + 0.4;
        end
    else
        txt = [v c];
        if axis_topbottom == 1
            ty = 1 + yoffset;
        else
            ty = yoffset;
        end
        if matlaboroctave == false
        	if axis_topbottom == 0
	        	ty = ty - laxis_fsize / 20;
        	else
        		ty = ty + laxis_fsize / 20;
       		end
       	end
    end
    txt = ['\color[rgb]{' conv_col(axis_color) '}{' txt '}']; %#ok<AGROW>
    if rev_xaxis == true
        xv = aln_pos(i, 2) - j + axis_offset;
    else
        xv = j + aln_pos(i, 1) - axis_offset;
    end
    if axis_topbottom == 1
        va = 'bottom';
    else
        va = 'top';
    end
    p = text(xv, ty, txt);
    set(p, 'VerticalAlignment', va, 'FontSize', laxis_fsize, 'FontName', fontname);
end

yoffset = plot_axis_offset2(yoffset);
