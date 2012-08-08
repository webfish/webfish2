function drawsquare(x, y, col, fillc)
global square_width
w = square_width;

xc = [x, fliplr(x)];
if nargin == 4
    yc = [y(1), y(1), y(2), y(2)];
    p = fill(xc, yc, fillc);
    set(p, 'EdgeColor', fillc, 'LineWidth', 0.1);
end
yc = y(1) * [1, 1, 1, 1] + [0, 0, w, w];
p = fill(xc, yc, col);
set(p, 'EdgeColor', col, 'LineWidth', 0.1);
yc = y(2) * [1, 1, 1, 1] - [0, 0, w, w];
p = fill(xc, yc, col);
set(p, 'EdgeColor', col, 'LineWidth', 0.1);
%fill(xc, yc, 'LineWidth', 0.1, 'Color', col);
xc = [x(1), x(1)];
plot(xc, y, '-', 'LineWidth', 0.1, 'Color', col);
xc = [x(2), x(2)];
plot(xc, y, '-', 'LineWidth', 0.1, 'Color', col);