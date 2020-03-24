function [ pinOutput ] = pinoutConverter( fromPinout, toPinout, varargin )
%Converts pinout from one device to another. Also handy way to keep track
%of all these.
%   

gamry     = [ 01 02 03 04 05 06 07 08 ... 
              09 10 11 12 13 14 15 16 ];

customPot = [ 16 15 14 13 12 11 10 09 ...
              08 07 06 05 04 03 02 01 ];
      
%% Default values Inputs
trodeSpecifierDefault = 1:16;

%% Parse inputs
pInput = inputParser;
pInput.addRequired( 'fromPinout', ...
    @(x) ( ischar(x) ) );
pInput.addRequired( 'toPinout', ...
    @(x) ( ischar(x) ) );
pInput.addParameter( 'trodeSpecifier', trodeSpecifierDefault, ...
    @(x) ( isvector(x) && isnumeric(x) ) ); 
try
    pInput.parse( fromPinout, toPinout, varargin{:} );
catch mExp
    error( 'pinoutConverter:invalidInputParameter', ...
        'Error: %s', mExp.message );
end
trodeSpecifier = pInput.Results.trodeSpecifier;
clear pInput

%% Conversions
numTrodes = length( trodeSpecifier );
if strcmp( fromPinout, 'gamry' )
    fromArray = gamry;
elseif strcmp( fromPinout, 'customPot' )
    fromArray = customPot;
end
if strcmp( toPinout, 'gamry' )
    toArray = gamry;
elseif strcmp( toPinout, 'customPot' )
    toArray = customPot;
end

for ii = 1:numTrodes
    indexTrode = find( fromArray == trodeSpecifier(ii) );
    pinOutput(ii) = toArray( indexTrode );
end

