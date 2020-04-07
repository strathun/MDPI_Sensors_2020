%% experiment_comparison_CV_20200316
% Comparison of CVs made with custom pot. and the gamry from post implant day 03. 
% All data from experiment on 20200316
% NOTE: All Tye's data is vs EOC. Gamry can be either and should say so in
% filename
% Work in progress, need to add Tye's CV

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

%% Extract Gamry CV Data
[cvStructure] = extractCVData('..\rawData\Gamry\20200316_TDT21_Day03\CV'); 

%% Plot CVs Gamry
pointerArray = [ 2 3 5 6 ];
electrode_numbers = [ 2 7 15 16 ];  % Electrode nums for plotted traces. used to match to custom
numTrodes = length( pointerArray );
for ii = 1:numTrodes
    figure
    jj = pointerArray( ii );
    [ numScans, ~] = size( cvStructure( jj ).potential );
    transparencyFactor = 1/( numScans );
    for kk = 2:numScans
        % first scan is ignored   
        s = scatter( cvStructure(jj).potential(kk,:), ...
                     cvStructure(jj).current(kk,:).*(1e6), '.', 'b' );
        s.MarkerEdgeAlpha = transparencyFactor * ( kk );
        hold on
    end
    title((sprintf('E%02d', electrode_numbers(ii) )))
    xlabel( 'Potential vs OCP (V)' )
    ylabel( 'Current (uA)' )
end

%% Plot CVs custom
% Need to divide out the gain still.
% Ask tye in lab meeting tomorrow about this. 
% Had to eyeball these to get scan lengths. Looks like there are two scans
% in this file, each one is 4064 points long.
numScans = 2;
load('2020-03-16_13hr_59min_57sec_TDT21_CV100.mat')
[ numTrodes, totalPoints ] = size ( Im );
scan_length = totalPoints/2; 
for ii = 1:numTrodes
    figure
    transparencyFactor = 1/( numScans );
    for kk = 1:numScans
        start_pointer = ( (kk - 1) * scan_length ) + 1; 
        stop_pointer  = kk * scan_length;
        s = scatter( Vstim( ii, start_pointer:stop_pointer ), ...
                 Im( ii, start_pointer:stop_pointer ), '.', 'k' );
        s.MarkerEdgeAlpha = transparencyFactor * ( kk );
        hold on
    end
    [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
    title((sprintf('Custom Pot CV Run 1; E%02d',jj)))
    xlabel( 'Potential vs ?? (V)' )
    ylabel( 'Current (A)' )
end

%% Plot other CV file I have to see if the speeds are the same
% Does not look like it, but not sure which is which. 
% Looks like this one also did just two scans. Safe to divide length by 2. 
load('2020-03-16_14hr_04min_14sec_TDT21_CV100.mat')
% Downsample so that the differences in transparency are more apparent
% Vstim = downsample( Vstim.', 3 ).';
% Im = downsample( Im.', 3 ).';
[ numTrodes, totalPoints ] = size ( Im );
scan_length = totalPoints/2; 
for ii = 1:numTrodes
    figure
    transparencyFactor = 1/( numScans );
    for kk = 1:numScans
        start_pointer = ( (kk - 1) * scan_length ) + 1; 
        stop_pointer  = kk * scan_length;
        s = scatter( Vstim( ii, start_pointer:stop_pointer ), ...
                 Im( ii, start_pointer:stop_pointer ), '.', 'k' );
        s.MarkerEdgeAlpha = transparencyFactor * ( kk );
        hold on
    end
    [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
    title((sprintf('Custom Pot CV Run 2; E%02d',jj)))
    xlabel( 'Potential vs ?? (V)' )
    ylabel( 'Current (A)' )
end
%%
% Interesting. They are in the same approximate ranges, but Tye's are much
% more interesting...
% Should send these to Tye and Ross and see if they have any ideas about
% what differences in the instrumentation might cause this. 
% Things to include in email to Tye and Ross: 
%       Order these were taken
%       what was taken between
%       Have direct measurements of the individual electrodes ready
%       Check the other CV file Tye gave. Maybe this one isn't actually
%           what the file says? Interesting! This one seems to be much
%           closer to Gamry
