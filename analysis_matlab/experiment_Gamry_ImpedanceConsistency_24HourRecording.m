%% experiment_Gamry_ImpedanceConsistency_24HourRecording
% Want to test if anything is happening to the counter or ref electrode
% that would cause the changes in impedance

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
    extractImpedanceDataGlobal('..\rawData\Gamry\20200825_TDT22_Invitro_OldPBS_r24hr');

%% Plot Impedance (new vs Old)
% [~, numTraces] = size( gamryStructure_C1 );
% figure(1)
% colorArray = lines( numTraces );
% for ii = 1:numTraces
%     loglog( gamryStructure_C1(ii).f, ...
%             gamryStructure_C1(ii).Zmag, ...
%             'Color', colorArray( ii, : ))
%         hold on
%     loglog( gamryStructure_C2(ii).f, ...
%             gamryStructure_C2(ii).Zmag, ...
%             '--', 'Color', colorArray( ii, : ))
% end
% xlim([10 100000])
% xlabel('Frequency (Hz)')
% ylabel('Mag(Impedance)')
% legend('Config1', 'Config2')
% title('Global Impedance Drop (Both Gamry)')

%% Plot Impedance (new vs Old) (Individual)
[~, numTraces] = size( gamryStructure );
numRuns = numTraces / 16;
colorArray = lines( numTraces );
jj = 1; % Figure counter
for ii = 1:numTraces
    figure(jj)
    loglog( gamryStructure(ii).f, ...
            gamryStructure(ii).Zmag )
        hold on
    if mod(ii, numRuns) == 0
        grid on
        xlim([10 100000])
%         legend('Config1', 'Config2')
        xlabel('Frequency (Hz)')
        ylabel('Mag(Impedance)')
        titStr = sprintf('24 Hour Soak - E%02d', jj);
        title(titStr)
        jj = jj + 1;
    end
end


%% Plot Impedance (new vs Old)(Averages)
% Needs fixing. right now it gives the average of each electrode, need
% array averages at each time point!!
% runPointer =   [01 10 11 12 13 14 15 16 17 18 19 02 ...
%                 20 21 22 23 24 03 04 05 06 07 08 09]; 
runPointer =   [01 12 18 19 20 21 22 23 24 02 03 04 ...
                05 06 07 08 09 10 11 13 14 15 16 17]; 
[~, numTraces] = size( gamryStructure );
numRuns = numTraces / 16;
colorArray = copper( 24 );   % change from lines to something showing progression
avgArray_temp = [];
% jj = 1;
ll = 0;
mm = 1;
figure
for ii = 1:numRuns
    mm = runPointer(ii);
    for jj = 1:16
        kk = mm + ll*24;
        avgArray_temp = [avgArray_temp gamryStructure(kk).Zmag];
        ll = ll + 1;
    end
    
    mean_temp = mean( avgArray_temp, 2 );
    std_temp  = std( avgArray_temp, 0, 2 );
    errorbar( gamryStructure(1).f, ...
    mean_temp, std_temp, 'Color', colorArray(ii,:) );
    hold on
    ll = 0;
    avgArray_temp = [];
end

set(gca,'XScale','log','YScale','log') 
grid on
xlim([10 100000])
xlabel('Frequency (Hz)')
ylabel('Mag(Impedance)')
% titStr = sprintf('24 Hour Soak - E%02d', jj);
% title(titStr)

% for ii = 1:numRuns
%     avgArray_temp = [avgArray_temp gamryStructure(ii).Zmag];
%     if mod(ii, numRuns) == 0
%         mean_temp = mean( avgArray_temp, 2 );
%         std_temp  = std( avgArray_temp, 0, 2 );
%         errorbar( gamryStructure(1).f, ...
%         mean_temp, std_temp );
%         hold on
%         set(gca,'XScale','log','YScale','log') 
%         grid on
%         xlim([10 100000])
% %         legend('Config1', 'Config2')
%         xlabel('Frequency (Hz)')
%         ylabel('Mag(Impedance)')
%         titStr = sprintf('24 Hour Soak - E%02d', jj);
%         title(titStr)
%         jj = jj + 1;
%     end
% end
%%
% Doesn't look like we can blame it on the counter yet...
