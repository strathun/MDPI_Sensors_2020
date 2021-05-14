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
    extractFEMData('..\rawData\FEM\raw-data\20210402_Sweep_floating_40mV_large_16sm_80eps');

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
% xlim([100 10e3])
legend('Gamry', 'FEM')

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
ylabel('Current (A)')

%%
% Doesn't seem like this is the current we want from Gamry...

%% See where all of the current is going
figure
Ctr_I_mag = abs(customStructure_floating.Ctr_I);
surface_I = abs(customStructure_floating.WE_I(:,5)); 
semilogx(customStructure_floating.f(:,1), Gnd_I_mag_floating(:,1))
hold on
semilogx(customStructure_floating.f(:,1), Ctr_I_mag(:,1))
semilogx(customStructure_floating.f(:,1), surface_I(:,1))
legend('Gnd - E05', 'Counter', 'surface - E05')
surface_I_total = 0;
gnd_I_total = 0;
customStructure_floating.Gnd_I(isnan(customStructure_floating.Gnd_I)) = 0;
for ii = 1:16
    surface_I_total = surface_I_total + abs(customStructure_floating.WE_I(:,ii));
    gnd_I_total = gnd_I_total + abs(customStructure_floating.Gnd_I(:,ii));
end
semilogx(customStructure_floating.f(:,1), surface_I_total)
semilogx(customStructure_floating.f(:,1), gnd_I_total, 'o')

%%
% weird. Current should be conserved in the system, but it looks like it's
% either being created or lost somewhere...