%% Plot the LIGO antenna pattern for plus and cross
%
% Tobin Fricke 2013-03-05

% The LIGO antenna pattern is derived in T970101-B, "Strain Calibration in
% LIGO" by Daniel Sigg, available from https://dcc.ligo.org/T970101/public
%
% The two relevant expressions are:
%
% h_xx = - cos(theta) sin(2 phi) h_x 
%        + (cos^2 theta cos^2 phi - sin^2 phi) h_+
% 
% h_yy =   cos(theta) sin(2 phi) h_x
%        + (cos^2 theta sin^2 phi - cos^2 phi) h_+
%
% The intereferometer response is | h_xx - h_yy | as a function of angles
% phi and theta.  

% The coordinate system used by Sigg is different from what Matlab's
% sph2cart expects.  
%
%    VARIABLE        SIGG         MATLAB
%    phi             longitude    latitude
%    theta           colatitude   longitude
%
% The conversion is:
%
%  theta_(matlab) = phi_(sigg)
%  phi_(matlab) = 90 - theta_(sigg)
%
% Here we use Sigg coordinates:

F_cross = @(phi, theta) abs(-2 * cos(theta) .* sin(2*phi));
F_plus  = @(phi, theta) abs((cos(theta).^2 .* cos(phi).^2 - sin(phi).^2) - ...
                            (cos(theta).^2 .* sin(phi).^2 - cos(phi).^2));
        

% Now plot everything:

[theta, phi] = meshgrid(linspace(0, pi, 51), linspace(0, 2*pi, 50));

subplot(2,3,1);
R = F_plus(phi, theta);
[X, Y, Z] = sph2cart(phi, pi/2-theta, R);
surf(X,Y,Z,R);
xlim([-2 2]);
ylim([-2 2]);
zlim([-2 2]);
title('PLUS');
xlabel('x');
ylabel('y');
zlabel('z');

subplot(2,3,2);
R = F_cross(phi, theta);
[X, Y, Z] = sph2cart(phi, pi/2-theta, R);
surf(X,Y,Z,R);
xlim([-2 2]);
ylim([-2 2]);
zlim([-2 2]);
title('CROSS');

subplot(2,3,3);
R = sqrt(F_plus(phi, theta).^2 + F_cross(phi, theta).^2);
[X, Y, Z] = sph2cart(phi, pi/2-theta, R);
surf(X,Y,Z,R);
xlim([-2 2]);
ylim([-2 2]);
zlim([-2 2]);
title('RMS');

subplot(2,3,4);
R = F_plus(phi, theta);
pcolor(phi *180/pi, theta *180/pi, R);
xlabel('longitude (\phi)');
ylabel('colatitude (\theta)');
shading interp

subplot(2,3,5);
R = F_cross(phi, theta);
pcolor(phi *180/pi, theta *180/pi, R);
xlabel('\phi');
ylabel('\theta');
shading interp

subplot(2,3,6);
R = sqrt(F_plus(phi, theta).^2 + F_cross(phi, theta).^2);
pcolor(phi *180/pi, theta *180/pi, R);
xlabel('\phi');
ylabel('\theta');
shading interp

%% Make PDF

orient landscape
print -dpdf peanut.pdf
print -dpng peanut.png
