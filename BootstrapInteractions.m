%
% This function performs a bootstrap procedure for the interactions and return the
% alpha-percentile of the L1norm for each parameter given the conditional parameter, each cluster and each bin.
 
% Author: Celine Scheidt
% Date: August 2012

function BootInteractions  = BootstrapInteractions(ParametersValues,CondIdx,Clustering,NbBins,NbDraw,alpha)

%% Input Parameters
%   - ParametersValues: matrix (NbModels x NbParams) of the parameter values
%   - CondIdx: index of the conditional parameter (e.g y in x|y)
%   - Clustering: Clustering results
%   - NbBins: number of bins for the conditional parameter
%   - NbDraw: number of sampling to perform
%   - alpha (optional): alpha-percentile (by default, alpha = 0.95)

%% Output Parameters 
%   - BootInteractions: Array ((NbParams-1) x Nbcluster x NbBins) containing the bootstrap alpha-percentile for each
%     parameter (1st dim), each cluster (2nd dim) and for each level (3rd dim).

if nargin < 6
    alpha = 0.95;
end

NbClusters = length(Clustering.medoids);
NbParams = size(ParametersValues,2);
BootInteractions = zeros(NbParams,NbClusters,NbBins);

%% Definition of levels (bin) for the conditional parameter

if length(unique(ParametersValues(:,CondIdx))) == NbBins
    levels = sort(unique(ParametersValues(:,CondIdx)));
else 
    levels = quantile(ParametersValues(:,CondIdx),(1:NbBins-1)/NbBins);
end


%% Resampling procedure and L1norm

for j = 1:NbClusters
        idx_c =  find(Clustering.T == j); % find points in the cluster
        
         % Bin the conditional parameter and store the indices in a vector
         for l = 1:NbBins
            if l == 1
                idx_cl = idx_c(ParametersValues(idx_c,CondIdx) <= levels(l));
            elseif l == NbBins
                idx_cl = idx_c(ParametersValues(idx_c,CondIdx) > levels(l-1));
            else
                idx_cl = idx_c(all(horzcat(ParametersValues(idx_c,CondIdx) <= levels(l),ParametersValues(idx_c,CondIdx) > levels(l-1)),2));
            end

            if  length(idx_cl) <= 3  % too few values in the bin -> nan
                BootInteractions(:,j,l) = NaN(NbParams,1);
            else
                for i =1:NbParams 
                    q_prior = quantile(ParametersValues(idx_c,i),(1:1:99)./100);% distribution of parameter p in the entire cluster: F(p|c)
                    boot = zeros(NbDraw,1);
                    for iter = 1:NbDraw % resampling procedure
                        x_redraw = idx_c(randsample(1:Clustering.weights(j),length(idx_cl))'); % sampling from F(p|c)
                        q = quantile(ParametersValues(x_redraw,i),(1:1:99)./100); % distribution of parameter p conditioned to pj in bin l: F(p|i(pj,tl),c)
                        boot(iter) = norm(q_prior-q,1); % L1-norm
                    end
                    BootInteractions(i,j,l) = quantile(boot,alpha);
                end
            end
        end
end
BootInteractions(CondIdx,:,:) = [];

end