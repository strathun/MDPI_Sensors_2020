%% plotScript_Gamry_Impedance_TDT22_modelFitting
% This script is to determine an electrode that approximately matches the
% average impedance of the electrodes in this array. 
% NOTE: May not be necessary. Just use E05 from a Gamry measurement for
% now since this is the electrode we're trying to match. Instead lets just
% make sure that the impedance measurements from the two systems are about
% the same. E12 (Gamry) = E05 (custom)

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
[customStructure_1PBS_inVitro] = ...
    extractCustomPstatData('..\rawData\CustomPot\20201201_TDT22_InVitro_1xPBS');

%% Plot Comparison
figure
semilogx( gamryStructure(12).f, gamryStructure(12).Zmag )
hold on
semilogx( gamryStructure(2).f, gamryStructure(2).Zmag )

%%
% Nice. Looks pretty close. Will go ahead and use this Gamry measurement to
% extrace the CPE parameters for the FEM model. 
