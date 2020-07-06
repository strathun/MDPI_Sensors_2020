%% experiment_palmSensVCustomVGamry_ImpedancePhase_20200629
% This is a comparison for impedance magnitude and phase measurements from
% Tye's custom pot. (with and without channels floated), PalmSens and the Gamry. 
% All data from experiment on 20200629

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
    extractImpedanceDataGlobal('..\rawData\Gamry\20200629_TDT22_InVitro_OldPBS');
load('..\rawData\CustomPot\20200629_TDT22_InVitro_OldPBS\2020-06-29_14hr_00min_29sec_NonMux_5V_nonInv')
combinePalmData;


%% Plot Impedance Comparison
figure
numElectrodes = length( palmSensStructure );
colorArray = lines(numElectrodes);
for ii = 1:1
    jj = ii + 1;
    loglog( gamryStructure(jj).f, ...
            gamryStructure(jj).Zmag, ...
            'Color', colorArray( ii, : ) )
    hold on
    loglog( palmSensStructure(ii).Frequency, ...
            palmSensStructure(ii).Z, ...
            'o', 'Color', colorArray( ii, : ))
        
    loglog( f_rec(16, :), Zest(16, :) , '*', ...
            'Color', colorArray( ii, : ) );
end
xlabel( 'Frequency (Hz)' )
ylabel( 'mag(Z) (Ohm)' ) 
title( 'Impedance Comparisons' )
legend( 'Gamry', 'PalmSens', 'Custom' )


% %% Plot Mag Impedance of Round 1 Gamry
% figure
% numSols = length(gamryStructure);
% colorArray = lines(numSols);
% for ii = 1:numSols
%     loglog( gamryStructure(ii).f, ...
%             gamryStructure(ii).Zmag, ...
%             'Color', colorArray( ii, : ) )
%     [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
%     hold on
%     loglog( f_rec(:, jj), Zest(:, jj) , 'o', ...
%             'Color', colorArray( ii, : ) );
% end
% xlabel( 'Frequency (Hz)' )
% ylabel( 'mag(Z) (Ohm)' ) 
% title('Impedance Mag; Gamry vs Custom Pot')
% leg = legend(' ');
% title(leg, '- = Gamry; o = Custom Pot.')

% %% Percent Error
% % Plots percent error between the two systems
% figure
% numSols = length(gamryStructure);
% for ii = 1:numSols
% [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
% % Interp to Gamry resolution
% customPot_interpolated = interp1( f_rec(:, jj), Zest(:, jj), ...
%                 gamryStructure(ii).f );
% % Calc. % error and plot
% impedance_difference = abs( customPot_interpolated - ...
%                             gamryStructure(ii).Zmag );
% percent_error = ( impedance_difference ./ gamryStructure(ii).Zmag ) * 100 ;
% semilogx( gamryStructure(ii).f, percent_error )
% hold on          
% end
% xlabel( 'Frequency (Hz)' )
% ylabel( '% Error' ) 
% title('Impedance Mag; % Error')

% %% Plot Phase of Round 1 Gamry vs Custom
% figure(6)
% numSols = length(gamryStructure);
% colorArray = lines(numSols);
% phases_rec_degrees = (-1)*( rad2deg( phases_rec ) ) ; % Phase comes in as radians
% for ii = 1:numSols
%     semilogx( gamryStructure(ii).f, ...
%             gamryStructure(ii).Phase, ...
%             '.' , 'Color', colorArray( ii, : ) )
%     hold on
%     [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
%     semilogx( f_rec(:, jj), phases_rec_degrees(:, jj), 'o', ...
%             'Color', colorArray( ii, : ) );
% end
% xlabel( 'Frequency (Hz)' )
% ylabel( 'Phase' ) 
% title('Phase; Gamry vs Custom Pot')
% leg = legend(' ');
% title(leg, '- = Gamry; o = Custom Pot.')

%%
% 