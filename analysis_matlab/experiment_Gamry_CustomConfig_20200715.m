%% experiment_Gamry_CustomConfig_20200715
% This experiment was to try to understand some of the errors seen with the
% custom pstat when more than one electrode is connected (soldered). With
% the custom pstat, this causes an increase in impedance and appears to do
% so here as well. 
% All measurements are in vitro in OldPBS taken 20200715

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
    extractImpedanceDataGlobal('..\rawData\Gamry\20200715_TDT22_InVitro_OldPBS');

%% Plot Impedance Comparison
figure
pointerArray = [8 5 4 3]; % selects the impedance measurements were interested in
for ii = 1:4
    jj = pointerArray( ii );
    loglog( gamryStructure(jj).f, ...
            gamryStructure(jj).Zmag )
    hold on
end
xlabel( 'Frequency (Hz)' )
ylabel( 'mag(Z) (Ohm)' ) 
title( 'Impedance Comparisons' )
legend( 'standard', '1 parallel', '2 parallel', '3 parallel' )

%%
% 