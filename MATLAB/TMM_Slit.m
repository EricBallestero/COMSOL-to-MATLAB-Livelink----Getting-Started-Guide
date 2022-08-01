function [R_A] = TMM_Slit(Geo,Freq)
% This function computes the reflection coefficient of a medium backed at
% an infinitively rigid wall via the Transfer Matrix Method (TMM).

% This script is part of a guide titled: 
% COMSOL® & MATLAB® livelink – Getting Started Guide.
% To find out more, go to [GitHub link]

% Author: 
% Eric Ballestero, Laboratoire d'Acoustique de l'Université du Mans (LAUM), 
% Le Mans, France.
% Théo Cavalieri,  Swiss Federal Laboratories for Materials Science and
% Technology (EMPA), Zurich, Switzerland. 

% Last updated: July 2022
%-------------------------------------------------------------------------%
%% MATRIX ALLOCATION
%-------------------------------------------------------------------------%
M_s = ones(2,2,length(Freq.Vector));
%-------------------------------------------------------------------------%
%% EFFECTIVE PROPAGATION PARAMETERS: RHO & KAPPA (AIR)
%-------------------------------------------------------------------------%
Rho = 1.213;
Kappa = 1.4*1.013e5;     
%-------------------------------------------------------------------------%
%% TRANSFER MATRIX METHOD
%-------------------------------------------------------------------------%
% effective sound celerity based on Newton-Laplace relation
cs = sqrt(Kappa./Rho);
% effective wavenumbers
ks = Freq.OmegaVector./cs;
% Volume impedances
Z0 = (Rho.*cs);                                
Zs = (Rho.*cs);    
% Solid matrix in 1
M_s(1,1,:) = cos(ks.*Geo.L);
M_s(1,2,:) = 1i.*Zs.*sin(ks.*Geo.L);
M_s(2,1,:) = (1i./Zs).*sin(ks.*Geo.L);
M_s(2,2,:) = cos(ks.*Geo.L);
%-------------------------------------------------------------------------%
%% TRANSFER MATRIX METHOD (reflection problem)
%-------------------------------------------------------------------------%
for y = 1:length(Freq.Vector)
    T(:,:,y) = M_s(:,:,y); 
    R_A(:,y) = (T(1,1,y) - (Z0*T(2,1,y)))/(T(1,1,y) + (Z0*T(2,1,y)));
end
% Absorption coefficient
A_A = 1-abs(R_A).^2;
end