function ylims = ylimgen_latex(i)
global nonuniq_vec
global yaxis_sigdig

%% Generate ylims from the maximum of the histogram; make the maximum ylim
%% 120 % of the max of the histogram and round it to 1 significant digit
ylims = [0, double(max(nonuniq_vec{i}))];
ylims(2) = ylims(2) * 1.02;

expon = 10 .^ (0 : 5);
grth = sign(abs(ylims(2)) - expon);
in = find(grth == 1, 1, 'last');
if isempty(in)
	ylims(2) = 1;
else
	ylims(2) = ...
    ceil(ylims(2) * 10 ^ (yaxis_sigdig - in)) / 10 ^ (yaxis_sigdig - in);
end