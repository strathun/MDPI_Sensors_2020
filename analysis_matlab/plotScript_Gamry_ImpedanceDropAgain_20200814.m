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
[gamryStructure_newHS] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200810_TDT22_inVitro_OldPBS_brOutHS');

[gamryStructure_Exp2] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200814_TDT22_InVitro_OldPBS_brOutHS');

%% Plot Impedance (new vs Old HS)
[~, numTraces] = size( gamryStructure_Exp2 );
figure(1)
colorArray = lines( numTraces );
pointerArray = [8 12:25 33 ];
for ii = 1:numTraces
    loglog( gamryStructure_newHS(ii).f, ...
            gamryStructure_newHS(ii).Zmag, ...
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
title('global Impedance Drop (Both Gamry)')

%%
%