function plot_genes(aln)
global genes_name
global genes_pos
global genes_color
global fontname
global genes_fsize
global genes_lfsize
global en_genes
global yoffset
global use_latex
global matlaboroctave

if en_genes == false
    return
end

% Plot Genes Names

for j = 1 : length(genes_name)
    c = genes_pos(j, 1 : 2);
    gene_mid = mean(c);
    if gene_mid >= aln(1) && gene_mid <= aln(2)
        drawsquare(c, [0, 1] + yoffset, genes_color, [0.999, 0.999, 0.999])
%        if j == 1
%            text_pos = genes_pos(j, 2);
%            v_al = 'bottom';
%            h_al = 'right';
%            text_add = '\ensuremath{\downarrow}';
%        else
%            if abs(genes_pos(j - 1, 1) - genes_pos(j, 2)) < abs(diff(aln(1 : 2)) / 30)
%                text_pos = genes_pos(j, 1);
%                v_al = 'top';
%                h_al = 'left';
%                text_add = '\ensuremath{\uparrow}';
%            else
%                text_pos = genes_pos(j, 2);
%                v_al = 'bottom';
%                h_al = 'right';
%                text_add = '\ensuremath{\downarrow}';
%            end
%        end
%        text_add = '';
        h_al = 'center';
        text_pos = gene_mid;
        if use_latex == true
            txt = ['\' genes_lfsize '{' genes_name{j} '}'];
            ty = 1 + yoffset - 0.2;
        else
            txt = genes_name{j};
            ty = 1 + yoffset;
        end
	if matlaboroctave == false
		%ty = ty - genes_fsize / 26;
		ty = ty - 0.5;
        	v_al = 'middle';
       	else
        	v_al = 'bottom';
       	end
        txt = ['\color[rgb]{' conv_col(genes_color) '}{' txt '}']; %#ok<AGROW>
        p = text(text_pos, ty, txt);
        set(p, 'HorizontalAlignment', h_al, ...
            'VerticalAlignment', v_al, 'FontName', fontname, ...
            'FontSize', genes_fsize, 'Color', conv_col(genes_color, 1));
    	%text_label = ['    ' genes_name{j}];
    	%text(gene_mid, ylims(2) * genes_ypos, text_label, ...
        %    'HorizontalAlignment', 'left', 'Rotation', 90, ...
        %    'VerticalAlignment', 'middle', 'Color', genes_color, ...
        %    'FontName', fontname, 'FontSize', genes_fsize);
    end
end

yoffset = plot_genes_offset(yoffset);
