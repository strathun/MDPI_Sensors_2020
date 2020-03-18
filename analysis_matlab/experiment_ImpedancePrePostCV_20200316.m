%% experiment_ImpedancePrePostCV_20200316
% This is a comparison of EIS before and after CV. Originally for Gamry.
% Custom pot will be added
% All data from experiment on 20200316
% Round 1 data is the inital run through on the Gamry (all vs EREF).
% Round 2 is the pre and post CV measurements
% NOTE: All Tye's data is vs EOC. Gamry can be either and should say so in
% filename

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
[gamryStructure_Round2] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200316_TDT21_Day03\Impedance\Round2');


%% Plot Mag Impedance of Round 2 Gamry ERef before and after CV
figure(1)
pointerArray = [08 10 12]; % Selects pre EREF Gamry
numSols = length(pointerArray);
colorArray = lines(numSols);
for ii = 1:numSols
    jj = pointerArray(ii);
    loglog( gamryStructure_Round2(jj).f, ...
            gamryStructure_Round2(jj).Zmag, ...
            'Color', colorArray(ii,:))
    hold on
end
figure(1)
pointerArray = [07 09 11]; % Selects post EREF Gamry
numSols = length(pointerArray);
for ii = 1:numSols
    jj = pointerArray(ii);
    loglog( gamryStructure_Round2(jj).f, ...
            gamryStructure_Round2(jj).Zmag, 'o', ...
            'Color', colorArray(ii,:))
    hold on
end
xlabel( 'Frequency (Hz)' )
ylabel( 'mag(Z) (Ohm)' ) 
title('- is pre; o is post')

%% 
% Looks to be serious effects from CV...
