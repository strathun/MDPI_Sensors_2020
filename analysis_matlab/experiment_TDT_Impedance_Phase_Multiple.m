%% experiment_TDT_Impedance_Phase_Multiple
% This experiment is to get a good picture of just how much variation we
% see across multiple TDT in vitro measurements across the years. 
% Data is taken from many sessions and can be found in Extract Impedance
% Data section below. 
% All measurements were made in the same "Old Stock PBS", except for TDT21
% which was made in a 1xPBS solution formulat given in Cogan et al. 20??

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
[gamryStructure_TDT10] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20180622_TDT10_InVitro\Impedance');
[gamryStructure_TDT11] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20180727_TDT11_InVitro\Impedance');
[gamryStructure_TDT12] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20180822_TDT12_InVitro\Impedance');
[gamryStructure_TDT17] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20190506_TDT17_InVitro\Impedance');
[gamryStructure_TDT19] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20190712_TDT19_InVitro\Impedance');
[gamryStructure_TDT21] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200311_TDT21_InVitro_1xPBSNew\Impedance');
[gamryStructure_TDT22] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200323_TDT22_InVitro_OldPBS');
[gamryStructure_TDT23] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200821_TDT23_InVitro_OldPBS');
load('..\rawData\CustomPot\20200323_TDT22_InVitro_OldPBS\2020-03-23_13hr_17min_28sec_TDT22')

%% Plot Mag Impedance for each array
% Visually, this is more of a gut check to see if anything is weird. The
% primary plot will be with the mean of all this data
% Also builds stats for later

numArrays = 8; % hard coded for now. Change if add or subtract arrays above
figure
loglog( [gamryStructure_TDT10.f], [gamryStructure_TDT10.Zmag] )
avgStructure(1).f    = mean([gamryStructure_TDT10.f],2);
avgStructure(1).Zmag = mean([gamryStructure_TDT10.Zmag],2);
figure
loglog( [gamryStructure_TDT11.f], [gamryStructure_TDT11.Zmag] )
avgStructure(2).f    = mean([gamryStructure_TDT11.f],2);
avgStructure(2).Zmag = mean([gamryStructure_TDT11.Zmag],2);
figure
loglog( [gamryStructure_TDT12.f], [gamryStructure_TDT12.Zmag] )
avgStructure(3).f    = mean([gamryStructure_TDT12.f],2);
avgStructure(3).Zmag = mean([gamryStructure_TDT12.Zmag],2);
figure
loglog( [gamryStructure_TDT17.f], [gamryStructure_TDT17.Zmag] )
avgStructure(4).f    = mean([gamryStructure_TDT17.f],2);
avgStructure(4).Zmag = mean([gamryStructure_TDT17.Zmag],2);
figure
loglog( [gamryStructure_TDT19.f], [gamryStructure_TDT19.Zmag] )
avgStructure(5).f    = mean([gamryStructure_TDT19.f],2);
avgStructure(5).Zmag = mean([gamryStructure_TDT19.Zmag],2);
figure
loglog( [gamryStructure_TDT21.f], [gamryStructure_TDT21.Zmag] )
avgStructure(6).f    = mean([gamryStructure_TDT21.f],2);
avgStructure(6).Zmag = mean([gamryStructure_TDT21.Zmag],2);
figure
loglog( [gamryStructure_TDT22.f], [gamryStructure_TDT22.Zmag] )
avgStructure(7).f    = mean([gamryStructure_TDT22.f],2);
avgStructure(7).Zmag = mean([gamryStructure_TDT22.Zmag],2);
figure
loglog( [gamryStructure_TDT23.f], [gamryStructure_TDT23.Zmag] )
avgStructure(8).f    = mean([gamryStructure_TDT23.f],2);
avgStructure(8).Zmag = mean([gamryStructure_TDT23.Zmag],2);
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
xlim([10 10e5]); 
ylim([100 1e6])
xlabel('Frequency (Hz)')
ylabel('Impedance Mag. (Ohms)')
leg = legend('10', '11', '12', '17', '19', '21', '22', '23');
title(leg,'TDT#')

%%
% There is clearly something different about these previous TDTs. Whether
% this is an issue with the arrays themselves, or of something is going on
% with the Gamry, we still aren't quite sure. 