function runblast(process)
global last_process
global target_seq
global target_name
global chr
global folder

%% Load saved target sequences
if last_process >= process
    write_log(process, 'BLAST alignment finished');
    write_log(process);
    return
end

%% Execute BLAST search
exec_blast(process, target_seq, target_name, chr)
delete([folder 'target.fa']);

write_log(process, 'Finished BLAST alignment');

%% Process finished
write_log(process);