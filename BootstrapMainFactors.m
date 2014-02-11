%
% This function performs a bootstrap procedure and return the
% alpha-percentile of the L1norm for each parameter and each cluster.
 
% Author: Celine Scheidt
% Date: August 2012

function BootMainFactors = BootstrapMainFactors(ParametersValues,Clustering,NbDraw,alpha)

%% Input Parameters
%   - ParametersValues: matrix (NbModels x NbParams) of the parameter values
%   - Clustering: Clustering results
%   - NbDraw: number of sampling to perform
%   - alpha (optional): alpha-percentile (by default, alpha = 0.95)

%% Output Parameters 
%   -BootMainFactors: Matrix containing the bootstrap alpha-percentile for each
%   parameter (one row) and each cluster (one column).

    nbParametersValues = size(ParametersValues,2);
    nbclusters = length(Clustering.medoids);
    
    if nargin < 4
        alpha = 0.95;
    end
    
    BootMainFactors = zeros(nbParametersValues,nbclusters);

    for i = 1:nbParametersValues
        q_prior = quantile(ParametersValues(:,i),(1:1:99)./100);  % prior distribution
        for  j = 1:nbclusters
            boot = zeros(NbDraw,1);
            for iter = 1:NbDraw
                x_redraw = randsample(size(ParametersValues,1),Clustering.weights(j))';  % sample points
                q = quantile(ParametersValues(x_redraw,i),(1:1:99)./100);  % bootstrapped distribution
                boot(iter) = norm(q_prior-q,1); % L1-norm
            end
            BootMainFactors(i,j) = quantile(boot,alpha);
        end
    end

end

