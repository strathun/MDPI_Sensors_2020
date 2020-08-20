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

%% Plot Impedance (Gamry vs Custom, single electrode) (Individual)
figure
colorArray = lines( 16 );
kk = 1;
ll = 2;
pointerArray = [17 16 15 14 12 13 11 10 9 8 7 6 5 4 3 2]; % Accounts for me accidentally measuring one electrode out of order
% Vs Gamry Run 1
for ii = 1:16
    subplot(4,4,ii)
    loglog( gamryStructure(kk).f, ...
            gamryStructure(kk).Zmag, ...
            'Color', colorArray( ii, : ))
        hold on
    % Convert from Tye's pinout to gamry
    mm = pointerArray(ii);
    [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
    loglog( customStructure(mm).f(:,jj), ...
            customStructure(mm).Zmag(:,jj) , 'o', ...
            'Color', colorArray( ii, : ))
    kk = kk + 2;
    xlim([10 100000])
    legend('Gamry - R1', 'Custom')
    grid on
end
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')


% Vs Gamry Run 2
figure
for ii = 1:16
    subplot(4,4,ii)
    loglog( gamryStructure(ll).f, ...
            gamryStructure(ll).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    hold on
    % Convert from Tye's pinout to gamry
    mm = pointerArray(ii);
    [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
    loglog( customStructure(mm).f(:,jj), ...
            customStructure(mm).Zmag(:,jj) , 'o', ...
            'Color', colorArray( ii, : ))
    ll = ll + 2;
    xlim([10 100000])
    legend('Gamry - R2', 'Custom')
    grid on
end
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')

%% Plot Impedance (Gamry vs Custom, single electrode) (Array Averages)
kk = 1;
ll = 2;
pointerArray = [17 16 15 14 12 13 11 10 9 8 7 6 5 4 3 2]; % Accounts for me accidentally measuring one electrode out of order
for ii = 1:16
    gamryArray_r1(ii,:) = gamryStructure(kk).Zmag;
    gamryArray_r2(ii,:) = gamryStructure(ll).Zmag; 
    % Convert from Tye's pinout to gamry
    mm = pointerArray(ii);
    [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
    customArray(ii,:) =  customStructure(mm).Zmag(:,jj);
    kk = kk + 2;
    ll = ll + 2;
end

gamryAvg_r1 = mean( gamryArray_r1, 1 );
gamrystd_r1 = std( gamryArray_r1, 1 );
gamryAvg_r2 = mean( gamryArray_r2, 1 );
gamrystd_r2 = std( gamryArray_r2, 1 );
customAvg   = mean( customArray,   1 );
customstd   = std( customArray,   1 );

figure
errorbar( gamryStructure(1).f, gamryAvg_r1, gamrystd_r1 );
hold on
errorbar( gamryStructure(1).f, gamryAvg_r2, gamrystd_r2 );
errorbar( customStructure(1).f(:,1), customAvg, customstd );

set(gca,'XScale','log','YScale','log') 
xlim([10 100000])
legend('Gamry - R1', 'Gamry - R2', 'Custom')
grid on
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')

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

%% Plot Impedance Gamry, before and after Custom (Single Electrodes)
figure
colorArray = lines( 16 );
kk = 1;
ll = 2;
for ii = 1:16
    subplot(4,4,ii)
    loglog( gamryStructure(kk).f, ...
            gamryStructure(kk).Zmag, ...
            'Color', colorArray( ii, : ))
        hold on
    loglog( gamryStructure(ll).f, ...
            gamryStructure(ll).Zmag, ...
            '--', 'Color', colorArray( ii, : ))
    kk = kk + 2;
    ll = ll + 2;
    xlim([10 100000])
    grid on
    legend('Gamry - Before', 'Gamry - After' )
end
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')


%% Plot Impedance Gamry, before and after Custom (Array Averages)
% Pulled from above
figure
errorbar( gamryStructure(1).f, gamryAvg_r1, gamrystd_r1 );
hold on
errorbar( gamryStructure(1).f, gamryAvg_r2, gamrystd_r2 );

set(gca,'XScale','log','YScale','log') 
xlim([10 100000])
legend('Gamry - R1', 'Gamry - R2')
grid on
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')

%% Plot Phase (Gamry, before and after Custom )(Array Averages)
kk = 1;
ll = 2;
for ii = 1:16
    gamryPhaseArray_r1(ii,:) = gamryStructure(kk).Phase;
    gamryPhaseArray_r2(ii,:) = gamryStructure(ll).Phase; 
    kk = kk + 2;
    ll = ll + 2;
end

gamryPhaseAvg_r1 = mean( gamryPhaseArray_r1, 1 );
gamryPhasestd_r1 = std( gamryPhaseArray_r1, 1 );
gamryPhaseAvg_r2 = mean( gamryPhaseArray_r2, 1 );
gamryPhasestd_r2 = std( gamryPhaseArray_r2, 1 );

figure
errorbar( gamryStructure(1).f, gamryPhaseAvg_r1, gamryPhasestd_r1 );
hold on
errorbar( gamryStructure(1).f, gamryPhaseAvg_r2, gamryPhasestd_r2 );

set(gca,'XScale','log','YScale','log') 
xlim([10 100000])
legend('Gamry - R1', 'Gamry - R2')
grid on
xlabel('Frequency (Hz)')
ylabel('Phase')

%% Plot Impedance (Custom Single vs Custom Mux, All)
figure
colorArray = lines( 16 );
pointerArray1 = [2 3 4 5 6 7 8 9 10 11 13 12 14 15 16 17]; % Accounts for me accidentally measuring one electrode out of order   
for ii = 1:16
    mm = pointerArray1(ii);
    loglog( customStructure(mm).f(:,(ii)), ...
            customStructure(mm).Zmag(:,(ii)), ...
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

%% Plot Impedance (Custom Single vs Custom Mux, single electrode)
figure
colorArray = lines( 16 );
pointerArray1 = [2 3 4 5 6 7 8 9 10 11 13 12 14 15 16 17]; % Accounts for me accidentally measuring one electrode out of order           
for ii = 1:16
    subplot(4,4,ii)
    mm = pointerArray1(ii);
    loglog( customStructure(mm).f(:,(ii)), ...
            customStructure(mm).Zmag(:,(ii)), ...
            'Color', colorArray( ii, : ))
        hold on
    loglog( customStructure(1).f(:,ii), ...
            customStructure(1).Zmag(:,ii), 'o', ...
            'Color', colorArray( ii, : ))
    xlim([100 10000])
    legend('Custom - Single', 'Custom - Mux')
    grid on
end
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')

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