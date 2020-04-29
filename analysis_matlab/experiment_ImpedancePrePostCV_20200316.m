%% experiment_ImpedancePrePostCV_20200316
% This is a comparison of EIS before and after CV. Originally for Gamry.
% Custom pot will be added
% All data from experiment on 20200316
% Round 1 data is the inital run through on the Gamry (all vs EREF).
% Round 2 is the pre and post CV measurements
% NOTE: All Tye's data is vs EOC. Gamry can be either and should say so in
% filename

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

%% Extract data
[gamryStructure_Round2] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200316_TDT21_Day03\Impedance\Round2');
[ocpStructure] = ...
    extractEarlyOCPData('..\rawData\Gamry\20200316_TDT21_Day03\Impedance\Round2');
[cvStructure] = extractCVData('..\rawData\Gamry\20200316_TDT21_Day03\CV'); 

%% Plot Mag Impedance of Round 2 Gamry ERef before and after CV
figure
pointerArray_pre = [08 10 12]; % Selects pre EREF Gamry
pointerArray_post = [07 09 11]; % Selects post EREF Gamry
number_electrodes = length(pointerArray_pre);
colorArray = lines(number_electrodes);
for ii = 1:number_electrodes
    jj = pointerArray_pre(ii);
    kk = pointerArray_post(ii);
    loglog( gamryStructure_Round2(jj).f, ...
            gamryStructure_Round2(jj).Zmag, ...
            'Color', colorArray(ii,:))
    hold on
    loglog( gamryStructure_Round2(kk).f, ...
            gamryStructure_Round2(kk).Zmag, 'o', ...
            'Color', colorArray(ii,:))
end
xlabel( 'Frequency (Hz)' )
ylabel( 'mag(Z) (Ohm)' ) 
title(' Impedance Magnitude before and after CV; Gamry; 3 electrodes')
legend( 'Pre-CV', 'Post-CV' )

%% 
% Looks to be serious effects from CV...
% Blue and red both increase in impedance and seem to maintain their
% original shape. Something interesting is definitely going on with yellow.
% 

%% OCP before and after CV
pointerArray_pre = [08 10 12]; % Selects pre EREF Gamry
pointerArray_post = [07 09 11]; % Selects post EREF Gamry
numTrodes = length( pointerArray_pre );
% Convert to array for plots because I'm bad at coding
for ii = 1:numTrodes
    jj = pointerArray_pre(ii);
    kk = pointerArray_post(ii);
    %Pre is column 1, post is column 2
    ocpArray( ii, 1 ) = ocpStructure(jj).VvRef(end)*(1e3);
    ocpArray( ii, 2 ) = ocpStructure(kk).VvRef(end)*(1e3);
end

figure
for ii = 1:numTrodes
    plot( [1 2], ocpArray( ii, : ), '-o' ) 
    hold on
end
set(gca,'XTick', [1 2])
set(gca,'XTickLabel',{'Pre','Post'})
title(' OCP before and after CV; Gamry; 3 electrodes')
ylabel( 'OCP (mV)' )
xlim([0.8 2.2])

%% 
% So the plot thickens...Blue and red both increased in impedance and
% increased in their offsets. Yellow had a big decrease in its offset and
% had an increase in the high frequency impedance and dramatic decrease in
% low frequency impedance. 

%% Plot scans of CV for all 3 electrodes
% Want to see if it looks like something weird is going on with the yellow
% electrodes
pointerArray = [ 2 3 4 ];   
numTrodes = length( pointerArray );
colorArray = lines(3);
for ii = 1:numTrodes
    figure
    jj = pointerArray( ii );
    [ numScans, ~] = size( cvStructure( jj ).potential );
    transparencyFactor = 1/( numScans );
    for kk = 1:numScans
        % first scan is ignored   
        s = scatter( cvStructure(jj).potential(kk,:), ...
                     cvStructure(jj).current(kk,:).*(1e6), 1, '.', ...
                     'MarkerEdgeColor', colorArray(ii,:));
        s.MarkerEdgeAlpha = transparencyFactor * ( kk );
        hold on
    end
    xlabel( 'Potential vs OCP (V)' )
    ylabel( 'Current (uA)' )
    ylim( [-0.5 4.5] )
    xlim( [-0.8 1])
end

% Plot the vs ERef for the yellow electrode
pointerArray = 7 ;   
numTrodes = length( pointerArray );
for ii = 1:numTrodes
    figure
    jj = pointerArray( ii );
    [ numScans, ~] = size( cvStructure( jj ).potential );
    transparencyFactor = 1/( numScans );
    for kk = 2:numScans
        % first scan is ignored   
        s = scatter( cvStructure(jj).potential(kk,:), ...
                     cvStructure(jj).current(kk,:).*(1e6), 1, '.', ...
                     'MarkerEdgeColor', colorArray(ii,:));
        s.MarkerEdgeAlpha = transparencyFactor * ( kk );
        hold on
    end
    xlabel( 'Potential vs OCP (V)' )
    ylabel( 'Current (uA)' )
    xlim( [-0.8 1])
end
%%
% Ok something weird definitely happened with the yellow electrode. Is this
% the same electrode that looks bad with Tye's scans? Maybe this is where
% it was damaged...
% Next on the list:
%   Look at the vs ERef CV
