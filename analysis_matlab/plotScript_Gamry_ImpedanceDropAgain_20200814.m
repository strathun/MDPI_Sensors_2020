%% plotScript_Gamry_ImpedanceDropAgain_20200814
% Quick comparison between two experimental sessions. Looks like impedance
% somehow dropped again across the array. 

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
[gamryStructure_Exp1] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200810_TDT22_inVitro_OldPBS_brOutHS');

[gamryStructure_Exp2] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200814_TDT22_InVitro_OldPBS_brOutHS');

[gamryStructure_Exp0] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200323_TDT22_InVitro_OldPBS');

%% Plot Impedance (new vs Old)
[~, numTraces] = size( gamryStructure_Exp2 );
figure(1)
colorArray = lines( numTraces );
pointerArray = [8 12:25 33 ];
for ii = 1:numTraces
    jj = pointerArray(ii);
    loglog( gamryStructure_Exp1(jj).f, ...
            gamryStructure_Exp1(jj).Zmag, ...
            'Color', colorArray( ii, : ))
        hold on
    loglog( gamryStructure_Exp2(ii).f, ...
            gamryStructure_Exp2(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
end
xlim([10 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
legend('Week 1', 'Week 2')
title('Global Impedance Drop (Both Gamry)')

%% Plot Impedance (new vs Old) (Individual)
[~, numTraces] = size( gamryStructure_Exp2 );
figure
colorArray = lines( numTraces );
pointerArray = [8 12:25 33 ];
for ii = 1:numTraces
    subplot(4,4,ii)
    jj = pointerArray(ii);
    loglog( gamryStructure_Exp1(jj).f, ...
            gamryStructure_Exp1(jj).Zmag, ...
            'Color', colorArray( ii, : ))
        hold on
    loglog( gamryStructure_Exp2(ii).f, ...
            gamryStructure_Exp2(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    grid on
    xlim([10 100000])
    legend('Week 1', 'Week 2')
end
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')

%% Plot Impedance (new vs Old)(Averages)
[~, numTraces] = size( gamryStructure_Exp2 );
colorArray = lines( numTraces );
pointerArray = [8 12:25 33 ];
for ii = 1:numTraces
    jj = pointerArray(ii);
    avgArray_1(ii,:) = gamryStructure_Exp1(jj).Zmag;
    avgArray_2(ii,:) = gamryStructure_Exp2(ii).Zmag;
end
mean_1 = mean( avgArray_1, 1);
std_1 = std( avgArray_1, 1 );
mean_2 = mean( avgArray_2, 1);
std_2 = std( avgArray_2, 1 );

figure
errorbar( gamryStructure_Exp1(1).f, ...
        mean_1, std_1 );
hold on
errorbar( gamryStructure_Exp2(1).f, ...
        mean_2, std_2);
set(gca,'XScale','log','YScale','log')    
grid on
xlim([10 100000])
legend('Week 1', 'Week 2')
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')

%% Plot Impedance (new vs Old)(Averages) Include original
[~, numTraces] = size( gamryStructure_Exp2 );
colorArray = lines( numTraces );
pointerArray = [8 12:25 33 ];
for ii = 1:numTraces
    jj = pointerArray(ii);
    avgArray_1(ii,:) = gamryStructure_Exp1(jj).Zmag;
    avgArray_2(ii,:) = gamryStructure_Exp2(ii).Zmag;
    avgArray_0(ii,:) = gamryStructure_Exp0(ii).Zmag;
end
mean_1 = mean( avgArray_1, 1);
std_1 = std( avgArray_1, 1 );
mean_2 = mean( avgArray_2, 1);
std_2 = std( avgArray_2, 1 );
mean_0 = mean( avgArray_0, 1);
std_0 = std( avgArray_0, 1 );

figure
errorbar( gamryStructure_Exp1(1).f, ...
        mean_1, std_1 );
hold on
errorbar( gamryStructure_Exp2(1).f, ...
        mean_2, std_2);
errorbar( gamryStructure_Exp0(1).f, ...
        mean_0, std_0);
set(gca,'XScale','log','YScale','log')    
grid on
xlim([10 100000])
legend('Week 1', 'Week 2', 'Week 0')
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')

