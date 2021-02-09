%% experiment_GamryStrayCapacitance
% Attempting to recreate the "jumps" we see with the Gamry when connecting
% multiple electrodes in parallel. Most of the manipulations here are to
% try to add more capacitance between the floating ground and the working
% electrode. 
% Data comes from two experimental sessions: 0930 & 10012020

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
[gamryStructure_Day01] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200930_TDT22_InVitro_1xPBS');
[gamryStructure_Day02] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20201001_TDT22_InVitro_1xPBS');

%% Plot all measurements for overview picture
[~, numTraces1] = size( gamryStructure_Day01 );
[~, numTraces2] = size( gamryStructure_Day02 );
figure
for ii = 1:numTraces1
    loglog( gamryStructure_Day01(ii).f, ...
            gamryStructure_Day01(ii).Zmag)
    hold on
end
for ii = 1:numTraces2
    loglog( gamryStructure_Day02(ii).f, ...
            gamryStructure_Day02(ii).Zmag, ...
            '--')
end
grid on
xlabel('Frequency (Hz)')
ylabel('mag(Impedance)')
title('All Configurations')
xlim([10 100000])
%% Day1 Cap range 
% Parallel connection is at E09
figure
colorArray = lines( 3 );
pointerArray = [11 13 14]; 
for ii = 1:3
    jj = pointerArray( ii );
    loglog( gamryStructure_Day01(jj).f, ...
            gamryStructure_Day01(jj).Zmag, ...
            'Color', colorArray( ii, : ))
    hold on
end
grid on
xlim([100 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
title('Increasing Capacitance E09 Parallel Connection')
leg = legend('.01', '1', '10');
title(leg,'Capactiance (uF)');

% Some increase in impedance, but none of the jumps

%% Day1 (10uF) at different locations
figure
colorArray = lines( 3 );
pointerArray = [14 1 15]; 
for ii = 1:3
    jj = pointerArray( ii );
    loglog( gamryStructure_Day01(jj).f, ...
            gamryStructure_Day01(jj).Zmag, ...
            'Color', colorArray( ii, : ))
    hold on
end
grid on
xlim([100 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
title('Parallel Electrode Location; 10uF all')
leg = legend('E09', 'E11', 'E16');
title(leg,'Parallel Connection at');

%% Day1 highest cap values E 16 in parallel
figure
colorArray = lines( 4 );
pointerArray = [15 2 3 4]; 
for ii = 1:4
    jj = pointerArray( ii );
    loglog( gamryStructure_Day01(jj).f, ...
            gamryStructure_Day01(jj).Zmag, ...
            'Color', colorArray( ii, : ))
    hold on
end
grid on
xlim([100 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
title('Increasing Capacitance E16 Parallel Connection')
leg = legend('10', '100', '200', '200-repeated');
title(leg,'Capactiance (uF)');

% BIG NOTE: This figure seems to show that the previous measurements may
% not have had great connections. 200-repeated was when I went back and
% soldered a larger wire to the capacitor lead to make it fit better in
% the 100 mil header. 

%% Day2 200uF at different locations
figure
pointerArray = [1 2 3 4 5 6 7]; 
numTraces = length( pointerArray );
colorArray = lines( numTraces );
for ii = 1:numTraces
    jj = pointerArray( ii );
    loglog( gamryStructure_Day02(jj).f, ...
            gamryStructure_Day02(jj).Zmag, ...
            'Color', colorArray( ii, : ))
    hold on
end
grid on
xlim([100 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
title('Parallel Electrode Location; E01; 200uF all')
leg = legend('control-noparallel', 'E11', 'E16', 'E02', 'E09', 'E08','E08-r2');
title(leg,'Parallel Location');

% Not sure what the reason for the 2nd run of E08 was, or why it caused
% a difference... Take better notes!!

%% Day2 300uF at different locations
figure
pointerArray = [1 9 10 11]; 
numTraces = length( pointerArray );
colorArray = lines( numTraces );
for ii = 1:numTraces
    jj = pointerArray( ii );
    loglog( gamryStructure_Day02(jj).f, ...
            gamryStructure_Day02(jj).Zmag, ...
            'Color', colorArray( ii, : ))
    hold on
end
grid on
xlim([100 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
title('Parallel Electrode Location; E01; 300uF all')
leg = legend('control-noparallel', 'E02', 'E11', 'E16');
title(leg,'Parallel Location');

% Closer definitely seems to have more of an effect

%% Day2 Parallel at E02 with increasing cap
figure
pointerArray = [1 8 9 12]; 
numTraces = length( pointerArray );
colorArray = lines( numTraces );
for ii = 1:numTraces
    jj = pointerArray( ii );
    loglog( gamryStructure_Day02(jj).f, ...
            gamryStructure_Day02(jj).Zmag, ...
            'Color', colorArray( ii, : ))
    hold on
end
grid on
xlim([100 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
title('Increasing Capacitance; E02 Parallel Connection')
leg = legend('control-noparallel', '100', '300', '1000');
title(leg,'Capactiance (uF)');

% Interesting that trend goes opposite direction with 1000 uF

%% Day2 300uF at different locations; MEASURING E03!
figure
pointerArray = [23 21 22]; 
numTraces = length( pointerArray );
colorArray = lines( numTraces );
for ii = 1:numTraces
    jj = pointerArray( ii );
    loglog( gamryStructure_Day02(jj).f, ...
            gamryStructure_Day02(jj).Zmag, ...
            'Color', colorArray( ii, : ))
    hold on
end
grid on
xlim([100 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
title('Parallel Electrode Location; E03!; 300uF all')
leg = legend('control-noparallel', 'E02', 'E04');
title(leg,'Parallel Location');

% Pretty similar results for both sides of electrode

%% Day2 300uF at ALL locations
figure
pointerArray = [1 24 26 27 28 29 30 31 32 33 34 35 36 37 38 39];  
numTraces = length( pointerArray );
colorArray = lines( numTraces );
for ii = 1:numTraces
    jj = pointerArray( ii );
    loglog( gamryStructure_Day02(jj).f, ...
            gamryStructure_Day02(jj).Zmag, ...
            'Color', colorArray( ii, : ))
    hold on
end
grid on
xlim([100 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
title('Parallel Electrode ALL Locations; E01; 300uF all')
leg = legend('control-noparallel', '2', '3', '4', '5', '6', '7', '8', ...
             '9', '10', '11', '12', '13', '14', '15', '16');
title(leg,'Parallel Location');

% Could be some trends, but need to label better to pick them out. 