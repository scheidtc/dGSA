%
% Distance-based generalized sensitivity analysis (dGSA)
% Evaluation of sensitivity of the main factors only
% Pareto plots are used to display the resuls
 
% Author: Celine Scheidt
% Date: August 2012

function [SensitivityMainFactors,StandardizedSensitivity] = dGSA_MainFactors(Clustering,ParametersValues,ParametersNames)

%% Input Parameters
%   - Clustering: Clustering results
%   - ParametersValues: matrix (NbModels x NbParams) of the parameter values
%     (numerical values should be provided, even for discrete parameters)
%   - ParametersNames: list containing the names of the parameters 

%% Output Parameters 
%   - SensitivityMainFactors: Matrix containing the normalized L1norm for each parameter (1st dim) and
%   each cluster (2nd dim).
%   - StandardizedSensitivity: Vector containing the standardized measure of sensitivity for each parameter

L1MainFactors = L1normMainFactors(Clustering,ParametersValues); % evaluate L1-norm
BootMainFactors = BootstrapMainFactors(ParametersValues,Clustering,2000);  % bootstrap procedure

SensitivityMainFactors = L1MainFactors./BootMainFactors; % normalization 
StandardizedSensitivity = mean(SensitivityMainFactors,2); % standardized measure of sensitivity 

% Display the results
ParetoMainFactors(SensitivityMainFactors,ParametersNames);

% Hypothesis test: Ho = 1 if at least one value > 1 (per cluster)
H0accMain = any(SensitivityMainFactors >=1,2);
Pareto_GlobalSensitivity(StandardizedSensitivity,ParametersNames,H0accMain);


end