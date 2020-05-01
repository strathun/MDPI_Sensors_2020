%% troubleshooting_Gamry_3eVs2e_20200311
% See how much influence the [Forced offset? Get actual name from gamry
% software] has on the impedance measurement

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
    extractImpedanceDataGlobal('..\rawData\Gamry\20200311_TDT21_InVitro_1xPBSNew\Impedance');
[gamryStructure_forced] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200311_TDT21_InVitro_1xPBSNew\ChangingOffset');

%% Plot Mag Impedance 
figure
% Plot og with offset at 0V
loglog( gamryStructure( 1 ).f, ...
        gamryStructure( 1 ).Zmag, ...
        'Color', 'k' )
    hold on
loglog( gamryStructure_forced( 1 ).f, ...
        gamryStructure_forced( 1 ).Zmag, '--', ...
        'Color', 'k' )
loglog( gamryStructure_forced( 2 ).f, ...
        gamryStructure_forced( 2 ).Zmag, '.', ...
        'Color', 'k'  )
ylim([300 4e4])
xlim([10 10e5]); 
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
leg = legend('0 mV', '-100 mV', '-600 mV');
title(leg,'Forced Offsets')
title('In Vitro Forced Offsets; one electrode; Gamry')
grid on
%%
% Definitley influenced! Interesting that the high frequency kind of
% bottoms out, but this actually makes sense for in vitro. You would expect
% this to purely be solution resistance (or at least mostly). Which brings
% up another interesting point about the pre-post CV. Maybe it is affecting
% the surrounding tissue. Really should have repeated THIS experiment in
% vivo...