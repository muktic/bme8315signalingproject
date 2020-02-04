function [dydt, algvars] = ProjectODEfun3(t,y,params)
% 1/25/20 GH: initial 

% Assign names for parameter values and state variables
[k1f,k1r,k2f,k2r,k3f,k3r,k4f,k4r,k6f,k6r, k7f,k7r,k8f,k8r,k9f,k9r,k10f,k10r,k11f,k11r,k12f,HS,FGF2,FGFRin,FRS2i,RASin, RAF, MEK, ERK,Vratio] = params{:};

HS = y(1);
%FGF2 =y(2);
FGF2 = -3*t;
FGF2_HS = y(3);
FGFRin = y(4);
FGF2_FGFR = y(5);
FRS2i = y(6);
FGFRact = y(7);
FRS2act = y(8);
RASin=y(9);
actRAS = y(10);
RAF = y(11);
pRAF= y(12);
MEK = y(13);
pMEK= y(14);
ERK = y(15);
pERK= y(16);
pERKNu = y(17);

% Rates

J1f = k1f*FGF2*HS;
J1r = k1r*FGF2_HS;
J2f = k2f*FGF2*FGFRin;
J2r = k2r*FGF2_FGFR;
J3f = k3f*FGF2_HS*FGFRin;
J3r = k3r*FGFRact;
J4f = k4f*FGF2_FGFR*HS;
J4r = k4r*FGFRact;
J6f = k6f*FGFRact*FRS2i;
J6r = k6r*FRS2act;
J7f = k7f*FRS2act*RASin;
J7r = k7r*actRAS;
J8f = k8f*actRAS*RAF;
J8r = k8r*pRAF;
J9f = k9f*pRAF*MEK;
J9r = k9r*pMEK;
J10f = k10f*pMEK*ERK;
J10r = k10r*pERK;
J11f = k11f*pERK;
J11r = k11r*pERKNu;
J12f = k12f*pERK*FRS2act;

% Differential Equations

%dFGF2 = J1r + J2r - J1f - J2f;
dFGF2=-3;
%dFGF2=0;
dHS = J1r + J4r - J1f - J4f;
dFGF2_HS = J1f  - J1r +J3r - J3f;
dFGFRin = J2r + J3r - J2f - J3f;
dFGF2_FGFR = J2f + J4r - J2r - J4f;
dFRS2i = J6r - J6f + J12f;
dFGFRact = J4f - J4r + J3f - J3r - J6f; 
dFRS2act = J6f - J12f;
dinaRAS = J7r - J7f;
dactRAS = J7f - J7r;
dRAF= J8r - J8f;
dpRAF = J8f - J8r;
dMEK = J9r - J9f; 
dpMEK = J9f-J9r;
dERK = J10r - J10f;
dpERK = J10f + J11r - J10r - (J11f*Vratio);
dpERKNu = (J11f)*Vratio-J11r;
dydt = [dHS;dFGF2; dFGF2_HS;dFGFRin;dFGF2_FGFR;dFRS2i;dFGFRact;dFRS2act;dinaRAS; dactRAS;dRAF;dpRAF;dMEK;dpMEK;dERK;dpERK;dpERKNu]; % reassemble differential equations
algvars = [J1f,J1r,J2f,J2r,J3f,J3r,J4f,J4r,J6f,J6r,J7f,J7r,J8f,J8r,J9f,J9r,J10f,J10r,J11f,J11r,J12f]; % optional for seeing fluxes
