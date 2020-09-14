%% experiment_Gamry_ImpedanceConsistency_envManipulations_pt2
% Changing cap related stuff
% C1 - End of 24hour run from 20200826
% C2 - Control
% C3 - 

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
[gamryStructure_C1] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200825_TDT22_Invitro_OldPBS_r24_finalRun');
[gamryStructure_C2] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200827_TDT22_InVitro_OldPBS_r1');
[gamryStructure_C3] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200827_TDT22_InVitro_OldPBS_r2');
[gamryStructure_C4] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200827_TDT22_InVitro_OldPBS_r3');
[gamryStructure_C5] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200827_TDT22_InVitro_OldPBS_r4');
[gamryStructure_C6] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200827_TDT22_InVitro_OldPBS_r5');
[gamryStructure_C7] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200827_TDT22_InVitro_OldPBS_r6');
[gamryStructure_C8] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200827_TDT22_InVitro_OldPBS_r7');
[gamryStructure_C9] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200827_TDT22_InVitro_OldPBS_r8');
[gamryStructure_C10] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200827_TDT22_InVitro_OldPBS_r9');
%% Plot Impedance (new vs Old)
[~, numTraces] = size( gamryStructure_C1 );
figure(1)
colorArray = lines( numTraces );
for ii = 1:numTraces
    loglog( gamryStructure_C1(ii).f, ...
            gamryStructure_C1(ii).Zmag, ...
            'Color', colorArray( ii, : ))
        hold on
    loglog( gamryStructure_C2(ii).f, ...
            gamryStructure_C2(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    loglog( gamryStructure_C3(ii).f, ...
            gamryStructure_C3(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    loglog( gamryStructure_C4(ii).f, ...
            gamryStructure_C4(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    loglog( gamryStructure_C5(ii).f, ...
            gamryStructure_C5(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    loglog( gamryStructure_C6(ii).f, ...
            gamryStructure_C6(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    loglog( gamryStructure_C7(ii).f, ...
            gamryStructure_C7(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    loglog( gamryStructure_C8(ii).f, ...
            gamryStructure_C8(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    loglog( gamryStructure_C9(ii).f, ...
            gamryStructure_C9(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    loglog( gamryStructure_C10(ii).f, ...
            gamryStructure_C10(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
end
xlim([10 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
legend('Config1', 'Config2', 'Config3', 'Config4', 'Config5', 'Config6', 'Config7', 'Config8', 'Config9', 'Config10')
title('Global Impedance Drop (Both Gamry)')

%% Plot Impedance (new vs Old) (Individual)
[~, numTraces] = size( gamryStructure_C1 );
colorArray = lines( numTraces );
for ii = 1:numTraces
    figure(100 + ii)
    loglog( gamryStructure_C1(ii).f, ...
            gamryStructure_C1(ii).Zmag )
        hold on
    loglog( gamryStructure_C2(ii).f, ...
            gamryStructure_C2(ii).Zmag  )
    loglog( gamryStructure_C3(ii).f, ...
            gamryStructure_C3(ii).Zmag  )
    loglog( gamryStructure_C4(ii).f, ...
            gamryStructure_C4(ii).Zmag  )
    loglog( gamryStructure_C5(ii).f, ...
            gamryStructure_C5(ii).Zmag  )
    loglog( gamryStructure_C6(ii).f, ...
            gamryStructure_C6(ii).Zmag  )
    loglog( gamryStructure_C7(ii).f, ...
            gamryStructure_C7(ii).Zmag  )
    loglog( gamryStructure_C8(ii).f, ...
            gamryStructure_C8(ii).Zmag  )
    loglog( gamryStructure_C9(ii).f, ...
            gamryStructure_C9(ii).Zmag  )
    loglog( gamryStructure_C10(ii).f, ...
            gamryStructure_C10(ii).Zmag  )
    grid on
    xlim([10 100000])
    legend('Config1', 'Config2', 'Config3', 'Config4', 'Config5', 'Config6', 'Config7', 'Config8', 'Config9', 'Config10')
end
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')

%% Plot Impedance (Averages); All manipulations
[~, numTraces] = size( gamryStructure_C1 );
colorArray = lines( numTraces );
gamryStructure_C7_mod = gamryStructure_C7(1:4); % Ch05 is damaged on old vial cap
gamryStructure_C7_mod = [gamryStructure_C7_mod gamryStructure_C7(6:end)];
gamryStructure_C8_mod = gamryStructure_C8(1:4); % Ch05 is damaged on old vial cap
gamryStructure_C8_mod = [gamryStructure_C8_mod gamryStructure_C8(6:end)];
for ii = 1:numTraces
    avgArray_1(ii,:) = gamryStructure_C1(ii).Zmag;
    avgArray_2(ii,:) = gamryStructure_C2(ii).Zmag;
    avgArray_3(ii,:) = gamryStructure_C3(ii).Zmag;
    avgArray_4(ii,:) = gamryStructure_C4(ii).Zmag;
    avgArray_5(ii,:) = gamryStructure_C5(ii).Zmag;
    avgArray_6(ii,:) = gamryStructure_C6(ii).Zmag;
    if ii < 16
        avgArray_7(ii,:) = gamryStructure_C7_mod(ii).Zmag;
        avgArray_8(ii,:) = gamryStructure_C8_mod(ii).Zmag;
    end
    avgArray_9(ii,:) = gamryStructure_C9(ii).Zmag;
    avgArray_10(ii,:) = gamryStructure_C10(ii).Zmag;
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

figure
errorbar( gamryStructure_C1(1).f, ...
        mean_1, std_1 );
hold on
errorbar( gamryStructure_C2(1).f, ...
        mean_2, std_2);
errorbar( gamryStructure_C3(1).f, ...
        mean_3, std_3);
errorbar( gamryStructure_C4(1).f, ...
        mean_4, std_4);
errorbar( gamryStructure_C5(1).f, ...
        mean_5, std_5);
errorbar( gamryStructure_C6(1).f, ...
        mean_6, std_6);
errorbar( gamryStructure_C7(1).f, ...
        mean_7, std_7);
errorbar( gamryStructure_C8(1).f, ...
        mean_8, std_8);
errorbar( gamryStructure_C9(1).f, ...
        mean_9, std_9);
errorbar( gamryStructure_C10(1).f, ...
        mean_10, std_10);

set(gca,'XScale','log','YScale','log')    
grid on
xlim([10 100000])
legend('Prev. Day', 'Control', 'Faraday Cage', 'Move Cap', 'Remove Electrode',...
       'Rinse', 'Old Cap', 'Old Cap +30', 'New Cap', 'Wire Imp HS')
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')

%% Plot Impedance (Averages); Selected Manipulatios
[~, numTraces] = size( gamryStructure_C1 );
colorArray = lines( numTraces );
gamryStructure_C7_mod = gamryStructure_C7(1:4); % Ch05 is damaged on old vial cap
gamryStructure_C7_mod = [gamryStructure_C7_mod gamryStructure_C7(6:end)];
gamryStructure_C8_mod = gamryStructure_C8(1:4); % Ch05 is damaged on old vial cap
gamryStructure_C8_mod = [gamryStructure_C8_mod gamryStructure_C8(6:end)];
for ii = 1:numTraces
    avgArray_1(ii,:) = gamryStructure_C1(ii).Zmag;
    avgArray_2(ii,:) = gamryStructure_C2(ii).Zmag;
    avgArray_3(ii,:) = gamryStructure_C3(ii).Zmag;
    avgArray_4(ii,:) = gamryStructure_C4(ii).Zmag;
    avgArray_5(ii,:) = gamryStructure_C5(ii).Zmag;
    avgArray_6(ii,:) = gamryStructure_C6(ii).Zmag;
    if ii < 16
        avgArray_7(ii,:) = gamryStructure_C7_mod(ii).Zmag;
        avgArray_8(ii,:) = gamryStructure_C8_mod(ii).Zmag;
    end
    avgArray_9(ii,:) = gamryStructure_C9(ii).Zmag;
    avgArray_10(ii,:) = gamryStructure_C10(ii).Zmag;
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

figure
% errorbar( gamryStructure_C1(1).f, ...
%         mean_1, std_1 );
hold on
errorbar( gamryStructure_C2(1).f, ...
        mean_2, std_2);
% errorbar( gamryStructure_C3(1).f, ...
%         mean_3, std_3);
errorbar( gamryStructure_C4(1).f, ...
        mean_4, std_4);
errorbar( gamryStructure_C5(1).f, ...
        mean_5, std_5);
errorbar( gamryStructure_C6(1).f, ...
        mean_6, std_6);
% errorbar( gamryStructure_C7(1).f, ...
%         mean_7, std_7);
% errorbar( gamryStructure_C8(1).f, ...
%         mean_8, std_8);
% errorbar( gamryStructure_C9(1).f, ...
%         mean_9, std_9);
% errorbar( gamryStructure_C10(1).f, ...
%         mean_10, std_10);

set(gca,'XScale','log','YScale','log')    
grid on
xlim([10 100000])
legend('Control', 'Move Cap', 'Remove Electrode',...
       'Rinse')
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
%% Plot error
% diffArray = mean_2 - mean_1;
% diffPercent = abs(diffArray)./mean_1;
% 
% figure
% loglog( gamryStructure_C1(1).f, diffArray )
% figure
% loglog( gamryStructure_C1(1).f, diffPercent )
% %%
% 
