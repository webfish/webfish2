function outcol = conv_col(incol, n)
global text_color


if text_color == true
  outcol = incol;
else
  outcol = [0, 0, 0];
end
if nargin == 1
  outcol = [num2str(outcol(1)), ',', num2str(outcol(2)), ',', num2str(outcol(3))];
end
