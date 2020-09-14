%% experiment_Gamry_ImpedanceConsistency_OldCapVsNew
% Wanted to test to see if there are any differences between the two vial
% caps we use. Might account for some of the differences in the TDTs we've
% seen. These measurements were made in a single session using the same
% (completely fresh) TDT array

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
    extractImpedanceDataGlobal('..\rawData\Gamry\20200821_TDT23_InVitro_OldPBS');

%% Plot Impedance (new vs Old)

% pointerArray = [4 1 3 8 5 7 12 9 11];
pointerArray = [4 8 12];
[~, numTraces] = size( pointerArray );
colorArray = lines(3);
kk = 1;
ll = 1;
for ii = 1:numTraces
    figure(ii)
    jj = pointerArray(ii);
    loglog( gamryStructure(jj).f, ...
            gamryStructure(jj).Zmag, ...
            'Color', colorArray( kk, : ))
    hold on
    loglog( gamryStructure(jj - 3).f, ...
            gamryStructure(jj - 3).Zmag, '--', ...
            'Color', colorArray( kk, : ))
    loglog( gamryStructure(jj - 1).f, ...
            gamryStructure(jj - 1).Zmag, 'o', ...
            'Color', colorArray( kk, : ))
        hold on
%     if mod(ii,3) == 0
%         kk = kk + 1;
%         ll = ll + 1;
%     end
grid on
xlim([10 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
legend('Old HS - r1', 'New HS', 'Old HS -r2')
titStr = sprintf('Vial Cap Influence - E%02d',ii);
title(titStr)
end


%% Plot error
% diffArray = mean_2 - mean_1;
% diffPercent = abs(diffArray)./mean_1;
% 
% figure
% loglog( gamryStructure(1).f, diffArray )
% figure
% loglog( gamryStructure(1).f, diffPercent )
%%
% Definitely looks like there is a difference between the two headstages,
% but also looks like a new array has a volatile impedance for quite a
% while. This probably needs to be incorporated into our characterization
% protocol. 
