function [dataStructure] = extractFEMData(relPath)
%[f, Zreal, Zim, Phase] = extractImpedanceDataGlobal(relPath)
%   This will be a generic function to extract all of the Gamry data to a
%   structure. 
%   Inputs: 
%       relPath: String of relative path of the directory to be analyzed
%                ex. '../rawData/Gamry/2018-01-30_TDT3_PreSurge'
%   Outputs:
%   dataStructure.
%       fname       : name of original text file
%       f           : frequency 
%       Ref_V       : Surface voltage of the reference
%       WESurface_V : Surface voltage of WE
%       WE_I        : Current through WE surface
%       WEOffset_V  : Voltage at ~ 5um from WE surface
%       Gnd_I       : Current going through the ground
%       Ctr_I       : All current leaving the counter electrode

% Sets relative filepaths
currentFile = mfilename( 'fullpath' );  % Gets path for THIS script
currentFolder = pwd;    % For resetting cd at end of function
cd(fileparts(currentFile));
cd(relPath);

% Grabs all filenames in current directory
listFiles = dir;
fnames = {listFiles.name}';

%% Finds starting row for impedance data
fid = fopen(fnames{3}, 'rt');
% read the entire file, if not too big
textRows = textscan(fid, '%s', 'delimiter', '\n');
% search for your Region:
a = strfind(textRows{1},'% freq');
startLine = find(not(cellfun('isempty',a)));
fclose(fid);

%% Pull Impedance data into structure
for kk = 3:length(fnames)
    % Format data to usable format
    fname = fnames(kk);
    fidi = fopen(fname{1},'r');
    numHeaders = 35;
    Data = textscan(fidi, '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f', ...                    
                   'HeaderLines', 5, 'CollectOutput',1);
    Data = cell2mat(Data);
    fclose(fidi);
    % Preload blanks
    dataStructure(kk-2).Ref_V = [];
    dataStructure(kk-2).WESurface_V = [];
    dataStructure(kk-2).WE_I = [];
    dataStructure(kk-2).WEOffset_V = [];
    dataStructure(kk-2).Gnd_I = [];
    % Grab data
    dataStructure(kk-2).fname = fname;
    dataStructure(kk-2).f = Data(:,1);
    dataStructure(kk-2).Ref_V = Data(:,2);
    dataStructure(kk-2).Ctr_I = Data(:,67);
    % Couldn't figure out how to reorganize columns in COMSOL so have to
    % have hardcoded here. Will ened to update if any additional data is
    % added.
    WESurface_V_order   = [ 11 10 09 08 07 03 12 13 ...
                            14 15 16 17 18 19 20 21];
    WEOffset_V_order    = [ 26 25 24 23 22 05 27 28 ...
                            29 30 31 32 33 34 35 36];
    WE_I_order          = [ 41 40 39 38 37 04 42 43 ...
                            44 45 46 47 48 49 50 51];
    Gnd_I_order         = [ 56 55 54 53 52 06 57 58 ...
                            59 60 61 62 63 64 65 66];
    for ii = 1:16
        jj = WESurface_V_order(ii);
        dataStructure(kk-2).WESurface_V = [dataStructure(kk-2).WESurface_V Data(:,jj)];
        jj = WE_I_order(ii);
        dataStructure(kk-2).WE_I = [dataStructure(kk-2).WE_I Data(:,jj)];
        jj = WEOffset_V_order(ii);
        dataStructure(kk-2).WEOffset_V = [dataStructure(kk-2).WEOffset_V Data(:,jj)];
        jj = Gnd_I_order(ii);
        dataStructure(kk-2).Gnd_I = [dataStructure(kk-2).Gnd_I Data(:,jj)];
    end
        
end

cd(currentFolder)
end

