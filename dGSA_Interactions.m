
%
% Distance-based generalized sensitivity analysis (dGSA)
% Evaluation of sensitivity of the intercations
% Pareto plots are used to display the resuls
 
% Author: Celine Scheidt
% Date: August 2013

function [NormalizedInteractions,StandardizedSensitivityInteractions] = dGSA_Interactions(Clustering,ParametersValues,InteractionsNames,NbBins)

%% Input Parameters
%   - Clustering: Clustering results
%   - ParametersValues: matrix (NbModels x NbParams) of the parameter values
%   - InteractionsNames: List containing the interaction names to be displayed on the y-axis
%   - NbBins: Vector containing the number of bins per parameter

%% Output Parameters 
%   - NormalizedInteractions: 4D array (NbParams x NbParams-1 x NbClusters x max(NbBins)) containing the sensitivity
%                             values for each interaction, each class and each bin.
%   - StandardizedSensitivityInteractions: vector containing the standardized measure of sensitivity
%                                          for each interaction


NbParams = size(ParametersValues,2);
NbClusters = size(Clustering.medoids,2);


% Evaluate the normalized conditionnal interaction for each parameter, each
% class and each bin
L1Interactions = NaN(NbParams,NbParams-1,NbClusters,max(NbBins));  % array containing all the Interactions 
BootInteractions = NaN(NbParams,NbParams-1,NbClusters,max(NbBins));  

for params = 1:NbParams
    L1InteractionsParams = L1normInteractions(ParametersValues,params,Clustering,NbBins(params));
    L1Interactions(params,:,:,1:NbBins(params)) = L1InteractionsParams(:,:,1:NbBins(params));
    BootInteractionsParams = BootstrapInteractions(ParametersValues,params,Clustering,NbBins(params),2000);
    BootInteractions(params,:,:,1:NbBins(params)) = BootInteractionsParams(:,:,1:NbBins(params));
    NormalizedInteractions = L1Interactions./BootInteractions;
end


% Measure of conditional interaction sensitivity per class
SensitivityPerClass = nanmean(NormalizedInteractions,4);

% Average measure of sensitivity over all classes 
SensitivityOverClass = nanmean(SensitivityPerClass,3);

% Display the results
ParetoInteractions(NormalizedInteractions,InteractionsNames,NbClusters,NbBins)

% Hypothesis test: Ho = 1 if at least one value > 1 (per cluster and per bin)
SensitivityPerInteraction = reshape(permute(NormalizedInteractions,[2,1,4,3]),[],max(NbBins)*NbClusters);
H0accInter = any(SensitivityPerInteraction >=1,2);

StandardizedSensitivityInteractions = reshape(SensitivityOverClass',1,[]);
Pareto_GlobalSensitivity(StandardizedSensitivityInteractions,InteractionsNames,H0accInter)
 
end



