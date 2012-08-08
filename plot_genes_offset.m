function outV = plot_genes_offset(inV)
global en_genes
global line_spacing
global genes_fsize

outV = inV;
if en_genes == false
    return
end

if line_spacing == -1
    %    ls = 0.5 + genes_fsize / 6;
    ls = 0.5;
else
    ls = line_spacing;
end
outV = outV + 1 + ls;
