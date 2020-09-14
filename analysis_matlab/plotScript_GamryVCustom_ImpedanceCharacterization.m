%% plotScript_GamryVCustom_ImpedanceCharacterization
% This is an attempt to collect all of the current direct comparisons we
% have between the gamry and custom potentiostat. 
% Focus will be on in vitro initially.

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
[gamryStructure_20200817_r1] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200817_TDT22_InVitro_OldPBS_r1');
[customStructure_20200817] = ...
    extractCustomPstatData('..\rawData\CustomPot\20200817_TDT22_InVitro_OldPBS');
[gamryStructure_20200817_r2] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200817_TDT22_InVitro_OldPBS_r2');

[gamryStructure_20200810] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200810_TDT22_inVitro_OldPBS_brOutHS_normal16');
[customStructure_20200810] = ...
    extractCustomPstatData('..\rawData\CustomPot\20200810_TDT22_InVitro_OldPBS');


%% Plot Impedance comparison for 20200817_r1
% Each electrode
figure
colorArray = lines( 16 );
for ii = 1:16
    subplot(4,4,ii)
    hold on
    [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
    loglog( gamryStructure_20200817_r1(ii).f, ...
            gamryStructure_20200817_r1(ii).Zmag, ...
            'Color', colorArray( ii, : ))
    loglog( customStructure_20200817(1).f(:,jj), ...
            customStructure_20200817(1).Zmag(:,jj), 'o', ...
            'Color', colorArray( ii, : )) 
    set(gca,'XScale','log','YScale','log')
    legend('Gamry','Custom')
    xlim([100 10000])
end
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')

% Averages
for ii = 1:16
    avgArray_gamry(:,ii) =  gamryStructure_20200817_r1(ii).Zmag;
    avgArray_custom(:,ii) = customStructure_20200817(1).Zmag(:,ii);
end
mean_gamry = mean(avgArray_gamry, 2);
std_gamry = std( avgArray_gamry, 0, 2);
mean_custom = mean(avgArray_custom, 2);
std_custom = std( avgArray_custom, 0, 2);

figure
hold on
errorbar( gamryStructure_20200817_r1(ii).f, ...
        mean_gamry, std_gamry);
errorbar( customStructure_20200817(1).f(:,1), ...
        mean_custom, std_custom);
set(gca,'XScale','log','YScale','log') 
legend('Gamry', 'Custom')
xlim([100 10000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')

%% Plot Impedance comparison for 20200817_r2
% Each electrode
figure
colorArray = lines( 16 );
for ii = 1:16
    subplot(4,4,ii)
    hold on
    [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
    loglog( gamryStructure_20200817_r2(ii).f, ...
            gamryStructure_20200817_r2(ii).Zmag, ...
            'Color', colorArray( ii, : ))
    loglog( customStructure_20200817(1).f(:,jj), ...
            customStructure_20200817(1).Zmag(:,jj), 'o', ...
            'Color', colorArray( ii, : )) 
    set(gca,'XScale','log','YScale','log')
    legend('Gamry','Custom')
    xlim([100 10000])
end
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')

% Averages
for ii = 1:16
    avgArray_gamry(:,ii) =  gamryStructure_20200817_r2(ii).Zmag;
    avgArray_custom(:,ii) = customStructure_20200817(1).Zmag(:,ii);
end
mean_gamry = mean(avgArray_gamry, 2);
std_gamry = std( avgArray_gamry, 0, 2);
mean_custom = mean(avgArray_custom, 2);
std_custom = std( avgArray_custom, 0, 2);

figure
hold on
errorbar( gamryStructure_20200817_r2(ii).f, ...
        mean_gamry, std_gamry);
errorbar( customStructure_20200817(1).f(:,1), ...
        mean_custom, std_custom);
set(gca,'XScale','log','YScale','log') 
legend('Gamry', 'Custom')
xlim([100 10000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')

%% Plot Impedance comparison for 20200817_r2
% Each electrode
figure
colorArray = lines( 16 );
for ii = 1:16
    subplot(4,4,ii)
    hold on
    [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
    loglog( gamryStructure_20200810(ii).f, ...
            gamryStructure_20200810(ii).Zmag, ...
            'Color', colorArray( ii, : ))
    loglog( customStructure_20200810(1).f(:,jj), ...
            customStructure_20200810(1).Zmag(:,jj), 'o', ...
            'Color', colorArray( ii, : )) 
    set(gca,'XScale','log','YScale','log')
    legend('Gamry','Custom')
    xlim([100 10000])
end
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')

% Averages
for ii = 1:16
    avgArray_gamry(:,ii) =  gamryStructure_20200810(ii).Zmag;
    avgArray_custom(:,ii) = customStructure_20200810(1).Zmag(:,ii);
end
mean_gamry = mean(avgArray_gamry, 2);
std_gamry = std( avgArray_gamry, 0, 2);
mean_custom = mean(avgArray_custom, 2);
std_custom = std( avgArray_custom, 0, 2);

figure
hold on
errorbar( gamryStructure_20200810(ii).f, ...
        mean_gamry, std_gamry);
errorbar( customStructure_20200810(1).f(:,1), ...
        mean_custom, std_custom);
set(gca,'XScale','log','YScale','log') 
legend('Gamry', 'Custom')
xlim([100 10000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')

