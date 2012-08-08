function [frag_name, frag_pos, frag_pos_over, frag_seq, frag_seq_over, ...
    frag_primer, frag_pos_clone, frag_seq_clone] = ...
    fragment_targets(process, region, min_pcr_size, max_pcr_size, ...
    frag_type, seq, name, fid, en_seg)
global fatal_error

frag_name = cell(1, 0);
frag_pos = ones(2, 0);
frag_pos_over = frag_pos;
frag_pos_clone = frag_pos;
frag_seq = frag_name;
frag_seq_over = frag_name;
frag_seq_clone = frag_name;
frag_primer = cell(2, 0);

d = 1;
for j = 1 : size(region, 2)
    m = 1;  % Variable numbering unique regions in given target
    % Length of given unique region
    reg_len = diff(region(:, j)) + 1;
    % Process long enough unique regions
    if reg_len >= min_pcr_size
        [Sfrag_name, Sfrag_pos, Sfrag_pos_over, Sfrag_seq, ...
            Sfrag_seq_over, Sfrag_primer, Sfrag_pos_clone, ...
            Sfrag_seq_clone, m, d] = fragment_region(process, region, ...
            reg_len, min_pcr_size, max_pcr_size, frag_type, seq, name, ...
            m, j, fid, en_seg, d);
        if fatal_error > 0
            return
        end
        frag_name = horzcat(frag_name, Sfrag_name);
        frag_pos = horzcat(frag_pos, Sfrag_pos);
        frag_pos_over = horzcat(frag_pos_over, Sfrag_pos_over);
        frag_pos_clone = horzcat(frag_pos_clone, Sfrag_pos_clone);        
        frag_seq = horzcat(frag_seq, Sfrag_seq);
        frag_seq_over = horzcat(frag_seq_over, Sfrag_seq_over);
        frag_seq_clone = horzcat(frag_seq_clone, Sfrag_seq_clone);
        frag_primer = horzcat(frag_primer, Sfrag_primer);
    end
end