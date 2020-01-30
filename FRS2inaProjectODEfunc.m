function [dydt, algvars] = FRS2inaProjectODEfunc(t,y,params)
% 1/30/20 GH: initial 

% Assign names for parameter values and state variables
[k1f,k1r,k2f,k2r,k3f,k3r,k4f,k4r,k5f,k5r,k6f,k6r,k7f,k8f,k8r,k9f,k9r,k10f,k10r,k11f,k11r,k12f,k12r,k13f,HS,FGF2,FGFRin,Vratio] = params{:};

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
FRS2ina = y(13);
pERKNu = y(14);

% Rates

react1f = k1f*FGF2*HS;
react1r = k1r*FGF2_HS;
react2f = k2f*FGF2*FGFRin;
react2r = k2r*FGF2_FGFR;
react3f = k3f*HS*FGFRin;
react3r = k3r*HS_FGFR;
react4f = k4f*FGF2_FGFR*HS;
react4r = k4r*FGFRact;
react5f = k5f*HS_FGFR*FGF2;
react5r = k5r*FGFRact;
react6f = k6f*FGF2_HS*FGFRin;
react6r = k6r*FGFRact;
react7f = k7f*FGFRact;
react8f = k8f*FRS2act;
react8r = k8r*RAS;
react9f = k9f*RAS;
react9r = k9r*RAF;
react10f = k10f*RAF;
react10r = k10r*MEK;
react11f = k11f*MEK;
react11r = k11r*ERK;
react12f = k12f*ERK;
react12r = k12r*pERKNu;
react13f = k13f*ERK*FRS2act;

% Differential Equations

dFGF2 = react1r + react2r + react5r - react1f - react2f - react5f;
dHS = react1r + react3r + react4r - react1f - react3f - react4f;
dFGF2_HS = react1f + react6r - react1r - react6f;
dFGFRin = react2r + react3r - react2f - react3f;
dFGF2_FGFR = react2f + react4r - react2r - react4f;
dHS_FGFR = react3f + react5r - react3r - react5f;
dFGFRact = react4f + react5f + react6f - react5r - react4r - react6r - react7f; 
dFRS2act = react7f + react8r - react8f - react13f;
dRAS = react8f + react9r - react8r - react9f; 
dRAF = react9f + react10r - react9r - react10f;
dMEK = react10f + react11r - react10r - react11f; 
dERK = react11f + react12r - react11r - (react12f*Vratio) - react13f;
dpERKNu = (react12f)*Vratio;
dFRS2ina = react13f;
dydt = [dHS;dFGF2;dFGF2_HS;dFGFRin;dFGF2_FGFR;dHS_FGFR;dFGFRact;dFRS2act;dRAS;dRAF;dMEK;dERK;dFRS2ina;dpERKNu]; % reassemble differential equations
algvars = [react1f,react1r,react2f,react2r,react3f,react3r,react4f,react4r,react5f,react5r,react6f,react6r,react7f,react8f,react8r,react9f,react9r,react10f,react10r,react11f,react11r,react12f,react12r,react13f]; % optional for seeing fluxes