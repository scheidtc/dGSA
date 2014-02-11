%
% This function creates a bar chart showing for each parameter, the L1-norm
% for each cluster and for each bin.
 
% Author: Celine Scheidt
% Date: August 2012


function ParetoInteractions(NormalizedSensDependencies,ParamsNames,NbClusters,NbBins)

%% Input Parameters
%   - NormalizedSensDependencies: 4D array (NbParams x NbParams-1 x NbClusters x max(NbBins)) containing the sensitivity
%   values for each interaction, each class and each bin.
%   - ParamsNames: Parameter names to be displayed on the y-axis
%   - NbClusters: number of cluster (class)
%   - NbBins: Vector containing the number of bins per parameter


% Reshape for easier computation
    Interactions = reshape(permute(NormalizedSensDependencies,[3,2,1,4]),[],max(NbBins));  

 % Compute the average mesure of sensitivity for each interaction (used for ploting)
    SensitivityPerClass = nanmean(NormalizedSensDependencies,4);
    SensitivityPerClass = reshape(permute(SensitivityPerClass,[2,1,3]),[],NbClusters);   
    
    
    NbInter = size(SensitivityPerClass,1);
    [DivFromRef,BarWidth,TextSize] = SetDefaultValuesForPlot(NbClusters,NbInter);    

    % Sort from less sensitive to most sensitive
    SensitivityOverClass = nanmean(SensitivityPerClass,2);
    GlobalSensitivityDependencies = reshape(permute(SensitivityOverClass,[2,1]),[],1);
    [~, SortedSA] = sort(GlobalSensitivityDependencies,'ascend');

    % Sort the Interactions according to their average mesure of sensitivity
    SortedSAInter = Interactions;
    for i = 1:length(SortedSA)
        SortedSAInter(((i-1)*NbClusters+1):i*NbClusters,:) = Interactions(((SortedSA(i)-1)*NbClusters+1):SortedSA(i)*NbClusters,:);
    end
    SortedInteractions = SortedSAInter;

    NbBinsAll = repmat(NbBins,length(NbBins)-1,1);
    NbBinsAll = NbBinsAll(SortedSA);
    
    % Compute the number of bins per interaction
    NbBinsPerInter =  repmat(sum(~isnan(SortedInteractions'))',1,size(SortedInteractions,2));
    
    % Bar plot
    figure; axes('FontSize',TextSize,'Fontweight','b');  hold on;
    barh(1:NbInter,SensitivityPerClass(SortedSA,:),0.5,'group'); 
     
    for j = 1:NbInter
        C = definecolor(NbClusters,NbBinsAll(j));
        for i = 1:NbClusters
           h1 = barh([DivFromRef(i)+j,DivFromRef(i)+j + 1],vertcat(SortedInteractions(i + (j-1)*NbClusters,:)./NbBinsPerInter(i + (j-1)*NbClusters,:),nan(1,size(Interactions,2))),BarWidth,'stack');              
           P=findobj(h1,'type','patch');
           for n=1:NbBinsAll(j)
               set(P(n),'facecolor',C(n+(i-1)*NbBinsAll(j),:),'LineWidth',1.5);
           end
        end
    end
    set(gca,'YTick',1:NbInter)
    set(gca,'YTickLabel',ParamsNames(SortedSA))
    ylim([0 NbInter+1])
    box on
 
end
    
   

%% Function defining the colors for each bin
function C = definecolor(NbClusters,NbBins)

    Cs = colormap(jet(124));  
    
    % First and last cluster are blue or red
    Ds1 = floor(linspace(24,1,NbBins));
    Dsend = floor(linspace(100,124,NbBins));
        
    % Definition of the color for the middle clusters
    Dint = [];
    Ds = floor(linspace(1,size(Cs,1),NbClusters));

    if NbClusters > 2          
        for i = 1:NbClusters - 2
            if Ds(i+1)+7 < 55 % i.e. in the blue color, need to reverse the color   
                Dint = floor([Dint,Ds(i+1)+7:-14/(NbBins-1):Ds(i+1)-7]);
            else
                Dint = floor([Dint,Ds(i+1)-7:14/(NbBins-1):Ds(i+1)+7]);
            end
        end
    end   
    C = Cs([Ds1,Dint,Dsend],:);       
end
    


%% Set default values for the bar plot
function [DivFromRef,BarWidth,TextSize] = SetDefaultValuesForPlot(NbClusters,NbInter)
       
    if NbClusters > 5
        fprintf('ERROR - this function cannot handle more than 5 clusters \n')
    end
    
    % Text Size for the plot
    if NbInter > 10
        TextSize = 10;
    else
         TextSize = 12;
    end
    
    % Bar Width
    if NbClusters == 2
        DivFromRef = [-0.15 0.15];
        BarWidth = 0.23;  
    elseif NbClusters == 3
        DivFromRef = [-0.21 0 0.21];
        BarWidth = 0.17;
    elseif NbClusters == 4
        DivFromRef = linspace(-0.25,0.25,4);
        BarWidth = 0.13;
    elseif NbClusters == 5
        DivFromRef = linspace(-0.3,0.3,5);
        BarWidth = 0.1;        
    end
    
end