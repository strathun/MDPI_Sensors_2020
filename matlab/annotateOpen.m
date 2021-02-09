function annotateOpen( nRemoved )
%   annotateOpen will annotate all open figures with the name of the script
%   that generated them and a timestamp of when that script was executed
%
%   Inputs:
%       nRemoved: specifies the number of levels you want to shift from the
%                 calling of this function. For instance, if you want to
%                 tag with the script that called this function set
%                 nRemoved = 1. If you want to call the script that called
%                 the script that called that funtion set nRemoved = 2.


%% Generate strings for tags
nRemoved = nRemoved + 1; % need to adjust to avoid tagging with 'annotateOpen'
st = dbstack;
nameStr = st( nRemoved ).name;
timeStr = datetime;
timeStr = datestr( timeStr );

annotationStr = [nameStr '_' timeStr];
    
%% Grab all open figures
figHandles = findobj( 'type', 'figure' );
figHandles = get( figHandles, 'Number' );
if isa( figHandles, 'cell' )
    figHandles = cell2mat( figHandles );
end
n = length( figHandles );
for f = 1:n

end
end

