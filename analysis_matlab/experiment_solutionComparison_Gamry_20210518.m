%% experiment_solutionComparison_Gamry_20210518
% Just a quick test to see how different the old PBS solution and the "new"
% 1xPBS are. All measurements were made 20210518 using the same electrodes
% (TDT22). 

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
[gamryStructure_OldPBS] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20210518_TDT22_InVitro_OldPBS');
[gamryStructure_1xPBS] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20210518_TDT22_InVitro_1xPBS');


%% Plot Impedances to visualize
% Plot all electrodes individually
for ii = 1:16
    figure(ii)
    loglog( gamryStructure_OldPBS(ii).f, ...
        gamryStructure_OldPBS(ii).Zmag , ...
        'LineWidth', 1.5)
    hold on
    loglog( gamryStructure_1xPBS(ii).f, ...
        gamryStructure_1xPBS(ii).Zmag , ...
        'o', 'LineWidth', 1.5)
    grid on
    xlabel('Frequency (Hz)')
    ylabel('Magnitude(Imp)')
    legend('Old PBS', 'New PBS')
end
% title('1x PBS')
% leg = legend('0', '1', '3', '7', '15');
% title(leg,'Parallel Connections');

%% 
% Pretty consistent between solutions. Some dips in high frequency
% impedance seen with the new solution for some electrodes, but does not
% seem to be a global trend. 

%% Analyze global trend
% Calculate mean and std
tempImp_1xPBS = [];
tempImp_OldPBS = [];
for ii = 1:16
    tempImp_1xPBS = [tempImp_1xPBS gamryStructure_1xPBS(ii).Zmag];
    tempImp_OldPBS = [tempImp_OldPBS gamryStructure_OldPBS(ii).Zmag];
end
globalStructure(1).avgImp = mean(tempImp_OldPBS, 2);
globalStructure(2).avgImp = mean(tempImp_1xPBS, 2);
globalStructure(1).stdImp = std(tempImp_OldPBS, 0, 2);
globalStructure(2).stdImp = std(tempImp_1xPBS, 0, 2);

figure
errorbar(gamryStructure_1xPBS(1).f, globalStructure(1).avgImp, ...
         globalStructure(1).stdImp)
     hold on
errorbar(gamryStructure_1xPBS(1).f, globalStructure(2).avgImp, ...
         globalStructure(2).stdImp)
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
title('Average Array Impedances')
xlabel('Frequency (Hz)')
ylabel('mag(Impedance) (Ohm)')
legend('OldPBS', 'NewPBS')
xlim([10 100000])