function out = textscanO(w, AS);

if nargin == 1
	AS = 10;
end
%if strfind(delim, '\n')
%	delim = char(10);
%end

in = strfind(w, char(AS));
%length(w)
%length(in)
%if double(delim) == 10
%	l = 0;
%else
%	l = length(in);
%end
in = [0, in, length(w) + 1];
out = cell(1, length(in) - 1);
for i = 1 : length(in) - 1
	out{i} = w(in(i) + 1 : in(i + 1) - 1);
end