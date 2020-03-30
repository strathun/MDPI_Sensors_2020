%% plotScript_comparison_ImpedancePhase_20200323
% Compares magnitude of impedance and phase of gamry and custom phate
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

%% Plot Mag Impedance 
[~, numTraces] = size( gamryStructure );
colorArray = lines( numTraces );
figure
for ii = 1:numTraces
    loglog( gamryStructure( ii ).f, ...
            gamryStructure( ii ).Zmag, ...
            'Color', colorArray(ii,:))
    hold on
    % Convert from Tye's pinout to gamry
    [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
    loglog( f_rec(:,jj), ...
            Zest(:,jj), 'o', 'Color', colorArray( ii, : ) ) 
    xlim([100 10e3]); 
    xlabel('Frequency (Hz)')
    ylabel('Mag(Impedance)')
end

%%
% Do not match at all! Gamry is consistently lower

%% 
[~, numTraces] = size( gamryStructure );
colorArray = lines( numTraces );
figure
for ii = 1:numTraces
    loglog( gamryStructure( ii ).f, ...
            gamryStructure( ii ).Phase * (-1), ...
            'Color', colorArray(ii,:))
    hold on
    % Convert from Tye's pinout to gamry
    [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
    loglog( f_rec(:,jj), ...
            phases_rec(:,jj), 'o', 'Color', colorArray( ii, : ) ) 
%     xlim([100 10e3]); 
    xlabel('Frequency (Hz)')
    ylabel('Phase')
end

%%
% Seemed like Tye's is maybe off by two orders of magnitude?
% Will eventually check with him if this seems correct. DELETE THIS
% WHEN I DO.