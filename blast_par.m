function blast_par(process)
global last_process
global folder
global blast_dir
%global blast_db
global blast_length
global blast_cutoff
global blast_cpus
global organism
global fatal_error
global OS
global config_file
global restrict_sequence
global include_haplo
global include_patch

%% Load saved target sequences
if last_process >= process
    load([folder 'mats/fp' num2str(process) '.mat']);
    write_log(process, 'BLAST parameters loaded');
    write_log(process);
    return
end

%% Import target sequences from fasta file
%blast_dir = read_config('blast_dir', process);
%% Make sure blast_dir ends with a slash
if ~isempty(blast_dir)
    if blast_dir(end) ~= '/'
        blast_dir = [blast_dir '/'];
    end
end
%blast_db = read_config('blast_db', process);
%fasta_db = read_config('fasta_db', process);
%blast_cpus = uint32(str2double(read_config('blast_cpus', process)));

%% ************
%%   OBSOLETE
%blast_length = read_config('blast_length', process, false);
blast_length = 1e+6;
%% ************
blast_cutoff = read_config('bit_score', process, false, 'blast_cutoff');
blast_cutoff = check_value(process, blast_cutoff, ...
    'bit_score', [200, 0, 1000], [0, 2000]);

%% Include haplotype chromosomes
include_haplo = read_config('include_haplo', process, false);
include_haplo = check_logical(process, include_haplo, 'include_haplo', false);

%% Include patches for chromosomes
include_patch = read_config('include_patch', process, false);
include_patch = check_logical(process, include_patch, 'include_patch', false);

restrict_sequence = read_config('restrict_sequence', process, true);
organism = read_config('organism', process, true);

%% Get OS type
OS = get_os_type(process);

if OS == 1
	nr_mac_cpus(process)
elseif OS == 2
    nr_linux_cpus(process)
end

%% Get number of computer cores
if OS > 0
    fid = fopen([folder 'nr_cpus.out'], 'r');
        if fid ~= -1
            st = 0;
        else
            st = 1;
        end
        error_msg(process, st, {'Failed getting the system type'});
        cpus = fscanf(fid, '%d');
    fclose(fid);
    delete([folder 'nr_cpus.out']);
else
    cpus = 0;
end

if cpus < 1 || isempty(cpus)
    cpus = 1;
    error_msg(process, 1, ...
        {'Could not acquire the number of available processor cores', ...
        'Assuming there is one CPU in your computer'});
end

%% Check if any of the parameters are left empty
if isempty(blast_cpus) || ~(blast_cpus > 0) || blast_cpus > cpus ...
        || length(blast_cpus) > 1
    blast_cpus = cpus;
    error_msg(process, 1, ...
        {'You have not provided valid number of CPUs', ...
        ['Will use ' num2str(cpus) ' CPUs']});
end

%% Check maximum blast length allowance
if isempty(blast_cpus) || blast_length < 1000 || length(blast_length) > 1
    blast_length = 1000;
    error_msg(process, st, ...
        {'Your maximum target length is too short', ...
        ['Will use maximum target length of ' ...
        num2str(blast_length) ' bp']});
end

%% Check maximum blast length allowance
if isempty(blast_cpus) || blast_length > 5000000 || ...
        length(blast_length) > 1
    blast_length = 5000000;
    error_msg(process, st, ...
        {'Your maximum target length is too long', ...
        ['Will use maximum target length of ' ...
        num2str(blast_length) ' bp']});
end
update_conffile(config_file, 'blast_length', num2str(blast_length))

%% Check is organism is set
if isempty(organism)
    fatal_error = 1;
    fatal_msg(process, {'You have not chosen valid organism'});
    return
end

if fatal_error == 1
    return
end

%% Check the restricted sequence
% Divide restrict_sequence into restricts for individual input
% sequences
restrict_sequence = textscanO(restrict_sequence, '|');
% check is every restrict_sequence can be converted into matrix
for i = 1 : numel(restrict_sequence);
    rest_err = true;
    try
        restrict_sequence{i} = str2num(restrict_sequence{i});
    catch
        restrict_sequence{i} = [];
        rest_err = false;
    end
    if size(restrict_sequence{i}, 2) ~= 2
        restrict_sequence{i} = [];
        rest_err = false;
    end
    if rest_err
        continue
    end
    error_msg(process, st, ...
              {'Invalid restrict_sequence format', ...
               ['Input start and end position of restriction ' ...
                'separated by comma (,).'], ...
               ['More restrictions per sequence can be added ' ...
                'when separated by semicolon (;).'], ...
               ['Restrictions for different query sequences ' ...
                'should be separated by pipe (|).'], ...
               'Example of a valid restriction sequence:', ...
               '1000,2000|5000,7000;8000,9000|||100,200' ...
               sprintf(['Restrict sequence for query %d will not ' ...
                        'be used'], i)});
end

%% Save output
save([folder 'mats/fp' num2str(process) '.mat'], 'blast_dir', ...
    'organism', 'blast_length', 'blast_cpus', 'OS', 'blast_cutoff', ...
    'restrict_sequence');
write_log(process, 'Imported BLAST parameters');

%% Process finished
write_log(process);
