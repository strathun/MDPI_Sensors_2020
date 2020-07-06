%% experiment_noiseCharacterization_Gamry_Custom_Agilent_20200323
% Looking at noise characterization (impedance predicted noise for gamry
% and custom pot.) between 3 systems. Partially to troubleshoot the gamry
% and partly to see which of the two potentiostats more closely aligns with
% noise measurements.
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

% Top two are for primary comparisons, this one is to see how much change
% took place throughout the entire characterization
[gamryStructure_Round2] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200323_TDT22_InVitro_OldPBS_Round2');

%% Extract Noise data
[ noiseStructure ] = ...
    combineNoiseSpans( '../rawData/Agilent/2020-03-23_TDT22_InVitro_OldPBS' );

%% Calc impedance predicted noise data and plot
kT = 300*( 1.38e-23 );
[~, numTraces] = size( noiseStructure );
for ii = 1:numTraces
    figure(ii)
    loglog( noiseStructure(ii).F, noiseStructure(ii).Spectrum * 1e9, 'k')
    hold on
    loglog( gamryStructure(ii).f, ...
            sqrt( 4 * kT * gamryStructure(ii).Zreal ) * ( 1e9 ), '--' )
    % Convert from Tye's pinout to gamry
    [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
    loglog( f_rec(:,jj), ...
            sqrt( 4 * kT * Zest(:,jj) ) * ( 1e9 ), '.') 
    xlim([100 10e3]); 
    ylim([1 100]);
    title(([sprintf('Noise for Electrode #%02d',ii)]))
    xlabel('Frequency (Hz)')
    ylabel('Noise Voltage (nV/$$\sqrt{Hz}$$)','Interpreter','latex')
    legend('Agilent', 'Gamry', 'Custom')
end

%% Plot Gamry 2nd pass
% This is to see if any significant change took place throughout the course
% of measurements
[~, numTraces] = size( gamryStructure_Round2 );
electrodeOrder = [ 01 05 08 09 12 16 ]; % Manually set from *_Round2
for ii = 1:numTraces
    jj = electrodeOrder(ii);
    figure( jj )
    loglog( gamryStructure_Round2(ii).f, ...
            sqrt( 4 * kT * gamryStructure_Round2(ii).Zreal ) * ( 1e9 ), '--', ...
            'Color', 'r')
end


%% Plot Agilent's "raw" traces
% Want to see which Agilent recording might have questionable measurements
% at lower frequencies
[~, numTraces] = size( noiseStructure );
for ii = 1:numTraces
    figure    
    loglog( gamryStructure(ii).f, ...
            sqrt( 4 * kT * gamryStructure(ii).Zreal ) * ( 1e9 ), '--' )
    hold on
    % Convert from Tye's pinout to gamry
    [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
    loglog( f_rec(:,jj), ...
            sqrt( 4 * kT * Zest(:,jj) ) * ( 1e9 ), '.') 
    % Agilent
    loglog( noiseStructure(ii).PSDF{1}, noiseStructure(ii).PSD{1} * 1e9)
    xlim([100 10e3]); 
    ylim([1 100]);
    title(([sprintf('Noise for Electrode #%02d',ii)]))
    xlabel('Frequency (Hz)')
    ylabel('Noise Voltage (nV/$$\sqrt{Hz}$$)','Interpreter','latex')
    legend('Gamry', 'Custom')
end

%% 
% Gamry actually matches noise pretty well at higher impedances...
% On first pass, looks like the custom pot. matches better... Still
% problems at low frequency for alot. 
%%
% Interestingly, we see a decrease in impedance across the board for
% measurements taken with the Gamry at the beginning of the experiment to
% the end. While the decrease in impedance is expected with increased soak
% time, it highlights the significance of whatever error is occuring with
% the Gamry. 
%%
% So, if we look at the fully de-embedded individual spans, it the custom
% pot actually agrees even better! We really need to figure out what's up
% with the Gamry...

%% Plot Gamry v Custom Impedance
[~, numTraces] = size( noiseStructure );
figure
for ii = 1:numTraces
    loglog( gamryStructure(ii).f, ...
            gamryStructure(ii).Zreal )
        hold on
    % Convert from Tye's pinout to gamry
    [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
    loglog( f_rec(:,jj), ...
            Zest(:,jj) , '.') 
end
xlim([100 10000])
xlabel('Frequency (Hz)')
ylabel('Real(Impedance)')