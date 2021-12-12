function [T, M] = body_2D_ode45(launchAngle, launchVelocity);

% Calculate x and y velocities from launch angle and launch velocity.
launchXvelocity = sind(90-launchAngle)*launchVelocity;
launchYvelocity = cosd(90-launchAngle)*launchVelocity;
bodyVelocity = [launchXvelocity,launchYvelocity]; % (m/s)

% Model parameters
G = 6.67e-11; % Gravitational Constant ((N*m^2)/kg^2)
earthMass = 5.97e24; % (kg)
moonMass = 7.348e22; % Mass of the Moon (kg)
bodyMass = 60; % Mass of the body being fired out of our cannon (kg)
d = 3.844e8; % Distance between the Earth and the Moon (m)
rEarth = 6.371e6; % Radius of Earth

% Initial parameters 
bodyX = 0;
bodyY = rEarth; 
bodyPos = [bodyX, bodyY];
bodyParameters = [bodyPos, bodyVelocity]; % bodyMoonPos may be needed (?)

% Simulation parameters
t_0 = 0;
t_end = 60*60*24*7;
t_span = [t_0, t_end];
options = odeset('Events',@event_func, 'RelTol', 1e-5);

% Run ode45
[T, M] = ode45(@rate_func, t_span, bodyParameters, options);
    function res = rate_func(~,M)
        bodyPosition = M(1:2);
        bodyVelocity = M(3:4);
        bodyMoonPosition = bodyPosition - [-d; rEarth];
        dPdt = [bodyVelocity];
        dVdt = acceleration(bodyPosition, bodyMoonPosition, bodyVelocity);
        res = [dPdt; dVdt];
    end
    
    function res = acceleration(bodyPosition, bodyMoonPosition, bodyVelocity)
        gravForceEarth = -(G*earthMass*bodyMass)/(norm(bodyPosition)^2) * (bodyPosition/norm(bodyPosition));
        gravForceMoon = -(G*moonMass*bodyMass)/(norm(bodyMoonPosition)^2) * (bodyMoonPosition/norm(bodyMoonPosition));
        dAdt = gravForceEarth/bodyMass + gravForceMoon/bodyMass;
        res = [dAdt];

    end
end
    % Helper function
    function [value, isterminal, direction] = event_func(T, M)
        P = M(1:2); % Position of body
        P_1 = M(1:2)-[3.844e8; 0]; % Tried to use moonX and moonY. How do we use these in the event function?
        dist = norm(P_1) - 1.738e6 - 75000*1000;
        value = sign(dist) + 1;
        isterminal = 1;
        direction = -1;
    end