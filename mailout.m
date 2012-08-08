function mailout(process)
global email
global tasks
global webserver
global fatal_error

if isempty(email)
    %fprintf('No email address provided\n')
    error_msg(process, -1, {'No email address provided'});
    return
end

if ~isa(email, 'char')
    error_msg(process, -1, {'Invalid email address provided', ...
        'Your email does seem to be a number'});
    return
end

atpos = strfind(email, '@');
if isempty(atpos)
    %fprintf('Your email address does not contain @ character\n')
    error_msg(process, -1, {'Invalid email address provided', ...
        'Your email address does not contain @ character'});
    return
end

if length(atpos) > 1
    %fprintf('Your email address contains several @ characters\n')
    error_msg(process, -1, {'Invalid email address provided', ...
        'Your email address contains several @ characters'});
    return
end

dotpos = strfind(email, '.');
if isempty(dotpos)
    %fprintf('Your email address does not contain any dot\n')
    error_msg(process, -1, {'Invalid email address provided', ...
        'Your email address does not contain any dot'});
    return
end

dotpos = dotpos(end);
if dotpos > length(email) - 2 || dotpos < length(email) - 3
    %fprintf('Your email address does not contain a dot at the second or third position from the end\n')
    error_msg(process, -1, {'Invalid email address provided', ...
        'Your email address does not contain a dot ' ...
        'at the second or third position from the end'});
    return
end

%% Write email about error
if fatal_error > 0
    text = {'Dear User!', ...
        ['The query which you have submitted at the tarFISH ' ...
        'website has not been processed due to an error'], ...
        ['You can view the explanation for the failude at the ' ...
        'following website:'], ...
        [webserver.html '/uploads/' tasks{1} '.html'], '', ...
        'Thank you for using tarFISH', '', ...
        'Note: Do not reply to this email'};
else
    text = {'Dear User!', ...
        ['The query which you have submitted at the tarFISH ' ...
        'website has been processed'], ...
        'You can view the output at the following website:', ...
        [webserver.html '/uploads/' tasks{1} '.html'], ...
        'Files will be kept on the server for one week', '', ...
        'Thank you for using tarFISH', '', ...
        'Note: Do not reply to this email'};
end

%% Send the email
[fid, w] = fopen('tasks/email.txt', 'w');
if fid == -1
    fatal_error = 1;
    fatal_msg(process, {'Failed writing email', w});
    return
end
for i = 1 : numel(text)
	fprintf(fid, [text{i} '\n']);
end
fclose(fid);

unix_cmd = ['export EMAIL="FISH<no-reply@nanoimaging.de>"; mutt -s "Your FISH Target Query is Finished" ' email ' < tasks/email.txt'];
[st, w] =  unix(unix_cmd);
if st ~= 0
    fatal_error = 1;
    fatal_msg(process, ...
        {['Failed sending email through mutt'], w});
    return
end
delete('tasks/email.txt');

email = '';
