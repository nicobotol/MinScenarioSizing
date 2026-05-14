%    ___  ____ ____          _       _   
%   / _ \/ ___/ ___|   _ __ | | ___ | |_ 
%  | | | \___ \___ \  | '_ \| |/ _ \| __|
%  | |_| |___) |__) | | |_) | | (_) | |_ 
%   \___/|____/____/  | .__/|_|\___/ \__|
%                     |_|                
%% Define the color map
n = 256; % Number of colors in the colormap
rgb_red = color(2);
whiteToRed = [linspace(1, rgb_red(1), n)', linspace(1, rgb_red(2), n)', linspace(1, rgb_red(3), n)']; % White to red gradient
% Insert blue for zero value
customColormap = [color(1); whiteToRed];

%% Get the index of the 1st+2nd stage optimization that converged
idx_include_1st = logical(zeros(size_loop_vec_1, size_loop_vec_2));
for a=1:size_loop_vec_1
  for b=1:size_loop_vec_2
    for i=1:num_sim
      if ~isempty(values_minvalue_1st{a,b,i})
        values_minvalue_mat(a,b,i) = values_minvalue_1st{a,b,i};
         % if strcmp(values_solution_1st{a,b,i}.min_info.message, 'OPTIMAL')
         % if values_solution_1st{a,b,i}.min_info.relativegap <= opt_parameters.rel_gap_tol*100
        if values_solution_1st{a,b,i}.min_info.relativegap <= 2
          idx_include_1st(a,b,i) = 1;
        end
      end
    end
  end
end
% idx_include_old = load(simulation_first_stage_results, 'idx_include');
% idx_include_1st = idx_include_old.idx_include;

% idx_include_1st = true(size_loop_vec_1, size_loop_vec_2);

%% Extract in matrix form the values of interest

for a=1:size_loop_vec_1
  for b=1:size_loop_vec_2
      if  idx_include_1st(a,b,i) == 1 % case in which the 1st stage converged
          if isfield(values_solution{a,b,1}, 'x_DGs') && ~isempty(values_solution{a,b,1}.x_DGs)
            P_DGs_mat(a,b) = values_solution{a,b,1}.x_DGs * DGs.PowRated;
            E_DGs_mat(a,b) = sum(values_solution{a,b,1}.P_DGs, 'all'); % total energy that should be added to satisfy the load
            E_DGs_nor_mat(a,b) = E_DGs_mat(a,b)/sum(values_vector{a,b,1}.Pload); % total energy that should be added to satisfy the load, normalized by the energy required by the load
          else
            P_DGs_mat(a,b) = 0;
            E_DGs_mat(a,b) = 0; 
            E_DGs_nor_mat(a,b) = 0;
          end
          qTy_mat(a,b) = values_solution{a,b,1}.qTy;
      else
        P_DGs_mat(a,b) = NaN;
        E_DGs_mat(a,b) = NaN; 
        E_DGs_nor_mat(a,b) = NaN;
        qTy_mat(a,b) = NaN;
      end
  end
end

%% From the matrix get the values for the converged simulations and compute the statistics
clear statistic inc P_DGs E_DGs E_DGs_nor P_DGs_sel_val E_DGs_sel_val E_DGs_nor_sel_val
for a=1:size_loop_vec_1
  inc = idx_include_1st(a,:,1); % index converged
  % inc = 1:28;

  P_DGs = P_DGs_mat(a,:);
  E_DGs = E_DGs_mat(a,:);
  E_DGs_nor = E_DGs_nor_mat(a,:);

  P_DGs_sel_val = P_DGs(inc);
  E_DGs_sel_val = E_DGs(inc);
  E_DGs_nor_sel_val = E_DGs_nor(inc);

  % P_DGs
  statistic{1}.mean_P_DGs(a)       = mean(P_DGs_sel_val, 'all', 'omitnan');   % mean of the cost function
  statistic{1}.std_P_DGs(a)        = std(P_DGs_sel_val, 'omitnan');    % standard deviation of the cost function
  statistic{1}.median_P_DGs(a)     = median(P_DGs_sel_val, 'all', 'omitnan'); % median of the cost function
  statistic{1}.iqr_P_DGs(a)        = iqr(P_DGs_sel_val);    % interquartile range of the cost function
  statistic{1}.range_P_DGs(a)      = range(P_DGs_sel_val);  % range of the cost function
  statistic{1}.prct90_P_DGs(a)     = prctile(P_DGs_sel_val, 90);  % 90 prct of the virtual power
  statistic{1}.prct99_P_DGs(a)     = prctile(P_DGs_sel_val, 99);  % 99 prct of the virtual power
  statistic{1}.mean_E_DGs(a)       = mean(E_DGs_sel_val, 'all', 'omitnan');   % mean of the cost function
  
  % E_DGs
  statistic{1}.std_E_DGs(a)        = std(E_DGs_sel_val, 'omitnan');    % standard deviation of the cost function
  statistic{1}.median_E_DGs(a)     = median(E_DGs_sel_val, 'all', 'omitnan'); % median of the cost function
  statistic{1}.iqr_E_DGs(a)        = iqr(E_DGs_sel_val);    % interquartile range of the cost function
  statistic{1}.range_E_DGs(a)      = range(E_DGs_sel_val);  % range of the cost function
  statistic{1}.prct90_E_DGs(a)     = prctile(E_DGs_sel_val, 90);  % 90 prct of the added energy
  statistic{1}.prct99_E_DGs(a)     = prctile(E_DGs_sel_val, 99);  % 99 prct of the added energy
  statistic{1}.mean_E_DGs_nor(a)   = mean(E_DGs_nor_sel_val, 'all', 'omitnan');   % mean of the cost function
  statistic{1}.std_E_DGs_nor(a)    = std(E_DGs_nor_sel_val, 'omitnan');    % standard deviation of the cost function
  statistic{1}.median_E_DGs_nor(a) = median(E_DGs_nor_sel_val, 'all', 'omitnan'); % median of the cost function
  statistic{1}.iqr_E_DGs_nor(a)    = iqr(E_DGs_nor_sel_val);    % interquartile range of the cost function
  statistic{1}.range_E_DGs_nor(a)  = range(E_DGs_nor_sel_val);  % range of the cost function
  statistic{1}.prct80_E_DGs_nor(a) = prctile(E_DGs_nor_sel_val, 80);  % range of the cost function
  statistic{1}.prct90_E_DGs_nor(a) = prctile(E_DGs_nor_sel_val, 90);  % range of the cost function
  statistic{1}.prct95_E_DGs_nor(a) = prctile(E_DGs_nor_sel_val, 95);  % range of the cost function
  
  % qTy
  statistic{1}.mean_qTy(a)         = mean(qTy_mat(a,inc), 'all', 'omitnan');   % mean of the cost function
  statistic{1}.std_qTy(a)          = std(qTy_mat(a,inc), 'omitnan');    % standard deviation of the cost function
  statistic{1}.median_qTy(a)       = median(qTy_mat(a,inc), 'all', 'omitnan'); % median of the cost function
  statistic{1}.iqr_qTy(a)          = iqr(qTy_mat(a,inc));    % interquartile range of the cost function
  statistic{1}.range_qTy(a)        = range(qTy_mat(a,inc));  % range of the cost function
  statistic{1}.prct90_qTy(a)       = prctile(qTy_mat(a,inc), 90);  % 90 prct of the virtual power
  statistic{1}.prct99_qTy(a)       = prctile(qTy_mat(a,inc), 99);  % 99 prct of the virtual power

end

%% Heatmap with the power for the power balance
fig = figure('Color','w');box on
im = heatmap(loop_vec_2, loop_vec_1, P_DGs_mat);
im.Colormap = customColormap;
im.MissingDataColor = [0 0 0];
im.ColorScaling = 'log';
im.CellLabelFormat = '%0.1f';
im.YLabel = '$|\Omega_s|$';
im.XLabel = 'Seed';
if ~strcmp(version('-release'), '2023a')
  im.Interpreter = 'latex';
end
im.FontSize = 6.5;
im.Title = 'Additional power for satisfying OSS';
im.ColorbarVisible='on'; % remove the colorbar on the side
fig.Units = "centimeters";
fig.Position = [0 0 25 10];
if plot_param.print_figure == 1
  export_figure(fig, 'OSS_max_power_2025_12_04.pdf', '..\report\figure');
end

%% Heatmap with the energy for the power balance
fig = figure('Color','w');box on
im = heatmap(loop_vec_2, loop_vec_1, E_DGs_nor_mat*100);%, 'ColorVariable',log10(max_virtual_power_mat));
im.Colormap = customColormap;
im.MissingDataColor = [0 0 0];
im.ColorScaling = 'log';
im.CellLabelFormat = '%0.1f';
im.YLabel = '$|\Omega_s|$';
im.XLabel = 'Seed';
if ~strcmp(version('-release'), '2023a')
  im.Interpreter = 'latex';
end
im.FontSize = 6.5;
im.Title = 'Normalized (\%) additional energy for satisfying OSS';
im.ColorbarVisible='on'; % remove the colorbar on the side
fig.Units = "centimeters";
fig.Position = [0 0 22 10];
if plot_param.print_figure == 1
  export_figure(fig, 'OSS_norm_energy_2025_12_04.pdf', '..\report\figure');
end

%% Convergence of the statistic regarding the additional power and energy
fig = figure('Color','w'); grid on; box on; hold on;
% Power
subplot(2,1,1); grid on; box on; hold on;
plot(loop_vec_1, statistic{1}.mean_P_DGs/statistic{1}.mean_P_DGs(1), 'Color', color(1), 'LineWidth', 1.5, 'DisplayName', '$\widetilde{P}_{OSS}$','HandleVisibility','off','Marker','none', 'LineStyle','-');
plot(loop_vec_1, statistic{1}.median_P_DGs/statistic{1}.median_P_DGs(1), 'Color', color(2), 'LineWidth', 1.5, 'DisplayName', '$Median$','HandleVisibility','off','Marker','none', 'LineStyle','-');
plot(loop_vec_1, statistic{1}.iqr_P_DGs/statistic{1}.iqr_P_DGs(1), 'Color', color(3), 'LineWidth', 1.5, 'DisplayName', '$IQR$','HandleVisibility','off','Marker','none', 'LineStyle','-');
plot(loop_vec_1, statistic{1}.std_P_DGs/statistic{1}.std_P_DGs(1), 'Color', color(4), 'LineWidth', 1.5, 'DisplayName', '$\sigma(P_{OSS})$','HandleVisibility','off','Marker','none', 'LineStyle','-');
plot(loop_vec_1, statistic{1}.range_P_DGs/statistic{1}.range_P_DGs(1), 'Color', color(5), 'LineWidth', 1.5, 'DisplayName', '$Range$','HandleVisibility','off','Marker','none', 'LineStyle','-');
ylim([0.2 2]);
yl = title('Normalized Power statistic');
yl.Interpreter = 'latex';
ay = gca;
ay.FontSize = 6.5;
ay.YColor = 'k';
set(gca,'TickLabelInterpreter','latex')
% Energy
subplot(2,1,2); grid on; box on; hold on;
plot(loop_vec_1, statistic{1}.mean_E_DGs/statistic{1}.mean_E_DGs(1), 'Color', color(1), 'LineWidth', 1.5, 'DisplayName', '$\widetilde{E}_{OSS}$', 'HandleVisibility','off','Marker','none');
plot(loop_vec_1, statistic{1}.median_E_DGs/statistic{1}.median_E_DGs(1), 'Color', color(2), 'LineWidth', 1.5, 'DisplayName', '$Median$', 'HandleVisibility','off','Marker','none');
plot(loop_vec_1, statistic{1}.iqr_E_DGs/statistic{1}.iqr_E_DGs(1), 'Color', color(3), 'LineWidth', 1.5, 'DisplayName', '$IQR$', 'HandleVisibility','off','Marker','none');
plot(loop_vec_1, statistic{1}.std_E_DGs/statistic{1}.std_E_DGs(1), 'Color', color(4), 'LineWidth', 1.5, 'DisplayName', '$\sigma(E_{OSS})$', 'HandleVisibility','off','Marker','none');
plot(loop_vec_1, statistic{1}.range_E_DGs/statistic{1}.range_E_DGs(1), 'Color', color(5), 'LineWidth', 1.5, 'DisplayName', '$Range$', 'HandleVisibility','off','Marker','none');
ay = gca;
ay.FontSize = 6.5;
ay.YColor = 'k';
xl = xlabel('$|\Omega_s|$');
xl.Interpreter = 'latex';
ax = gca;
ax.FontSize = 6.5;
yl = title('Normalized Energy statistic');
yl.Interpreter = 'latex';
set(gca,'TickLabelInterpreter','latex')
% legend
subplot(2,1,1); grid on; box on; hold on;
plot(NaN, NaN, 'Color', color(1), 'LineWidth', 1.5, 'DisplayName', '$Mean$','Marker','s', 'LineStyle','none', 'MarkerFaceColor',color(1));
plot(NaN, NaN, 'Color', color(2), 'LineWidth', 1.5, 'DisplayName', '$Median$','Marker','s', 'LineStyle','none', 'MarkerFaceColor',color(2));
plot(NaN, NaN, 'Color', color(3), 'LineWidth', 1.5, 'DisplayName', '$IQR$','Marker','s', 'LineStyle','none', 'MarkerFaceColor',color(3));
plot(NaN, NaN, 'Color', color(4), 'LineWidth', 1.5, 'DisplayName', '$\sigma$','Marker','s', 'LineStyle','none', 'MarkerFaceColor',color(4));
plot(NaN, NaN, 'Color', color(5), 'LineWidth', 1.5, 'DisplayName', '$Range$','Marker','s', 'LineStyle','none', 'MarkerFaceColor',color(5));
% plot(NaN, NaN, 'Color', 'k', 'LineWidth', 1.5, 'DisplayName', '$Power$', 'LineStyle','-','Marker','none');
% plot(NaN, NaN, 'Color', 'k', 'LineWidth', 1.5, 'DisplayName', '$Energy$', 'LineStyle',':','Marker','none');
lg = legend();
lg.Interpreter = 'latex';
lg.Location = 'north';
lg.FontSize = 6.5;
lg.NumColumns = 5;
lg.ItemTokenSize = [10 5];
fig.Units = "centimeters";
fig.Position = [0 0 8.8 2*5];
if plot_param.print_figure == 1
  export_figure(fig, 'OSS_convergence_statistic_2025_12_04.pdf', '..\report\figure');
end

%% Only some
fig = figure('Color','w'); grid on; box on; hold on;
% Power
subplot(2,1,1); grid on; box on; hold on;
plot(loop_vec_1, statistic{1}.mean_P_DGs, 'Color', color(4), 'LineWidth', 1.5, 'DisplayName', '$Median$','HandleVisibility','off','Marker','none', 'LineStyle','-');
plot(loop_vec_1, statistic{1}.median_P_DGs, 'Color', color(1), 'LineWidth', 1.5, 'DisplayName', '$Median$','HandleVisibility','off','Marker','none', 'LineStyle','-');
plot(loop_vec_1, statistic{1}.range_P_DGs, 'Color', color(2), 'LineWidth', 1.5, 'DisplayName', '$Range$','HandleVisibility','off','Marker','none', 'LineStyle','-');
plot(loop_vec_1, statistic{1}.prct90_P_DGs, 'Color', color(3), 'LineWidth', 1.5, 'DisplayName', '$90-percentile$','HandleVisibility','off','Marker','none', 'LineStyle','-');
% plot(loop_vec_1, statistic{1}.prct99_P_DGs, 'Color', color(4), 'LineWidth', 1.5, 'DisplayName', '$99-percentile$','HandleVisibility','off','Marker','none', 'LineStyle','-');
yl = title('DG power $[MW]$');
yl.Interpreter = 'latex';
ay = gca;
ay.FontSize = 6.5;
ay.YColor = 'k';
set(gca,'TickLabelInterpreter','latex')
% Energy
subplot(2,1,2); grid on; box on; hold on;
plot(loop_vec_1, statistic{1}.mean_E_DGs_nor*100, 'Color', color(4), 'LineWidth', 1.5, 'DisplayName', '$Median$', 'HandleVisibility','off','Marker','none');
plot(loop_vec_1, statistic{1}.median_E_DGs_nor*100, 'Color', color(1), 'LineWidth', 1.5, 'DisplayName', '$Median$', 'HandleVisibility','off','Marker','none');
plot(loop_vec_1, statistic{1}.range_E_DGs_nor*100, 'Color', color(2), 'LineWidth', 1.5, 'DisplayName', '$Range$', 'HandleVisibility','off','Marker','none');
plot(loop_vec_1, statistic{1}.prct90_E_DGs_nor*100, 'Color', color(3), 'LineWidth', 1.5, 'DisplayName', '$90-percentile$','HandleVisibility','off','Marker','none');
% plot(loop_vec_1, statistic{1}.prct95_E_DGs_nor*100, 'Color', color(4), 'LineWidth', 1.5, 'DisplayName', '$95-percentile$','HandleVisibility','off','Marker','none');
ay = gca;
ay.FontSize = 6.5;
ay.YColor = 'k';
xl = xlabel('$|\Omega_s|$');
xl.Interpreter = 'latex';
ax = gca;
ax.FontSize = 6.5;
yl = title('DG energy (\%)');
yl.Interpreter = 'latex';
set(gca,'TickLabelInterpreter','latex')
subplot(2,1,1);
% legend
plot(NaN, NaN, 'Color', color(4), 'LineWidth', 1.5, 'DisplayName', '$Mean$','Marker','s', 'LineStyle','none', 'MarkerFaceColor',color(1));
plot(NaN, NaN, 'Color', color(1), 'LineWidth', 1.5, 'DisplayName', '$Median$','Marker','s', 'LineStyle','none', 'MarkerFaceColor',color(1));
plot(NaN, NaN, 'Color', color(2), 'LineWidth', 1.5, 'DisplayName', '$Range$','Marker','s', 'LineStyle','none', 'MarkerFaceColor',color(2));
plot(NaN, NaN, 'Color', color(3), 'LineWidth', 1.5, 'DisplayName', '$90-perc.$','Marker','s', 'LineStyle','none', 'MarkerFaceColor',color(3));
% plot(NaN, NaN, 'Color', color(4), 'LineWidth', 1.5, 'DisplayName', '$95-perc.$','Marker','s', 'LineStyle','none', 'MarkerFaceColor',color(4));
% plot(NaN, NaN, 'Color', 'k', 'LineWidth', 1.5, 'DisplayName', '$Power$', 'LineStyle','-','Marker','none');
% plot(NaN, NaN, 'Color', 'k', 'LineWidth', 1.5, 'DisplayName', '$Energy$', 'LineStyle',':','Marker','none');
lg = legend();
lg.Interpreter = 'latex';
lg.Location = 'north';
lg.FontSize = 6.5;
lg.NumColumns = 4;
ylim([0, 11])
lg.ItemTokenSize = [10 5];
fig.Units = "centimeters";
fig.Position = [0 0 8.8 2*5];
if plot_param.print_figure == 1
  export_figure(fig, 'OSS_convergence_statistic_some_stats_2025_12_04.pdf', '..\report\figure');
end

%%
fig = figure('Color','w'); grid on; box on; hold on;
% Power
yyaxis left; grid on; box on; hold on;
plot(loop_vec_1, statistic{1}.mean_P_DGs, 'Color', color(1), 'LineWidth', 1.5, 'DisplayName', '$Mean$','HandleVisibility','off','Marker','none', 'LineStyle','-');
plot(loop_vec_1, statistic{1}.median_P_DGs, 'Color', color(1), 'LineWidth', 1.5, 'DisplayName', '$Median$','HandleVisibility','off','Marker','none', 'LineStyle','-.');
% plot(loop_vec_1, statistic{1}.range_P_DGs, 'Color', color(1), 'LineWidth', 1.5, 'DisplayName', '$Range$','HandleVisibility','off','Marker','none', 'LineStyle',':');
plot(loop_vec_1, statistic{1}.prct90_P_DGs, 'Color', color(1), 'LineWidth', 1.5, 'DisplayName', '$90-percentile$','HandleVisibility','off','Marker','none', 'LineStyle',':');
% plot(loop_vec_1, statistic{1}.prct99_P_DGs, 'Color', color(4), 'LineWidth', 1.5, 'DisplayName', '$99-percentile$','HandleVisibility','off','Marker','none', 'LineStyle','-');
ylabel('$\widetilde{P}_{DGs}$ [MW]', 'Interpreter', 'latex', 'FontSize', 6.5)
ay = gca;
ay.FontSize = 6.5;
ay.YColor = color(1);
set(gca,'TickLabelInterpreter','latex')
ylim([2 12]);
% Energy
yyaxis right; grid on; box on; hold on;
plot(loop_vec_1, statistic{1}.mean_E_DGs_nor*100, 'Color', color(2), 'LineWidth', 1.5, 'DisplayName', '$Mean$', 'HandleVisibility','off','Marker','none', 'LineStyle','-');
plot(loop_vec_1, statistic{1}.median_E_DGs_nor*100, 'Color', color(2), 'LineWidth', 1.5, 'DisplayName', '$Median$', 'HandleVisibility','off','Marker','none', 'LineStyle','-.');
% plot(loop_vec_1, statistic{1}.range_E_DGs_nor*100, 'Color', color(2), 'LineWidth', 1.5, 'DisplayName', '$Range$', 'HandleVisibility','off','Marker','none', 'LineStyle',':');
plot(loop_vec_1, statistic{1}.prct90_E_DGs_nor*100, 'Color', color(2), 'LineWidth', 1.5, 'DisplayName', '$90-percentile$','HandleVisibility','off','Marker','none', 'LineStyle',':');
% plot(loop_vec_1, statistic{1}.prct95_E_DGs_nor*100, 'Color', color(4), 'LineWidth', 1.5, 'DisplayName', '$95-percentile$','HandleVisibility','off','Marker','none');
ylabel('$\widetilde{E}_{DGs}/E_{LOAD}$ [\%]', 'Interpreter', 'latex', 'FontSize', 6.5)
ay = gca;
ay.FontSize = 6.5;
ay.YColor = color(2);
xl = xlabel('$|\Omega_s|$');
xl.Interpreter = 'latex';
ax = gca;
ax.FontSize = 6.5;
% yl = title('Additional power and normalized energy for OSS');
% yl.Interpreter = 'latex';
set(gca,'TickLabelInterpreter','latex')
% subplot(2,1,1);
% legend
plot(NaN, NaN, 'Color', 'k', 'LineWidth', 1.5, 'DisplayName', '$Mean$','Marker','none', 'LineStyle','-', 'MarkerFaceColor','k');
plot(NaN, NaN, 'Color', 'k', 'LineWidth', 1.5, 'DisplayName', '$Median$','Marker','none', 'LineStyle','-.', 'MarkerFaceColor','k');
% plot(NaN, NaN, 'Color', 'k', 'LineWidth', 1.5, 'DisplayName', '$Range$','Marker','none', 'LineStyle',':', 'MarkerFaceColor','k');
plot(NaN, NaN, 'Color', 'k', 'LineWidth', 1.5, 'DisplayName', '$90-perc.$','Marker','none', 'LineStyle',':', 'MarkerFaceColor','k');
% plot(NaN, NaN, 'Color', color(4), 'LineWidth', 1.5, 'DisplayName', '$95-perc.$','Marker','s', 'LineStyle','none', 'MarkerFaceColor',color(4));
% plot(NaN, NaN, 'Color', 'k', 'LineWidth', 1.5, 'DisplayName', '$Power$', 'LineStyle','-','Marker','none');
% plot(NaN, NaN, 'Color', 'k', 'LineWidth', 1.5, 'DisplayName', '$Energy$', 'LineStyle',':','Marker','none');
lg = legend();
lg.Interpreter = 'latex';
lg.Location = 'northeast';
lg.FontSize = 6.5;
lg.NumColumns = 1;
ylim([1, 4.2])
lg.ItemTokenSize = [10 10];
fig.Units = "centimeters";
fig.Position = [0 0 8.8 5];
if plot_param.print_figure == 1
  export_figure(fig, 'OSS_convergence_statistic_one_plot2025_12_04.pdf', '..\report\figure');
end

%% Convergence of the second stage cost
fig = figure('Color','w'); grid on; box on; hold on;
yyaxis left
plot(loop_vec_1, statistic{1}.mean_qTy/1e6,   'Color', color(1), 'LineWidth', 1.5, 'HandleVisibility','on','Marker','none', 'LineStyle','-', 'DisplayName', 'Mean');
plot(loop_vec_1, statistic{1}.median_qTy/1e6, 'Color', color(2), 'LineWidth', 1.5, 'HandleVisibility','on','Marker','none', 'LineStyle','-', 'DisplayName', 'Median');
ay = gca;
ay.FontSize = 6.5;
ay.YColor = 'k';
set(gca,'TickLabelInterpreter','latex')
ylabel('$\widehat{f}_{O,M}$ mean and median [M\$]', 'Interpreter', 'latex', 'FontSize', 6.5)
yyaxis right
plot(loop_vec_1, statistic{1}.std_qTy/1e6, 'Color', color(3), 'LineWidth', 1.5, 'HandleVisibility','on','Marker','none', 'LineStyle','--', 'DisplayName', '$\sigma$');
set(gca,'TickLabelInterpreter','latex')
ylabel('$\widehat{f}_{O,M}$ std deviation [M\$]', 'Interpreter', 'latex', 'FontSize', 6.5)
set(gca,'TickLabelInterpreter','latex')
ay = gca;
ay.FontSize = 6.5;
ay.YColor = 'k';
xl = xlabel('$|\Omega_s|$');
xl.Interpreter = 'latex';
ax = gca;
ax.FontSize = 6.5;
% title
yl = title('Convergence of the $\widehat{f}_{O,M}$ cost statistic');
yl.Interpreter = 'latex';
ay = gca;
ay.FontSize = 6.5;
ay.YColor = 'k';
% legend
lg = legend();
lg.Interpreter = 'latex';
lg.Location = 'northeast';
lg.FontSize = 6.5;
lg.NumColumns = 1;
lg.ItemTokenSize = [14 10];

fig.Units = "centimeters";
fig.Position = [0 0 8.8 5];
if plot_param.print_figure == 1
  export_figure(fig, 'qTy_convergence_statistic_2025_12_04.pdf', '..\report\figure');
end