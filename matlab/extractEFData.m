function [dataStructure, fnames] = extractEFData(relPath)
%[dataStructure] = extractCVData(relPath)
% Extracts EF data from Gamry data files
% Puts all traces (voltage and current data) in dataStructure. This script 
% will pull the data from each file in relPath directory. 
% Data is labeled with the electrode number (pulled from filename).
% Inputs:
%       relPath: String of relative path of the directory to be analyzed
%                ex. '../rawData/Gamry/2018-01-30_TDT3_PreSurge'
% Outpus:
%       dataStructure: Voltage and current data in dataStructure

% Sets relative filepaths
currentFile = mfilename( 'fullpath' );
currentFolder = pwd;    % For resetting cd at end of function
cd(fileparts(currentFile));
cd(relPath);

%change .dat files to ..txt files for processing
system(['rename ' '*.dta ' '*.txt']);

% Filenames in the directory
listFiles = dir;
fnames = {listFiles.name}'; %returns cell array
fnames = fnames(cellfun(@(x) length(x) >= 5, fnames));

for ii = 1:length(fnames)
    
    % Grab electrode number from filename
    currentNameStr = char( fnames{ ii } );
    fid = fopen( currentNameStr );
    elecIndex = strfind( currentNameStr , '_E' ) + 2;
    electrode = str2num( currentNameStr( elecIndex:elecIndex+1 ) );
    
    % Finds start of each scan in data file
    sniffer = 'CURVE';
    c = textread(currentNameStr,'%s','delimiter','\n');
    curveStartIndex = find(~cellfun(@isempty,strfind(c, sniffer )));
        
    dataStructure(ii).fname = currentNameStr;
    startLine = curveStartIndex + 1;
    rawTable = readtable( fnames{ii},'delimiter','tab',...
                          'headerlines', startLine+1, ...
                          'ReadVariableNames', false);
%     dataRows = curveStartIndex(jj+1) - curveStartIndex(jj) - 3;
    % Grab and store all the data
%     [dataArray] = textToArray( fnames{ii}, line, dataRows, dataColumns );  % line + 1 because header is 2 lines long
    dataStructure(ii).time = rawTable.Var3;
    dataStructure(ii).potential = rawTable.Var4;
    dataStructure(ii).current = rawTable.Var5;  
end
cd( currentFolder )
end

