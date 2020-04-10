%% experiment_CV_vitroVvivo_Gamry_TDT7
% Lucked out and actually found an old TDT array where we did in vitro and
% in vivo. Here it is!
% In vitro data was taken on 20180516
% In vivo data taken on 20180529

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
[cvStructure_vitro] = extractCVData('..\rawData\Gamry\2018-05-16_TDT7_CVPresurge\CV'); 
[cvStructure_vivo] = extractCVData('..\rawData\Gamry\2018-05-29_TDT7_Surgery\CV'); 

%% Plot CVs Gamry (vitro)
numTrodes = length( cvStructure_vitro );
colorArray = lines(1);
for ii = 1:numTrodes
    figure
    [ numScans, ~] = size( cvStructure_vitro( ii ).potential );
    transparencyFactor = 1/( numScans );
    for kk = numScans:numScans
        % first scan is ignored   
        s = scatter( cvStructure_vitro(ii).potential(kk,:), ...
                     cvStructure_vitro(ii).current(kk,:).*(1e6), '.', ...
                     'MarkerEdgeColor', colorArray(1,:));
        s.MarkerEdgeAlpha = transparencyFactor * ( kk );
        hold on
    end
    title((sprintf('E%02d', ii ))) % Measurements are in order
    xlabel( 'Potential vs OCP (V)' )
    ylabel( 'Current (uA)' )
end

%% Plot CVs Gamry (vivo)
numTrodes = length( cvStructure_vivo );
colorArray = lines(1);
electrode_numbers = [ 4 6 8 13 ];
for ii = 1:numTrodes
    figure
    [ numScans, ~] = size( cvStructure_vivo( ii ).potential );
    transparencyFactor = 1/( numScans );
    for kk = numScans:numScans
        % first scan is ignored   
        s = scatter( cvStructure_vivo(ii).potential(kk,:), ...
                     cvStructure_vivo(ii).current(kk,:).*(1e6), '.', ...
                     'MarkerEdgeColor', colorArray(1,:));
        s.MarkerEdgeAlpha = transparencyFactor * ( kk );
        hold on
    end
    title((sprintf( 'E%02d', electrode_numbers(ii) ) ) ) % Measurements are in order
    xlabel( 'Potential vs OCP (V)' )
    ylabel( 'Current (uA)' )
end

%% Plot CVs Gamry (vivo) all traces.
numTrodes = length( cvStructure_vivo );
colorArray = lines(1);
electrode_numbers = [ 4 6 8 13 ];
for ii = 1:numTrodes
    figure
    [ numScans, ~] = size( cvStructure_vivo( ii ).potential );
    transparencyFactor = 1/( numScans );
    for kk = 2:numScans
        % first scan is ignored   
        s = scatter( cvStructure_vivo(ii).potential(kk,:), ...
                     cvStructure_vivo(ii).current(kk,:).*(1e6), 1, '.', ...
                     'MarkerEdgeColor', colorArray(1,:));
        s.MarkerEdgeAlpha = transparencyFactor * ( kk );
        hold on
    end
    title((sprintf( 'E%02d', electrode_numbers(ii) ) ) ) % Measurements are in order
    xlabel( 'Potential vs OCP (V)' )
    ylabel( 'Current (uA)' )
end

%% Plot CVs Gamry vivo vs vitro
pointerArray = [ 4 6 8 ]; % for in vitro measurements
electrode_numbers = [ 4 6 8 ];  % Electrode nums for plotted traces. used to match to custom
numTrodes = length( pointerArray );
for ii = 1:numTrodes
    figure
    jj = pointerArray( ii );
    [ numScans, ~] = size( cvStructure_vitro( jj ).potential );
    % first scan is ignored   
    s = scatter( cvStructure_vitro(jj).potential( numScans,:), ...
                 cvStructure_vitro(jj).current( numScans,:).*(1e6), '.' );
    hold on
    [ numScans, ~] = size( cvStructure_vivo( ii ).potential );
    s = scatter( cvStructure_vivo(ii).potential( numScans,:), ...
                 cvStructure_vivo(ii).current( numScans,:).*(1e6), '.' );
    title((sprintf('E%02d', electrode_numbers(ii) )))
    xlabel( 'Potential vs OCP (V)' )
    ylabel( 'Current (uA)' )
    legend( 'In Vitro', 'In Vivo' )
end

%%
% 