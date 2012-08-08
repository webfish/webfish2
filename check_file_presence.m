function check_file_presence(process, fname)
global fatal_error

files = dir(fname);
if isempty(files)
    fatal_error = 1;
    fatal_msg(process, {['File "' fname '" not found']});
end