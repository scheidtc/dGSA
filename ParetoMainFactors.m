%
% This function creates a bar chart showing for each parameter, the L1-norm
% for each cluster.
 
% Author: Celine Scheidt
% Date: August 2012


function ParetoMainFactors(SensitivityMainFactors,ParamsNames)

%% Input Parameters
%   - SensitivityMainFactors: matrix (NbParams x NbClusters) of the L1-norm values
%   - ParamsNames: Parameter names to be displayed on the y-axis

[NbParams NbClusters] = size(SensitivityMainFactors);


% Sort from less sensitive to most sensitive
StandardizedSensitivity = mean(SensitivityMainFactors,2); 
[~, SortedSA] = sort(StandardizedSensitivity,'ascend');
SensitivityMainFactors = SensitivityMainFactors(SortedSA,:);
ParamsNames = ParamsNames(SortedSA);

figure;
axes('FontSize',12,'fontweight','b');  hold on;
h0 = barh(1:NbParams,SensitivityMainFactors,0.8,'group','LineWidth',1.5);

P=findobj(h0,'type','patch');
C = definecolor(NbClusters);
for n=1:length(P) 
    set(P(n),'facecolor',C(n,:),'LineWidth',1.5);
end

plot([1 1],[0.5 NbParams+0.5],'r','LineWidth',3) 
set(gca,'YTick',1:NbParams)
set(gca,'YTickLabel',ParamsNames)
box on

end


% This function defines the bar colors
function C = definecolor(NbClusters)
    Cs = colormap(jet(124));
    Ds = floor(linspace(1,size(Cs,1),NbClusters));
    C = Cs(Ds,:);
end