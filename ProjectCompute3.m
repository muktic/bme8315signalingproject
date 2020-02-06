% function ProjectCompute
% GH 1/25/2020 


clear
close all
clc

% Modeling the following reactions:

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
HS = 1000;     % initial concentrations of ligand

FGF2 = 5.1866;   % delayed initial concentrations of ligand 
%FGF2= 100; %burst
%FGF2 = 5;% burst- in saline
%FGF2=0.4; %ustained
FGFRin = 1000; % initial concentrations of receptor
FRS2i = 100; % initial concentration of FRS2
RASin = 100; % initial concentration of RAS
RAF = 100; % initial concentration of RAF
MEK = 100; % initial concentration of MEK
ERK = 100; % initial concentration of ERK

Vratio = .1; % ratio of cytosol to nuclear space

% should add total concentrations of inputs here
params = {k1f,k1r,k2f,k2r,k3f,k3r,k4f,k4r,k6f,k6r, k7f,k7r,k8f,k8r,k9f,k9r,k10f,k10r,k11f,k11r,k12f,HS,FGF2, FGFRin,FRS2i,RASin, RAF, MEK, ERK, Vratio};

%% Run single simulation
y0 = [HS; % HS
    FGF2 % FGF2
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
tspan = [0 120];
options = [];
[t,y] = ode45(@ProjectODEfun3,tspan,y0,options,params);

yfinal = y(end,:)';
% save -ascii 'yfinal.dat yfinal;       % saves the final values to a file

% plot timecourse
% subplot(1,3,1);
figure (1)
plot(t,y);
xlabel('Time (hours)'); ylabel('y(t) (\muM)'); legend('HS','FGF2','FGF2:HS','FGFRin','FGF2:FGFR','FRS2i','FGFRact','FRS2act','RASin', 'actRAS','RAF','pRAF','MEK','pMEK','ERK','pERK','pERKNu', 'location','eastoutside');

% ^^ gets the system to steady state

%%%Plot ODE solutions in individual subplots
names = {'HS','FGF2','FGF2:HS','FGFRin','FGF2:FGFR','FRS2i','FGFRact','FRS2act','RASin', 'actRAS','RAF','pRAF','MEK','pMEK','ERK','pERK','pERKNu'};
figure (2)
for i = 1:length(yfinal)
   subplot(4, ceil(length(yfinal)/4), i)
   plot(t,y(:,i))
   ylabel('\muM')
   xlabel('t (min)')
   title(names{i})
end

%delayed release
subplot(2,1,1)
x4 = 24*[0.07, 0.34, 1.13, 2.12, 3.06, 4.05, 5.03];
y4 = [0, 8.99, 14.66, 15.64, 17.60, 21.51, 23.86];
plot(t,y(:,2),x4,y4,'o')
title('FGF2 release')
xlabel('Time(hrs)')
ylabel('\muM')
subplot(2,1,2)
plot(t,y(:,17))
title('pERK-Delayed Release')
xlabel('Time (hrs)')
ylabel('\muM')

% subplot(2,1,1)
% x3 = [3.06, 6.13, 24.07, 95.96];
% y3 = [1.13, 1.66, 2.63, 3.07];
% plot(t,y(:,2),x3,y3,'o')
% title('FGF2 release')
% xlabel('Time(hrs)')
% ylabel('\muM')
% subplot(2,1,2)
% plot(t,y(:,17))
% title('pERK-Sustained Release')
% xlabel('Time (hrs)')
% ylabel('\muM')

% % %plotting them on top of one another- Burst
% figure ('color','white')
% subplot(2,1,1)
% 
% xdata = 24*[1, 2.63, 4.21, 5.79];%, 7.43, 9.01, 10.62, 12.20, 13.83, 15.41, 17.05];
% ydata = [40.44, 15.02, 12.07, 6.46];%, 4.77, 2.94, 0.56, 0.56, 0.56, 0.28, 0.14];
% plot(t,y(:,2),xdata,ydata,'o')
% title('FGF2 release')
% xlabel('Time(hrs)')
% ylabel('\muM')
% subplot(2,1,2)
% plot(t,y(:,17))
% title('pERK-Burst Release')
% xlabel('Time (hrs)')
% ylabel('\muM')


% %plotting them on top of one another- burst from saline- init conc. 5
% figure ('color','white')
% subplot(2,1,1)
% plot(t,y(:,2))
% title('FGF2 release')
% xlabel('Time(hrs)')
% ylabel('\muM')
% subplot(2,1,2)
% plot(t,y(:,17))
% title('pERK-Delivery in Saline')
% xlabel('Time (hrs)')
% ylabel('\muM')

% % optional: re-evaluate ODE function after solving ODEs to calculate
% algebra variables
%  for tstep=1:length(t),
%   [~,algvars(tstep,:)]=ProjectODEfunc(t(step),y(tstep,:),params);
%  end
%  subplot(1,3,2);
%  plot(t,algvars(:,1),t,algvars(:,2),t,algvars(:,3),t,algvars(:,4));
%  xlabel('Time (sec)'); ylabel('fluxes(t) (\muM/s)');
% legend('react1f','react1r','react2f','react2r','react3f','react3r','react4f','react5f','react5r','react6f','react6r','react7f','react7r','react8f','react8r','react9f');

%% Run dose response over a range of total ligand concentrations
% %% HS
% paramRange = 10.^[-2:.1:2];
% for i=1:length(paramRange)
%     HS = paramRange(i);
%     params = {k1f,k1r,k2f,k2r,k3f,k3r,k4f,k5f,k5r,k6f,k6r,k7f,k7r,k8f,k8r,k9f,HS,FGF2,FRS2};
%     y0 = [HS; FGF2; 0; 0; FRS2; 0; 0; 0; 0 ; 0]; % could also load in saved data from a file like y0 = load('yfinal.dat');
%     tspan = [0 10];
%     options = [];
%     [t,y] = ode15s(@ProjectODEfunc,tspan,y0,options,params);
%     Pfinal(i) = y(end,end);
% end
% subplot(1,3,3);
% semilogx(paramRange,Pfinal);
% xlabel('HS (\muM)'); ylabel('Steady state Product (\muM)');

% %% FGF2
% paramRange = 10.^[-2:.1:4];
% for i=1:length(paramRange)
%     FGF2 = paramRange(i);
%     params = {k1f,k1r,k2f,k2r,k3f,k3r,k4f,k4r,k6f,k6r, k7f,k7r,k8f,k8r,k9f,k9r,k10f,k10r,k11f,k11r,k12f,HS,FGF2,FGFRin,FRS2i,RASin, RAF, MEK, ERK, Vratio};
%    y0 = [HS; % HS
%     FGF2; % FGF2
%     0; % FGF2:Hs
%     FGFRin; % FGFR
%     0; %FGF2_FGFR
%     FRS2i; %FRS2i
%     0; %FGRRact
%     0; % FRS2act
%     RASin; % RASin
%     0; %actRAS
%     RAF; %inactivated RAF
%     0; %activated RAF
%     MEK; %inactivated MEK
%     0; %activated MEK
%     ERK; %inactivated ERK
%     0; %pERK
%     0 %pERK nucleus
%     ];
%     tspan = [0 120];
%     options = [];
%     [t,y]= ode15s(@ProjectODEfun3,tspan,y0,options,params);
%     Pfinal(i) = y(end,end);
% end
% figure()
% semilogx(paramRange,Pfinal);
% xlabel('FGF2 (\muM)'); ylabel('Steady state Product (\muM)');

%% FRS2
% paramRange = 10.^[-2:.1:2];
% for i=1:length(paramRange)
%     HS = paramRange(i);
%     params = {k1f,k1r,k2f,k2r,k3f,k3r,k4f,k5f,k5r,k6f,k6r,k7f,k7r,k8f,k8r,k9f};
%     y0 = [HS; FGF2; 0; 0; FRS2; 0; 0; 0; 0 ; 0]; % could also load in saved data from a file like y0 = load('yfinal.dat');
%     tspan = [0 10];
%     options = [HS; 0; ];
%     [t,y]= ode15s(@ProjectODEfunc,tspan,y0,options,params);
%     Pfinal(i) = y(end,end);
% end
% subplot(1,3,3);
% semilogx(paramRange,Pfinal);
% xlabel('FRS2 (\muM)'); ylabel('Steady state Product (\muM)');