%% experiment_Gamry_ImpedanceConsistency_sameSolution_20200917
% Want to test how consistent the Gamry is between days/measurements when
% using the same sample of stock solution. Typically a fresh sample of
% solution will be taken before each experiment.

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
    extractImpedanceDataGlobal('..\rawData\Gamry\20200915_TDT22_InVitro_1xPBS');
[gamryStructure_Day01_r1] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200917_TDT22_InVitro_1xPBS');
[gamryStructure_Day01_br] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200917_TDT22_InVitro_1xPBS_brOutHS');

%% Plot Impedance (new vs Old)
[~, numTraces] = size( gamryStructure_Day00 );
figure(1)
colorArray = lines( numTraces );
    loglog( gamryStructure_Day00(6).f, ...
            gamryStructure_Day00(6).Zmag, ...
            'Color', colorArray( 1, : ))
        hold on
    loglog( gamryStructure_Day01_r1(1).f, ...
            gamryStructure_Day01_r1(1).Zmag, ...
            '--', 'Color', colorArray( 1, : ))
    loglog( gamryStructure_Day01_br(1).f, ...
            gamryStructure_Day01_br(1).Zmag, ...
            '--', 'Color', colorArray( 1, : ))
    loglog( gamryStructure_Day01_br(2).f, ...
            gamryStructure_Day01_br(2).Zmag, ...
            '--', 'Color', colorArray( 1, : ))
%     loglog( gamryStructure_Day01_r1(ii).f, ...
%             gamryStructure_Day01_r1(ii).Zmag, ...
%             '--', 'Color', colorArray( ii, : ))
xlim([10 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
legend('Day 00', 'Day01_r1', 'Day01_r2', 'Day01_r3', 'Day01_r4',...
       'Day02_r1', 'Day02_r2', 'Day02_temp',...
       'Day03_r1', 'Day03_r2', 'Day03_r3')
title('Global Impedance Drop (Both Gamry)')


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
    loglog( gamryStructure_Day01_r1(ii).f, ...
            gamryStructure_Day01_r1(ii).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
end
xlim([10 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
legend('Day 00', 'Day01_r1', 'Day01_r2', 'Day01_r3', 'Day01_r4',...
       'Day02_r1', 'Day02_r2', 'Day02_temp',...
       'Day03_r1', 'Day03_r2', 'Day03_r3')
title('Global Impedance Drop (Both Gamry)')