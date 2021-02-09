%% experiment_ImpedanceVIncreasingChannels_VariRef_Gamry_20200929
% Attempting to recreate the errors with increasing channel count that were
% seen with the custom system on 20200629
% Tried to mimic this effect by connecting channels not being measured with
% the gamry to gamry's floating ground.
% Then, I tried to modify (reduce) these errors by moving the reference
% electrode closer to the working electrode
% Config 1: Control (old setup)
% Config 2: Modified counter electrode
% Config 3: Modified Reference electrode

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
[gamryStructure_C1] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200929_TDT22_InVitro_1xPBS_C1');
[gamryStructure_C2] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200929_TDT22_InVitro_1xPBS_C2');
[gamryStructure_C3] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200929_TDT22_InVitro_1xPBS_C3');

%% Plot Gamry Impedance vs increasing electrode number_C1
figure
colorArray = lines( 6 );
pointerArray = [ 5 3 2 1 4 6]; 
for ii = 1:6
    jj = pointerArray( ii );
    loglog( gamryStructure_C1(jj).f, ...
            gamryStructure_C1(jj).Zmag, ...
            'Color', colorArray( ii, : ))
    hold on
end
grid on
xlim([100 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
title('In Vitro Impedance and Number of Electrodes; Gamry E01; Control')
leg = legend('1', '2', '4', '8', '16', '1 (repeated)');
title(leg,'Connected Electrodes');

%% Plot Gamry Impedance vs increasing electrode number_ModCounterE
figure
colorArray = lines( 6 );
pointerArray = [ 5 3 2 1 4 6]; 
for ii = 1:6
    jj = pointerArray( ii );
    loglog( gamryStructure_C2(jj).f, ...
            gamryStructure_C2(jj).Zmag, ...
            'Color', colorArray( ii, : ))
    hold on
end
grid on
xlim([100 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
title('In Vitro Impedance V Number of Electrodes; Gamry E01; Mod-CE')
leg = legend('1', '2', '4', '8', '16', '1 (repeated)');
title(leg,'Connected Electrodes');

%% Plot Gamry Impedance vs increasing electrode number_ModReferenceE
figure
colorArray = lines( 6 );
pointerArray = [ 5 3 2 1 4 6]; 
for ii = 1:6
    jj = pointerArray( ii );
    loglog( gamryStructure_C3(jj).f, ...
            gamryStructure_C3(jj).Zmag, ...
            'Color', colorArray( ii, : ))
    hold on
end
grid on
xlim([100 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
title('In Vitro Impedance and Number of Electrodes; Gamry E01; Mod-RE')
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
    impStructure_1x(ii) = gamryStructure_C1(jj).Zmag( freqIndex );
    impStructure_2x(ii) = gamryStructure_C2(jj).Zmag( freqIndex );
    impStructure_0p1x(ii) = gamryStructure_C3(jj).Zmag( freqIndex );
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
legend('C1', 'C2', 'C3')
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
    impStructure_1x(ii) = gamryStructure_C1(jj).Zmag( freqIndex );
    impStructure_2x(ii) = gamryStructure_C2(jj).Zmag( freqIndex );
    impStructure_0p1x(ii) = gamryStructure_C3(jj).Zmag( freqIndex );
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
legend('C1', 'C2', 'C3')
title('% Impedance Change; F = 100kHz')

%%
% Make sure everything is actually plotting correctly here. Right now it
% looks like moving the reference electrode closer has increased the error.
% If this is the case, it's possible that the exposed surface area is
% smaller than before. Would this have a big effect? What else does this
% imply? 
% UPDAte: 20201001, I did have C2 and C3 switched (in the wrong folder).
% Should be correct now