function producehtml(process, addline, headname, addtail)
global tasks
global currenthtml
global webserver
global firsthtml
global sendhtml

%% Generate html file
if nargin == 4
    tail = htmltail(addtail);
    head = htmlhead(headname, 1);
else
    tail = htmltail;
    head = htmlhead(headname);
end
currenthtml = horzcat(currenthtml, addline);

%% Save html file locally
fname = ['tasks/' tasks{1} '.html'];
[fid, w] = fopen(fname, 'w');
if fid ~= -1
    fprintf(fid, '%s\n', head{:}); 
    fprintf(fid, '%s\n', currenthtml{:}); 
    fprintf(fid, '%s\n', tail{:}); 
    fclose(fid);
else
    st = 1;
    error_msg(process, st, {'Unable to write html file', w});
end

%% Transfer html file to the server
if firsthtml == 1
    unix_cmd = ['rm -f ' webserver.directory 'uploads/' tasks{1} '.html'];
    [st, w] = unix(unix_cmd);
    error_msg(process, st, {'Failed deletting old html file from the server', w});
    firsthtml = 0;
end
if sendhtml == true && ~isequal(webserver.html, '.')
    unix_cmd = ['cp ' fname ' ' webserver.directory 'uploads/'];
    [st, w] = unix(unix_cmd);
    error_msg(process, st, {'Failed sending html file to the server', w});
end