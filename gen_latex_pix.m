function gen_latex_pix(process)
global last_process
global aln_pos
global target_name
global nonuniq_vec
global hist_color
global en_hist
global dpi_res
global gformat
global sel_nonun_frags
global nonuniq_frag_pos_clone
global log_file
global yoffset
global use_latex
global en_nonunseg
global matlaboroctave

%% Check if graphics is ready
if last_process >= process
    write_log(process, 'Graphics generated');
    write_log(process);
    return
end

%% Open a new figure window and set its size and position
close all;
fig = zeros(1, length(target_name));
ax = fig;
hax = fig;
for i = 1 : length(target_name)
    %% Modify sequence ID to get rid of invalid escape sequence
    seq_id = regexprep(target_name{i}, '\\\\', '\');
    seq_id = regexprep(seq_id, '\\', '\\');

    write_log(process, ['Generate Graphics for ''' seq_id '''']);
    if isempty(sel_nonun_frags{i}) || en_nonunseg == false || ...
            size(nonuniq_frag_pos_clone{i}, 2) == 0
        vec = 1;
    else
        vec = [1 : length(sel_nonun_frags{i}), ...
            size(nonuniq_frag_pos_clone{i}, 2)];
    end
    for k = vec
        yoffset = 0;
        % Generate the figure
        [fig(i), ax(i)] = new_latex_figure(i, k);
        hold on
        % Generate ylims
        ylims = ylimgen_latex(i);
        

        % Find coordinates where any transition between unique/non-unique
        % region or mapped area appears and plot them
        plot_latex_areas(i, k);

        % Plot axis
        plot_latex_axis(i);

        % Plot Genes Names
        plot_genes(aln_pos(i, 1 : 2));
        % Plot Unique and Non-Unique Regions
        plot_latex_regions(i, k);
        % Plot Fragments
        plot_latex_uniq_frags(i, k)
        plot_latex_nonuniq_frags_new(i, k)
        % Plot histogram of number of repeats confined to each non-unique
        % region
        plot_latex_histogram(ylims, i);
        % Label Graph
        label_latex_graph(i, ax);
        if k <= length(sel_nonun_frags{i})
            t = num2str(k);
        else
            t = 'all';
        end
        fname = [log_file(1 : (end - 4)) '_' num2str(i) '_' t];
        if use_latex == true
            laprint(fig, fname);
        else
		if matlaboroctave == true
	        	fname = [fname '.' regexprep(regexprep(gformat, '-d', ''), '-', '')];
	            print(fig(i), ['-r' num2str(dpi_res)], gformat, fname);
		else
			print(fig(i), '-dpsc2', [fname '.ps']);
			type = regexprep(regexprep(gformat, '-d', ''), '-', '');
			if strfind(type, 'png')
				dev = 'pngalpha';
				ext = 'png';
			elseif strfind(type, 'jpeg')
				dev = 'jpeg';
				ext = 'jpeg';
			elseif strfind(type, 'pgmraw')
				dev = 'pgmraw';
				ext = 'pgm';
			elseif strfind(type, 'pgm')
				dev = 'pgm';
				ext = 'pgm';
			elseif strfind(type, 'pbmraw')
				dev = 'pbmraw';
				ext = 'pbm';
			elseif strfind(type, 'pbm')
				dev = 'pbm';
				ext = 'pbm';
			elseif strfind(type, 'ppmraw')
				dev = 'ppmraw';
				ext = 'ppm';
			elseif strfind(type, 'ppm')
				dev = 'ppm';
				ext = 'ppm';
			elseif strfind(type, 'tiff')
				dev = 'tiff24nc';
				ext = 'tiff';
			else
				dev = 'pngalpha';
				ext = 'png';
			end
			unix(['ps2eps -B < ' fname '.ps > ' fname '.eps']);
			delete([fname '.ps']);
			unix(['awk -F''[ .]'' ''{if (NR==1){print $0}}{if (NR==2){print $1" "$2-2" "$3-2" "$4+2" "$5+2}}{if (NR==3){print $1" "$2-2"."$3" "$4-2"."$5" "$6+2"."$7" "$8+2"."$9}}{if (NR > 3){print $0}}'' ' fname '.eps > ' fname '.tmp; mv ' fname '.tmp ' fname '.eps']);
			unix(['gs -dNOPAUSE -dBATCH -sDEVICE=' dev ...
				' -sOutputFile=' fname '.' ext ' -r' num2str(dpi_res) ' -dEPSCrop ' fname '.eps']);
				%delete([fname '.eps'])
		end
        end
        close all;
    end
end

%% Save output
write_log(process, 'Generated graphic output');

%% Process finished
write_log(process);
