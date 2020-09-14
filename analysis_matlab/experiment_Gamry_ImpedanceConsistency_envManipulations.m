%% experiment_Gamry_ImpedanceConsistency_RegVsMuxHS_envManipulations
% Want to see if the muxd impedance headstage will work with the gamry.
% This is the v4.0 board that works with the v4.0 interface (mother) board
% C1 = control
% C2 = removed and reinserted array

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
    extractImpedanceDataGlobal('..\rawData\Gamry\20200824_TDT22_InVitro_OldPBS_MuxHS_r2');
[gamryStructure_C2] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200824_TDT22_InVitro_OldPBS_MuxHS_r3');
[gamryStructure_C3] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200824_TDT22_InVitro_OldPBS_MuxHS_r4');
[gamryStructure_C4] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200824_TDT22_InVitro_OldPBS_MuxHS_r5');
[gamryStructure_C5] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200824_TDT22_InVitro_OldPBS_MuxHS_r6');

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
    loglog( gamryStructure_C3(ii).f, ...
            gamryStructure_C3(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    loglog( gamryStructure_C4(ii).f, ...
            gamryStructure_C4(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
end
xlim([10 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
legend('Control', 'MoveCap', 'FreshSoln', 'FreshSoln - 1hr', 'Manip Ref/Cntr')
title('Global Impedance Drop (Both Gamry)')

%% Plot Impedance (new vs Old) (Individual)
[~, numTraces] = size( gamryStructure_C1 );
figure
colorArray = lines( numTraces );
for ii = 1:numTraces
    subplot(4,4,ii)
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
    grid on
    xlim([10 100000])
    legend('Control', 'MoveCap', 'FreshSoln', 'FreshSoln - 1hr', 'Manip Ref/Cntr')
end
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')

%% Plot Impedance (new vs Old)(Averages)
[~, numTraces] = size( gamryStructure_C1 );
colorArray = lines( numTraces );
for ii = 1:numTraces
    avgArray_1(ii,:) = gamryStructure_C1(ii).Zmag;
    avgArray_2(ii,:) = gamryStructure_C2(ii).Zmag;
    avgArray_3(ii,:) = gamryStructure_C3(ii).Zmag;
    avgArray_4(ii,:) = gamryStructure_C4(ii).Zmag;
    avgArray_5(ii,:) = gamryStructure_C5(ii).Zmag;
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
set(gca,'XScale','log','YScale','log')    
grid on
xlim([10 100000])
legend('Control', 'MoveCap', 'FreshSoln', 'FreshSoln - 1hr', 'Manip Ref/Cntr')
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
title('Environmental Manipulations')
%%
% %% Plot error
% diffArray = mean_2 - mean_1;
% diffPercent = abs(diffArray)./mean_1;
% 
% figure
% loglog( gamryStructure_C1(1).f, diffArray )
% figure
% loglog( gamryStructure_C1(1).f, diffPercent )
%%
% 
