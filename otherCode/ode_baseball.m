%% Simulate baseball trajectory
%
% Simulates baseball trajectory, but terminates solution once the
% horizontal range reaches that of the Green Monster (Fenway park wall).
%
% Usage
%   [T, U] = ode_baseball(speed0, angle)
%
% Arguments
%   speed0 = initial speed of baseball (m/s)
%   angle  = initial angle of baseball velocity;
%            between x-axis rotating counter-clockwise (degrees)
% Returns
%   T = vector of time instances (s)
%   U = matrix of state instances
%     = [x (m), y (m), u (m/s), v (m/s)]
function [T, U] = ode_baseball(speed0, angle)
    
%% Set parameters
% Green Monster range
wall_range = 94.5; % (m)

% initial conditions
x0 = 0; % Initial horizontal position (meters)
y0 = 1; % Initial vertical position (meters)
u0 = cosd(angle) * speed0; % Initial horizontal velocity (m/s)
v0 = sind(angle) * speed0; % Initial vertical velocity (m/s)

% acceleration due to gravity
g = 9.8; % m/s**2

% mass and diameter of a baseball from 
% https://en.wikipedia.org/wiki/Baseball_(ball)
mass = 145e-3; % kg
diameter = 73e-3; % m
radius = diameter/2; % m
area = pi * radius^2; % m^2

% density of air at 20 C near sea level
rho = 1.2; % kg/m**3

% coefficient of drag for a baseball
C_d = 0.33;  % dimensionless

%% Run ODE solver
% Set event for ground collision
options = odeset('Events', @event_range_met);

% Run solver
State0 = [x0; y0; u0; v0];
[T, U] = ode45(@rate_baseball, [0, 60], State0, options);

%% Helper functions
    
    function res = rate_baseball(~, State)
        % Compute time rate-of-change for the baseball state.
%         x = State(1); % We could unpack these from the state, but it's
%         y = State(2); % not necessary because we don't use x,y to
%                       % compute the acceleration of the baseball.
        u = State(3);
        v = State(4);
        
        Velocity = [u, v];
        a_drag = drag_force(Velocity) / mass;
        a_grav = [0, -g];
    
        Acceleration = a_grav + a_drag;
        
        res = [u; v; Acceleration(1); Acceleration(2)];
    end

    function res = drag_force(V)
        % Compute the drag force on a baseball.
        mag = - (0.5 * rho * norm(V)^2) * C_d * area;
        direction = hat(V);
        res = direction * mag;
    end
    
    function res = hat(V)
        % Compute a unit vector in the direction of V.
        res = V / norm(V);
    end
    
    function [value, isterminal, direction] = event_range_met(~, State)
        % Stop when the ball's x position reaches the wall.
        x = State(1);
%         y = State(2);
%         u = State(3);
%         v = State(4);
        value = x - wall_range;
        isterminal = 1;
        direction = 1;
    end    
end