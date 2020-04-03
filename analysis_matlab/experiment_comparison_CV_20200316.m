%% experiment_comparison_CV_20200316
% Comparison of CVs made with custom pot. and the gamry. 
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

%% Extract CV Data
[cvStructure] = extractCVData('..\rawData\Gamry\20200316_TDT21_Day03\CV'); 
load('2020-03-16_13hr_59min_57sec_TDT21_CV100.mat')
%% Plot CVs Gamry
pointerArray = [ 2 3 5 6 ];
numTrodes = length( pointerArray );
for ii = 1:numTrodes
    figure
    jj = pointerArray( ii );
    [ numScans, ~] = size( cvStructure( jj ).potential );
    transparencyFactor = 1/( numScans );
    for kk = 2:numScans
        % first scan is ignored   
        s = scatter( cvStructure(jj).potential(kk,:), ...
                     cvStructure(jj).current(kk,:), '.', 'b' );
        s.MarkerEdgeAlpha = transparencyFactor * ( kk );
        hold on
    end
end

%% Plot CVs Gamry
% Need to divide out the gain still.
% Ask tye in lab meeting tomorrow about this. 
[ numTrodes, ~ ] = size ( Im );
for ii = 1:numTrodes
    figure
    scatter( Vstim( ii, : ), Im( ii, : ), '.' )
end

%% Plot other CV file I have to see if the speeds are the same
load('2020-03-16_14hr_04min_14sec_TDT21_CV100.mat')
[ numTrodes, ~ ] = size ( Im );
for ii = 1:numTrodes
    figure
    scatter( Vstim( ii, : ), Im( ii, : ), '.' )
    title(' CV_2 ')
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
