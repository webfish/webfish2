function outV = plot_areas_offset(inV)
global en_area
global backgroundarea
global line_spacing

outV = inV;
if en_area == false || backgroundarea == true
    return
end

if line_spacing == -1
    ls = 0.5;
else
    ls = line_spacing;
end
outV = outV + 1 + ls;
