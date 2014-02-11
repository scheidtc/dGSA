%
% This function computes the L1-norm distance between the prior cdf and the
% cdf of each cluster for each parameter
 
% Author: Celine Scheidt
% Date: August 2012

function L1norm = L1normMainFactors(Clustering,ParametersValues)

%% Input Parameters
%   - Clustering: Clustering results
%   - ParametersValues: matrix (NbModels x NbParams) of the parameter values

%% Output Parameters 
%   - L1norm: Matrix containing the L1norm for each parameter (1st dim) and
%   each cluster (2nd dim).

NbParameters = size(ParametersValues,2);
NbClusters = length(Clustering.medoids);
L1norm = zeros(NbParameters,NbClusters);

% Numerical calculation of the L1 norm for each parameter
for i = 1:NbParameters
    q_prior = quantile(ParametersValues(:,i),(1:1:99)./100);  % prior distribution    
    for j = 1:NbClusters
        q_c = quantile(ParametersValues(Clustering.T == j,i),(1:1:99)./100); % distribution per cluster    
        L1norm(i,j) = norm(q_prior - q_c,1);
    end
end

end