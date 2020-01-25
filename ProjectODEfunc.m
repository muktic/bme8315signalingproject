function [dydt, algvars] = ProjectODEfunc(t,y,params)
% 1/25/20 GH: initial 

% Assign names for parameter values and state variables
[k1f,k1r,k2f,k2r,k3f,k3r,k4f,k5f,k5r,k6f,k6r,k7f,k7r,k8f,k8r,k9f] = params{:};


HS = y(1);
FGF2 =y(2);
FGF2HS = y(3);
FGFRact = y(4);
FRS2 = y(5);
RAS = y(6);
RAF = y(7);
MEK = y(8);
ERK = y(9);
pERKNu = y(10);

% Rates
react1f = k1f*FGF2*HS;
react1r = k1r*FGF2HS;
react2f = k2f*FGF2*HS;
react2r = k2r*FGFRact;
react3f = k3f*FGF2HS;
react3r = k3r*FGFRact;
react4f = k4f*FGFRact*FRS2;
react5f = k5f*RAS;
react5r = k5r*RAF;
react6f = k6f*RAF;
react6r = k6r*MEK;
react7f = k7f*MEK;
react7r = k7r*ERK;
react8f = k8f*ERK;
react8r = k8r*pERKNu;
react9f = k9f*ERK;

% Differential Equations
dHS = react1r + react2r - react1f - react2r;
dFGF2 = react1r + react2r - react1f - react2r;
dFGF2HS = react1f + react3r - react1r - react3f;
dFGFRact = react2f + react3f - react2r -react2f;
dFRS2 = -react9f;
dRAS = react4f + react5r - react5f;
dRAF = react5f + react6r - react5r - react6f;
dMEK = react6f + react7r - react6r - react7f; 
dERK = react7f + react8r - react7r - react8f;
dpERKNu = react8f - react8r - react9f;
dydt = [dHS;dFGF2;dFGF2HS;dFGFRact;dFRS2;dRAS;dRAF;dMEK;dERK;dpERKNu]; % reassemble differential equations
algvars = [react1f,react1r,react2f,react2r,react3f,react3r,react4f,react5f,react5r,react6f,react6r,react7f,react7r,react8f,react8r,react9f]; % optional for seeing fluxes