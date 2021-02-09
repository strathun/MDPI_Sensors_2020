%% plotScript_InVivoImpedanceChange_shortTime
% This is to get a rough approximation of the % change in impedance that
% occurs over short time scales ~within a single experiment. 

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
[gamryStructure_round1] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200316_TDT21_Day03\Impedance\Round1');
[gamryStructure_round2] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200316_TDT21_Day03\Impedance\Round2');


%% Plot Impedance (Gamry vs Custom, single electrode)
pointerArray_r1 = [9 7 2]; % Actual electrode numbers
pointerArray_r2 = [12 10 8];
for ii = 1:3
    figure
    kk = pointerArray_r1(ii);
    ll = pointerArray_r2(ii);
    loglog( gamryStructure_round1(kk).f, ...
            gamryStructure_round1(kk).Zmag)
        hold on
    loglog( gamryStructure_round2(ll).f, ...
            gamryStructure_round2(ll).Zmag)
end
xlim([10 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
legend('Gamry - R1', 'Gamry - R2')

%% Percent difference
pointerArray_r1 = [9 7 2]; % Actual electrode numbers
pointerArray_r2 = [12 10 8];
for ii = 1:3
    kk = pointerArray_r1(ii);
    ll = pointerArray_r2(ii);
    diffArray(:,ii) = abs( gamryStructure_round1(kk).Zmag - ...
                           gamryStructure_round2(ll).Zmag );
    percentDiffArray(:,ii) = (diffArray(:,ii) ./ gamryStructure_round1(kk).Zmag) * 100;
end