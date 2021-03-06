%% experiment_ImpedanceVIncreasingChannels_VariConc_Gamry_20200915
% Attempting to recreate the errors with increasing channel count that were
% seen with the custom system on 20200629
% Tried to mimic this effect by connecting channels not being measured with
% the gamry to gamry's floating ground.
% This experiment was repeated in freshly made (0915) 1xPBS, 2xPBS and
% 0p1xPBS

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
% Gamry
[gamryStructure_1x] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200915_TDT22_InVitro_1xPBS');
[gamryStructure_2x] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200915_TDT22_InVitro_2xPBS');
[gamryStructure_0p1x] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200915_TDT22_InVitro_0p1xPBS');



%% Plot Gamry Impedance vs increasing electrode number_ 1xPBS
figure
colorArray = lines( 6 );
pointerArray = [ 5 3 2 1 4 6]; 
for ii = 1:6
    jj = pointerArray( ii );
    loglog( gamryStructure_1x(jj).f, ...
            gamryStructure_1x(jj).Zmag, ...
            'Color', colorArray( ii, : ))
    hold on
end
grid on
xlim([100 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
title('In Vitro Impedance and Number of Electrodes; Gamry E01; 1xPBS')
leg = legend('1', '2', '4', '8', '16', '1 (repeated)');
title(leg,'Connected Electrodes');

%% Plot Gamry Impedance vs increasing electrode number_ 2xPBS
figure
colorArray = lines( 6 );
pointerArray = [ 5 3 2 1 4 6]; 
for ii = 1:6
    jj = pointerArray( ii );
    loglog( gamryStructure_2x(jj).f, ...
            gamryStructure_2x(jj).Zmag, ...
            'Color', colorArray( ii, : ))
    hold on
end
grid on
xlim([100 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
title('In Vitro Impedance V Number of Electrodes; Gamry E01; 2xPBS')
leg = legend('1', '2', '4', '8', '16', '1 (repeated)');
title(leg,'Connected Electrodes');

%% Plot Gamry Impedance vs increasing electrode number_0p1xPBS
figure
colorArray = lines( 6 );
pointerArray = [ 5 3 2 1 4 6]; 
for ii = 1:6
    jj = pointerArray( ii );
    loglog( gamryStructure_0p1x(jj).f, ...
            gamryStructure_0p1x(jj).Zmag, ...
            'Color', colorArray( ii, : ))
    hold on
end
grid on
xlim([100 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
title('In Vitro Impedance and Number of Electrodes; Gamry E01; 0.1xPBS')
leg = legend('1', '2', '4', '8', '16', '1 (repeated)');
title(leg,'Connected Electrodes');

%% Quantify Imp changes (Magnitude)
% Max Frequency
freqIndex = 1;
% 1x Concentration
% baselineImp = gamryStructure_1x(5).Zmag(1);
pointerArray = [ 5 3 2 1 4 6]; 
for ii = 1:6
    jj = pointerArray(ii);
    impStructure_1x(ii) = gamryStructure_1x(jj).Zmag( freqIndex );
    impStructure_2x(ii) = gamryStructure_2x(jj).Zmag( freqIndex );
    impStructure_0p1x(ii) = gamryStructure_0p1x(jj).Zmag( freqIndex );
end
for ii = 1:6
    impChangeArray_1x(ii) = abs( impStructure_1x( 1 ) - impStructure_1x( ii ) );
    impChangeArray_2x(ii) = abs( impStructure_2x( 1 ) - impStructure_2x( ii ) );
    impChangeArray_0p1x(ii) = abs( impStructure_0p1x( 1 ) - impStructure_0p1x( ii ) );
end
% Figure
figure
numElectrodes = [1 2 4 8 16];
plot(numElectrodes, impChangeArray_1x(1:5), '-o');
hold on
plot(numElectrodes, impChangeArray_2x(1:5), '-o');
plot(numElectrodes, impChangeArray_0p1x(1:5), '-o');
grid on
xlabel('Number of Electrodes')
ylabel('Impedance Change from Baseline')
legend('1xPBS', '2xPBS', '0.1XPBS')
title('Impedance Change; F = 100kHz')
% Figure without 0p1 for clarity
figure
numElectrodes = [1 2 4 8 16];
plot(numElectrodes, impChangeArray_1x(1:5), '-o');
hold on
plot(numElectrodes, impChangeArray_2x(1:5), '-o');
grid on
xlabel('Number of Electrodes')
ylabel('Impedance Change from Baseline')
legend('1xPBS', '2xPBS')
title('Impedance Change; F = 100kHz')

%% Quantify Imp changes (Percent)
% Max Frequency
freqIndex = 1;
% 1x Concentration
% baselineImp = gamryStructure_1x(5).Zmag(1);
pointerArray = [ 5 3 2 1 4 6]; 
for ii = 1:6
    jj = pointerArray(ii);
    impStructure_1x(ii) = gamryStructure_1x(jj).Zmag( freqIndex );
    impStructure_2x(ii) = gamryStructure_2x(jj).Zmag( freqIndex );
    impStructure_0p1x(ii) = gamryStructure_0p1x(jj).Zmag( freqIndex );
end
for ii = 1:6
    impChangeArray_1x(ii) = ((abs( impStructure_1x( 1 ) - impStructure_1x( ii ) ))./impStructure_1x( 1 ))*100;
    impChangeArray_2x(ii) = ((abs( impStructure_2x( 1 ) - impStructure_2x( ii ) ))./impStructure_2x( 1 ))*100;
    impChangeArray_0p1x(ii) = ((abs( impStructure_0p1x( 1 ) - impStructure_0p1x( ii ) ))./impStructure_0p1x( 1 ))*100;
end
% Figure
figure
numElectrodes = [1 2 4 8 16];
plot(numElectrodes, impChangeArray_1x(1:5), '-o');
hold on
plot(numElectrodes, impChangeArray_2x(1:5), '-o');
plot(numElectrodes, impChangeArray_0p1x(1:5), '-o');
grid on
xlabel('Number of Electrodes')
ylabel('%Impedance Change from Baseline')
legend('1xPBS', '2xPBS', '0.1XPBS')
title('% Impedance Change; F = 100kHz')

%%
% annotateOpen(1);