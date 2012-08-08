function outV = plot_region_offset(inV, i)
global en_unseg
global line_spacing
global segment_fsize
global sel_nonun_frags
global uniq_frag_pos
global en_nonunseg
global en_unreg
global en_nonunreg

outV = inV;
%% If no PCR segments are plotted, but regions are, then we need to
%% add to the offset
if (~en_unseg || isempty(sel_nonun_frags{i})) && ...
        (~en_nonunseg || isempty(uniq_frag_pos{i})) && ...
        (en_unreg || en_nonunreg)
    if line_spacing == -1
        ls = 0.5 + segment_fsize / 6;
    else
        ls = line_spacing;
    end
    ls = 0.5;
    outV = outV + 1 + ls;
end

