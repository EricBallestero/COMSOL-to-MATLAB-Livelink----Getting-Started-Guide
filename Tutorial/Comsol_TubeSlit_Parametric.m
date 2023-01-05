function [Data] = Comsol_TubeSlit_Parametric(Geo,Freq,File,Probe)
% This script is part of a guide titled: 
% COMSOL® & MATLAB® livelink – Getting Started Guide.
% To find out more, go to [GitHub link]

% Authors: 
% Eric Ballestero, Laboratoire d'Acoustique de l'Université du Mans (LAUM), 
% Le Mans, France.
% Théo Cavalieri,  Swiss Federal Laboratories for Materials Science and
% Technology (EMPA), Zurich, Switzerland. 

% Last updated: August 2022
%-------------------------------------------------------------------------%
%% CALL COMSOL
disp(' -- Call COMSOL')
%-------------------------------------------------------------------------%
import com.comsol.model.*
import com.comsol.model.util.*
model = ModelUtil.create('Model');
model.modelPath('./Guide_LiveLink');
model.label('TubeSlit_Concept.mph');
model.component.create('comp1', true);
%-------------------------------------------------------------------------%
%% PARAMETERS
disp(' -- Sending parameters')
%-------------------------------------------------------------------------%
model.param.set('H', num2str(Geo.H));
model.param.set('L', num2str(Geo.L));
model.param.set('L_PML', num2str(Geo.L_PML));
model.param.set('L_QWR', num2str(Geo.L_QWR));
model.param.set('H_QWR', num2str(Geo.H_QWR));

model.param.set('Rho0', '1.213');
model.param.set('c0', '341.930');
%-------------------------------------------------------------------------%
%% VARIABLES
% disp(' -- Sending variables')
%-------------------------------------------------------------------------%
% Variables can be created here for calculating analytical expressions directly in COMSOL
% Example (Losses)
% creates a 'var1' object
% model.component('comp1').variable.create('var1'); 

% add a variable 'w' (omega) to be set as the radial frequency
% NOTE: freq is already defined in COMSOL in the Frequency Domain study as
% the frequency being studied.
% model.component('comp1').variable('var1').set('w','2*pi*freq');'sqrt((-i*w*Rho0*Pr0)/Eta0)');  

% compute two other variables in function of 'w'
% model.component('comp1').variable('var1').set('Gp','sqrt((-i*w*Rho0)/Eta0)');
% model.component('comp1').variable('var1').set('Gk','sqrt((-i*w*Rho0*Pr0)/Eta0)');
%-------------------------------------------------------------------------%
%% GEOMETRY
disp(' -- Build geometry')
%-------------------------------------------------------------------------%
% creates a 'geom1' object in a 2D space
model.component('comp1').geom.create('geom1', 2);
% creates a rectangle 'r1' in the 'geom1' object with label, position, base and size
model.component('comp1').geom('geom1').create('r1', 'Rectangle');
model.component('comp1').geom('geom1').feature('r1').label('PML');
model.component('comp1').geom('geom1').feature('r1').set('pos', {'-L_PML' '0'});
model.component('comp1').geom('geom1').feature('r1').set('base', 'corner');
model.component('comp1').geom('geom1').feature('r1').set('size', {'L_PML' 'H'});
% creates a rectangle 'r2' in the 'geom1' object with label, position, base and size
model.component('comp1').geom('geom1').create('r2', 'Rectangle');
model.component('comp1').geom('geom1').feature('r2').label('Duct');
model.component('comp1').geom('geom1').feature('r2').set('pos', {'0' '0'});
model.component('comp1').geom('geom1').feature('r2').set('base', 'corner');
model.component('comp1').geom('geom1').feature('r2').set('size', {'L' 'H'});
% creates a rectangle 'r3' in the 'geom1' object with label, position, base and size
model.component('comp1').geom('geom1').create('r3', 'Rectangle');
model.component('comp1').geom('geom1').feature('r3').label('SWR');
model.component('comp1').geom('geom1').feature('r3').set('pos', {'L' num2str((Geo.H-Geo.H_QWR)/2)});
model.component('comp1').geom('geom1').feature('r3').set('base', 'corner');
model.component('comp1').geom('geom1').feature('r3').set('size', {'L_QWR' 'H_QWR'});
% executes the geometry
model.component('comp1').geom('geom1').run;
%%% EXTRA CODE: visualise the geometry before going further with
% approval input with the [Enter] key.
fig = figure();
clf(fig)
set(fig,'Renderer','opengl');
mphgeom(model,'geom1','facealpha',0.5);
box on;
kk = input('Is the geometry valid?');clear kk;
%-------------------------------------------------------------------------%
%% PML
disp(' -- Set PML')
%-------------------------------------------------------------------------%
% creates a Perfectly Matched Layer (PML) named 'PML'
model.component('comp1').coordSystem.create('pml1', 'PML');
% assign the PML to the domain '1'
model.component('comp1').coordSystem('pml1').selection.set([1]);
%-------------------------------------------------------------------------%
%% MATERIAL
disp(' -- Define materials')
%-------------------------------------------------------------------------%
% creates a 'mat1' material, here air
% NOTE: the material from the library comes with all sorts of parameters
% but only density and sound speed will be useful here.
% Custom values can be entered when creating a blank material.
model.component('comp1').material.create('mat1', 'Common');
model.component('comp1').material('mat1').label('Air');
model.component('comp1').material('mat1').set('family', 'air');
% creates analytical functions for important parameters
model.component('comp1').material('mat1').propertyGroup('def').func.create('eta', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func.create('Cp', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func.create('rho', 'Analytic');
model.component('comp1').material('mat1').propertyGroup('def').func.create('k', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func.create('cs', 'Analytic');
% defines material parameters
model.component('comp1').material('mat1').propertyGroup('def').func('eta').set('arg', 'T');
model.component('comp1').material('mat1').propertyGroup('def').func('eta').set('pieces', {'200.0' '1600.0' '-8.38278E-7+8.35717342E-8*T^1-7.69429583E-11*T^2+4.6437266E-14*T^3-1.06585607E-17*T^4'});
model.component('comp1').material('mat1').propertyGroup('def').func('Cp').set('arg', 'T');
model.component('comp1').material('mat1').propertyGroup('def').func('Cp').set('pieces', {'200.0' '1600.0' '1047.63657-0.372589265*T^1+9.45304214E-4*T^2-6.02409443E-7*T^3+1.2858961E-10*T^4'});
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('expr', 'pA*0.02897/R_const[K*mol/J]/T');
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('args', {'pA' 'T'});
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('dermethod', 'manual');
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('argders', {'pA' 'd(pA*0.02897/R_const/T,pA)'; 'T' 'd(pA*0.02897/R_const/T,T)'});
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('plotargs', {'pA' '0' '1'; 'T' '0' '1'});
model.component('comp1').material('mat1').propertyGroup('def').func('k').set('arg', 'T');
model.component('comp1').material('mat1').propertyGroup('def').func('k').set('pieces', {'200.0' '1600.0' '-0.00227583562+1.15480022E-4*T^1-7.90252856E-8*T^2+4.11702505E-11*T^3-7.43864331E-15*T^4'});
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('expr', 'sqrt(1.4*287*T)');
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('args', {'T'});
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('dermethod', 'manual');
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('argders', {'T' 'd(sqrt(1.4*287*T),T)'});
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('plotargs', {'T' '0' '1'});
model.component('comp1').material('mat1').propertyGroup('def').set('dynamicviscosity', 'eta(T[1/K])[Pa*s]');
model.component('comp1').material('mat1').propertyGroup('def').set('ratioofspecificheat', '1.4');
model.component('comp1').material('mat1').propertyGroup('def').set('electricconductivity', {'0[S/m]' '0' '0' '0' '0[S/m]' '0' '0' '0' '0[S/m]'});
model.component('comp1').material('mat1').propertyGroup('def').set('heatcapacity', 'Cp(T[1/K])[J/(kg*K)]');
model.component('comp1').material('mat1').propertyGroup('def').set('density', 'rho(pA[1/Pa],T[1/K])[kg/m^3]');
model.component('comp1').material('mat1').propertyGroup('def').set('thermalconductivity', {'k(T[1/K])[W/(m*K)]' '0' '0' '0' 'k(T[1/K])[W/(m*K)]' '0' '0' '0' 'k(T[1/K])[W/(m*K)]'});
model.component('comp1').material('mat1').propertyGroup('def').set('soundspeed', 'cs(T[1/K])[m/s]');
model.component('comp1').material('mat1').propertyGroup('def').addInput('temperature');
model.component('comp1').material('mat1').propertyGroup('def').addInput('pressure');
%-------------------------------------------------------------------------%
%% PHYSICS
disp(' -- Implementing physics')
%-------------------------------------------------------------------------%
% creates a physics study 'acpr' (ACoustic PRessure)
model.component('comp1').physics.create('acpr', 'PressureAcoustics', 'geom1');
% add any non-default physics setting, e.g., 2D background pressure field on domain '2'
model.component('comp1').physics('acpr').create('bpf1', 'BackgroundPressureField', 2);
model.component('comp1').physics('acpr').feature('bpf1').selection.set([2]);
% sets the pressure amplitude of the background pressure field to 1 Pa
model.component('comp1').physics('acpr').feature('bpf1').set('pamp', 1);
% sets the sound speed as per the one of the material
model.component('comp1').physics('acpr').feature('bpf1').set('c_mat', 'from_mat');
% sets the direction of the background pressure field in the [x,y] plane
% model.component('comp1').physics('acpr').feature('bpf1').set('dir', [1; 0]);
%-------------------------------------------------------------------------%
%% MESH
disp(' -- Build mesh')
%-------------------------------------------------------------------------%
% creates a mesh object 'mesh1'
model.component('comp1').mesh.create('mesh1');
% sets the mesh size distribution as automatic (COMSOL controlled)
model.component('comp1').mesh('mesh1').automatic(true);
% selects the second item on COMSOL mesh size menu: 'Extra Fine'
model.component('comp1').mesh('mesh1').autoMeshSize(2);
% runs the mesh
model.component('comp1').mesh('mesh1').run;
%%% EXTRA CODE: gives the number of kiloelements + mean quality of the mesh
meshstats = mphmeshstats(model);
disp(['    > # of kElements: ',num2str(sum(meshstats.numelem)/1e3)]);
disp(['    > Mean quality is: ',num2str(meshstats.meanquality*100),'%']);
%-------------------------------------------------------------------------%
%% STUDY
disp(' -- Solving')
%-------------------------------------------------------------------------%
% creates a study 'std1' with a frequency variable 'freq', set as 300 Hz
model.study.create('std1');
model.study('std1').create('freq', 'Frequency');
model.study('std1').feature('freq').set('plist',Freq.Vector);
%-------------------------------------------------------------------------%
% creates a 'sol1' solution object in which to store study results (default)
model.sol.create('sol1');
model.sol('sol1').study('std1');
model.sol('sol1').attach('std1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').create('p1', 'Parametric');
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').feature('v1').set('clistctrl', {'p1'});
model.sol('sol1').feature('v1').set('cname', {'freq'});
model.sol('sol1').feature('v1').set('clist', {num2str(Freq.Vector)});
model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol1').feature('s1').feature('p1').set('plistarr', {num2str(Freq.Vector)});
model.sol('sol1').feature('s1').feature('p1').set('punit', {'Hz'});
model.sol('sol1').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol1').feature('s1').feature('p1').set('preusesol', 'auto');
%%% EXTRA CODE: opens a window to show the solver's progress
ModelUtil.showProgress(true);
% runs the solver
model.sol('sol1').runAll;
%-------------------------------------------------------------------------%
%% PLOT
disp(' -- Generate plots')
%-------------------------------------------------------------------------%
% generate COMSOL plots ('pg1','pg2') and display them in a MATLAB figure environment
model.result.create('pg1', 'PlotGroup2D');
model.result.create('pg2', 'PlotGroup2D');
% plot group 1 'pg1'
model.result('pg1').create('surf1', 'Surface');
model.result('pg1').label('Acoustic Pressure (acpr)');
model.result('pg1').feature('surf1').set('resolution', 'normal');
model.result('pg1').label('Acoustic Pressure (acpr)');
model.result('pg1').feature('surf1').set('colortable', 'WaveLight');
model.result('pg1').feature('surf1').set('resolution', 'normal');
% plot group 2 'pg2'
model.result('pg2').create('surf1', 'Surface');
model.result('pg2').label('Sound Pressure Level (acpr)');
model.result('pg2').feature('surf1').set('expr', 'acpr.Lp');
model.result('pg2').feature('surf1').set('unit', 'dB');
model.result('pg2').feature('surf1').set('descr', 'Sound pressure level');
model.result('pg2').feature('surf1').set('resolution', 'normal');
% creates table to store probe data
model.result.table.create('tbl1', 'Table');
model.result.table('tbl1').label('Probe Table 1');
% creates MATLAB figures and plot data with 'mphplot' COMSOL function
figure;mphplot(model,'pg1'); xlabel('x-axis'); ylabel('y-axis');
figure;mphplot(model,'pg2'); xlabel('x-axis'); ylabel('y-axis');
%-------------------------------------------------------------------------%
%% GET DATA/PROBING
disp(' -- Probing')
%-------------------------------------------------------------------------%
Data.RealInterface = mphinterp(model,Probe.Expression.Real,'coord',Probe.CoordinatesInterface);
Data.ImagInterface = mphinterp(model,Probe.Expression.Imag,'coord',Probe.CoordinatesInterface);
Data.TotInterface = Data.RealInterface + 1i*Data.ImagInterface;

Data.RealLine = mphinterp(model,Probe.Expression.Real,'coord',Probe.CoordinatesLine);
Data.ImagLine = mphinterp(model,Probe.Expression.Imag,'coord',Probe.CoordinatesLine);
Data.TotLine = Data.RealLine + 1i*Data.ImagLine;
%-------------------------------------------------------------------------%
%% SAVE
disp(' -- Save model')
%-------------------------------------------------------------------------%
mphsave(model,[File.Path,filesep,File.Tag,File.Extension]);
disp(' -- DONE')
%-------------------------------------------------------------------------%
end
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%