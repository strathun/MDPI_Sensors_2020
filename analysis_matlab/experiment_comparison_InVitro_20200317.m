%% experiment_comparison_InVitro_20200317
% Troubleshooting
% Wanted to test to see if high frequency discrepancies exist in vitro as
% well
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

%% Extract impedance data
[gamryStructure] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200317_TDT22_InVitro_0p1PBS\Impedance');
load('..\rawData\CustomPot\20200317_TDT22_InVitro_0p1PBS\2020-03-17_20hr_06min_44sec_MUX_TDT22_0p1x.mat')

%% Plot Mag Impedance for 0.1x PBS (Note: solutions were mixed incorrectly, but this still should be a diluted version of 1x)
figure(1)
[ ~, numSols] = size(gamryStructure);
colorArray = lines(numSols);
for ii = 1:numSols
    loglog( gamryStructure(ii).f, ...
            gamryStructure(ii).Zmag, ...
            'Color', colorArray(ii,:))
    hold on
end
figure(1)
pointerArray = [16 09 05 04]; % Equiv of 1 8 12 13 in Tye's pinout
numSols = length(pointerArray);
for ii = 1:numSols
    jj = pointerArray(ii);
    plot( f_rec(:,jj), Zest(:,jj) , 'o', ...
            'MarkerEdgeColor', colorArray(ii,:));
    hold on
end
xlabel( 'Frequency (Hz)' )
ylabel( 'mag(Z) (Ohm)' ) 
title('')

%%
% Very significant discrepencies between the two systems. Still not certain
% if this has to do with impedance, frequency or some other unknown issues.
% Both Tye's circuit and the gamry record the dummy cell within very close
% agreement with each other (not shown here). 
% Gamry measurements are way lower than anything we'eve ever measured with
% TDT arrays. Next step is to take noise measurements and see which
% impedance measurement matches the best. 

%% I think this was for the .001x solution, but don't think I have Tye's measurements. 
% %% Plot Mag 
% figure(2)
% [ ~, numSols] = size(gamryStructure);
% colorArray = lines(numSols);
% for ii = 1:numSols
%     loglog( gamryStructure(ii).f, ...
%             gamryStructure(ii).Zmag, ...
%             'Color', colorArray(ii,:))
%     hold on
% end
% figure(2)
% pointerArray = [05 06 07 14 15]; % Equiv of 12 11 10 03 02 in Tye's pinout
% numSols = length(pointerArray);
% for ii = 1:numSols
%     jj = pointerArray(ii);
%     plot( f_rec(:,jj), Zest(:,jj) , 'o', ...
%             'MarkerEdgeColor', colorArray(ii,:));
%     hold on
% end
% xlabel( 'Frequency (Hz)' )
% ylabel( 'mag(Z) (Ohm)' ) 
% title('')