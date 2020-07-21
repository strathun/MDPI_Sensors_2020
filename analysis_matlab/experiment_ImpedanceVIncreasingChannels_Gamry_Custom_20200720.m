%% experiment_ImpedanceVIncreasingChannels_Gamry_Custom_20200720
% Attempting to recreate the errors with increasing channel count that were
% seen with the custom system on 20200629
% Tried to mimic this effect by connecting channels not being measured with
% the gamry to gamry's floating ground

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
    extractImpedanceDataGlobal('..\rawData\Gamry\20200720_TDT22_inVitro_OldPBS');

% Custom
% 1 channel
load('..\rawData\CustomPot\20200720_TDT22_InVitro_OldPBS\2020-07-20_13hr_37min_59sec_MUX_TDT22_Invitro_OldPBS_E01')
customStructure(1).electrodes = 1;
customStructure(1).f = f_rec(:,1);
customStructure(1).Z = Zest(:,1);
% 2 channel
load('..\rawData\CustomPot\20200720_TDT22_InVitro_OldPBS\2020-07-20_13hr_47min_56sec_MUX_TDT22_Invitro_OldPBS_E01_E16')
customStructure(2).electrodes = 2;
customStructure(2).f = f_rec(:,1);
customStructure(2).Z = Zest(:,1);
% 4 channel
load('..\rawData\CustomPot\20200720_TDT22_InVitro_OldPBS\2020-07-20_13hr_58min_13sec_MUX_TDT22_Invitro_OldPBS_E01_E16E06E11')
customStructure(3).electrodes = 4;
customStructure(3).f = f_rec(:,1);
customStructure(3).Z = Zest(:,1);
% 16 channel
load('..\rawData\CustomPot\20200720_TDT22_InVitro_OldPBS\2020-07-20_12hr_53min_12sec_MUX_TDT22_Invitr_OldPBS')
customStructure(4).electrodes = 16;
customStructure(4).f = f_rec(:,1);
customStructure(4).Z = Zest(:,1);


%% Plot Gamry v Custom Impedance
[~, numTraces] = size( customStructure );
figure
colorArray = lines( numTraces );
pointerArray = [ 4 3 1 ]; % pointer for Gamry
for ii = 1:4
    loglog( customStructure(ii).f, ...
            customStructure(ii).Z , '--', ...
            'Color', colorArray( ii, : )) 
        hold on
end
for ii = 1:3
    jj = pointerArray( ii );
    loglog( gamryStructure(jj).f, ...
            gamryStructure(jj).Zmag, ...
            'Color', colorArray( ii, : ))
end
xlim([100 10000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
legend('1 electrode', '2 electrodes', '4 electrodes', '16 electrodes')
title('In Vitro Impedance and Number of Electrodes; Gamry (-) V Custom (- -)')

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