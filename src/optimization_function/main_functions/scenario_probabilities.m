
%    ____                           _            _               
%   / ___| ___ _ __   ___ _ __ __ _| |  ___  ___| |_ _   _ _ __  
%  | |  _ / _ \ '_ \ / _ \ '__/ _` | | / __|/ _ \ __| | | | '_ \ 
%  | |_| |  __/ | | |  __/ | | (_| | | \__ \  __/ |_| |_| | |_) |
%   \____|\___|_| |_|\___|_|  \__,_|_| |___/\___|\__|\__,_| .__/ 
%                                                         |_|    

clear; clc; close all;
parameters
set(0,'DefaultFigureWindowStyle','normal');
plot_param.print_figure = 0;
% if enable_parallel_computing == 1 && isempty(gcp('nocreate'))
%   num_core = feature('numcores');
%   parpool('Processes', num_core);
% end
tic;

%   ____        _                 _       
%  |  _ \  __ _| |_ __ _ ___  ___| |_ ___ 
%  | | | |/ _` | __/ _` / __|/ _ \ __/ __|
%  | |_| | (_| | || (_| \__ \  __/ |_\__ \
%  |____/ \__,_|\__\__,_|___/\___|\__|___/
define_converters
import_datasets_norway % load the datasets of the different resources

scenario.InCopula = 600;
scenario.InScenNum = 40;
[cellScenGenSetRes, scenGenSetLoad] = generate_data_series(scenario, scenGenSetLoad, LoadA, wind, irradiance, SWH, W_period, 0);
%%
[res_scens, load_scens, prob_scens, mappedCoords] = generate_scenarios_modified(cellScenGenSetRes, scenGenSetLoad, load_scenarios, scenario, 1, 0);

%% Plot
[~, idx_order] = sort(prob_scens, 'descend');
clc;

tot = zeros(scenario.InScenNum, 10);
tot(:,1:2:end) = mappedCoords(idx_order,:)*100;
tot(:,2:2:end) = 100 - mappedCoords(idx_order,:)*100;

fig = figure('Color','w'); box on; grid on;
tiledlayout(7,1,"TileSpacing","tight","Padding","compact");

nexttile([2,1]); 
% nexttile
pl = plot(1:size(mappedCoords,1), prob_scens(idx_order)*100);
pl.Color = color(2);
pl.LineWidth = 1.2;
pl.Marker = 'o';
pl.MarkerSize = 4;
ax = gca();
xlim([0, 1 + scenario.InScenNum])
set(gca,'XTick',[])
ax.FontSize = 6.5;
ax.TickLabelInterpreter = 'latex';
ylabel('$\pi_{\omega}$', 'FontSize',6.5, 'Interpreter','latex')
max_prob = max(prob_scens*100);
% ylim([0, max_prob+2])
grid on;

legend_list = {'Load','Irr.','WS','SWH','Per.'};
for j=1:5
  nexttile()
  b_plot = bar(tot(:,2*(j-1) + [1,2]), 'stacked');
  
  color_list = [1, 2, 3, 4, 5];
  b_plot(1).FaceColor = color(color_list(j));
  b_plot(1).EdgeColor = 'w';
  b_plot(1).LineWidth = 0.05;
  b_plot(2).FaceColor = color(-1);
  b_plot(2).EdgeColor = 'w';
  b_plot(2).LineWidth = 0.05;

  % ylim([0,5.2])
  xlim([0, 1 + scenario.InScenNum])
  ax = gca();
  ax.FontSize = 6.5;
  ax.TickLabelInterpreter = 'latex';

  ylabel([legend_list{j}], 'FontSize', 6.5, 'Interpreter', 'latex');
  
  if j < 5
    set(gca,'XTick',[])
  end
end
ax.XLabel.String = 'Scenario number';
ax.XLabel.FontSize = 6.5;
ax.XLabel.Interpreter = 'latex';

fig.Units = "centimeters";
fig.Position = [10 10 8.8 7];

if plot_param.print_figure == 1
  exportgraphics(fig, ['../report/figure/vectorial/scenario_prob_projection.pdf'], 'ContentType', 'vector','BackgroundColor', 'none');
end

%%
%   _____                 _   _                 
%  |  ___|   _ _ __   ___| |_(_) ___  _ __  ___ 
%  | |_ | | | | '_ \ / __| __| |/ _ \| '_ \/ __|
%  |  _|| |_| | | | | (__| |_| | (_) | | | \__ \
%  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
                                              
function [ResselScens_N, load_copy, LscensProbVec_N, coords_N] = generate_scenarios_modified(cellScenGenSetRes, scenGenSetLoad, load_scenarios, scenario, rngSeed, enable_parallel_computing)

  [coords_N,points_N,ResselScens_N,LselScens_N,LscensProbVec_N,MapData_N]=KantorMapND_modified(cellScenGenSetRes, scenGenSetLoad, scenario.InScenNum, rngSeed);
    

  % if sum(all(WT.Power < 1e1, 1)) > 0
  %   WT.Power(:, all(WT.Power < 1e1, 1)) = 1e1*ones(scenario.T, sum(all(WT.Power < 1e1, 1)));
  % end
    
  load_copy = copy(load_scenarios);
  load_copy.iniVec = LselScens_N;
  load_copy.iniVec(load_copy.iniVec <= load_copy.NS_fraction*load_copy.P_rated) = load_copy.NS_fraction*load_copy.P_rated; 

end

function [mappedCoords,closestPoints,RESselScens,LOADselScens,probVec,mapVars] = KantorMapND_modified(cellObjDataRES,objDataLOAD,clustersNum, rngSeed)
  %KantorMapND Performs the ND mapping
  %   This actually created the N-Dimension map with a ranked RES power
  %   variables on one axis and a platform's LOAD on the other
  %   Example: [coords,points]=KantorMapND(DataX(WF1.Power),LoadC);
  %   The RES are given as cell array
  %   This function has less methods than the 2D version

  % Set the random seed
  rng(rngSeed);

  numObj = numel(cellObjDataRES); % number of resources
  x = RankScenarios(objDataLOAD);

  % Write the res in the y matrix
  for i = 1:numObj
    y(:,i) = RankScenarios(cellObjDataRES{i});
  end        
  
  X = [x y];
  mapVars.x = x;
  mapVars.y = y;
  mapVars.points = X;
  
  %             clustersNum = 10;
  replicatesNum = 1;
  max_iter = 1;
  
  % Choose best out of many initializations
  opts = statset('Display','off');
  [idx,C,~] = kmeans(X,clustersNum,'Distance','sqeuclidean','Replicates',replicatesNum,'Options',opts,'Start','uniform','MaxIter',max_iter);
  
  mapVars.clusterID = idx;
  mapVars.centroids = C;
  
  
  % --------- K-MEANS FIXED NUMBER OF CLUSTERS - END ------------
  
  %------------- FIND CLOSEST TO CENTROIDS POINTS ---------------
  % loop through all clusters
  closestIdx = zeros(max(idx),1);
  size_iCluster=zeros(max(idx),1);
  for iCluster = 1:max(idx)
      %# find the points that are part of the current cluster
      currentPointIdx = find(idx==iCluster);
      %# find the index (among points in the cluster)
      %# of the point that has the smallest Euclidean distance from the centroid
      %# bsxfun subtracts coordinates, then you sum the squares of
      %# the distance vectors, then you take the minimum
      [~,minIdx] = min(sum(bsxfun(@minus,X(currentPointIdx,:),C(iCluster,:)).^2,2));
      %# store the index into X (among all the points)
      closestIdx(iCluster) = currentPointIdx(minIdx);
      size_iCluster(iCluster,1) = length(X(idx==iCluster,1));
  end
  
  for iCluster = 1:max(idx)
      coordinates_closest(iCluster,:) = X(closestIdx(iCluster),:);
  end
  
  
  mappedCoords  = coordinates_closest;
  closestPoints = closestIdx;
  probVec =size_iCluster./(size(objDataLOAD.iniVec,2)-1);
  
  % Loop over the respurces
  RESselScens = cell(numObj, 1);
  for i = 1:numObj

      for iCluster = 1:max(idx)
          clustVarSel1(:,iCluster) = cellObjDataRES{i}.PickScenario(closestPoints(iCluster));
      end
      
      selectedScensClustVar1 = DataX(clustVarSel1);
      RESselScens{i} = UnGroupSamples(selectedScensClustVar1);
  end

  for iCluster = 1:max(idx)
      clustVarSel2(:,iCluster) = objDataLOAD.PickScenario(closestPoints(iCluster));
  end

  selectedScensClustVar2 = DataX(clustVarSel2);
  LOADselScens = UnGroupSamples(selectedScensClustVar2);
        
end       