%% plotScript_comparison_vitro_offsets_20200323
% Compares offsets (OCPs) of gamry and custom phate
% All data collected 20200323, using TDT22 in vitro (Old PBS)
% Gamry OCP is taken as the final ocp measurement before the EIS
% measurement starts.

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

%% Extract OCP Data
% Gamry
[ocpStructure] = extractEarlyOCPData('..\rawData\Gamry\20200323_TDT22_InVitro_OldPBS');
% Custom Pot 
load('..\rawData\CustomPot\20200323_TDT22_InVitro_OldPBS\2020-03-23_13hr_17min_28sec_TDT22')

%% Calculate custom pot offsets


%% Plot of electrode number vs OCP
[ ~, numTrodes ] = size( ocpStructure );
for ii = 1:numTrodes
    scatter( ii, ocpStructure(ii).VvRef(end), ...
             [], 'b');
    hold on
end

%%
% Notes