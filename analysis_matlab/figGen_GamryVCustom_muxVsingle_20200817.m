%% figGen_GamryVCustom_muxVsingle_20200817
% Adapted from experiment_GamryVCustom_singleElectrode_20200817. Used for a
% figure for NERG presentation on 20210119.
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
figure
colorArray = lines( 6 );
% kk = 17;    % Points to electrode 9 (2 runs per electrode)
kk = 21;
ll = 2;
% pointerArray = [17 16 15 14 12 13 11 10 9 8 7 6 5 4 3 2]; % Accounts for me accidentally measuring one electrode out of order
% pointerArray = [9 8 7 6 5 4 3 2];
pointerArray = [7 6 5 4 3 2];
% Vs Gamry Run 1
for ii = 1:6
%     subplot(4,2,ii)
    loglog( gamryStructure(kk).f, ...
            gamryStructure(kk).Zmag, ...
            'Color', colorArray( ii, : ), ...
            'LineWidth', 1.5)
        hold on
    % Convert from Tye's pinout to gamry
    mm = pointerArray(ii);
    [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii + 10 );
    loglog( customStructure(mm).f(:,jj), ...
            customStructure(mm).Zmag(:,jj) , 'o', ...
            'Color', colorArray( ii, : ), ...
            'LineWidth', 1.5)
    kk = kk + 2;
    xlim([70 10000])
    ylim([800 30000])
    legend('Gamry', 'Custom')
    grid on
end
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')

%% Plot Impedance (Gamry vs Custom, muxd)
figure
colorArray = lines( 6 );
kk = 21;
pointerArray = [7 6 5 4 3 2];
for ii = 1:6
    loglog( gamryStructure(kk).f, ...
            gamryStructure(kk).Zmag, ...
            'Color', colorArray( ii, : ), ...
            'LineWidth', 1.5)
        hold on
    % Convert from Tye's pinout to gamry
    mm = pointerArray(ii);
    [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii + 10 );
    loglog( customStructure(1).f(:,jj), ...
            customStructure(1).Zmag(:,jj) , 'o', ...
            'Color', colorArray( ii, : ), ...
            'LineWidth', 1.5)
    kk = kk + 2;
    xlim([70 10000])
    ylim([800 30000])
    legend('Gamry', 'Custom')
    grid on
end
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')


