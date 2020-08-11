%% plotScript_Gamry_headstageVerification_2020810
% Made a new head stage so that we could get up to 16 channels (connected)
% to get a better comparison to the mux. This is just to make sure that the
% new headstage matches the older one

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
[gamryStructure_newHS] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200810_TDT22_inVitro_OldPBS_brOutHS');
[gamryStructure_oldHS] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200810_TDT22_inVitro_OldPBS');

load('..\rawData\CustomPot\20200810_TDT22_InVitro_OldPBS\2020-08-10_13hr_20min_34sec_MUX_TDT22_Invitro_OldPBS_EAll')

%% Plot Impedance (new vs Old HS)
[~, numTraces] = size( gamryStructure_newHS );
[~, numTraces_old] = size( gamryStructure_oldHS );
figure(1)
colorArray = lines( numTraces );
for ii = 1:numTraces
    loglog( gamryStructure_newHS(ii).f, ...
            gamryStructure_newHS(ii).Zmag, ...
            'Color', colorArray( ii, : ))
        hold on
        if ii <= numTraces_old
            loglog( gamryStructure_oldHS(ii).f, ...
                    gamryStructure_oldHS(ii).Zmag, ...
                    'o', 'Color', colorArray( ii, : ))
        end
end
xlim([10 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
legend('New HS', 'Old HS')
title('Verifying New Break-Out HS Works Same as Old (Both Gamry)')

%%
% Comparisons look spot on! New headstage appears to be ready to use.

%% Plot Impedance (Gamry (new HS) vs Mux Pstat)
[~, numTraces] = size( gamryStructure_newHS );
figure
colorArray = lines( numTraces );
for ii = 1:numTraces
    loglog( gamryStructure_newHS(ii).f, ...
            gamryStructure_newHS(ii).Zmag, ...
            'Color', colorArray( ii, : ))
        hold on
    % Convert from Tye's pinout to gamry
    [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
    loglog( f_rec(:,jj), ...
            Zest(:,jj) , 'o', ...
            'Color', colorArray( ii, : )) 
end
xlim([100 10000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
legend('Gamry', 'Custom')
title('In Vitro Comparison; Gamry V Custom')

%% 
% Looks like we see pretty significant differences here

%% Plot Real Impedance (Gamry (new HS) vs Mux Pstat)
% Just wanted to see if this made any difference in the comparions. Looks
% to have made it worse (as expected). 
[~, numTraces] = size( gamryStructure_newHS );
figure
colorArray = lines( numTraces );
for ii = 1:numTraces
    loglog( gamryStructure_newHS(ii).f, ...
            gamryStructure_newHS(ii).Zreal, ...
            'Color', colorArray( ii, : ))
        hold on
    % Convert from Tye's pinout to gamry
    [ jj ] = pinoutConverter( 'gamry', 'customPot', 'trodeSpecifier', ii );
    loglog( f_rec(:,jj), ...
            Zest(:,jj) , 'o', ...
            'Color', colorArray( ii, : )) 
end
xlim([100 10000])
xlabel('Frequency (Hz)')
ylabel('Real(Impedance)')
legend('Gamry', 'Custom')
title('In Vitro Comparison; Gamry V Custom')

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