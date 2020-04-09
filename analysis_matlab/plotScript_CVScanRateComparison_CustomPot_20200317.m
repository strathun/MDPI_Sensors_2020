%% plotScript_CVScanRateComparison_CustomPot_20200317
% Compares the CV for the same electrodes at different scan rates. All data
% comes from an in vitro measurements of TDT22 from 20200317.
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

%% Plot CV Traces 100mV/s
load('..\rawData\CustomPot\20200317_TDT22_InVitro_unsureOfSolution\2020-03-17_21hr_03min_51sec_TDT22_CV100.mat');
[ numTrodes, totalPoints ] = size ( Im );
scan_length = ceil( totalPoints/2 ); % 2 total scans
for ii = 1:numTrodes
    figure(ii)
    [ kk ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
    start_pointer = scan_length; 
    stop_pointer  = totalPoints;
    scatter( Vstim( kk, start_pointer:stop_pointer ), ...
             Im( kk, start_pointer:stop_pointer ).*(1e6), '.');
    hold on
end

load('..\rawData\CustomPot\20200317_TDT22_InVitro_unsureOfSolution\2020-03-17_21hr_05min_10sec_TDT22_CV1000.mat');
[ numTrodes, totalPoints ] = size ( Im );
scan_length = ceil( totalPoints / 4 ); % 4 total scans
for ii = 1:numTrodes
    figure(ii)
    [ kk ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
    start_pointer = totalPoints - scan_length; 
    stop_pointer  = totalPoints;
    scatter( Vstim( kk, start_pointer:stop_pointer ), ...
             Im( kk, start_pointer:stop_pointer ).*(1e6), '.');
    title((sprintf('E%02d', ii )))
    xlabel( 'Potential vs OCP (V)' )
    ylabel( 'Current (uA)' )
    legend('100 mV/s', '1 V/s')
    ylim([ -8 12])
    xlim([ -0.6 1.0 ])
    grid on
end


