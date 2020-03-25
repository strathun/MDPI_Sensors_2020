function [ noiseStructure ] = combineNoiseSpans( relPath )
%[ f P ] = combineNoiseSpans( filePath )
% This script (function?) was adapted from combineLowHighData and
% combineHighLow from the electrode characterization project folder (copied
% on 20200324). These were streamlined into a single function that could
% generate the data for the MDPI_Sensors 2020 paper.

% NOTE: This version of the function will probably only work with
% measurements made with the version 4 high speed headstage (full spectrum
% measurements). 

%   Inputs:
%       relPath   : String of relative path of the directory to be analyzed
%                   ex. '../rawData/Gamry/2018-01-30_TDT3_PreSurge'
%   Outputs:
%       noiseStructure.
%        E        : Electrode Number
%        F        : Frequency spectrum
%        Spectrum : combined PSD
%        PSD      : 3 PSDs; deembedded, BUT GAIN IS NOT DIVIDED OUT
%                   (UPdate: It is now BEB!)

% Sets relative filepaths
currentFile = mfilename( 'fullpath' );  % Gets path for THIS script
currentFolder = pwd;    % For resetting cd at end of function
cd(fileparts(currentFile));
cd(relPath);

% Load and name gain measurement
AvH = '../noiseHSGains/highSpeedGain_v4.mat';

% Grab files in this directory
d = pwd; 
listFiles = dir(d);
addpath(d);
fnames = {listFiles.name}'; %returns cell array

%% Assign measurements to correct electrodes
for ii=1:length(fnames) 
    file = fnames{ii}; %convert cell to string
    
%%High Speed only Frequency Sorting
    if ~isempty(findstr(file,'0000')) && ~isempty(findstr(file,'HSonly'))
        e01_High = file;
    end
    if ~isempty(findstr(file,'0001')) && ~isempty(findstr(file,'HSonly'))
        e02_High = file;
    end
    if ~isempty(findstr(file,'0010')) && ~isempty(findstr(file,'HSonly')) 
        e03_High = file;
    end
    if ~isempty(findstr(file,'0011')) && ~isempty(findstr(file,'HSonly'))
        e04_High = file;
    end
    if ~isempty(findstr(file,'0100')) && ~isempty(findstr(file,'HSonly'))
        e05_High = file;
    end
    if ~isempty(findstr(file,'0101')) && ~isempty(findstr(file,'HSonly'))
        e06_High = file;
    end
    if ~isempty(findstr(file,'0110')) && ~isempty(findstr(file,'HSonly'))
        e07_High = file;
    end
    if ~isempty(findstr(file,'0111')) && ~isempty(findstr(file,'HSonly'))
        e08_High = file;
    end
    if ~isempty(findstr(file,'1000')) && ~isempty(findstr(file,'HSonly'))
        e09_High = file;
    end
    if ~isempty(findstr(file,'1001')) && ~isempty(findstr(file,'HSonly'))
        e10_High = file;
    end
    if ~isempty(findstr(file,'1010')) && ~isempty(findstr(file,'HSonly'))
        e11_High = file;
    end
    if ~isempty(findstr(file,'1011')) && ~isempty(findstr(file,'HSonly'))
        e12_High = file;
    end
    if ~isempty(findstr(file,'1100')) && ~isempty(findstr(file,'HSonly'))
        e13_High = file;
    end
    if ~isempty(findstr(file,'1101')) && ~isempty(findstr(file,'HSonly'))
        e14_High = file;
    end
    if ~isempty(findstr(file,'1110')) && ~isempty(findstr(file,'HSonly'))
        e15_High = file;
    end
    if ~isempty(findstr(file,'1111')) && ~isempty(findstr(file,'HSonly'))
        e16_High = file;
    end
    if ~isempty(findstr(file,'gnd__')) && ~isempty(findstr(file,'HSonly'))
        gnd_High = file;
    end
end

%% This function will no longer plot. Adapt CombineHighLow to a for loop here instead of the plotting
% Below is dapted from CombineHighLow function.
for ii = 1:16
    try
        fHigh = eval(['e' sprintf('%02d',ii) '_High']); % Find PSD for electrode ii (see above)
        % Load PSD measurements and subtract instrument noise
        load( gnd_High );
        PSD_gnd_H = y( 1:end,: )';  % y comes from gndHigh file
        load(fHigh)
        PSD_el_H = y';
        PSD_F = x';
        % Subtract instrument noise from measurement
        final_PSDs_H = sqrt( ( PSD_el_H.^2 ) - ( PSD_gnd_H.^2 ) );
        
        % Merge 3 frequency spans into one array [Adapted from "mergeSpans"
        frequencies = x';
        PH = [final_PSDs_H(1:end,1); final_PSDs_H(67:end,2); final_PSDs_H(97:end,3)];
        fH = [frequencies(1:end,1); frequencies(67:end,2); frequencies(97:end,3)];
        
        % Pulls in gain spectrum gain measurement. Interpolates these
        % measurements across the frequency range of interest.
        load(AvH)
        y = db2mag(y);
        gain_fullSpectrum = interp1(x,y,fH);
        % Interp gain for each of the individual spans (from above) as
        % well!
        [ ~, numSpans ] = size( final_PSDs_H );
        for kk = 1:numSpans
            gain_spanSpectrum( :, kk ) = ...
                interp1( x, y, PSD_F( :, kk ) );
        end
        lastGainIndex = find(isnan(gain_fullSpectrum),1); %Actually first non gain index/ Think I can skip this for individual spans
        if ~isempty(lastGainIndex)
            gain_fullSpectrum(lastGainIndex:end) = gain_fullSpectrum(lastGainIndex-1);
        end
        % De-Embed the gain
        PH = PH./gain_fullSpectrum;
        final_PSDs_H = final_PSDs_H ./ gain_spanSpectrum;
        
        noiseStructure(ii).E        = ii;
        noiseStructure(ii).F        = fH;
        noiseStructure(ii).Spectrum = PH;
        noiseStructure(ii).PSD      = {final_PSDs_H};
        noiseStructure(ii).PSDF      = {PSD_F};
                        
    catch
        sprintf('fail %02d',ii)
    end
end

cd(currentFolder) % Returns to original directory
end
