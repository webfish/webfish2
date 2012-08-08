function outV = plot_uniq_offset(inV, i)
global en_unseg
global line_spacing
global segment_fsize
global sel_nonun_frags
global en_nonunseg
global en_unreg
global en_nonunreg

outV = inV;
if en_unseg == false
    return
end

if en_nonunseg == false || isempty(sel_nonun_frags{i})
    %if en_unreg == false && en_nonunreg == false
    %    ls = 0.5;
%    else
%        if line_spacing == -1
%            ls = 0.5 + segment_fsize / 6;
%        else
%            ls = line_spacing;
%        end
    %end
    ls = 0.5;
    outV = outV + 1 + ls;
end

