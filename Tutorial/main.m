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

% Last updated: August 2022
%-------------------------------------------------------------------------%
%% SESSION START UP COMMANDS
%-------------------------------------------------------------------------%
set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesFontSize',18)
set(0,'DefaultFigureWindowStyle','docked');
set(0,'defaultFigureColor',[1 1 1])
path = convertCharsToStrings(fileparts(matlab.desktop.editor.getActiveFilename));
cd(path)
clear; clear global *; clc; warning off; close all;
%-------------------------------------------------------------------------%
%% GEOMETRY
%-------------------------------------------------------------------------%
Geo.L = 0.5;        % length of the duct
Geo.L_QWR = 0.3;    % length of the resonator
Geo.L_PML = 0.3;    % length of the PML
Geo.H = 0.2;        % height of the duct
Geo.H_QWR = 0.05;   % height of the resonator
%-------------------------------------------------------------------------%
%% FREQUENCY
%-------------------------------------------------------------------------%
Freq.fmin = 5;                                  % Minimum Freq of interest
Freq.fmax = 1000;                               % Maximum Freq of interest
Freq.Df = 2;                                    % Freq discretization
Freq.Vector = (Freq.fmin:Freq.Df:Freq.fmax);    % Freq vector
Freq.Nf = numel(Freq.Vector);                   % Number of frequencies
Freq.OmegaVector = 2.*pi.*Freq.Vector;          % Radial Freq vector
%-------------------------------------------------------------------------%
%% COMSOL FILE INFORMATION
%-------------------------------------------------------------------------%
File.Path = [pwd,filesep,'Models'];
File.Tag = 'Comsol_TubeSlit';
File.Extension = '.mph';
%-------------------------------------------------------------------------%
%% COMSOL PROBE INFORMATION
%-------------------------------------------------------------------------%
Probe.Expression.Real = 'real(acpr.p_t)';
Probe.Expression.Imag = 'imag(acpr.p_t)';
Probe.CoordinatesInterface(1,:) = Geo.L;         
Probe.CoordinatesInterface(2,:) = (Geo.H + Geo.H_QWR)/2;
Probe.Resolution = 1000;
Probe.CoordinatesLine(1,:) = linspace(-Geo.L_PML,Geo.L+Geo.L_QWR,Probe.Resolution);
Probe.CoordinatesLine(2,:) = Geo.H/2*ones(1,Probe.Resolution);
%-------------------------------------------------------------------------%
%% FEM MODELLING
%-------------------------------------------------------------------------%
tStart = tic;
Data = Comsol_TubeSlit_Parametric(Geo,Freq,File,Probe);
tEnd = toc(tStart);
fprintf('FEM. time: %d minutes and  %.f seconds\n', floor(tEnd/60), rem(tEnd,60));
%-------------------------------------------------------------------------%
%% PLOT
%-------------------------------------------------------------------------%
figure;
plot(Freq.Vector,abs(Data.TotInterface));
ylabel('Scattered pressure $\vert p_\mathrm{s} \vert$ (Pa)')
xlabel('Frequency (Hz)')
axis square

figure;
pcolor(Probe.CoordinatesLine(1,:),Freq.Vector,abs(Data.TotLine))
hold on
xlabel('Position $x$ (m)')
ylabel('Frequency (Hz)')
title('Absolute pressure $\vert p \vert$ (Pa)')
shading interp
colormap jet
colorbar
axis square

fh = figure('Menu','none','ToolBar','none'); 
ah = axes('Units','Normalize','Position',[0 0 1 1]);
pcolor(Probe.CoordinatesLine(1,:),Freq.Vector,abs(Data.TotLine))
colormap jet
shading interp
%caxis([min(min(err_abs_dir)) max(max(err_abs_dir))]);
grid off
set(gcf,'Color',[1 1 1]);
set(gca,'XTick',[]);
set(gca,'YTick',[]);
set(gca,'ZTick',[]);
set(gca,'GridColor',[1 1 1]);
set(gca,'XColor',[1 1 1]);
set(gca,'YColor',[1 1 1]);
set(gca,'ZColor',[1 1 1]);
axis(ah,'square');
fh.Position(4)=fh.Position(3);
print('data_line.png','-dpng','-r600')