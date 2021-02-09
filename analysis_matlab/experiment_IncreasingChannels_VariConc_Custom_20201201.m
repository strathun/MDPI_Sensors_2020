%% experiment_IncreasingChannels_VariConc_Custom_20201201
% This was a modified repeat of the 20200915 experiments with the Gamry,
% using the Custom potentiostat here. A single electrode's impedance was
% measured with an increasing number of channels connected in parallel for
% 3 different PBS concentrations (0p1x, 1x and 2x). 

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
[customStructure_0p1] = ...
    extractCustomPstatData('..\rawData\CustomPot\20201201_TDT22_InVitro_0p1xPBS');
[customStructure_1] = ...
    extractCustomPstatData('..\rawData\CustomPot\20201201_TDT22_InVitro_1xPBS');
[customStructure_2] = ...
    extractCustomPstatData('..\rawData\CustomPot\20201201_TDT22_InVitro_2xPBS');


%% Plot Impedances to visualize
% 1xPBS
figure
measOrder = [2 3 4 5 6]; % selects 0, 1, 3, 7, and 15 parallel electrodes
colorArray = lines( 5 );
for ii = 1:5
    jj = measOrder(ii);
    semilogx( customStructure_1(jj).f(:,5), ...
        customStructure_1(jj).Zmag(:,5) , ...
        'Color', colorArray( ii, : ), ...
        'LineWidth', 1.5)
    hold on
end
xlim([70 10000])
ylim([300 30000])
grid on
xlabel('Frequency (Hz)')
ylabel('Magnitude(Imp)')
title('1x PBS')
leg = legend('0', '1', '3', '7', '15');
title(leg,'Parallel Connections');

% 2xPBS
figure
measOrder = [1 2 3 4 5]; % selects 0, 1, 3, 7, and 15 parallel electrodes
colorArray = lines( 5 );
for ii = 1:5
    jj = measOrder(ii);
    semilogx( customStructure_2(jj).f(:,5), ...
        customStructure_2(jj).Zmag(:,5) , ...
        'Color', colorArray( ii, : ), ...
        'LineWidth', 1.5)
    hold on
end
xlim([70 10000])
ylim([300 30000])
grid on
xlabel('Frequency (Hz)')
ylabel('Magnitude(Imp)')
title('2x PBS')
leg = legend('0', '1', '3', '7', '15');
title(leg,'Parallel Connections');

% 0.1xPBS
figure
measOrder = [1 2 3 4 5]; % selects 0, 1, 3, 7, and 15 parallel electrodes
colorArray = lines( 5 );
for ii = 1:5
    jj = measOrder(ii);
    semilogx( customStructure_0p1(jj).f(:,5), ...
        customStructure_0p1(jj).Zmag(:,5) , ...
        'Color', colorArray( ii, : ), ...
        'LineWidth', 1.5)
    hold on
end
xlim([70 10000])
ylim([300 30000])
grid on
xlabel('Frequency (Hz)')
ylabel('Magnitude(Imp)')
title('0.1x PBS')
leg = legend('0', '1', '3', '7', '15');
title(leg,'Parallel Connections');

%% Impedance y axis number of electrodes x axis
% This is meant to be an easier way of comparing the changes between the
% solutions. 
% Grab frequencies for each solution
% 1xPBS
measOrder = [2 3 4 5 6]; % selects 0, 1, 3, 7, and 15 parallel electrodes
freqSelector = [1 10 18]; % selects freqs 100 1k and 7k
for ii = 1:5
    jj = measOrder(ii);
    ZmagStructure(1).concentration = 1;
    for kk = 1:3
        ll = freqSelector(kk);
        ZmagStructure(1).Zmag(kk, ii) = customStructure_1(jj).Zmag(ll,5);
    end
end
% 0.1xPBS and 2xPBS
measOrder = [1 2 3 4 5]; % selects 0, 1, 3, 7, and 15 parallel electrodes
freqSelector = [1 10 18]; % selects freqs 100 1k and 7k
for ii = 1:5
    jj = measOrder(ii);
    ZmagStructure(2).concentration = 2;
    ZmagStructure(3).concentration = 0.1;
    for kk = 1:3
        ll = freqSelector(kk);
        ZmagStructure(2).Zmag(kk, ii) = customStructure_2(jj).Zmag(ll,5);
        ZmagStructure(3).Zmag(kk, ii) = customStructure_0p1(jj).Zmag(ll,5);
    end
end

% Plot it!
number_electrodes = [1 2 4 8 16];
for ii = 1:3
    figure(100 + ii)
    plot( number_electrodes, ZmagStructure(3).Zmag(ii,:),'-o', 'LineWidth', 1.5 )
    hold on
    plot( number_electrodes, ZmagStructure(1).Zmag(ii,:),'-o', 'LineWidth', 1.5 )
    plot( number_electrodes, ZmagStructure(2).Zmag(ii,:),'-o', 'LineWidth', 1.5 )
    xlabel( 'Number of Electrodes' )
    ylabel( 'Mag(Impedance)')
    grid on
    legend( '0.1x', '1x', '2x')
end

%% Change in impedance per additional electrode
number_electrodes = [1 2 4 8]; % Number of NEW electrodes added in that group
for ii = 1:3
    for jj = 1:3
        for kk = 1:4
            change_stage(kk) = ZmagStructure(ii).Zmag(jj, kk+1) - ...
                               ZmagStructure(ii).Zmag(jj, kk);
        end
        ZmagStructure(ii).deltaZPer(jj,:) = change_stage./number_electrodes;
    end
end

figure
for ii = 1:3
    plot( ZmagStructure(1).deltaZPer(ii, :), '-o', 'LineWidth', 1.5 )
    hold on
end
grid on
xlabel( 'Stage')
ylabel( 'Impedance Change Per Additional Electrode' )
legend('100 Hz', '1 kHz', '7 kHz')
title( '1xPBS' )

figure
for ii = 1:3
    plot( ZmagStructure(2).deltaZPer(ii, :), '-o', 'LineWidth', 1.5 )
    hold on
end
grid on
xlabel( 'Stage')
ylabel( 'Impedance Change Per Additional Electrode' )
legend('100 Hz', '1 kHz', '7 kHz')
title( '2xPBS' )

figure
for ii = 1:3
    plot( ZmagStructure(3).deltaZPer(ii, :), '-o', 'LineWidth', 1.5 )
    hold on
end
grid on
xlabel( 'Stage')
ylabel( 'Impedance Change Per Additional Electrode' )
legend('100 Hz', '1 kHz', '7 kHz')
title( '0.1xPBS' )
