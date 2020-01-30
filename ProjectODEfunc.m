function [dydt, algvars] = ProjectODEfunc(t,y,params)
% 1/25/20 GH: initial 

% Assign names for parameter values and state variables
[k1f,k1r,k2f,k2r,k3f,k3r,k4f,k4r,k5f,k5r,k6f,k7f,k7r,k8f,k8r,k9f,k9r,k10f,k10r,k11f,k11r,k12f,HS,FGF2,FGFRin,Vratio] = params{:};

HS = y(1);
FGF2 =y(2);
FGF2_HS = y(3);
FGFRin = y(4);
FGF2_FGFR = y(5);
HS_FGFR = y(6);
FGFRact = y(7);
FRS2act = y(8);
RAS = y(9);
RAF = y(10);
MEK = y(11);
ERK = y(12);
pERKNu = y(13);

% Rates

react1f = k1f*FGF2*HS;
react1r = k1r*FGF2_HS;
react2f = k2f*FGF2*FGFRin;
react2r = k2r*FGF2_FGFR;
react3f = k3f*HS*FGFRin;
react3r = k3r*HS_FGFR;
react4f = k4f*FGF2_FGFR*HS_FGFR;
react4r = k4r*FGFRact;
react5f = k5f*FGF2_HS*FGFRin;
react5r = k5r*FGFRact;
react6f = k6f*FGFRact;
react7f = k7f*FRS2act;
react7r = k7r*RAS;
react8f = k8f*RAS;
react8r = k8r*RAF;
react9f = k9f*RAF;
react9r = k9r*MEK;
react10f = k10f*MEK;
react10r = k10r*ERK;
react11f = k11f*ERK;
react11r = k11r*pERKNu;
react12f = k12f*ERK;

% Differential Equations

dFGF2 = react1r + react2r - react1f - react2f;
dHS = react1r + react3r - react1f - react3f;
dFGF2_HS = react1f + react5r - react1r - react5f;
dFGFRin = react2r + react3r - react2f - react3f;
dFGF2_FGFR = react2f + react4r - react2r - react4f;
dHS_FGFR = react3f + react4r - react3r - react4f;
dFGFRact = react5f + react4f - react5r - react4r - react6f; 
dFRS2act = react6f - react12f;
dRAS = react7f + react8r - react7r - react8f; 
dRAF = react8f + react9r - react8r - react9f;
dMEK = react9f + react10r - react9r - react10f; 
dERK = react10f + react11r - react10r - (react11f*Vratio) - react12f;
dpERKNu = (react11f)*Vratio;
dydt = [dHS;dFGF2; dFGF2_HS;dFGFRin;dFGF2_FGFR;dHS_FGFR;dFGFRact;dFRS2act;dRAS;dRAF;dMEK;dERK;dpERKNu]; % reassemble differential equations
algvars = [react1f,react1r,react2f,react2r,react3f,react3r,react4f,react4r,react5f,react5r,react6f,react7f,react7r,react8f,react8r,react9f,react9r,react10f,react10r,react11f,react11r,react12f]; % optional for seeing fluxes