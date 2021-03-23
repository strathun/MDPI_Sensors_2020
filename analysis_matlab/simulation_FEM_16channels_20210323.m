%% simulation_FEM_16channels_20210323
% Trying to compare the FEM predicted changes in impedance to those that were
% actually observed in vitro. 

close all 
clearvars 

% Sets relative filepaths from this script
currentFile = mfilename( 'fullpath' );
cd(fileparts(currentFile));
addpath(genpath('../matlab'));
addpath(genpath('../rawData'));
addpath(genpath('../output'));
parts = strsplit(currentFile, {'\', '\'});
outputDir = ['../output/' parts{end}];
[~, ~] = mkdir(outputDir);

%% Extract impedance data
[customStructure_floating] = ...
    extractFEMData('..\rawData\FEM\raw-data\20210323_Sweep_floating');
[customStructure_gnded] = ...
    extractFEMData('..\rawData\FEM\raw-data\20210323_Sweep_gnded');
[customStructure_1PBS_inVitro] = ...
    extractCustomPstatData('..\rawData\CustomPot\20201201_TDT22_InVitro_1xPBS');
Zest_VCModel = load('..\rawData\Volume-Conductor\20210323_irMonopole_VC_calculation_1xPBS.mat');

%% Floating
numPoints = length(customStructure_floating.f);
Ref_V_mag = abs(customStructure_floating.Ref_V);
Gnd_I_mag = abs(customStructure_floating.Gnd_I);
Zmag_floating = Ref_V_mag./Gnd_I_mag;
figure(1)
semilogx(customStructure_floating.f(:,1), Zmag_floating(:,1))
hold on
xlabel('Frequency (Hz)')
ylabel('mag(Impedance) (Ohms)')

%% Gnded
numPoints = length(customStructure_gnded.f);
Ref_V_mag = abs(customStructure_gnded.Ref_V);
Gnd_I_mag = abs(customStructure_gnded.Gnd_I);
Zmag_gnd = Ref_V_mag./Gnd_I_mag;
figure(1)
semilogx(customStructure_gnded.f(:,1), Zmag_gnd(:,1))
xlabel('Frequency (Hz)')
ylabel('mag(Impedance) (Ohms)')
legend('Floating', 'Grounded')

%%
% Interesting.... Look like the lower frequencies have a big effect on
% impedance that drops off at higher frequencies. 

%% Plot measured vs predicted impedance for all simulations/measurements
figure
colorArray = lines( 2 );
% Plot initial values
% FEM
semilogx(customStructure_floating.f(:,1), ...
         Zmag_floating(:,1), '*', ...
         'Color', colorArray( 1, : ), 'LineWidth', 1.5)
hold on
% VC
semilogx(customStructure_1PBS_inVitro(2).f(:,5), ...
     customStructure_1PBS_inVitro(2).Zmag(:,5), 'o', ...
     'Color', colorArray( 1, : ), 'LineWidth', 1.5)
hold on
% Actual; Note VC is same as actual since VC only estimated changes in imp
semilogx(customStructure_1PBS_inVitro(2).f(:,5), ...
         customStructure_1PBS_inVitro(2).Zmag(:,5), ...
         'Color', colorArray( 1, : ), 'LineWidth', 1.5)
     
% Plot 16e values
% FEM
semilogx(customStructure_gnded.f(:,1), ...
         Zmag_gnd(:,1), '*', ...
         'Color', colorArray( 2, : ), 'LineWidth', 1.5)
hold on
% VC
semilogx(customStructure_1PBS_inVitro(2).f(:,5), ...
     Zest_VCModel(1).Zest_array(:,4), 'o', ...
     'Color', colorArray( 2, : ), 'LineWidth', 1.5)
hold on
% Actual
semilogx(customStructure_1PBS_inVitro(6).f(:,5), ...
         customStructure_1PBS_inVitro(6).Zmag(:,5), ...
         'Color', colorArray( 2, : ), 'LineWidth', 1.5)

xlim([70 10300])
grid on
xlabel('Frequency Markers')
ylabel('Impedance Magnitude')
title('1xPBS')
legend('FEM', 'VC', 'Measured')

%% %Change by freq/model

% Calculate % Change
p_Change_FEM = (( Zmag_gnd - Zmag_floating )./ Zmag_floating )*100;
p_Change_VC =  (( Zest_VCModel(1).Zest_array(:,4) - ...
                  customStructure_1PBS_inVitro(2).Zmag(:,5) )./ customStructure_1PBS_inVitro(2).Zmag(:,5) ) * 100;
p_Change_measured = (( customStructure_1PBS_inVitro(6).Zmag(:,5) - ...
                       customStructure_1PBS_inVitro(2).Zmag(:,5) )./ customStructure_1PBS_inVitro(2).Zmag(:,5)) * 100;

figure
% FEM
semilogx(customStructure_gnded.f(:,1), ...
         p_Change_FEM, '*', ...
         'LineWidth', 1.5)
hold on
% VC
semilogx(customStructure_1PBS_inVitro(2).f(:,5), ...
         p_Change_VC, 'o', ...
         'LineWidth', 1.5)
% Actual
semilogx(customStructure_1PBS_inVitro(6).f(:,5), ...
         p_Change_measured, ...
         'LineWidth', 1.5)
xlabel('Frequency (Hz)')
ylabel('% Impedance change')
legend('FEM', 'VC', 'Measured')

%%
% FEM model matches the shape of the % change for the measured, but it is
% shifted down by about 200%... ish...