function print_fragment(name, frag_name, frag_pos, frag_pos_clone, ...
    frag_seq, frag_seq_over, frag_seq_clone, fid)
global fatal_error
global enzymes

fprintf(fid, ['Target sequence: ' name '\n']);
fprintf(fid, ['Segment name: ' frag_name '\n']);
fprintf(fid, ['Segment from: ' num2str(frag_pos(1)) ' bp\n']);
fprintf(fid, ['Segment to: ' num2str(frag_pos(2)) ' bp\n']);
fprintf(fid, ['Segment length: ' num2str(diff(frag_pos) + 1) ' bp\n']);
fprintf(fid, ['Cloning segment from: ' num2str(frag_pos_clone(1)) ' bp\n']);
fprintf(fid, ['Cloning segment to: ' num2str(frag_pos_clone(2)) ' bp\n']);
fprintf(fid, ['Cloning segment length: ' ...
    num2str(diff(frag_pos_clone) + 1) ' bp\n']);
sites = restrictioncut(frag_seq_clone);
if fatal_error > 0
    return
end
for n = find(~isnan(sites(:)))'
    fprintf(fid, ['Number of ' enzymes{n} ' sites: ' num2str(sites(n)) ...
        '\n']);
end
fprintf(fid, ['Segment sequence: ' frag_seq '\n']);
fprintf(fid, ['Segment sequence with overhang: ' frag_seq_over '\n']);
fprintf(fid, ['Cloned sequence: ' frag_seq_clone '\n\n']);