function [] = plot_earth_moon()
clf;
hold on
% Plot Earth
points = linspace(0, 2*pi, 500); r = 6.371e6;
x = r*cos(points); y = r*sin(points);
plot(x,y,'g'); plot(0,0,'*g')

% Plot Moon
r = 1.738e6;
x = r*cos(points) + 3.844e8; y = r*sin(points);
plot(x,y,'k'); plot(3.844e8,0, '*k')

% Plot lunar satelite orbit
r = 1.738e6 + 75000*1000;
x = r*cos(points) + 3.844e8; y = r*sin(points);
plot(x,y,'--k')

% Set graph bounds and axis labels
axis equal; xlim([-0.25*10^8 4.8*10^8]); ylim([-1.5*10^8 1.5*10^8]);
xlabel('X Distance from Center of Earth (m)'); ylabel('Y Distance from Center of Earth (m)');
end