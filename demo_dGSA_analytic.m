%% Distance-Based Generalized Sensitivity Analysis
% Author: Celine Scheidt
% Date: August 2012
% Updated: January 2014


% Definition of the 3 parameters (x,y,z) using Latin Hypercube Sampling 
NbSimu = 200;  NbParams = 3; rng(12756);

ParametersValues = lhsdesign(NbSimu,NbParams,'criterion','correlation','iterations',50); 

% Evaluation of the response: r = [z abs(x*(y-1)]
ParametersNames = {'x','y','z'};
r = [ParametersValues(:,3) abs(ParametersValues(:,1).*(ParametersValues(:,2)-1))];

 % Compute the distance between the responses
d = pdist(r);

% Classify the response in a few classes using kmedoid
nbclusters = 3;  
Clustering = kmedoids(d,nbclusters,10);

%% MAIN FACTORS

% Plot the cdf and apply dGSA
cdf_MainFactor(ParametersValues,Clustering,ParametersNames)
[SensitivityMainFactor,StandardizedSensitivity] = dGSA_MainFactors(Clustering,ParametersValues,ParametersNames);


%% INTERACTIONS
InteractionsNames = {'y|x','z|x','x|y','z|y','x|z','y|z'};

% Define the number of bins for each parameter
NbBins = [3,3,3];

cdf_Interactions(ParametersValues(:,2),ParametersValues(:,1),Clustering,NbBins(1),3,'y|x')

% Sensitivity
[SensitivityInteractions GlobalSensitivityInteractions] = dGSA_Interactions(Clustering,ParametersValues,InteractionsNames,NbBins);


