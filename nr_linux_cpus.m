function nr_linux_cpus(process)
global folder

%% Write a script to read the number of processors
fid = fopen([folder 'nr_linux_cpus.sh'], 'w');
    if fid ~= -1
        st = 0;
	else
        st = 1;
    end
    error_msg(process, st, {'Failed getting the system type'});
    fprintf(fid, '#!/bin/bash\n');
	fprintf(fid, ['#from http://www.dslreports.com/forum/'...
        'r20892665-Help-test-Linux-core-count-script\n']);
    fprintf(fid, 'if [ ! -r /proc/cpuinfo ]; then\n');
    fprintf(fid, ['        echo ''-1'' > ' folder 'nr_cpus.out\n']);
	fprintf(fid, '        exit 0\n');
    fprintf(fid, 'fi\n');
	fprintf(fid, ['num_cores=`grep ''physical id'' /proc/cpuinfo | '...
        'sort -u | wc -l`\n']);
	fprintf(fid, 'if [ $num_cores -eq 0 ]; then\n');
    fprintf(fid, ['        num_cores=`grep ''^processor'' '...
        '/proc/cpuinfo | sort -u | wc -l`\n']);
    fprintf(fid, 'else\n');
    fprintf(fid, ['        list=(`grep -iE ''(physical|core).*id'' '...
        '/proc/cpuinfo | cut -d: -f2 | tr -d '' ''`)\n']);
    fprintf(fid, '        index=0\n');
    fprintf(fid, '        for ent in ${list[@]}; do\n');
	fprintf(fid, '                new_index=$(($index/2))\n');
    fprintf(fid, '                tmp=${new_list[$new_index]}\n');
	fprintf(fid, '                if [ -z ''$tmp'' ]; then\n');
    fprintf(fid, ['                        '...
        'new_list[$new_index]=$ent\n']);
	fprintf(fid, '                else\n');
    fprintf(fid, ['                        '...
        'new_list[$new_index]=$tmp,$ent\n']);
    fprintf(fid, '                fi\n');
    fprintf(fid, '                index=$(($index+1))\n');
	fprintf(fid, '        done\n');
    fprintf(fid, ['        num_cores=`echo ${new_list[*]} | '...
        'tr '' '' ''\\n'' | sort -u | wc -l`\n']);
    fprintf(fid, 'fi\n');
    fprintf(fid, ['echo $num_cores > ' folder 'nr_cpus.out\n']);
fclose(fid);

%% Make the script executable
unix_cmd = ['chmod 777 ' folder 'nr_linux_cpus.sh'];
[st, w] =  unix(unix_cmd);
error_msg(process, st, {'Failed chmoding nr_linux_cpus.sh', w});

%% Execute script
unix_cmd = ['./' folder 'nr_linux_cpus.sh'];
[st, w] =  unix(unix_cmd);
error_msg(process, st, {'Failed executing nr_linux_cpus.sh', w});

%% Delete nr_linux_cpus.sh
delete([folder 'nr_linux_cpus.sh']);