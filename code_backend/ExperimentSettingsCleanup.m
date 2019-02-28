% CLEANUP from ExperimentSettings.m (removing redundant and confusing settings variables)

settings.QuitKeyCodes = zeros(1, numel(settings.QuitKeyNames));
for n = 1:numel(settings.QuitKeyNames)
    settings.QuitKeyCodes(n) = KbName(settings.QuitKeyNames{n});
end

settings.YesKeyCodes = zeros(1, numel(settings.YesKeyNames));
for n = 1:numel(settings.YesKeyNames)
    settings.YesKeyCodes(n) = KbName(settings.YesKeyNames{n});
end

settings.NoKeyCodes = zeros(1, numel(settings.NoKeyNames));
for n = 1:numel(settings.NoKeyNames)
    settings.NoKeyCodes(n) = KbName(settings.NoKeyNames{n});
end

if ~settings.VariableITIDur
    % If variable ITI duration has not been indicated, remove settings
    % for ITI duration distribution parameters
    settings = rmfield(settings, 'ITIDurMean');
    settings = rmfield(settings, 'ITIDurMin');
    settings = rmfield(settings, 'ITIDurMax');
end