%% Plotscript for NERG
% 20210128 Nerg presentation
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
[gamryStructure] = ...
    extractImpedanceDataGlobal('..\..\ElectrodeCharacterization\rawData\2018-06-07_TDT8_Surgery\Impedance');

%% Plot Impedance Comparison
figure
for jj = 1:16
    loglog( gamryStructure(jj).f, ...
            gamryStructure(jj).Zmag, 'LineWidth', 1.5 )
    hold on
end
xlim([10 1000000])
grid on
xlabel( 'Frequency (Hz)' )
ylabel( 'Impedance Magnitude (Ohm)' ) 

%%
% 