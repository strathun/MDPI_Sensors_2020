%% troubleshooting_Gamry_3eVs2e_20200323
% Troubleshooting request from technician at Gamry

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
    extractImpedanceDataGlobal('..\rawData\Gamry\20200323_TDT22_InVitro_OldPBS_Round2');
[gamryStructure_2e] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200323_TDT22_InVitro_OldPBS_2e');

%% Plot Mag Impedance 
figure
% Plot og with offset at 0V
loglog( gamryStructure( 3 ).f, ...
        gamryStructure( 3 ).Zmag )
    hold on
loglog( gamryStructure_2e( 1 ).f, ...
        gamryStructure_2e( 1 ).Zmag )
ylim([300 4e4])
xlim([10 10e5]); 
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
legend( '3-electrode', '2-electrode' )
%%
% Very little difference
