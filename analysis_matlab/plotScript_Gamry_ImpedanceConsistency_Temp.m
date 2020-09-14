%% plotScript_Gamry_ImpedanceConsistency_Temp
% Want to test how consistent the Gamry is across temperature

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
[gamryStructure_Day02_r1] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200821_TDT22_InVitro_OldPBS_r1');
[gamryStructure_Day02_r2] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200821_TDT22_InVitro_OldPBS_r2');
[gamryStructure_Day02_temp] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200821_TDT22_InVitro_OldPBS_temp');
%% Plot Impedance (new vs Old)
[~, numTraces] = size( gamryStructure_Day02_r1 );
figure(1)
colorArray = lines( numTraces );
for ii = 1:numTraces
    hold on
    loglog( gamryStructure_Day02_r1(ii).f, ...
            gamryStructure_Day02_r1(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    loglog( gamryStructure_Day02_r2(ii).f, ...
            gamryStructure_Day02_r2(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    loglog( gamryStructure_Day02_temp(ii).f, ...
            gamryStructure_Day02_temp(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
end
xlim([10 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
legend('Day02_r1', 'Day02_r2', 'Day02_temp')
title('Global Impedance Drop (Both Gamry)')

%% Plot Impedance (new vs Old) (Individual)
[~, numTraces] = size( gamryStructure_Day02_r1 );
colorArray = lines( numTraces );
for ii = 1:numTraces
    figure(100+ii)
    hold on
    loglog( gamryStructure_Day02_r1(ii).f, ...
            gamryStructure_Day02_r1(ii).Zmag )
    loglog( gamryStructure_Day02_r2(ii).f, ...
            gamryStructure_Day02_r2(ii).Zmag )
    loglog( gamryStructure_Day02_temp(ii).f, ...
            gamryStructure_Day02_temp(ii).Zmag )
    grid on
    xlim([10 100000])
    legend('Day02_r1', 'Day02_r2', 'Day02_temp')
end
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')

%% Plot Impedance (new vs Old)(Averages)
[~, numTraces] = size( gamryStructure_Day02_r1 );
colorArray = lines( numTraces );
for ii = 1:numTraces
    avgArray_6(ii,:) = gamryStructure_Day02_r1(ii).Zmag;
    avgArray_7(ii,:) = gamryStructure_Day02_r2(ii).Zmag;
    avgArray_8(ii,:) = gamryStructure_Day02_temp(ii).Zmag;
end
mean_6 = mean( avgArray_6, 1);
std_6 = std( avgArray_6, 1 );
mean_7 = mean( avgArray_7, 1);
std_7 = std( avgArray_7, 1 );
mean_8 = mean( avgArray_8, 1);
std_8 = std( avgArray_8, 1 );

figure
hold on
errorbar( gamryStructure_Day02_r1(1).f, ...
        mean_6, std_6);
errorbar( gamryStructure_Day02_r2(1).f, ...
        mean_7, std_7);
errorbar( gamryStructure_Day02_temp(1).f, ...
        mean_8, std_8);
set(gca,'XScale','log','YScale','log')    
grid on
xlim([10 100000])
legend('Day02_r1', 'Day02_r2', 'Day02_temp')
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')

%%
% So, looks like temperature may cause some change, but difficult to say
% whether or not it's just from ~2 hour wait time for the solution to heat
% up.