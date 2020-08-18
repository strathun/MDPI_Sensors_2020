%% experiment_GamryVCustom_singleElectrode_20200817
% This is a comparison for all 16 electrodes of TDT22 between EIS
% measurments from the Gamry and the Custom pstat. Both pstats had a single
% electrode connected for each measurement. For the custom pstat this means
% one pull down resistor was connected for each electrode measured. 

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
    extractImpedanceDataGlobal('..\rawData\Gamry\20200817_TDT22_InVitro_OldPBS');

[customStructure] = ...
    extractCustomPstatData('..\rawData\CustomPot\20200817_TDT22_InVitro_OldPBS');

%% Plot Impedance (Gamry vs Custom, single electrode)
figure(1)
colorArray = lines( 16 );
kk = 1;
ll = 2;
pointerArray = [17 16 15 14 12 13 11 10 9 8 7 6 5 4 3 2]; % Accounts for me accidentally measuring one electrode out of order
for ii = 1:16
    loglog( gamryStructure(kk).f, ...
            gamryStructure(kk).Zmag, ...
            'Color', colorArray( ii, : ))
        hold on
    loglog( gamryStructure(ll).f, ...
            gamryStructure(ll).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    % Convert from Tye's pinout to gamry
    mm = pointerArray(ii);
    [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
    loglog( customStructure(mm).f(:,jj), ...
            customStructure(mm).Zmag(:,jj) , 'o', ...
            'Color', colorArray( ii, : ))
    kk = kk + 2;
    ll = ll + 2;
end
xlim([10 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
legend('Gamry - R1', 'Gamry - R2', 'Custom')
title('Single Electrode Comparison')

%%
% Very strange... Seems to be all over the place

%% Plot Impedance Gamry, before and after Custom
figure
colorArray = lines( 16 );
kk = 1;
ll = 2;
for ii = 1:16
    loglog( gamryStructure(kk).f, ...
            gamryStructure(kk).Zmag, ...
            'Color', colorArray( ii, : ))
        hold on
    loglog( gamryStructure(ll).f, ...
            gamryStructure(ll).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    kk = kk + 2;
    ll = ll + 2;
end
xlim([10 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
legend('Gamry - Before', 'Gamry - After' )
title('Impedance Changes from Custom Pstat Measurements - Gamry')

%% Plot Impedance (Gamry vs Custom, single electrode)
figure
colorArray = lines( 16 );
pointerArray1 = [2 3 4 5 6 7 8 9 10 11 13 12 14 15 16 17]; % Accounts for me accidentally measuring one electrode out of order           
for ii = 1:16
    mm = pointerArray(ii);
    loglog( customStructure(mm).f(:,(mm-1)), ...
            customStructure(mm).Zmag(:,(mm-1)), ...
            'Color', colorArray( ii, : ))
        hold on
    loglog( customStructure(1).f(:,ii), ...
            customStructure(1).Zmag(:,ii), 'o', ...
            'Color', colorArray( ii, : ))
end
xlim([100 10000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
legend('Custom - Single', 'Custom - Mux')
title('Single Electrode Comparison')

%%
% %% Plot Impedance (Gamry (new HS) vs Mux Pstat)
% [~, numTraces] = size( gamryStructure );
% figure
% colorArray = lines( numTraces );
% for ii = 1:numTraces
%     loglog( gamryStructure(ii).f, ...
%             gamryStructure(ii).Zmag, ...
%             'Color', colorArray( ii, : ))
%         hold on
%     % Convert from Tye's pinout to gamry
%     [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
%     loglog( f_rec(:,jj), ...
%             Zest(:,jj) , 'o', ...
%             'Color', colorArray( ii, : )) 
% end
% xlim([100 10000])
% xlabel('Frequency (Hz)')
% ylabel('Mag(Impedance)')
% legend('Gamry', 'Custom')
% title('In Vitro Comparison; Gamry V Custom')
% 
% %% 
% % Looks like we see pretty significant differences here
% 
% %% Plot Real Impedance (Gamry (new HS) vs Mux Pstat)
% % Just wanted to see if this made any difference in the comparions. Looks
% % to have made it worse (as expected). 
% [~, numTraces] = size( gamryStructure );
% figure
% colorArray = lines( numTraces );
% for ii = 1:numTraces
%     loglog( gamryStructure(ii).f, ...
%             gamryStructure(ii).Zreal, ...
%             'Color', colorArray( ii, : ))
%         hold on
%     % Convert from Tye's pinout to gamry
%     [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
%     loglog( f_rec(:,jj), ...
%             Zest(:,jj) , 'o', ...
%             'Color', colorArray( ii, : )) 
% end
% xlim([100 10000])
% xlabel('Frequency (Hz)')
% ylabel('Real(Impedance)')
% legend('Gamry', 'Custom')
% title('In Vitro Comparison; Gamry V Custom')

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