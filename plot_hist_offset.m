function outV = plot_hist_offset(inV)
global hist_height
global en_hist

outV = inV;
if en_hist == false
    return
end

outV = outV + hist_height;

