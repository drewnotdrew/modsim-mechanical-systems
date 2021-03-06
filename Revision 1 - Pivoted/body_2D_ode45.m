function [T, M] = body_2D_ode45(bodyVelocity);

% Model parameters
G = 6.67e-11; % Gravitational Constant ((N*m^2)/kg^2)
earthMass = 5.97e24; % (kg)
sunMass = 1.99e30; % (kg)
moonMass = 7.348e22; % Mass of the Moon (kg)
bodyMass = 60; % Mass of the body being fired out of our cannon (kg)
d = 3.844e8; % Distance between the Earth and the Moon (m)
rEarth = 6.371e6; % Radius of Earth
rMoon = 1.738e6; % Radius of Earth

% Initial parameters 
earthX = 0;
earthY = 0;
earthPos = [earthX, earthY];
moonX = d;
moonY = 0;
moonPos = [moonX, moonY];
bodyX = 0;
bodyY = rEarth; 
bodyPos = [bodyX, bodyY];
% bodyMoonPos = [-d, rEarth];
bodyParameters = [bodyPos, bodyVelocity]; % bodyMoonPos may be needed (?)
% Simulation parameters

t_0 = 0;
t_end = 60*60*24*365;
t_span = [t_0, t_end];
options = odeset('Events',@event_func, 'RelTol', 1e-5);

% Run ode45
[T, M] = ode15s(@rate_func, t_span, bodyParameters, options);
    function res = rate_func(~,M)
        bodyPosition = M(1:2);
%         bodyMoonPosition = M(3:4);
        bodyVelocity = M(3:4);
        bodyMoonPosition = bodyPosition - [-d; rEarth];
        dPdt = [bodyVelocity]; % [bodyMoonPosition]
        dVdt = acceleration(bodyPosition, bodyMoonPosition, bodyVelocity);
       L  = size(dPdt);
       L2 = size(dVdt);
        res = [dPdt; dVdt];
    end
    
    function res = acceleration(bodyPosition, bodyMoonPosition, bodyVelocity)
        gravForceEarth = -(G*earthMass*bodyMass)/(norm(bodyPosition)^2) * (bodyPosition/norm(bodyPosition));
        gravForceMoon = -(G*moonMass*bodyMass)/(norm(bodyMoonPosition)^2) * (bodyMoonPosition/norm(bodyMoonPosition));
        dAdt = gravForceEarth/bodyMass + gravForceMoon/bodyMass;
        moonbrr = size(gravForceMoon);
        earthbrr = size(gravForceEarth);
        jerkbrr = size(dAdt);
        res = [dAdt];

    end
end
    function [value, isterminal, direction] = event_func(~, M)
    value = 0;
    isterminal = 1;
    direction = -1;
    end