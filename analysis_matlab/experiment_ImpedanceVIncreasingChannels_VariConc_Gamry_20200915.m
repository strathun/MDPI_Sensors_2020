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
