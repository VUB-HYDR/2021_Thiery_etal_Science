

% --------------------------------------------------------------------
% function to load 2D model data
% --------------------------------------------------------------------


function [lat, lon, years, varargout] = mf_load(file_name, varargin)


% check if file is there
file_exist = exist(file_name,'file');


% 1. if file is there:
if file_exist == 2

    
% load grid data
lat = ncread(file_name, 'lat'); % latitude [° N] (axis: Y)
lon = ncread(file_name, 'lon') ; % longitude [° E] (axis: X)


% get 2D grid
[lon, lat] = meshgrid(lon, lat);


% load time data - convert from [months since 1661] to [calendar year]
time_units = ncreadatt(file_name,'time','units');
if     contains(time_units,'years since 1661')
    years = floor(ncread(file_name,'time')                 ) + 1661;
elseif contains(time_units,'years since 1860')
    years = floor(ncread(file_name,'time')                 ) + 1860;
elseif contains(time_units,'years since 1861')
    years = floor(ncread(file_name,'time')                 ) + 1861;
elseif contains(time_units,'years since 2006')
    years = floor(ncread(file_name,'time')                 ) + 2006;
elseif contains(time_units,'years since 2100')
    years = floor(ncread(file_name,'time')                 ) + 2100;
elseif contains(time_units,'months since')
    years = floor(ncread(file_name,'time')/12              ) + 1661;
elseif contains(time_units,'days since 1661')
    years = floor(ncread(file_name,'time')/(365.25        )) + 1661;
elseif contains(time_units,'days since 1861')
    years = floor(ncread(file_name,'time')/(365.25        )) + 1861;
elseif contains(time_units,'days since 2006')
    years = floor(ncread(file_name,'time')/(365.25        )) + 2006;
elseif contains(time_units,'days since 2100')
    years = floor(ncread(file_name,'time')/(365.25        )) + 2100;
elseif contains(time_units,'seconds since 1661')
    years = floor(ncread(file_name,'time')/(365.25*24*3600)) + 1661;
elseif contains(time_units,'seconds since 1801')
    years = floor(ncread(file_name,'time')/(365.25*24*3600)) + 1801;
elseif contains(time_units,'seconds since 1861')
    years = floor(ncread(file_name,'time')/(365.25*24*3600)) + 1861;
elseif contains(time_units,'seconds since 2006')
    years = floor(ncread(file_name,'time')/(365.25*24*3600)) + 2006;
elseif contains(time_units,'seconds since 2008')
    years = floor(ncread(file_name,'time')/(365.25*24*3600)) + 2006;   % assume it's a typo
elseif contains(time_units,'seconds since 2100')
    years = floor(ncread(file_name,'time')/(365.25*24*3600)) + 2100;
end


% loop over variable names
for i=1:length(varargin)

    
    % load variable data
    VAR = varargin{i};            % get variable name
    VAR = ncread(file_name, VAR); % load the variable


    % check variable dimensions and tread accordingly
    [nx ny nz nt] = size(VAR);
    if     numel(size(VAR)) == 2
        VAR = flipud(rot90(VAR)); 
    elseif numel(size(VAR)) == 3
        VARr = NaN(ny,nx,nz);
        for j=1:size(VAR,3)
            VARr(:,:,j) = flipud(rot90(VAR(:,:,j)));
        end
        VAR = VARr;
    elseif numel(size(VAR)) == 4
        VAR = permute(VAR,[1 2 4 3]);
        % check dimensions again after permute command
        if     numel(size(VAR)) == 3    % it was a 'fake' fourth dimension (e.g. U10,V10)
            VARr = NaN(ny,nx,nz);
            for j=1:size(VAR,3)
                VARr(:,:,j) = flipud(rot90(VAR(:,:,j)));
            end
            VAR = VARr;
        elseif numel(size(VAR)) == 4    % it was a real fourth dimension (e.g. QV_hm)

            % undo permute (result: vertical: 3th, time: 4th)
            VAR = permute(VAR,[1 2 4 3]);
            VARr = NaN(ny,nx,nz,nt);
            for j=1:size(VAR,3)
                for k=1:size(VAR,4)
                    VARr(:,:,j,k) = flipud(rot90(VAR(:,:,j,k)));
                end
            end
            VAR = VARr;
        end
    end

    
    % store data
    varargout{i} = VAR;
    
end


% 2. if file is not there: send out warning
else
disp(['file ', file_name,' does not exist'])
end


end

