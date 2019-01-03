% CLEANUP from ExperimentSettings.m (removing redundant and confusing settings variables)

if ~settings.VariableITIDur
    % If variable ITI duration has not been indicated, remove settings
    % for ITI duration distribution parameters
    settings = rmfield(settings, 'ITIDurMean');
    settings = rmfield(settings, 'ITIDurMin');
    settings = rmfield(settings, 'ITIDurMax');
end