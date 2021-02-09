%% experiment_GamryStrayCapacitance_FG_CE_WE_RE
% Attempting to recreate the "jumps" we see with the Gamry when connecting
% multiple electrodes in parallel. All manipulations here are by connecting
% the FG to either the WE CE or RE with a capacitor in between

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
[gamryStructure] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20201014_TDT22_InVitro_1xPBS');

%% F.G. to W.E
figure
pointerArray = [1 5 4]; 
for ii = 1:3
    jj = pointerArray( ii );
    loglog( gamryStructure(jj).f, ...
            gamryStructure(jj).Zmag)
    hold on
end
grid on
xlim([10 100000])
xlabel('Frequency (Hz)')
ylabel('mag(Impedance)')
title('F.G. Connected to W.E.')
leg = legend('Control', '1', '10');
title(leg,'Series Capactiance (uF)');

%% F.G. to C.E.
figure
pointerArray = [1 8 6 7]; 
numTraces = length( pointerArray );
for ii = 1:numTraces
    jj = pointerArray( ii );
    loglog( gamryStructure(jj).f, ...
            gamryStructure(jj).Zmag)
    hold on
end
grid on
xlim([10 100000])
xlabel('Frequency (Hz)')
ylabel('mag(Impedance)')
title('F.G. Connected to C.E.')
leg = legend('Control', '0.1', '1', '2');
title(leg,'Series Capactiance (uF)');

%% F.G. to R.E.
figure
pointerArray = [1 2 3]; 
numTraces = length( pointerArray );
for ii = 1:numTraces
    jj = pointerArray( ii );
    loglog( gamryStructure(jj).f, ...
            gamryStructure(jj).Zmag)
    hold on
end
grid on
xlim([10 100000])
xlabel('Frequency (Hz)')
ylabel('mag(Impedance)')
title('F.G. Connected to R.E.')
leg = legend('Control', 'Post Bubble', 'Post Bubble-rinsed');