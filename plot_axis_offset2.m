function outV = plot_axis_offset2(inV)
global en_axis
global axis_topbottom
global line_spacing
global laxis_fsize

outV = inV;
if en_axis == false
    return
end

if axis_topbottom == 1
    if line_spacing == -1
        ls = 0.5 + laxis_fsize / 6;
    else
        ls = line_spacing;
    end
else
    ls = 0.5;
end
outV = outV + 1 + ls;
