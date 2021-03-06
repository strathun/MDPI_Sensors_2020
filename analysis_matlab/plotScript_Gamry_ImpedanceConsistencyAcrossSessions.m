%% plotScript_Gamry_ImpedanceConsistencyAcrossSessions
% Want to test how consistent the Gamry is between days/measurements to see
% if it is a possible cause of any array wide changes in impedance

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
[gamryStructure_Day00] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200817_TDT22_inVitro_OldPBS_r2');
[gamryStructure_Day01_r1] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200820_TDT22_InVitro_OldPBS_r1');
[gamryStructure_Day01_r2] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200820_TDT22_InVitro_OldPBS_r2');
[gamryStructure_Day01_r3] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200820_TDT22_InVitro_OldPBS_r3');
[gamryStructure_Day01_r4] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200820_TDT22_InVitro_OldPBS_r4');
[gamryStructure_Day02_r1] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200821_TDT22_InVitro_OldPBS_r1');
[gamryStructure_Day02_r2] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200821_TDT22_InVitro_OldPBS_r2');
[gamryStructure_Day02_temp] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200821_TDT22_InVitro_OldPBS_temp');
[gamryStructure_Day03_r1] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200824_TDT22_InVitro_OldPBS_r1');
[gamryStructure_Day03_r2] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200824_TDT22_InVitro_OldPBS_r2');
[gamryStructure_Day03_r3] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200824_TDT22_InVitro_OldPBS_r3');
%% Plot Impedance (new vs Old)
[~, numTraces] = size( gamryStructure_Day00 );
figure(1)
colorArray = lines( numTraces );
for ii = 1:numTraces
    loglog( gamryStructure_Day00(ii).f, ...
            gamryStructure_Day00(ii).Zmag, ...
            'Color', colorArray( ii, : ))
        hold on
    loglog( gamryStructure_Day01_r1(ii).f, ...
            gamryStructure_Day01_r1(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    loglog( gamryStructure_Day01_r2(ii).f, ...
            gamryStructure_Day01_r2(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    loglog( gamryStructure_Day01_r3(ii).f, ...
            gamryStructure_Day01_r3(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    loglog( gamryStructure_Day01_r4(ii).f, ...
            gamryStructure_Day01_r4(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    loglog( gamryStructure_Day02_r1(ii).f, ...
            gamryStructure_Day02_r1(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    loglog( gamryStructure_Day02_r2(ii).f, ...
            gamryStructure_Day02_r2(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    loglog( gamryStructure_Day02_temp(ii).f, ...
            gamryStructure_Day02_temp(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    loglog( gamryStructure_Day03_r1(ii).f, ...
            gamryStructure_Day03_r1(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    loglog( gamryStructure_Day03_r2(ii).f, ...
            gamryStructure_Day03_r2(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    loglog( gamryStructure_Day03_r3(ii).f, ...
            gamryStructure_Day03_r3(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
end
xlim([10 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
legend('Day 00', 'Day01_r1', 'Day01_r2', 'Day01_r3', 'Day01_r4',...
       'Day02_r1', 'Day02_r2', 'Day02_temp',...
       'Day03_r1', 'Day03_r2', 'Day03_r3')
title('Global Impedance Drop (Both Gamry)')

%% Plot Impedance (new vs Old) (Individual)
[~, numTraces] = size( gamryStructure_Day00 );
colorArray = lines( numTraces );
for ii = 1:numTraces
    figure(100+ii)
    loglog( gamryStructure_Day00(ii).f, ...
            gamryStructure_Day00(ii).Zmag )
        hold on
    loglog( gamryStructure_Day01_r1(ii).f, ...
            gamryStructure_Day01_r1(ii).Zmag )
    loglog( gamryStructure_Day01_r2(ii).f, ...
            gamryStructure_Day01_r2(ii).Zmag )
    loglog( gamryStructure_Day01_r3(ii).f, ...
            gamryStructure_Day01_r3(ii).Zmag )
    loglog( gamryStructure_Day01_r4(ii).f, ...
            gamryStructure_Day01_r4(ii).Zmag )
    loglog( gamryStructure_Day02_r1(ii).f, ...
            gamryStructure_Day02_r1(ii).Zmag )
    loglog( gamryStructure_Day02_r2(ii).f, ...
            gamryStructure_Day02_r2(ii).Zmag )
    loglog( gamryStructure_Day02_temp(ii).f, ...
            gamryStructure_Day02_temp(ii).Zmag )
    loglog( gamryStructure_Day03_r1(ii).f, ...
            gamryStructure_Day03_r1(ii).Zmag )
    loglog( gamryStructure_Day03_r2(ii).f, ...
            gamryStructure_Day03_r2(ii).Zmag )
    loglog( gamryStructure_Day03_r3(ii).f, ...
            gamryStructure_Day03_r3(ii).Zmag )
    grid on
    xlim([10 100000])
    legend('Day00', 'Day01_r1', 'Day01_r2', 'Day01_r3', 'Day01_r4',...
           'Day02_r1', 'Day02_r2', 'Day02_temp',...
           'Day03_r1', 'Day03_r2', 'Day03_r3')
end
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')

%% Plot Impedance (new vs Old)(Averages)
[~, numTraces] = size( gamryStructure_Day00 );
colorArray = lines( numTraces );
for ii = 1:numTraces
    avgArray_1(ii,:) = gamryStructure_Day00(ii).Zmag;
    avgArray_2(ii,:) = gamryStructure_Day01_r1(ii).Zmag;
    avgArray_3(ii,:) = gamryStructure_Day01_r2(ii).Zmag;
    avgArray_4(ii,:) = gamryStructure_Day01_r3(ii).Zmag;
    avgArray_5(ii,:) = gamryStructure_Day01_r4(ii).Zmag;
    avgArray_6(ii,:) = gamryStructure_Day02_r1(ii).Zmag;
    avgArray_7(ii,:) = gamryStructure_Day02_r2(ii).Zmag;
    avgArray_8(ii,:) = gamryStructure_Day02_temp(ii).Zmag;
    avgArray_9(ii,:) = gamryStructure_Day03_r1(ii).Zmag;
    avgArray_10(ii,:) = gamryStructure_Day03_r2(ii).Zmag;
    avgArray_11(ii,:) = gamryStructure_Day03_r3(ii).Zmag;
end
mean_1 = mean( avgArray_1, 1);
std_1 = std( avgArray_1, 1 );
mean_2 = mean( avgArray_2, 1);
std_2 = std( avgArray_2, 1 );
mean_3 = mean( avgArray_3, 1);
std_3 = std( avgArray_3, 1 );
mean_4 = mean( avgArray_4, 1);
std_4 = std( avgArray_4, 1 );
mean_5 = mean( avgArray_5, 1);
std_5 = std( avgArray_5, 1 );
mean_6 = mean( avgArray_6, 1);
std_6 = std( avgArray_6, 1 );
mean_7 = mean( avgArray_7, 1);
std_7 = std( avgArray_7, 1 );
mean_8 = mean( avgArray_8, 1);
std_8 = std( avgArray_8, 1 );
mean_9 = mean( avgArray_9, 1);
std_9 = std( avgArray_9, 1 );
mean_10 = mean( avgArray_10, 1);
std_10 = std( avgArray_10, 1 );
mean_11 = mean( avgArray_11, 1);
std_11 = std( avgArray_11, 1 );

figure
errorbar( gamryStructure_Day00(1).f, ...
        mean_1, std_1 );
hold on
errorbar( gamryStructure_Day01_r1(1).f, ...
        mean_2, std_2);
errorbar( gamryStructure_Day01_r2(1).f, ...
        mean_3, std_3);
errorbar( gamryStructure_Day01_r3(1).f, ...
        mean_4, std_4);
errorbar( gamryStructure_Day01_r4(1).f, ...
        mean_5, std_5);
errorbar( gamryStructure_Day02_r1(1).f, ...
        mean_6, std_6);
errorbar( gamryStructure_Day02_r2(1).f, ...
        mean_7, std_7);
% errorbar( gamryStructure_Day02_temp(1).f, ...
%         mean_8, std_8);
errorbar( gamryStructure_Day03_r1(1).f, ...
        mean_9, std_9);
errorbar( gamryStructure_Day03_r2(1).f, ...
        mean_10, std_10);
errorbar( gamryStructure_Day03_r3(1).f, ...
        mean_11, std_11);
set(gca,'XScale','log','YScale','log')    
grid on
xlim([10 100000])
legend('Day00', 'Day01-r1', 'Day01-r2', 'Day01-r3', 'Day01-r4',...
       'Day02-r1', 'Day02-r2', ...
       'Day03-r1', 'Day03-r2', 'Day03-r3')
% legend('Day00', 'Day01_r1', 'Day01_r2', 'Day01_r3', 'Day01_r4',...
%        'Day02_r1', 'Day02_r2', 'Day02_temp', ...
%        'Day03_r1', 'Day03_r2', 'Day03_r3')
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')

%%
% So, looks like temperature may cause some change, but difficult to say
% whether or not it's just from ~2 hour wait time for the solution to heat
% up.