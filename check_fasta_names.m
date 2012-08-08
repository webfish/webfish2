function target_name = check_fasta_names(process, target_name)

enames = find(cellfun(@isempty, target_name));
if ~isempty(enames)
    for i = enames
        target_name{i} = ['Target_Sequence_' num2str(i)];
        error_msg(process, 0, ['Given sequence name: ' target_name{i}]);
    end
end