%% Main: Tutorial MATLAB Livelink module for COMSOL Multiphysics
% This code runs a short acoustic study of a quarter-wavelength 
% resonator (QWR), i.e. open-closed slit. The opposite end is considered 
% as anechoic and is therefore loaded with a Perfectly Matched Layer (PML).

% By changing the length L of the QWR, the code updates the analytical
% function results as well as automatically building and running the
% equivalent COMSOL model (all from MATLAB).

% This script is part of a guide titled: 
% COMSOL® & MATLAB® Livelink – Getting Started Guide.
% To find out more, go to [GitHub link]

% Author: 
% Eric Ballestero, Laboratoire d'Acoustique de l'Université du Mans (LAUM), 
% Le Mans, France.
% Théo Cavalieri,  Swiss Federal Laboratories for Materials Science and
% Technology (EMPA), Zurich, Switzerland. 

% Last updated: July 2022
%-------------------------------------------------------------------------%
%% SESSION START UP COMMANDS
%-------------------------------------------------------------------------%
set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesFontSize',18)
set(0,'DefaultFigureWindowStyle','docked')
path = convertCharsToStrings(fileparts(matlab.desktop.editor.getActiveFilename));
cd(path)
addpath(genpath('/home/evan/Documents/Academic/UPV/MATLAB'))
clear; clear global; clc; figure(1); warning off; close all;
%-------------------------------------------------------------------------%
%% GEOMETRY
%-------------------------------------------------------------------------%
Geo.L = 0.5;
Geo.L_PML = 0.3;
Geo.H = 0.1;
%-------------------------------------------------------------------------%
%% FREQUENCY (in Hz)
%-------------------------------------------------------------------------%
Freq.fmin = 5;                                  % minimum Freq of interest
Freq.fmax = 1000;                               % maximum Freq of interest
Freq.Df = 5;                                    % Freq discretization
Freq.Vector = (Freq.fmin:Freq.Df:Freq.fmax);    % Freq vector
Freq.OmegaVector = 2.*pi.*Freq.Vector;          % radial Freq vector
%-------------------------------------------------------------------------%
%% COMSOL FILE INFORMATION
%-------------------------------------------------------------------------%
File.Path = pwd;
File.Tag = 'Comsol_TubeSlit';
File.Extension = '.mph';
%-------------------------------------------------------------------------%
%% COMSOL PROBE INFORMATION
%-------------------------------------------------------------------------%
Probe.Expression.ReScatt = 'real(acpr.p_s)';
Probe.Expression.ImScatt = 'imag(acpr.p_s)';
Probe.Coordinates(1,:) = 0;         
Probe.Coordinates(2,:) = 0;        
Probe.Coordinates = [Probe.Coordinates(1,:) ; Probe.Coordinates(2,:)];
%-------------------------------------------------------------------------%
%% TMM UPDATE
%-------------------------------------------------------------------------%
[R_A] = TMM_Slit(Geo,Freq);
%-------------------------------------------------------------------------%
%% FEM MODELLING
%-------------------------------------------------------------------------%
tStart = tic;
Data = Comsol_TubeSlit_Parametric(Geo,Freq,File,Probe);
tEnd = toc(tStart);
R_C = Data.TotScatt; 
fprintf('FEM. time: %d minutes and  %.f seconds\n', floor(tEnd/60), rem(tEnd,60));
%-------------------------------------------------------------------------%
%% PLOTTER
%-------------------------------------------------------------------------%
figure()
plot(Freq.Vector,angle(R_A),'-','color',[0.9 0.4 0.1],'linewidth',3);
hold on
plot(Freq.Vector,angle(R_C),'.','markersize',10,'MarkerEdgeColor',[0.3 0.1 0.6],...
            'MarkerFaceColor',[0.3 0.1 0.6],'LineWidth',3);
ylim([-pi,pi])
yticks([-pi -pi/2 0 pi/2 pi])
yticklabels({'-$\pi$','-$\pi$/2','0','$\pi$/2','$\pi$'})
ylabel('$\phi$R [rad]')
xlabel('Frequency [Hz]')
set(gca,'fontsize',24,'xscale','linear')
legend('TMM','FEM','Location','northwest','Orientation','vertical','fontsize',18)
legend boxoff   


