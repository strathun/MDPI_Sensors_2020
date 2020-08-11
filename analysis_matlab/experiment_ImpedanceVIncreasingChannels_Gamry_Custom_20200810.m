%% experiment_ImpedanceVIncreasingChannels_Gamry_Custom_20200810
% Attempting to recreate the errors with increasing channel count that were
% seen with the custom system on 20200629
% Tried to mimic this effect by connecting channels not being measured with
% the gamry to gamry's floating ground.
% This is a repeat of the 2020720 experiment, that was a more direct
% comparison and took the Gamry up to 16 electrodes. 

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
% Gamry
[gamryStructure] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200810_TDT22_inVitro_OldPBS_brOutHS');

[customStructure] = ...
    extractCustomPstatData('..\rawData\CustomPot\20200810_TDT22_InVitro_OldPBS');


%% Plot Gamry Impedance vs increasing electrode number
figure
colorArray = lines( 5 );
pointerArray = [ 34 29 28 27 30]; 
for ii = 1:5
    jj = pointerArray( ii );
    loglog( gamryStructure(jj).f, ...
            gamryStructure(jj).Zmag, ...
            'Color', colorArray( ii, : ))
    hold on
end
% Print repeat of single electrode measurement to show drift
loglog( gamryStructure(35).f, ...
        gamryStructure(35).Zmag, ...
        'o', 'Color', colorArray( 1, : ))
grid on
xlim([100 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
title('In Vitro Impedance and Number of Electrodes; Gamry E16')
leg = legend('1', '2', '4', '8', '16', '1 (repeated)');
title(leg,'Connected Electrodes');

%% Plot Custom Impedance vs increasing electrode number
figure
colorArray = lines( 5 );
kk = 1; % counter for colorArray to match Gamry
for ii = 10:24
    loglog( customStructure(ii).f(:,1), ...
            customStructure(ii).Zmag(:,1), ...
            'Color', colorArray( kk, : ))
    hold on
    jj = ii - 9;
    if mod(jj,3) == 0
        kk = kk + 1;
    end
end
grid on
xlim([100 10000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
title('In Vitro Impedance and Number of Electrodes; Custom E16')
leg = legend('1', '2', '4', '8', '16');
title(leg,'Connected Electrodes');


%% Plot Gamry Impedance vs increasing electrode number
% Repeating this with the original electrode (does not have a direct
% comparison with custom, just want to see if the effect is as dramatic.
figure
colorArray = lines( 5 );
pointerArray = [ 11 5 3 1 7 ]; 
for ii = 1:5
    jj = pointerArray( ii );
    loglog( gamryStructure(jj).f, ...
            gamryStructure(jj).Zmag, ...
            'Color', colorArray( ii, : ))
    hold on
end
grid on
xlim([100 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
title('In Vitro Impedance and Number of Electrodes; Gamry E01')
leg = legend('1', '2', '4', '8', '16');
title(leg,'Connected Electrodes');

%% Multiplexed vs non Multiplexed for E16 (Custom)
figure
colorArray = lines( 2 );
kk = 1; % counter for colorArray to match Gamry
for ii = 22:27
    loglog( customStructure(ii).f(:,1), ...
            customStructure(ii).Zmag(:,1), ...
            'Color', colorArray( kk, : ))
    hold on
    jj = ii - 21;
    if mod(jj,3) == 0
        kk = kk + 1;
    end
end
grid on
xlim([100 10000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
title('Muxd vs Non-Muxd Impedance for Single Electrode; Custom E16')
% leg = legend('1', '2', '4', '8', '16');
% title(leg,'Connected Electrodes');

%%
% Interesting that the drift seems to restart when we switch to the muxd...
% maybe not drift??
%%
% %% Difference between systems
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
% ylabel( '% Difference Relative to Gamry' ) 
% title(' % Difference of mag(impedance) of Custom Pstat Relative to Gamry')