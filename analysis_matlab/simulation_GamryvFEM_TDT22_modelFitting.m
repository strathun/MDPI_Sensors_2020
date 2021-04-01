%% simulation_GamryvFEM_TDT22_modelFitting
% Trying to tune the FEM model parameters to match impedance and current
% measured with the Gamry. 
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
[gamryStructure] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200917_TDT22_InVitro_1xPBS');
[customStructure_floating] = ...
    extractFEMData('..\rawData\FEM\raw-data\20210401_Sweep_floating_40mV_large_16sm');

%% Plot Impedance
figure
% Gamry
semilogx( gamryStructure(12).f, gamryStructure(12).Zmag )
hold on
% FEM
Ref_V_mag_floating = abs(customStructure_floating.Ref_V);
Gnd_I_mag_floating = abs(customStructure_floating.Gnd_I(:,5));
Zmag_floating = Ref_V_mag_floating./Gnd_I_mag_floating;
semilogx(customStructure_floating.f(:,1), Zmag_floating(:,1))
hold on
xlabel('Frequency (Hz)')
ylabel('mag(Impedance) (Ohms)')

%% Plot Current
figure
% Gamry
semilogx( gamryStructure(12).f, gamryStructure(12).Idc )
hold on
% FEM
Ref_V_mag_floating = abs(customStructure_floating.Ref_V);
Gnd_I_mag_floating = abs(customStructure_floating.Gnd_I(:,5));
Zmag_floating = Ref_V_mag_floating./Gnd_I_mag_floating;
semilogx(customStructure_floating.f(:,1), Gnd_I_mag_floating(:,1))
hold on
xlabel('Frequency (Hz)')
ylabel('mag(Impedance) (Ohms)')

%%
% Doesn't seem like this is the current we want from Gamry...
