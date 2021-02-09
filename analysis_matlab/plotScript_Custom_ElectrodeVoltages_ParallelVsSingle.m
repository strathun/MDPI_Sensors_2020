%% plotScript_Custom_ElectrodeVoltages_ParallelVsSingle_20200817
% This is an investigation to any changes at the interface when performing
% EIS measurements with the custom pot with multiple connections vs a
% single connected channel. 

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
[customStructure] = ...
    extractCustomPstatData('..\rawData\CustomPot\20200817_TDT22_InVitro_OldPBS');


%% Plot Impedance comparison for parallel vs single channel
colorArray = lines( 16 );
electrodeOrder = [01 02 03 04 05 06 07 08 ...
                  09 10 12 11 13 14 15 16]; % Measurements made slightly out of order
for ii = 1:16
    jj = electrodeOrder(ii);
    figure(ii)
    loglog( customStructure(1).f(:,ii), ...
            customStructure(1).Zmag(:,ii), ...
            'Color', colorArray( ii, : )) 
    hold on
    loglog( customStructure(jj + 1).f(:,ii), ...
        customStructure(jj + 1).Zmag(:,ii), 'o', ...
        'Color', colorArray( ii, : ))
    set(gca,'XScale','log','YScale','log')
    legend('Parallel','Single')
    xlim([100 10000])
    xlabel('Frequency (Hz)')
    ylabel('Mag(Impedance)')
    % Build average arrays
    if ii < 14
        avg_array_parallel(:, ii) = customStructure(1).Zmag(:,ii);
        avg_array_single(:, ii)   = customStructure(jj + 1).Zmag(:,ii);
    end
end

% Plot averages
mean_parallel = mean(avg_array_parallel, 2);
std_parallel = std(avg_array_parallel, 0, 2);
mean_single = mean(avg_array_single, 2);
std_single = std(avg_array_single, 0, 2);
figure
hold on
errorbar( customStructure(1).f(:,1), ...
        mean_parallel, std_parallel);
errorbar( customStructure(2).f(:,1), ...
        mean_single, std_single);
set(gca,'XScale','log','YScale','log')
legend('Parallel', 'Single')
title('Ref Voltages; Avgs')
xlim([100 10000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
title('Impedance; Avgs')
avg_array_parallel = [];
avg_array_single = [];

%%
% Parallel measurements are clearly higher impedance.

%% Electrode Voltage Comparisons

% Reference electrodes
colorArray = lines( 16 );
electrodeOrder = [01 02 03 04 05 06 07 08 ...
                  09 10 12 11 13 14 15 16]; % Measurements made slightly out of order
for ii = 1:16
    jj = electrodeOrder(ii);
    figure(100+ii)
    semilogx( customStructure(1).f(:,ii), ...
            customStructure(1).Vpp_ref_rec(:,ii), ...
            'Color', colorArray( ii, : )) 
    hold on
    semilogx( customStructure(jj + 1).f(:,ii), ...
        customStructure(jj + 1).Vpp_ref_rec(:,ii), 'o', ...
        'Color', colorArray( ii, : ))
    set(gca,'XScale','log','YScale','log')
    legend('Parallel','Single')
    xlim([100 10000])
    xlabel('Frequency (Hz)')
    ylabel('Voltage (V)')
    title('Ref Voltages')
    % Build average arrays
    if ii < 14
        avg_array_parallel(:, ii) = customStructure(1).Vpp_ref_rec(:,ii);
        avg_array_single(:, ii)   = customStructure(jj + 1).Vpp_ref_rec(:,ii);
    end
end

% Plot averages
mean_parallel = mean(avg_array_parallel, 2);
std_parallel = std(avg_array_parallel, 0, 2);
mean_single = mean(avg_array_single, 2);
std_single = std(avg_array_single, 0, 2);
figure
hold on
errorbar( customStructure(1).f(:,1), ...
        mean_parallel, std_parallel);
errorbar( customStructure(2).f(:,1), ...
        mean_single, std_single);
set(gca,'XScale','log') 
legend('Parallel', 'Single')
title('Ref Voltages; Avgs')
xlim([100 10000])
xlabel('Frequency (Hz)')
ylabel('Voltage (V)')
avg_array_parallel = [];
avg_array_single = [];

%Working Electrodes
for ii = 1:16
    jj = electrodeOrder(ii);
    figure(200+ii)
    semilogx( customStructure(1).f(:,ii), ...
            customStructure(1).Vpp_sig_rec(:,ii), ...
            'Color', colorArray( ii, : )) 
    hold on
    semilogx( customStructure(jj + 1).f(:,ii), ...
        customStructure(jj + 1).Vpp_sig_rec(:,ii), 'o', ...
        'Color', colorArray( ii, : ))
    set(gca,'XScale','log','YScale','log')
    legend('Parallel','Single')
    xlim([100 10000])
    xlabel('Frequency (Hz)')
    ylabel('Voltage (V)')
    title('WE Voltages')
    % Build average arrays
    if ii < 14
        avg_array_parallel(:, ii) = customStructure(1).Vpp_sig_rec(:,ii);
        avg_array_single(:, ii)   = customStructure(jj + 1).Vpp_sig_rec(:,ii);
    end
end

% Plot averages
mean_parallel = mean(avg_array_parallel, 2);
std_parallel = std(avg_array_parallel, 0, 2);
mean_single = mean(avg_array_single, 2);
std_single = std(avg_array_single, 0, 2);
figure
hold on
errorbar( customStructure(1).f(:,1), ...
        mean_parallel, std_parallel);
errorbar( customStructure(2).f(:,1), ...
        mean_single, std_single);
set(gca,'XScale','log') 
legend('Parallel', 'Single')
title('Working Electrode Voltages; Avgs')
xlim([100 10000])
xlabel('Frequency (Hz)')
ylabel('Voltage (V)')
avg_array_parallel = [];
avg_array_single = [];

% Voltage difference between electrodes
for ii = 1:16
    jj = electrodeOrder(ii);
    figure(300+ii)
    semilogx( customStructure(1).f(:,ii), ...
            abs(customStructure(1).Vpp_ref_rec(:,ii) - customStructure(1).Vpp_sig_rec(:,ii)), ...
            'Color', colorArray( ii, : )) 
    hold on
    semilogx( customStructure(jj + 1).f(:,ii), ...
        abs(customStructure(jj + 1).Vpp_ref_rec(:,ii) - customStructure(jj + 1).Vpp_sig_rec(:,ii)), 'o', ...
        'Color', colorArray( ii, : ))
    set(gca,'XScale','log','YScale','log')
    legend('Parallel','Single')
    xlim([100 10000])
    xlabel('Frequency (Hz)')
    ylabel('Voltage (V)')
    title('abs(ref - WE) Voltages')
    % Build average arrays
    if ii < 14
        avg_array_parallel(:, ii) = abs(customStructure(1).Vpp_ref_rec(:,ii) - customStructure(1).Vpp_sig_rec(:,ii));
        avg_array_single(:, ii)   = abs(customStructure(jj + 1).Vpp_ref_rec(:,ii) - customStructure(jj + 1).Vpp_sig_rec(:,ii));
    end
end

% Plot averages
mean_parallel = mean(avg_array_parallel, 2);
std_parallel = std(avg_array_parallel, 0, 2);
mean_single = mean(avg_array_single, 2);
std_single = std(avg_array_single, 0, 2);
figure
hold on
errorbar( customStructure(1).f(:,1), ...
        mean_parallel, std_parallel);
errorbar( customStructure(2).f(:,1), ...
        mean_single, std_single);
set(gca,'XScale','log') 
legend('Parallel', 'Single')
title('abs(ref - WE) Voltages; Avgs')
xlim([100 10000])
xlabel('Frequency (Hz)')
ylabel('Voltage (V)')
avg_array_parallel = [];
avg_array_single = [];

%% Electrode Current Comparisons
% Measured across the pull down resistor
colorArray = lines( 16 );
electrodeOrder = [01 02 03 04 05 06 07 08 ...
                  09 10 12 11 13 14 15 16]; % Measurements made slightly out of order
for ii = 1:16
    jj = electrodeOrder(ii);
    figure(500+ii)
    semilogx( customStructure(1).f(:,ii), ...
            customStructure(1).I_rec(:,ii), ...
            'Color', colorArray( ii, : )) 
    hold on
    semilogx( customStructure(jj + 1).f(:,ii), ...
        customStructure(jj + 1).I_rec(:,ii), 'o', ...
        'Color', colorArray( ii, : ))
    set(gca,'XScale','log','YScale','log')
    legend('Parallel','Single')
    xlim([100 10000])
    xlabel('Frequency (Hz)')
    ylabel('Current (unsure)')
    title('Currents Across PD Resistor')
    % Build average arrays
    if ii < 14
        avg_array_parallel(:, ii) = customStructure(1).I_rec(:,ii);
        avg_array_single(:, ii)   = customStructure(jj + 1).I_rec(:,ii);
    end
end

% Plot averages
mean_parallel = mean(avg_array_parallel, 2);
std_parallel = std(avg_array_parallel, 0, 2);
mean_single = mean(avg_array_single, 2);
std_single = std(avg_array_single, 0, 2);
figure
hold on
errorbar( customStructure(1).f(:,1), ...
        mean_parallel, std_parallel);
errorbar( customStructure(2).f(:,1), ...
        mean_single, std_single);
set(gca,'XScale','log') 
legend('Parallel', 'Single')
title('Currents Across PD Resistor; Avgs')
xlim([100 10000])
xlabel('Frequency (Hz)')
ylabel('Current (unsure)')
avg_array_parallel = [];
avg_array_single = [];


