% function ProjectCompute
% GH 1/25/2020 

close all
clear
clc

%% define parameters
k1f = 1;    % [uM^-1 h^-1] react1 forward rate constant
k1r = 1;    % [h^-1] react1 reverse rate constant
k2f = 1;    % [uM^-1 h^-1] react2 forward rate constant
k2r = 1;    % [h^-1] react2 reverse rate constant
k3f = 1;    % [uM^-1 h^-1] react3 forward rate constant
k3r = 1;    % [h^-1] react3 reverse rate constant
k4f = 1;    % [uM^-1 h^-1] react4 forward rate constant
k4r = 1;    % [h^-1] react3 reverse rate constant
k6f = 1;    % [uM^-1 h^-1] react6 forward rate constant
k6r = 1;    
k7f = 1;    % [uM^-1 h^-1] react7 forward rate constant
k7r = 1;    % [h^-1] react7 reverse rate constant
k8f = 1;    % [uM^-1 h^-1] react8 forward rate constant
k8r = 1;    % [h^-1] react8 reverse rate constant
k9f = 1;    % [uM^-1 h^-1] react9 forward rate constant
k9r = 1;    % [h^-1] react9 reverse rate constant
k10f = 1;   % [uM^-1 h^-1] react10 forward rate constant
k10r = 1;   % [h^-1] react10 reverse rate constant
k11f = 1;   % [uM^-1 h^-1] react11 forward rate constant
k11r = 1;   % [h^-1] reac11 reverse rate constant
k12f = 1;   % [uM^-1 h^-1] react12 forward rate constant
HS = 5;     % initial concentrations of ligand
FGF2 = 10;   % initial concentrations of ligand 
FGFRin = 10; % initial concentrations of receptor

FRS2i = 10; % initial concentration of FRS2
RASin = 10; % initial concentration of RAS
RAF = 10; % initial concentration of RAF
MEK = 10; % initial concentration of MEK
ERK = 10; % initial concentration of ERK

Vratio = .1; % ratio of cytosol to nuclear space

% should add total concentrations of inputs here
params = {k1f,k1r,k2f,k2r,k3f,k3r,k4f,k4r,k6f,k6r, k7f,k7r,k8f,k8r,k9f,k9r,k10f,k10r,k11f,k11r,k12f,HS,FGF2,FGFRin,FRS2i,RASin, RAF, MEK, ERK, Vratio};

%% Run single simulation
y0 = [HS; % HS
    FGF2; % FGF2
    0; % FGF2:Hs
    FGFRin; % FGFR
    0; %FGF2_FGFR
    FRS2i; %FRS2i
    0; %FGRRact
    0; % FRS2act
    RASin; % RASin
    0; %actRAS
    RAF; %inactivated RAF
    0; %activated RAF
    MEK; %inactivated MEK
    0; %activated MEK
    ERK; %inactivated ERK
    0; %pERK
    0 %pERK nucleus
    ]; % could also load in saved data from a file like y0 = load('yfinal.dat');
tspan = [0 10];
options = [];
[t,y] = ode45(@ProjectODEfun3,tspan,y0,options,params);

yfinal = y(end,:)';
% save -ascii 'yfinal.dat yfinal;       % saves the final values to a file

% plot timecourse
% subplot(1,3,1);
figure
plot(t,y);
xlabel('Time (hours)'); ylabel('y(t) (\muM)'); legend('HS','FGF2','FGF2:HS','FGFRin','FGF2:FGFR','FRS2i','FGFRact','FRS2act','RASin', 'actRAS','RAF','pRAF','MEK','pMEK','ERK','pERK','pERKNu', 'location','eastoutside');

% ^^ gets the system to steady state

%%%Plot ODE solutions in individual subplots
names = {'HS','FGF2','FGF2:HS','FGFRin','FGF2:FGFR','FRS2i','FGFRact','FRS2act','RASin', 'actRAS','RAF','pRAF','MEK','pMEK','ERK','pERK','pERKNu'};
figure
for i = 1:length(yfinal)
   subplot(4, ceil(length(yfinal)/4), i)
   plot(t,y(:,i))
   ylabel('\muM')
   xlabel('t (min)')
   title(names{i})
end

%% FGF2
% % Sustained release input curve
% x = 24*[0.07, 0.34, 1.13, 2.12, 3.06, 4.05, 5.03];
% y = [0, 8.99, 14.66, 15.64, 17.60, 21.51, 23.86];
% p = polyfit(x, y, 1);
% x1 = 0:1:120;
% fgf2 = polyval(p, x1); 
% plot(x, y, 'o', x1, fgf2, 'r');

% f = @(x,xdata) x(1)*(xdata.^x(2));
% x = [3.06, 6.13, 24.07, 95.96];
% y = [1.13, 1.66, 2.63, 3.07];
% x0 = [100; -1];
% [coeff] = lsqcurvefit(f, x0, x, y);
% x1 = [0:1:120];
% fgf2 = f(coeff, x1);
% plot(x, y, 'o', x1, fgf2);

% Burst release
x = 24*[1, 2.63, 4.21, 5.79];%, 7.43, 9.01, 10.62, 12.20, 13.83, 15.41, 17.05];
y = [40.44, 15.02, 12.07, 6.46];%, 4.77, 2.94, 0.56, 0.56, 0.56, 0.28, 0.14];
f = @(x,xdata) x(1)*log(xdata) + x(2);
x0 = [100; 1];
[coeff] = lsqcurvefit(f, x0, x, y);
x1 = [0:1:120];
fgf2 = f(coeff, x1);
plot(x, y, 'o', x1, fgf2);

% y0 = [HS FGF2 FGF2:Hs FGFR FGF2_FGFR FRS2i FGRRact FRS2act RASin actRAS inactivated RAF
% activated RAF inactivated MEK activated MEK inactivated ERK pERK pERK nucleus
y0 = [HS; FGF2; 0; FGFRin; 0; FRS2i; 0; 0; RASin; 0; RAF; 0; MEK; 0; ERK; 0; 0];
for i=1:length(fgf2)
    y0(2) = fgf2(i);
    params = {k1f,k1r,k2f,k2r,k3f,k3r,k4f,k4r,k6f,k6r, k7f,k7r,k8f,k8r,k9f,k9r,k10f,k10r,k11f,k11r,k12f,HS,FGF2,FGFRin,FRS2i,RASin, RAF, MEK, ERK, Vratio};
    tspan = [0 120];
    options = [];
    [t,y]= ode15s(@ProjectODEfun3,tspan,y0,options,params);
    nuclear_ERK(i) = y(end,end);
    y0 = y(end, :);
    
    % If any of the concentrations are less than 0, then 0
    for j=1:length(y0)
        if y0(j) < 0
            y0(j) = 0;
        end
    end
end

figure()
plot(0:1:120, nuclear_ERK);
xlabel('Time (in hours)'); ylabel('Nuclear ERK');