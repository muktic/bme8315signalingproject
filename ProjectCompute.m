function ProjectCompute
% GH 1/25/2020 

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
k5f = 1;    % [uM^-1 h^-1] react5 forward rate constant
k5r = 1;    % [h^-1] react5 reverse rate constant
k6f = 1;    % [uM^-1 h^-1] react6 forward rate constant
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
HS = 1;     % initial concentrations of ligand
FGF2 = 1;   % initial concentrations of ligand 
FGFRin = 1; % initial concentrations of receptor
Vratio = .1; % ratio of cytosol to nuclear space

% should add total concentrations of inputs here
params = {k1f,k1r,k2f,k2r,k3f,k3r,k4f,k4r,k5f,k5r,k6f,k7f,k7r,k8f,k8r,k9f,k9r,k10f,k10r,k11f,k11r,k12f,HS,FGF2,FGFRin,Vratio};

%% Run single simulation
y0 = [HS; FGF2; 0; FGFRin; 0; 0; 0; 0; 0; 0; 0; 0 ; 0]; % could also load in saved data from a file like y0 = load('yfinal.dat');
tspan = [0 130];
options = [];
[t,y] = ode23(@ProjectODEfunc,tspan,y0,options,params);

yfinal = y(end,:)';
% save -ascii 'yfinal.dat yfinal;       % saves the final values to a file

% plot timecourse
subplot(1,3,1);
plot(t,y);
xlabel('Time (hours)'); ylabel('y(t) (\muM)'); legend('HS','FGF2','FGF2:HS','FGFRin','FGF2:FGFR','HS:FGFR','FGFRact','FRS2act','RAS','RAF','MEK','ERK','pERKNu');

% ^^ gets the system to steady state

% % optional: re-evaluate ODE function after solving ODEs to calculate
% algebra variables
% for tstep=1:length(t),
%    [~,algvars(tstep,:)]=ProjectODEfunc(t(step),y(tstep,:),params);
% end
% subplot(1,3,2);
% plot(t,algvars(:,1),t,algvars(:,2),t,algvars(:,3),t,algvars(:,4));
% xlabel('Time (sec)'); ylabel('fluxes(t) (\muM/s)');
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

%% FGF2
paramRange = 10.^[-2:.1:2];
for i=1:length(paramRange)
    HS = paramRange(i);
    params = {k1f,k1r,k2f,k2r,k3f,k3r,k4f,k4r,k5f,k5r,k6f,k7f,k7r,k8f,k8r,k9f,k9r,k10f,k10r,k11f,k11r,k12f,HS,FGF2,FGFRin,Vratio};
    y0 = [HS; FGF2; 0; FGFRin; 0; 0; 0; 0; 0; 0; 0; 0 ; 0]; % could also load in saved data from a file like y0 = load('yfinal.dat');
    tspan = [0 130];
    options = [];
    [t,y]= ode15s(@ProjectODEfunc,tspan,y0,options,params);
    Pfinal(i) = y(end,end);
end
subplot(1,3,3);
semilogx(paramRange,Pfinal);
xlabel('FGF2 (\muM)'); ylabel('Steady state Product (\muM)');

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