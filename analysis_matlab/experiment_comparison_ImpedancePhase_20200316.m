%% experiment_comparison_ImpedancePhase_20200316
% This is a comparison for impedance magnitude and phase measurements from
% both Tye's custom pot. and the Gamry. 
% All data from experiment on 20200316
% Round 1 data is the inital run through on the Gamry (all vs EREF).
% Round 2 is the pre and post CV measurements
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
    extractImpedanceDataGlobal('..\rawData\Gamry\20200316_TDT21_Day03\Impedance\Round1');
[gamryStructure_Round2] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200316_TDT21_Day03\Impedance\Round2');
load('..\rawData\CustomPot\20200316_TDT21_Day03\2020-03-16_12hr_14min_18sec_MUX_vivoTDT21_staged')

%% Plot Mag Impedance of Round 1 Gamry
figure
numSols = length(gamryStructure);
colorArray = lines(numSols);
for ii = 1:numSols
    loglog( gamryStructure(ii).f, ...
            gamryStructure(ii).Zmag, ...
            'Color', colorArray( ii, : ) )
    [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
    hold on
    loglog( f_rec(:, jj), Zest(:, jj) , 'o', ...
            'Color', colorArray( ii, : ) );
end
xlabel( 'Frequency (Hz)' )
ylabel( 'mag(Z) (Ohm)' ) 
title('Impedance Mag; Gamry vs Custom Pot')
leg = legend(' ');
title(leg, '- = Gamry; o = Custom Pot.')

%% Percent Error
% Plots percent error between the two systems
figure
numSols = length(gamryStructure);
for ii = 1:numSols
[ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
% Interp to Gamry resolution
customPot_interpolated = interp1( f_rec(:, jj), Zest(:, jj), ...
                gamryStructure(ii).f );
% Calc. % error and plot
impedance_difference = abs( customPot_interpolated - ...
                            gamryStructure(ii).Zmag );
percent_error = ( impedance_difference ./ gamryStructure(ii).Zmag ) * 100 ;
semilogx( gamryStructure(ii).f, percent_error )
hold on          
end
xlabel( 'Frequency (Hz)' )
ylabel( '% Error' ) 
title('Impedance Mag; % Error')

%% Plot Mag Impedance of Round 2 Gamry EOC 
figure(2)
pointerArray = 2:6; % Selects EOC Gamry measurements
numSols = length(pointerArray);
colorArray = lines(numSols);
for ii = 1:numSols
    jj = pointerArray(ii);
    loglog( gamryStructure_Round2(jj).f, ...
            gamryStructure_Round2(jj).Zmag, ...
            'Color', colorArray(ii,:))
    hold on
end
figure(2)
pointerArray = [15 10 8 02 01]; % Equiv of 2 7 9 15 16 in Tye's pinout
numSols = length(pointerArray);
for ii = 1:numSols
    jj = pointerArray(ii);
    plot( f_rec(:,jj), Zest(:,jj) , 'o', ...
            'MarkerEdgeColor', colorArray(ii,:));
    hold on
end
xlabel( 'Frequency (Hz)' )
ylabel( 'mag(Z) (Ohm)' ) 
title('Gamry (OCP) vs Custom')
leg = legend(' ');
title(leg, '- = Gamry; o = Custom Pot.')
%% Plot Mag Impedance of Round 2 Gamry ERef (before CV)
figure(3)
pointerArray = [8 10 12]; % Selects EREF Gamry measurements
numSols = length(pointerArray);
colorArray = lines(numSols);
for ii = 1:numSols
    jj = pointerArray(ii);
    loglog( gamryStructure_Round2(jj).f, ...
            gamryStructure_Round2(jj).Zmag, ...
            'Color', colorArray(ii,:))
    hold on
end
figure(3)
pointerArray = [15 10 8]; % Equiv of 2 7 9 in Tye's pinout
numSols = length(pointerArray);
for ii = 1:numSols
    jj = pointerArray(ii);
    plot( f_rec(:,jj), Zest(:,jj) , 'o', ...
            'MarkerEdgeColor', colorArray(ii,:));
    hold on
end
xlabel( 'Frequency (Hz)' )
ylabel( 'mag(Z) (Ohm)' ) 
title('Gamry (REF) vs Custom')
leg = legend(' ');
title(leg, '- = Gamry; o = Custom Pot.')
%% Comparing Gamry ERef vs EOC
figure(4)
pointerArray = 2:4; % Selects EOC Gamry measurements
numSols = length(pointerArray);
colorArray = lines(numSols);
for ii = 1:numSols
    jj = pointerArray(ii);
    loglog( gamryStructure_Round2(jj).f, ...
            gamryStructure_Round2(jj).Zmag, ...
            'Color', colorArray(ii,:))
    hold on
end
figure(4)
pointerArray = [8 10 12]; % Selects EREF Gamry measurements
numSols = length(pointerArray);
colorArray = lines(numSols);
for ii = 1:numSols
    jj = pointerArray(ii);
    loglog( gamryStructure_Round2(jj).f, ...
            gamryStructure_Round2(jj).Zmag, ...
            '--', 'LineWidth', 2.0, 'Color', colorArray(ii,:))
    hold on
end
xlabel( 'Frequency (Hz)' )
ylabel( 'mag(Z) (Ohm)' ) 
title('Gamry ERef vs EOC')
leg = legend(' ');
title(leg, '- = EOC; -- = REF')
%% Comparing two separate measurements from Tyes pot.
% Just a gut check
figure(5)
[~, numSols] = size(f_rec);
colorArray = lines(numSols);
for ii = 1:numSols
    loglog( f_rec(:,ii), Zest(:,ii) , 'o', ...
            'MarkerEdgeColor', colorArray(ii,:));
    hold on
end
load('..\rawData\CustomPot\20200316_TDT21_Day03\2020-03-16_12hr_06min_25sec_MUX_vivoTDT21_staged')
figure(5)
for ii = 1:numSols
    loglog( f_rec(:,ii), Zest(:,ii), ...
            'color', colorArray(ii,:));
    hold on
end
title('Gut Check; Custom vs Custom')

%% Plot Phase of Round 1 Gamry vs Custom
figure
numSols = length(gamryStructure);
colorArray = lines(numSols);
for ii = 1:numSols
    semilogx( gamryStructure(ii).f, ...
            gamryStructure(ii).Phase, ...
            '.' , 'Color', colorArray( ii, : ) )
    hold on
    [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
    semilogx( f_rec(:, jj), phases_rec(:, jj), 'o', ...
            'Color', colorArray( ii, : ) );
end
xlabel( 'Frequency (Hz)' )
ylabel( 'Phase' ) 
title('Phase; Gamry vs Custom Pot')
leg = legend(' ');
title(leg, '- = Gamry; o = Custom Pot.')
%%
% Not sure what's up with Tye's phase. 