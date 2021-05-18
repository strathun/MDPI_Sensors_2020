%% plotScript_OldPBSvsNew
% Just want to see the differences between impedance for the old vs new 1x
% PBS. Worth noting that these are not from the same day, but are the same
% electrodes. 

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
[gamryStructure_OldPBS1] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200824_TDT22_InVitro_OldPBS_r1');
[gamryStructure_OldPBS2] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200824_TDT22_InVitro_OldPBS_r2');
[gamryStructure_NewPBS] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200917_TDT22_InVitro_1xPBS');

%% Plot Impedance
figure(1)
colorArray = lines( 16 );
for ii = 1:16
    loglog( gamryStructure_OldPBS1(ii).f, ...
            gamryStructure_OldPBS1(ii).Zmag, ...
            'Color', colorArray( ii, : ))
        hold on
    loglog( gamryStructure_OldPBS2(ii).f, ...
            gamryStructure_OldPBS2(ii).Zmag, ...
            'o', 'Color', colorArray( ii, : ))
    semilog( gamryStructure_NewPBS(ii).f, ...
            gamryStructure_NewPBS(ii).Zmag, ...
            '*', 'Color', colorArray( ii, : ))
end
xlim([10 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
legend('OldPBS - R1', 'OldPBS - R2', 'NewPbs')
title('Single Electrode Comparison')
