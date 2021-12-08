function [T, M] = nuke_ode(nukeVelocity)

% Model parameters
G = 6.67e-11;        % Gravitational Constant ((N*m^2)/kg^2)
earthMass = 5.97e24; % Mass of the earth(kg)
sunMass = 1.99e30;   % Mass of the sun(kg)
nukeMass = 60;       % Mass of the nuke (kg)
d = 3.844e8;         % Distance between the Earth and the Moon (m)
rEarth = 6.371e6;    % Radius of the Earth

% Initial parameters 
earthX = 0;                  % X-position of the Earth
earthY = 0;                  % Y-position of the Earth
earthPos = [earthX, earthY]; % Matrix of the Earth's position 
nukeX = 0;
nukeY = rEarth; % What is rEarth?
nukePos = [nukeX, nukeY];
nukeParameters = [nukePos, nukeVelocity];

% Simulation parameters

t_0 = 0;
t_end = 60*60*24*365; % A year's length of time in seconds
t_span = [t_0, t_end];
options = odeset('Events',@event_func, 'RelTol', 1e-5); % Ask drew about the event function

% Run ode45
[T, M] = ode15s(@rate_func, t_span, nukeParameters, options);
    function res = rate_func(~,M)
        nukePosition = M(1:2);
        nukeVelocity = M(3:4);
        
        dPdt = [nukeVelocity];
        dVdt = acceleration(nukePosition, nukeVelocity);

        res = [dPdt; dVdt];
    end
    
    function res = acceleration(nukePosition, nukeVelocity)
        gravForceEarth = -(G*earthMass*nukeMass)/(norm(nukePosition)^2) * (nukePosition/norm(nukePosition));

        dAdt = gravForceEarth/nukeMass; 

        res = [dAdt];

    end
end
    function [value, isterminal, direction] = event_func(~, M) % This is the helper function
    value = 0;
    isterminal = 1;
    direction = -1;
    end