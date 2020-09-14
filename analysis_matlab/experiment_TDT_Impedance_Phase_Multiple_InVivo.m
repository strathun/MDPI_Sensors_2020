%% experiment_TDT_Impedance_Phase_Multiple_InVivo
% This experiment is to get a good picture of just how much variation we
% see across multiple TDT in vivo measurements across the years. 
% Data is taken from many sessions and can be found in Extract Impedance
% Data section below. 

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
[gamryStructure_TDT06] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\2018-05-10_TDT6_Day03\Impedance');
[gamryStructure_TDT17] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\2019-05-13_TDT17_Day04\Impedance');
[gamryStructure_TDT21] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200316_TDT21_Day03\Impedance\Round1');


%% Plot Mag Impedance for each array
% Visually, this is more of a gut check to see if anything is weird. The
% primary plot will be with the mean of all this data
% Also builds stats for later

numArrays = 3; % hard coded for now. Change if add or subtract arrays above
figure
loglog( [gamryStructure_TDT06.f], [gamryStructure_TDT06.Zmag] )
avgStructure(1).f    = mean([gamryStructure_TDT06.f],2);
avgStructure(1).Zmag = mean([gamryStructure_TDT06.Zmag],2);
figure
loglog( [gamryStructure_TDT17.f], [gamryStructure_TDT17.Zmag] )
avgStructure(2).f    = mean([gamryStructure_TDT17.f],2);
avgStructure(2).Zmag = mean([gamryStructure_TDT17.Zmag],2);
figure
loglog( [gamryStructure_TDT21.f], [gamryStructure_TDT21.Zmag] )
avgStructure(3).f    = mean([gamryStructure_TDT21.f],2);
avgStructure(3).Zmag = mean([gamryStructure_TDT21.Zmag],2);
for ii = 1:numArrays
    figure(ii)
    xlim([10 1000e3]); 
    ylim([100 1e6])
    xlabel('Frequency (Hz)')
    ylabel('Mag(Impedance)')
end

%% Plot all average impedances
[~, numArrays] = size(avgStructure);
figure
for ii = 1:numArrays
    loglog( avgStructure(ii).f, avgStructure(ii).Zmag )
    hold on
end
grid on
xlim([10 10e3]); 
ylim([100 1e6])
xlabel('Frequency (Hz)')
ylabel('Impedance Mag. (Ohms)')
leg = legend('06', '17', '21');
title(leg,'TDT#')

%%
% 