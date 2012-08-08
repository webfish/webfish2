function [frag_name, frag_pos, frag_pos_over, frag_seq, frag_seq_over, ...
    frag_primer, frag_pos_clone, frag_seq_clone, m, d] = ...
    fragment_region(process, region, reg_len, min_pcr_size, ...
    max_pcr_size, frag_type, seq, name, m, j, fid, en_seg, d)
global Apcro
global Npcro
global pcrSteps
global fatal_error

alph = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

% Number of fragments to cover unique region
nr_pcrs = ceil(reg_len / max_pcr_size);
pcr_len = round(reg_len / nr_pcrs);
right_pos = 0;
seg_start = 0;
frag_name = cell(1, nr_pcrs);
frag_pos = ones(2, nr_pcrs);
frag_pos_over = frag_pos;
frag_pos_clone = frag_pos;
frag_seq = frag_name;
frag_seq_over = frag_name;
frag_seq_clone = frag_name;
frag_primer = cell(2, nr_pcrs);
while seg_start + min_pcr_size + Apcro * (1 - Npcro) < reg_len
    % Give fragment a name
    if en_seg == true
        if nr_pcrs > 1
            if m <= length(alph)
                ext = alph(m);
            else
                nralphs = floor(m / length(alph));
                ext = [alph(nralphs) alph(m - length(alph) * nralphs)];
            end
            frag_name{m} = [frag_type num2str(j) ext];
        else
            frag_name{m} = [frag_type num2str(j)];
        end
    else
        if d <= length(alph)
            ext = alph(d);
        else
            nralphs = floor(d / length(alph));
            ext = [alph(nralphs) alph(d - length(alph) * nralphs)];
        end
        frag_name{m} = [frag_type ext];
    end
    for n = pcrSteps
        start = seg_start + region(1, j) + Npcro * n;
        frag_pos(1, m) = start;
        % Ending position of PCR fragment
        frag_pos(2, m) = min([region(2, j) - Npcro * n, ...
            start + pcr_len - 1 - 2 * Npcro * n]);
        % Starting position of PCR fragment with overlap; it is trimmed 
        % so that it does not span further than the region
        frag_pos_over(1, m) = max([region(1, j), frag_pos(1, m) - n]);
        % Ending position of PCR fragment with overlap; it is trimmed so
        % that it does not span further than the region
        frag_pos_over(2, m) = min([region(2, j), frag_pos(2, m) + n]);
        % Sequence of the PCR fragment
        frag_seq{m} = seq((frag_pos(1, m) : frag_pos(2, m)));
        % Sequence of the PCR fragment with overlap in lower case letters
        frag_seq_over{m} = lower(seq((frag_pos_over(1, m) : ...
            frag_pos_over(2, m))));
        % Find coordinates of non-overlapping PCR fragment
        in = (frag_pos(1, m) - frag_pos_over(1, m)) + ...
            (1 : (frag_pos(2, m) - frag_pos(1, m) + 1));
        % Capitalize letters of the non-overlapping part of the PCR fragment
        frag_seq_over{m}(in) = upper(frag_seq_over{m}(in));
        % Generate a primer
        [left_prim, right_prim, left_pos, right_pos] = ...
            primer3calc(process, frag_seq_over{m}, ...
            [name '-' frag_name{m}], n);
        if fatal_error > 0;
            return
        end
        if ~isempty(left_prim) && ~isempty(right_prim)
            frag_primer{1, m} = left_prim;
            frag_primer{2, m} = right_prim;
            frag_pos_clone(1 : 2, m) = frag_pos_over(1, m) + ...
                double([left_pos; right_pos]);
            frag_seq_clone{m} = seq(frag_pos_over(1, m) + ...
                double(left_pos : right_pos));
            d = d + 1;
            break
        else
            frag_primer{1, m} = '';
            frag_primer{2, m} = '';
            frag_pos_clone(1 : 2, m) = [NaN; NaN];
            frag_seq_clone{m} = '';
        end
    end
    if isempty(right_pos) || isnan(right_pos) || isempty(left_pos) || isnan(left_pos)
        seg_start = seg_start + Apcro;
    else
        seg_start = frag_pos_over(1, m) - region(1, j) + right_pos + 1;
        if ~isnan(fid)
            print_fragment(name, frag_name{m}, frag_pos(:, m), ...
                frag_pos_clone(:, m), frag_seq{m}, frag_seq_over{m}, ...
                frag_seq_clone{m}, fid)
        end
        m = m + 1;
    end
end

in = find(diff(frag_pos) == 0);
frag_name(in) = [];
frag_pos(:, in) = [];
frag_pos_over(:, in) = [];
frag_pos_clone(:, in) = [];
frag_seq(in) = [];
frag_seq_over(in) = [];
frag_seq_clone(in) = [];
frag_primer(:, in) = [];
m = m - 1;