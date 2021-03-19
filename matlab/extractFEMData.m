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
    Data = textscan(fidi, '%f%f%f%f%f%f', 'HeaderLines',5, 'CollectOutput',1);
    Data = cell2mat(Data);
    fclose(fidi);
    dataStructure(kk-2).fname = fname;
    dataStructure(kk-2).f = Data(:,1);
    dataStructure(kk-2).Ref_V = Data(:,2);
    dataStructure(kk-2).WESurface_V = Data(:,3);
    dataStructure(kk-2).WE_I = Data(:,4);
    dataStructure(kk-2).WEOffset_V = Data(:,5);
    dataStructure(kk-2).Gnd_I = Data(:,6);
end

cd(currentFolder)
end

