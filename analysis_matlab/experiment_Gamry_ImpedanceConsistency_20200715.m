%% experiment_Gamry_ImpedanceConsistency_20200715
% This experiment was to quantify changes in impedance from one
% experimental day to another. 
% All measurements are in vitro in OldPBS taken 20200715 or 20200629

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
[gamryStructure_Day2] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200715_TDT22_InVitro_OldPBS');
[gamryStructure_Day1] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200629_TDT22_InVitro_OldPBS');
%% Plot Impedance Comparison
figure
pointerArray1 = 1; % selects the impedance measurements were interested in
pointerArray2 = 8; % selects the impedance measurements were interested in
for ii = 1:1
    jj = pointerArray1( ii );
    loglog( gamryStructure_Day1(jj).f, ...
            gamryStructure_Day1(jj).Zmag )
    hold on
    kk = pointerArray2( ii );
    loglog( gamryStructure_Day2(kk).f, ...
            gamryStructure_Day2(kk).Zmag )
end
xlabel( 'Frequency (Hz)' )
ylabel( 'mag(Z) (Ohm)' ) 
title( 'Impedance Comparisons' )
legend( 'Day1', 'Day2' )