function [dataStructure] = extractEarlyOCPData(relPath)
%[dataStructure] = extractEarlyOCPData(relPath)
%   This will be a generic function to extract the initial OCP measurement
%   before the gamry starts the EIS measurement.
%   Inputs: 
%       relPath: String of relative path of the directory to be analyzed
%                ex. '../rawData/Gamry/2018-01-30_TDT3_PreSurge'
%   Outputs:
%   dataStructure.
%       fnames : cell containing filenames. Same order as other outputs.
%       t      : time
%       VvRef  : Voltage vs Ref
%       V      : Not sure what this is exactly
%       

% Sets relative filepaths
currentFile = mfilename( 'fullpath' );  % Gets path for THIS script
currentFolder = pwd;    % For resetting cd at end of function
cd(fileparts(currentFile));
cd(relPath);

% change .dat files to ..txt files for processing (if not already done)
if ~isempty(dir('*.dta'))
    system(['rename ' '*.dta ' '*.txt']);
end

% Grabs all filenames in current directory
listFiles = dir;
fnames = {listFiles.name}';

%% Finds starting row for Open circuit potential data
fid = fopen(fnames{3}, 'rt');
% read the entire file, if not too big
textRows = textscan(fid, '%s', 'delimiter', '\n');
% search for your Region:
a = strfind(textRows{1},'OCVCURVE');
startLine = find(not(cellfun('isempty',a)));
a = strfind(textRows{1},'EOC');
stopLine = find(not(cellfun('isempty',a)));
fclose(fid);
fieldSize = stopLine - ( startLine + 3 );

%% Pull Impedance data into structure
for kk = 3:length(fnames)
    % Format data to usable format
    fname = fnames{kk};
    fileID = fopen(fname);
    rawCellArray = ...
        textscan(fileID, '%f %f %f %f %f %s %f', fieldSize, ...
                 'HeaderLines', startLine + 2);
    fclose(fileID);
    
    dataStructure(kk-2).fname = fname;
    dataStructure(kk-2).t = rawCellArray{1,2};
    dataStructure(kk-2).VvRef = rawCellArray{1,3};
    dataStructure(kk-2).V = rawCellArray{1,4};
%     rawTable = readtable( cell2mat(fname),'delimiter','tab',...
%                           'headerlines', startLine+2, ...
%                           'ReadVariableNames', false);
%     dataStructure(kk-2).fname = fname;
%     dataStructure(kk-2).f = rawTable.Var4;
%     dataStructure(kk-2).Zreal = rawTable.Var5;
%     dataStructure(kk-2).Zim = rawTable.Var6;
%     dataStructure(kk-2).Zmag = sqrt( ( rawTable.Var5.^2 ) + ( rawTable.Var6.^2 ) );
%     dataStructure(kk-2).Phase = rawTable.Var9;
end

cd(currentFolder)
end

