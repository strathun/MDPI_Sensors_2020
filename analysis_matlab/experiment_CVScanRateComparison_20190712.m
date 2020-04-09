%% experiment_CVScanRateComparison_20190712
% Compares the CV for the same electrodes at different scan rates. All data
% comes from an in vitro pre surge characterization of TDT19 from 20190712.
% 

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

%% Extract CV Data
relPath = '..\rawData\Gamry\2019-07-12_TDT19_PreSurge\CV';
[dataStructure] = extractCVData(relPath);

%% Plot CV Traces
E13Scans = [ 3 5 7 1 ];
E16Scans = [ 4 6 8 2 ];
scan_to_plot = 3;

% Plot E13
figure
for jj = 1:4
    ii = E13Scans(jj);
plot(dataStructure(ii).potential(scan_to_plot,:), ...
    dataStructure(ii).current(scan_to_plot,:).* (1e6),'.')
hold on
end
xlabel('Potential (V vs Ref)')
ylabel('Current (uA)')
lgd = legend('10', '20', '50', '100');
title(lgd, 'Sweep Rate (mV/s)')
xlim([-0.8 1])
ylim([-3 4])
grid on
title('E13')

% Plot E16
figure
for jj = 1:4
    ii = E16Scans(jj);
plot(dataStructure(ii).potential(scan_to_plot,:), ...
    dataStructure(ii).current(scan_to_plot,:).* (1e6),'.')
hold on
end
xlabel('Potential (V vs Ref)')
ylabel('Current (uA)')
lgd = legend('10', '20', '50', '100');
title(lgd, 'Sweep Rate (mV/s)')
xlim([-0.8 1])
ylim([-3 4])
grid on
title('E16')

