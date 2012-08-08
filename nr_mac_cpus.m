function nr_mac_cpus(process)
global folder

%% Write a script to read the number of processors

fid = fopen([folder 'nr_mac_cpus.sh'], 'w');
    if fid ~= -1
        st = 0;
	else
        st = 1;
    end
    error_msg(process, st, {'Failed getting the system type'});
    fprintf(fid, '#!/bin/bash\n');
	fprintf(fid, ['hwprefs cpu_count > ' folder 'nr_cpus.out\n']);
    fprintf(fid, 'if [ $? -ne 0 ]\n');
    fprintf(fid, 'then\n');
    fprintf(fid, ['        echo "-1" > ' folder 'nr_cpus.out\n']);
    fprintf(fid, 'fi\n');
fclose(fid);

%% Make the script executable
unix_cmd = ['chmod 777 ' folder 'nr_mac_cpus.sh'];
[st, w] =  unix(unix_cmd);
error_msg(process, st, {'Failed chmoding nr_mac_cpus.sh', w});

%% Execute script
unix_cmd = ['./' folder 'nr_mac_cpus.sh'];
[st, w] =  unix(unix_cmd);
error_msg(process, st, {'Failed executing nr_mac_cpus.sh', w});

%% Delete nr_linux_cpus.sh
delete([folder 'nr_mac_cpus.sh']);