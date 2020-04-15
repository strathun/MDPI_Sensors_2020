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
[ numTrodes, totalPoints_vitro ] = size ( Im );
scan_length_vitro = ceil( totalPoints_vitro/2 ); % 2 total scans
for ii = 1:numTrodes
    figure(ii)
    [ kk ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
    start_pointer = scan_length_vitro; 
    stop_pointer  = totalPoints_vitro;
    scatter( Vstim( kk, start_pointer:stop_pointer ), ...
             Im( kk, start_pointer:stop_pointer ).*(1e6), '.');
    hold on
end

load('..\rawData\CustomPot\20200317_TDT22_InVitro_unsureOfSolution\2020-03-17_21hr_05min_10sec_TDT22_CV1000.mat');
[ numTrodes, totalPoints_vitro ] = size ( Im );
scan_length_vitro = ceil( totalPoints_vitro / 4 ); % 4 total scans
for ii = 1:numTrodes
    figure(ii)
    [ kk ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
    start_pointer = totalPoints_vitro - scan_length_vitro; 
    stop_pointer  = totalPoints_vitro;
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

%% Rough comparison to in vivo
% Note: these are not the same arrays, but should give us an idea if there
% is a "positive trend" in the baseline
% Tried to do +/- stddev but got way more complicated. Deal with this
% later. Just plotting means for now. 

% In vitro 100 mV/s
load('..\rawData\CustomPot\20200317_TDT22_InVitro_unsureOfSolution\2020-03-17_21hr_03min_51sec_TDT22_CV100.mat');
[ numTrodes, totalPoints_vitro ] = size ( Im );
scan_length_vitro = ceil( totalPoints_vitro/2 ); % 2 total scans
% remove bad electrodes for the averaging
Im( 9, : ) = [];
ImVitro_mean = mean(Im);
% ImVitro_std = std(Im);
start_pointer = scan_length_vitro; 
stop_pointer  = totalPoints_vitro;
% mid_pointer = start_pointer + floor(scan_length_vitro/2);
% ImVitro_std_high = ImVitro_mean(start_pointer:mid_pointer) + ...
%     ImVitro_std(start_pointer:mid_pointer);
% ImVitro_std_high = [ImVitro_std_high ...
%     ImVitro_mean(mid_pointer + 1:stop_pointer) - ...
%     ImVitro_std(mid_pointer + 1:stop_pointer)];
% Vstim = Vstim( 1, start_pointer:stop_pointer);
% 
figure
% scatter( Vstim, ...
%          ImVitro_mean( start_pointer:stop_pointer ).*(1e6), '.');
% hold on
scatter( Vstim(1, start_pointer:stop_pointer), ...
         ImVitro_mean(start_pointer:stop_pointer).*(1e6), '.');
hold on

% In vivo 100 mV/s
load('2020-03-16_14hr_04min_14sec_TDT21_CV100.mat');
% remove bad electrodes for the averaging
Im( 8, : ) = [];
Im( end, : ) = [];
[ numTrodes, totalPoints_vivo ] = size ( Im );
scan_length_vivo = ceil( totalPoints_vivo/2 ); % 2 total scans
ImVivo_mean = mean(Im);
start_pointer = scan_length_vivo; 
stop_pointer  = totalPoints_vivo;
scatter( Vstim(1, start_pointer:stop_pointer), ...
         ImVivo_mean(start_pointer:stop_pointer).*(1e6), '.');
legend('In vivo', 'In vitro')
ylim([ -2 3])
xlim([ -0.2 0.6 ])
xlabel( 'Potential vs OCP (V)' )
ylabel( 'Current (uA)' )

