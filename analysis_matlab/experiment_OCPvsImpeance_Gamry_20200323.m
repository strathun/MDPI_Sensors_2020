%% experiment_OCPvsImpeance_Gamry_20200323
% Looking to see if there is a clear relationship between open circuit
% potential and impedance.
% All data collected 20200323, using TDT22 in vitro (Old PBS)

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
    extractImpedanceDataGlobal('..\rawData\Gamry\20200323_TDT22_InVitro_OldPBS');
load('..\rawData\CustomPot\20200323_TDT22_InVitro_OldPBS\2020-03-23_13hr_17min_28sec_TDT22')

% Top two are for primary comparisons, this one is to see how much change
% took place throughout the entire characterization
[gamryStructure_Round2] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200323_TDT22_InVitro_OldPBS_Round2');

%% Extract OCP Data
[ocpStructure] = extractEarlyOCPData('..\rawData\Gamry\20200323_TDT22_InVitro_OldPBS');

%% 
frequency_array = [ 10 300 1e3 6e3 ];
numFrequencies = length( frequency_array );
[ ~, numTrodes ] = size( gamryStructure );
colorArray = lines( numTrodes );
for jj = 1:numFrequencies
    
    for ii = 1:numTrodes
        % Find index of value closes to current frequency
        [d, ix] = min( abs( gamryStructure( ii ).f - frequency_array( jj ) ) );
        
        scatter( ocpStructure(ii).VvRef(end), ...
                 gamryStructure( ii ).Zmag( ix ), [ ], ...
                 colorArray( ii, : ) )
        hold on
    end
end

%%
% Nothing obvious seems to be jumping out. Will have to dig into this one
% a little more.
% Maybe look at magnitude of offset? 
% Look into if there is a particular offset range that seems to have the
% most affect on impedance.
