if plot_param.print_figure == 1
  set(0,'DefaultFigureWindowStyle','normal');
else
  set(0,'DefaultFigureWindowStyle','docked');
end
% set(0,'DefaultFigureWindowStyle','normal');

switch loop_type_1
  case 'scenario_num'
    x_label = '$ |\Omega_{s}| $';
  case 'scenario_len'
    x_label = '$T$';
  otherwise
    error('Case not implemented yet')
end
%   ___ ____ ____          _       _    
%  |_ _/ ___/ ___|   _ __ | | ___ | |_  
%   | |\___ \___ \  | '_ \| |/ _ \| __| 
%   | | ___) |__) | | |_) | | (_) | |_  
%  |___|____/____/  | .__/|_|\___/ \__| 
%                   |_|                 
%% Std deviation of the cost function std(F) and time
% fig = figure('Color', 'w'); hold on; grid on; box on
% yyaxis left
% pl_l = plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.std_F(1:size_loop_vec_1));
% pl_l.Marker = 'o';
% pl_l.Color = color(1);
% pl_l.LineWidth = 2;
% ay_l = ylabel('$\sigma\left(F(x, \Omega_{s})\right)$');
% ay_l.Interpreter = 'latex';
% ay_l.FontSize = 6.5;
% ay_l = gca;
% ay_l.FontSize = 6.5;
% 
% ay_l.YColor = color(1); 
% yyaxis right
% pl_r = plot(loop_vec_1(1:size_loop_vec_1), mean(time_mat(1:size_loop_vec_1(1:size_loop_vec_1), :), 2));
% pl_r.LineStyle = '--';
% pl_r.Marker = 'x';
% pl_r.MarkerSize = 10;
% pl_r.Color = color(2);
% pl_r.LineWidth = 1.5;
% ay_r = ylabel('Minimization time [s]');
% ay_r.Interpreter = 'latex';
% ay_r.FontSize = 6.5;
% ay_r = gca;
% ay_r.FontSize = 6.5;
% ay_r.YColor = color(2);
% xl = xlabel(x_label);
% xl.Interpreter = 'latex';
% xl.FontSize = 6.5;
% tl = title('Final cost and time of the optimization');
% tl.Interpreter = 'latex';
% tl.FontSize = 6.5;
% set(gca,'TickLabelInterpreter','latex')
% fig.Units = "centimeters";
% fig.Position = [0 0 8.8 5];
% 
% if plot_param.print_figure == 1
%   export_figure(fig, 'scenario_number_select_1GTRECDG_2025_12_04.pdf', '..\report\figure');
% end

%% Value of the cost F and time
fig = figure('Color', 'w'); hold on; grid on; box on;
yyaxis left
for a=1:size_loop_vec_1
  errorbar(loop_vec_1(a), statistics{1}.mean_F(a)/1e6, 1.5*std(values_minvalue_mat(a,:))/1e6, 'Marker', '_', 'MarkerSize',10)
  pl_l = plot(loop_vec_1(a), values_minvalue_mat(a,:)/1e6, 'o', 'Color', color(1), 'LineWidth', 1.5, 'MarkerSize',5);
end
ay_l = ylabel('$F(x, \Omega_{s})$ [M\$] ');
ay_l.Interpreter = 'latex';
ay_l.FontSize = 6.5;
ay_l = gca;
ay_l.FontSize = 6.5;
ay_l.YColor = color(1); 
yyaxis right
pl_r = plot(loop_vec_1(1:size_loop_vec_1), mean(time_mat(1:size_loop_vec_1, :), 2));
pl_r.LineStyle = '--';
pl_r.Marker = 'x';
pl_r.MarkerSize = 10;
pl_r.Color = color(2);
pl_r.LineWidth = 1.5;
ay_r = ylabel('Minimization time [s]');
ay_r.Interpreter = 'latex';
ay_r.FontSize = 6.5;
ay_r = gca;
ay_r.FontSize = 6.5;
ay_r.YColor = color(2);
xl = xlabel(x_label);
xl.Interpreter = 'latex';
xl.FontSize = 6.5;

set(gca,'TickLabelInterpreter','latex')
tl = title('Final cost and time of the optimization');
tl.Interpreter = 'latex';
tl.FontSize = 6.5;
fig.Units = "centimeters";
fig.Position = [0 0 8.8 5];


if plot_param.print_figure == 1
  export_figure(fig, 'scenario_number_select_errorbar_1GTRECDG_2025_12_04.pdf', '..\report\figure');
end

%% (Partial) Stability of the solution of the optimiazation
% if ~strcmp(case_sim_vec{1}, 'GT24') 
%   fig = figure('Color', 'w'); hold on; grid on; box on
%   for a=1:size_loop_vec_1
%     for b=1:size_loop_vec_2
% 
%       yyaxis left
%       pl_l = plot(loop_vec_1(a), values_solution{a,b,1}.x_REC(1)); % PV
%       pl_l.Marker = 'o';
%       pl_l.Color = color(1);
%       pl_l.LineWidth = 2;
% 
%       yyaxis right
%       pl_r = plot(loop_vec_1(a), values_solution{a,b,1}.x_ESS_E); % ESS energy size
%       pl_r.Marker = 'x';
%       pl_r.Color = color(2);
%       pl_r.LineWidth = 2;
%     end
%   end
% 
%   yyaxis left
%   ay_l = ylabel('PV number');
%   ay_l.Interpreter = 'latex';
%   ay_l.FontSize = 6.5;
%   ay_l = gca;
%   ay_l.FontSize = 6.5;
%   ay_l.YColor = color(1);
%   xl = xlabel(x_label);
%   xl.Interpreter = 'latex';
%   xl.FontSize = 6.5;
% 
%   yyaxis right
%   ay_r = ylabel('ESS energy size [Wh]');
%   ay_r.Interpreter = 'latex';
%   ay_r.FontSize = 6.5;
%   ay_r = gca;
%   ay_r.FontSize = 6.5;
%   ay_r.YColor = color(2);
% 
%   set(gca,'TickLabelInterpreter','latex')
%   tl = title('Study on the stability of the solution');
%   tl.Interpreter = 'latex';
%   tl.FontSize = 6.5;
%   fig.Units = "centimeters";
%   fig.Position = [0 0 8.8 5];
% 
%   if plot_param.print_figure == 1
%     export_figure(fig, 'solution_stability_1GTRECDG_2025_12_04.pdf', '..\report\figure');
%   end
% end

%% (Complete) Stability of the solution of the optimiazation
scale = [PV.PowRated, WT.PowRated, WEC.PowRated];

if ~strcmp(case_sim_vec{1}, 'GT24') 
  fig = figure('Color','w');
  subplot(3,2,1); hold on; grid on; box on;
  for a=1:size_loop_vec_1
    for b=1:size_loop_vec_2
        pl = plot(loop_vec_1(a), values_minvalue_mat(a,b));
        pl.Marker = marker_vec(1);
        if idx_include(a,b,1) == 0
          pl.Color = 'r';
        else
          pl.Color = 'k';
        end
        pl.LineStyle = 'none';
    end
  end
  % lg = legend('Seed 1', 'Seed 2', 'Seed 3', 'Seed 4');
  % lg.Interpreter = 'latex';
  % lg.NumColumns = 2;
  % lg.Location = 'southeast';
  yl = ylabel('ISS cost');
  yl.Interpreter = "latex";
  yl.FontSize = 6.5;
  xl = xlabel(x_label);
  xl.FontSize = 6.5;
  xl.Interpreter = 'latex';
  ax = gca;
  ax.FontSize = 6.5;
  set(gca,'TickLabelInterpreter','latex')

  subplot(3,2,2);hold on; grid on; box on;
  for a=1:size_loop_vec_1
    for b=1:size_loop_vec_2
      for k=1:length(values_solution{a,b,1}.x_REC)
        pl = plot(loop_vec_1(a), values_solution{a,b,1}.x_REC(k)*scale(k));
        pl.Marker = marker_vec(k);
        if idx_include(a,b,1) == 0
          pl.Color = 'r';
        else
          pl.Color = 'k';
        end
        pl.LineStyle = 'none';
      end
    end
  end
  lg = legend('PV', 'WT', 'WEC');
  lg.Interpreter = 'latex';
  lg.NumColumns = 3;
  lg.Location = 'northeast';
  ax = gca;
  ax.FontSize = 6.5;
  yl = ylabel('REC installed power [MW]');
  yl.Interpreter = "latex";
  yl.FontSize = 6.5;
  set(gca,'TickLabelInterpreter','latex')

  subplot(3,2,3);hold on; grid on; box on;
  for a=1:size_loop_vec_1
    for b=1:size_loop_vec_2
        if ~strcmp(values_solution{a,b,1}.min_info.message, 'INFEASIBLE') 
            plot(loop_vec_1(a), values_solution{a,b,1}.x_ESS_E*BAT.C_storage_u, 'Marker',marker_vec(1), 'Color','k');
        end
    end
  end
  ax = gca;
  ax.FontSize = 6.5;
  yl = ylabel('$E_{BESS} [MWh]$');
  yl.Interpreter = "latex";
  yl.FontSize = 6.5;
  set(gca,'TickLabelInterpreter','latex')

  subplot(3,2,4);hold on; grid on; box on;
  for a=1:size_loop_vec_1
    for b=1:size_loop_vec_2
        if ~strcmp(values_solution{a,b,1}.min_info.message, 'INFEASIBLE') 
            pl = plot(loop_vec_1(a), values_solution{a,b,1}.x_ESS_P*BAT.C_power_u);
            pl.Marker = marker_vec(1);
            if idx_include(a,b,1) == 0
              pl.Color = 'r';
            else
              pl.Color = 'k';
            end
            pl.LineStyle = 'none';
        end
    end
  end
  % lg = legend('Seed 1', 'Seed 2', 'Seed 3', 'Seed 4');
  % lg.Interpreter = 'latex';
  % lg.NumColumns = 2;
  % lg.Location = 'southeast';
  yl = ylabel('$P_{BESS} [MW]$');
  yl.Interpreter = "latex";
  yl.FontSize = 6.5;
  xl = xlabel(x_label);
  xl.FontSize = 6.5;
  xl.Interpreter = 'latex';
  ax = gca;
  ax.FontSize = 6.5;
  set(gca,'TickLabelInterpreter','latex')
  
  subplot(3,2,5);hold on; grid on; box on;
  for a=1:size_loop_vec_1
    for b=1:size_loop_vec_2
        if ~strcmp(values_solution{a,b,1}.min_info.message, 'INFEASIBLE') 
            pl = plot(loop_vec_1(a), (sum(values_vector{a,b,1}.P_GT,'all') + sum(values_vector{a,b,1}.P_DG,'all'))/sum(values_vector{a,b,1}.Pload,'all'));
            pl.Marker = marker_vec(1);
            if idx_include(a,b,1) == 0
              pl.Color = 'r';
            else
              pl.Color = 'k';
            end
            pl.LineStyle = 'none';
        end
    end
  end
  yl = ylabel('$\frac{P_{GT} + P_{DG}}{P_{LOAD}} [MW]$');
  yl.Interpreter = "latex";
  yl.FontSize = 6.5;
  xl = xlabel(x_label);
  xl.FontSize = 6.5;
  xl.Interpreter = 'latex';
  ax = gca;
  ax.FontSize = 6.5;
  set(gca,'TickLabelInterpreter','latex')

  subplot(3,2,6);hold on; grid on; box on;
  yyaxis left
  % for a=1:size_loop_vec_1
  %   for b=1:size_loop_vec_2
  %     if isfield(values_solution{a,b,1}, 'x_GT')
  %       % pl1 = plot(loop_vec_1(a), values_solution{a,b,1}.x_GT(1),'d');
  %       % pl2 = plot(loop_vec_1(a), values_solution{a,b,1}.x_GT(2),'o');
  %       pl3 = plot(loop_vec_1(a), sum(values_solution{a,b,1}.x_GT,1),'x');
  %       % pl.Marker = marker_vec(1);
  %       % if idx_include(a,b,1) == 0
  %       %   pl1.Color = 'r';
  %       %   pl2.Color = 'r';
  %       % else
  %       %   pl1.Color = 'k';
  %       %   pl2.Color = 'k';
  %       % end
  %       % pl1.LineStyle = 'none';
  %       % pl2.LineStyle = 'none';
  %     end
  %   end
  % end
  yl = ylabel('Installed GT');
  yl.Interpreter = "latex";
  yl.FontSize = 6.5;
  yyaxis right
  for a=1:size_loop_vec_1
    for b=1:size_loop_vec_2
        if ~strcmp(values_solution{a,b,1}.min_info.message, 'INFEASIBLE') 
          pl1 = plot(loop_vec_1(a), values_solution{a,b,1}.x_DG*REC.DG.DG_obj{1}.PowRated,'d');
          % pl.Marker = marker_vec(1);
          if idx_include(a,b,1) == 0
            pl1.Color = 'r';
          else
            pl1.Color = 'g';
          end
          pl1.LineStyle = 'none';
        end
    end
  end
  yl = ylabel('Installed DG [MW]');
  yl.Interpreter = "latex";

  xl = xlabel(x_label);
  xl.FontSize = 6.5;
  xl.Interpreter = 'latex';
  ax = gca;
  ax.FontSize = 6.5;
  set(gca,'TickLabelInterpreter','latex')

  tl = sgtitle('Convergence of the solution');
  tl.FontSize = 6.5;
  tl.Interpreter = 'latex';
  fig.Units = "centimeters";
  fig.Position = [0 0 2*8.8 5*6.5];
  if plot_param.print_figure == 1
    export_figure(fig, 'ISS_convergence_1GTRECDG_2025_12_04.pdf', '..\report\figure');
  end
end

%%
fig = figure('Color','w');
subplot(2,1,1);hold on; grid on; box on;

for a=1:size_loop_vec_1
  for b=1:size_loop_vec_2
      if ~strcmp(values_solution{a,b,1}.min_info.message, 'INFEASIBLE') 
        PV_mat(a,b)     = values_solution{a,b,1}.x_REC(1)*scale(1);
        WT_mat(a,b)     = values_solution{a,b,1}.x_REC(2)*scale(2);
        WEC_mat(a,b)    = values_solution{a,b,1}.x_REC(3)*scale(3);    
        BESS_E_mat(a,b) = values_solution{a,b,1}.x_ESS_E*BAT.C_storage_u;
        BESS_P_mat(a,b) = values_solution{a,b,1}.x_ESS_P*BAT.C_power_u;
        DG_mat(a,b)     = values_solution{a,b,1}.x_DG*REC.DG.DG_obj{1}.PowRated;
      end
  end
end
pl = plot(loop_vec_1(1:size_loop_vec_1), mean(PV_mat,2));
pl = plot(loop_vec_1(1:size_loop_vec_1), mean(WT_mat,2));
pl = plot(loop_vec_1(1:size_loop_vec_1), mean(WEC_mat,2));
lg = legend('PV', 'WT', 'WEC');
lg.Interpreter = 'latex';
lg.NumColumns = 3;
lg.Location = 'northeast';
ax = gca;
ax.FontSize = 6.5;
yl = ylabel('REC installed power [MW]');
yl.Interpreter = "latex";
yl.FontSize = 6.5;
set(gca,'TickLabelInterpreter','latex')

subplot(2,1,2);hold on; grid on; box on;
yyaxis left
plot(loop_vec_1(1:size_loop_vec_1), mean(BESS_E_mat, 2));
yl = ylabel('$\widetilde{P}_{BESS}$ [MW]');
yl.Interpreter = "latex";
yl.FontSize = 6.5;
set(gca,'TickLabelInterpreter','latex')
yyaxis right
plot(loop_vec_1(1:size_loop_vec_1), mean(BESS_P_mat, 2));
ax = gca;
ax.FontSize = 6.5;
yl = ylabel('$E_{BESS}$ [MWh]');
yl.Interpreter = "latex";
yl.FontSize = 6.5;
set(gca,'TickLabelInterpreter','latex')

tl = sgtitle('Convergence of the solution');
tl.FontSize = 6.5;
tl.Interpreter = 'latex';
fig.Units = "centimeters";
fig.Position = [0 0 2*8.8 5*6.5];
if plot_param.print_figure == 1
  export_figure(fig, 'ISS_convergence_some_stats_1GTRECDG_2025_12_04.pdf', '..\report\figure');
end

%%
fig = figure('Color','w');hold on; grid on; box on;
yyaxis left
plot(loop_vec_1(1:size_loop_vec_1), mean(BESS_E_mat, 2), 'Color', color(1), 'LineWidth', 1.5,'HandleVisibility','off');
plot(loop_vec_1(1:size_loop_vec_1), std(BESS_E_mat,[], 2), 'Color', color(1), 'LineWidth', 1.5, 'LineStyle','--','HandleVisibility','off');
% errorbar(loop_vec_1(1:size_loop_vec_1), mean(BESS_E_mat, 2), std(BESS_E_mat, [], 2), 'Color', color(1), 'LineWidth', 1.5);
yl = ylabel('$\widetilde{P}_{BESS}$ [MW]');
yl.Interpreter = "latex";
yl.FontSize = 6.5;
yl.Color = color(1);
set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.YAxis(1).Color = color(1);
yyaxis right
plot(loop_vec_1(1:size_loop_vec_1), mean(BESS_P_mat, 2), 'Color', color(2), 'LineWidth', 1.5,'HandleVisibility','off');
plot(loop_vec_1(1:size_loop_vec_1), std(BESS_P_mat,[], 2), 'Color', color(2), 'LineWidth', 1.5, 'LineStyle','--','HandleVisibility','off');
% errorbar(loop_vec_1(1:size_loop_vec_1), mean(BESS_P_mat, 2), std(BESS_P_mat, [], 2), 'Color', color(2), 'LineWidth', 1.5);
ax = gca;
ax.FontSize = 6.5;
yl = ylabel('$E_{BESS}$ [MWh]');
yl.Interpreter = "latex";
yl.FontSize = 6.5;
yl.Color = color(2);
ax.YAxis(2).Color = color(2);
set(gca,'TickLabelInterpreter','latex')
xl = xlabel(x_label);
xl.FontSize = 6.5;
xl.Interpreter = 'latex';
ax = gca;
ax.FontSize = 6.5;
set(gca,'TickLabelInterpreter','latex')

plot(NaN,NaN,'Color','k','LineWidth',1.5,'DisplayName','Mean','LineStyle','-');
plot(NaN,NaN,'Color','k','LineWidth',1.5,'DisplayName','$\sigma$','LineStyle','--');
lg = legend();
lg.Interpreter = 'latex';
lg.Location = 'northwest';
lg.FontSize = 6.5;
lg.ItemTokenSize = [15 15];

tl = sgtitle('Average and standard deviation ofBESS power and energy size');
tl.FontSize = 6.5;
tl.Interpreter = 'latex';
fig.Units = "centimeters";
fig.Position = [0 0 8.8 6.5];
if plot_param.print_figure == 1
  export_figure(fig, 'ISS_convergence_BESS_stats_1GTRECDG_2025_12_04.pdf', '..\report\figure');
end

%% REC and DG installation sizes
fig = figure('Color','w');hold on; grid on; box on;
yyaxis left
plot(loop_vec_1(1:size_loop_vec_1), mean(PV_mat,2), 'LineWidth', 1.5, 'Color', color(1), 'LineStyle', '-', 'DisplayName', 'PV', 'HandleVisibility', 'off');
plot(loop_vec_1(1:size_loop_vec_1), mean(WT_mat,2), 'LineWidth', 1.5, 'Color', color(1), 'LineStyle', '-.', 'DisplayName', 'WT', 'HandleVisibility', 'off');
plot(loop_vec_1(1:size_loop_vec_1), mean(WEC_mat,2), 'LineWidth', 1.5, 'Color', color(1), 'LineStyle', '--', 'DisplayName', 'WEC', 'HandleVisibility', 'off');
plot(loop_vec_1(1:size_loop_vec_1), mean(DG_mat,2), 'LineWidth', 1.5, 'Color', color(1), 'LineStyle', ':', 'DisplayName', 'DG', 'HandleVisibility', 'off');
ax = gca;
ax.FontSize = 6.5;
ax.YColor = color(1);
yl = ylabel('Mean REC/DG installed power [MW]');
yl.Interpreter = "latex";
yl.FontSize = 6.5;
ylim([0 45])
set(gca,'TickLabelInterpreter','latex')

yyaxis right
plot(loop_vec_1(1:size_loop_vec_1), std(PV_mat,[],2), 'LineWidth', 1.5, 'Color', color(2), 'LineStyle', '-', 'DisplayName', 'PV', 'HandleVisibility', 'off');
plot(loop_vec_1(1:size_loop_vec_1), std(WT_mat,[],2), 'LineWidth', 1.5, 'Color', color(2), 'LineStyle', '-.', 'DisplayName', 'WT', 'HandleVisibility', 'off');
plot(loop_vec_1(1:size_loop_vec_1), std(WEC_mat,[],2), 'LineWidth', 1.5, 'Color', color(2), 'LineStyle', '--', 'DisplayName', 'WEC', 'HandleVisibility', 'off');
plot(loop_vec_1(1:size_loop_vec_1), std(DG_mat,[],2), 'LineWidth', 1.5, 'Color', color(2), 'LineStyle', ':', 'DisplayName', 'DG', 'HandleVisibility', 'off');
ax = gca;
ax.FontSize = 6.5;
ax.YColor = color(2);
yl = ylabel('$\sigma$ REC/DG installed power [MW]');
yl.Interpreter = "latex";
yl.FontSize = 6.5;

plot(NaN, NaN, 'LineWidth', 1.5, 'Color', 'k', 'LineStyle', '-', 'DisplayName', 'PV', 'marker', 'none');
plot(NaN, NaN, 'LineWidth', 1.5, 'Color', 'k', 'LineStyle', '-.', 'DisplayName', 'WT', 'marker', 'none');
plot(NaN, NaN, 'LineWidth', 1.5, 'Color', 'k', 'LineStyle', '--', 'DisplayName', 'WEC', 'marker', 'none');
plot(NaN, NaN, 'LineWidth', 1.5, 'Color', 'k', 'LineStyle', ':', 'DisplayName', 'DG', 'marker', 'none');
lg = legend();
lg.Interpreter = 'latex';
lg.Location = 'northeast';
lg.NumColumns = 2;
lg.FontSize = 6.5;
lg.ItemTokenSize = [15 15];

xl = xlabel('$| \Omega_{s} |$');
xl.Interpreter = "latex";
xl.FontSize = 6.5;

tl = sgtitle('REC and DG installed power');
tl.FontSize = 6.5;
tl.Interpreter = 'latex';
fig.Units = "centimeters";
fig.Position = [0 0 8.8 5];
if plot_param.print_figure == 1
  export_figure(fig, 'ISS_convergence_REC_DG_1GTRECDG_2025_12_04.pdf', '..\report\figure');
end
%%
fig = figure('Color','w');hold on; grid on; box on;
t = tiledlayout(2,1,'TileSpacing','compact','Padding','compact');
ax = nexttile(1); hold on; grid on; box on;
% yyaxis left
plot(loop_vec_1(1:size_loop_vec_1), mean(PV_mat,2),   'LineWidth', 1.5, 'Color', color(1), 'LineStyle', '-', 'DisplayName', 'PV', 'HandleVisibility', 'off');
plot(loop_vec_1(1:size_loop_vec_1), mean(WT_mat,2),   'LineWidth', 1.5, 'Color', color(2), 'LineStyle', '-', 'DisplayName', 'WT', 'HandleVisibility', 'off');
plot(loop_vec_1(1:size_loop_vec_1), mean(WEC_mat,2),  'LineWidth', 1.5, 'Color', color(3), 'LineStyle', '-', 'DisplayName', 'WEC', 'HandleVisibility', 'off');
plot(loop_vec_1(1:size_loop_vec_1), mean(DG_mat,2),   'LineWidth', 1.5, 'Color', color(4), 'LineStyle', '-', 'DisplayName', 'DG', 'HandleVisibility', 'off');
ax = gca;
ax.FontSize = 6.5;
ax.YColor = 'k';
yl = ylabel('Mean REC/DG power [MW]');
yl.Interpreter = "latex";
yl.FontSize = 6.5;
ylim([0 45])
set(gca,'TickLabelInterpreter','latex')

% yyaxis right
% plot(loop_vec_1(1:size_loop_vec_1), std(PV_mat,[],2), 'LineWidth', 1.5, 'Color', color(2), 'LineStyle', '-', 'DisplayName', 'PV', 'HandleVisibility', 'off');
% plot(loop_vec_1(1:size_loop_vec_1), std(WT_mat,[],2), 'LineWidth', 1.5, 'Color', color(2), 'LineStyle', '-.', 'DisplayName', 'WT', 'HandleVisibility', 'off');
% plot(loop_vec_1(1:size_loop_vec_1), std(WEC_mat,[],2), 'LineWidth', 1.5, 'Color', color(2), 'LineStyle', '--', 'DisplayName', 'WEC', 'HandleVisibility', 'off');
% plot(loop_vec_1(1:size_loop_vec_1), std(DG_mat,[],2), 'LineWidth', 1.5, 'Color', color(2), 'LineStyle', ':', 'DisplayName', 'DG', 'HandleVisibility', 'off');
% ax = gca;
% ax.FontSize = 6.5;
% ax.YColor = color(2);
% yl = ylabel('$\sigma$ REC/DG installed power [MW]');
% yl.Interpreter = "latex";
% yl.FontSize = 6.5;

plot(NaN, NaN, 'LineWidth', 1.5, 'Color', color(6), 'LineStyle', '-', 'DisplayName', '$\widetilde{P}_{PV}$', 'marker', 'none');
plot(NaN, NaN, 'LineWidth', 1.5, 'Color', color(2), 'LineStyle', '-', 'DisplayName', '$\widetilde{P}_{WT}$', 'marker', 'none');
plot(NaN, NaN, 'LineWidth', 1.5, 'Color', color(3), 'LineStyle', '-', 'DisplayName', '$\widetilde{P}_{WEC}$', 'marker', 'none');
plot(NaN, NaN, 'LineWidth', 1.5, 'Color', color(4), 'LineStyle', '-', 'DisplayName', '$\widetilde{P}_{DG}$', 'marker', 'none');
lg = legend();
lg.Interpreter = 'latex';
lg.Location = 'east';
lg.NumColumns = 2;
lg.FontSize = 6.5;
lg.ItemTokenSize = [15 15];

ax = nexttile(2); hold on; grid on; box on;
yyaxis left
plot(loop_vec_1(1:size_loop_vec_1), mean(BESS_P_mat,2),   'LineWidth', 1.5, 'Color', color(5), 'LineStyle', '-', 'DisplayName', '$\widetilde{P}_{B}$', 'HandleVisibility', 'off');
ax = gca;
ax.FontSize = 6.5;
ax.YColor = color(5);
yl = ylabel('Mean BESS power [MW]');
yl.Interpreter = "latex";
yl.FontSize = 6.5;
ylim([0 10])
set(gca,'TickLabelInterpreter','latex')

yyaxis right
plot(loop_vec_1(1:size_loop_vec_1), mean(BESS_E_mat,2),   'LineWidth', 1.5, 'Color', color(1), 'LineStyle', '-', 'DisplayName', '$\widetilde{E}_{B}$', 'HandleVisibility', 'off');
ax = gca;
ax.FontSize = 6.5;
ax.YColor = color(1);
yl = ylabel('Mean BESS energy [MWh]');
yl.Interpreter = "latex";
yl.FontSize = 6.5;
ylim([0 45])
set(gca,'TickLabelInterpreter','latex')

xl = xlabel('$| \Omega_{s} |$');
xl.Interpreter = "latex";
xl.FontSize = 6.5;

% tl = sgtitle('REC and DG installed power');
% tl.FontSize = 6.5;
% tl.Interpreter = 'latex';
fig.Units = "centimeters";
fig.Position = [0 0 8.8 8];
if plot_param.print_figure == 1
  export_figure(fig, 'ISS_convergence_REC_DG_ESS_1GTRECDG_2025_12_04.pdf', '..\report\figure');
end

%% REC and DG installation sizes errorbar
fig = figure('Color','w');hold on; grid on; box on;
yyaxis left
errorbar(loop_vec_1(1:size_loop_vec_1), mean(PV_mat,2),  std(PV_mat,[],2),     'LineWidth', 1.5, 'Color', color(14), 'LineStyle', '-', 'DisplayName', 'PV', 'HandleVisibility', 'off', 'Marker', 'none');
errorbar(loop_vec_1(1:size_loop_vec_1), mean(WT_mat,2),  std(WT_mat,[],2),     'LineWidth', 1.5, 'Color', color(2), 'LineStyle', '-', 'DisplayName', 'WT', 'HandleVisibility', 'off', 'Marker', 'none');
errorbar(loop_vec_1(1:size_loop_vec_1), mean(WEC_mat,2), std(WEC_mat,[],2),    'LineWidth', 1.5, 'Color', color(3), 'LineStyle', '-', 'DisplayName', 'WEC', 'HandleVisibility', 'off', 'Marker', 'none');
errorbar(loop_vec_1(1:size_loop_vec_1), mean(DG_mat,2),  std(DG_mat,[],2),     'LineWidth', 1.5, 'Color', color(7), 'LineStyle', '-', 'DisplayName', 'DG', 'HandleVisibility', 'off', 'Marker', 'none');
errorbar(loop_vec_1(1:size_loop_vec_1),mean(BESS_P_mat,2),std(BESS_P_mat,[],2),'LineWidth', 1.5, 'Color', color(4), 'LineStyle', '-', 'DisplayName', 'DG', 'HandleVisibility', 'off', 'Marker', 'none');
ax = gca;
ax.FontSize = 6.5;
ax.YColor = 'k';
yl = ylabel('REC/DG/BESS installed power [MW]');
yl.Interpreter = "latex";
yl.FontSize = 6.5;
ylim([-5 55])
yyaxis right
errorbar(loop_vec_1(1:size_loop_vec_1),mean(BESS_E_mat,2),std(BESS_E_mat,[],2),'LineWidth', 1.1, 'Color', color(1), 'LineStyle', '-', 'DisplayName', 'DG', 'HandleVisibility', 'off', 'Marker', 'none');
ax = gca;
ax.FontSize = 6.5;
ax.YColor = 'k';
yl = ylabel('BESS installed energy [MWh]');
yl.Interpreter = "latex";
yl.FontSize = 6.5;
ylim([0 65])
set(gca,'TickLabelInterpreter','latex')

yyaxis left
plot(NaN, NaN, 'LineWidth', 1.5, 'Color', color(14), 'LineStyle', '-', 'DisplayName','$\widetilde{P}_{PV}$', 'marker', 'none');
plot(NaN, NaN, 'LineWidth', 1.5, 'Color', color(2), 'LineStyle', '-', 'DisplayName', '$\widetilde{P}_{WT}$', 'marker', 'none');
plot(NaN, NaN, 'LineWidth', 1.5, 'Color', color(3), 'LineStyle', '-', 'DisplayName', '$\widetilde{P}_{WEC}$', 'marker', 'none');
plot(NaN, NaN, 'LineWidth', 1.5, 'Color', color(7), 'LineStyle', '-', 'DisplayName', '$\widetilde{P}_{DG}$', 'marker', 'none');
plot(NaN, NaN, 'LineWidth', 1.5, 'Color', color(4), 'LineStyle', '-', 'DisplayName', '$\widetilde{P}_{B}$', 'marker', 'none');
yyaxis right
plot(NaN, NaN, 'LineWidth', 1.5, 'Color', color(1), 'LineStyle', '-', 'DisplayName', '$\widetilde{E}_{B}$', 'marker', 'none');
lg = legend();
lg.Interpreter = 'latex';
lg.Location = 'northeast';
lg.NumColumns = 6;
lg.FontSize = 6.5;
lg.ItemTokenSize = [10 5];

xl = xlabel('$| \Omega_{s} |$');
xl.Interpreter = "latex";
xl.FontSize = 6.5;

tl = sgtitle('REC, DG, and BESS installed powers and energy and distributions');
tl.FontSize = 6.5;
tl.Interpreter = 'latex';
fig.Units = "centimeters";
fig.Position = [20 30 8.8 5];
if plot_param.print_figure == 1
  export_figure(fig, 'ISS_convergence_REC_DG_errorbar_1GTRECDG_2025_12_04.pdf', '..\report\figure');
end

%% Not renewable production
fig=figure('Color','w');hold on; grid on; box on;
for a=1:size_loop_vec_1
  for b=1:size_loop_vec_2
      if ~strcmp(values_solution{a,b,1}.min_info.message, 'INFEASIBLE') 
        NRE(a,b) =(sum(values_vector{a,b,1}.P_GT,'all') + sum(values_vector{a,b,1}.P_DG,'all'))/sum(values_vector{a,b,1}.Pload,'all');
      end
  end
end

pl = plot(loop_vec_1(1:size_loop_vec_1), mean(NRE, 2), 'Color', color(1), 'LineWidth', 1.5);
yl = ylabel('$\frac{E_{GT} + E_{DG}}{E_{LOAD}}$ [\%]');
yl.Interpreter = "latex";
yl.FontSize = 6.5;
xl = xlabel(x_label);
xl.FontSize = 6.5;
xl.Interpreter = 'latex';
ax = gca;
ax.FontSize = 6.5;
set(gca,'TickLabelInterpreter','latex')
tl = sgtitle('Fraction of not renewable energy over the load energy');
tl.FontSize = 6.5;
tl.Interpreter = 'latex';
fig.Units = "centimeters";
fig.Position = [0 0 8.8 6];
if plot_param.print_figure == 1
  export_figure(fig, 'ISS_not_ren_energy_1GTRECDG_2025_12_04.pdf', '..\report\figure');
end

%% Convergence of the statistics normalized
fig = figure('Color','w'); grid on; box on; hold on;
% plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.mean_F, 'Color', color(1), 'LineWidth', 1.5, 'DisplayName', '$\bar{F}$');
% plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.median_F, 'Color', color(2), 'LineWidth', 1.5, 'DisplayName', '$Median$');
% plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.iqr_F, 'Color', color(3), 'LineWidth', 1.5, 'DisplayName', '$IQR$');
% plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.std_F, 'Color', color(4), 'LineWidth', 1.5, 'DisplayName', '$\sigma(F)$');
% plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.range_F, 'Color', color(5), 'LineWidth', 1.5, 'DisplayName', '$Range$');
yyaxis left % plot the quantitites in [dollars]
plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.mean_F(1:size_loop_vec_1)/statistics{1}.mean_F(1), 'Color', color(1), 'LineWidth', 1.5, 'DisplayName', '$\bar{F}$', 'LineStyle', '-');
plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.median_F(1:size_loop_vec_1)/statistics{1}.median_F(1) , 'Color', color(1), 'LineWidth', 1.5, 'DisplayName', '$Median$', 'LineStyle', ':');
plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.percentile_F(1:size_loop_vec_1,1)/statistics{1}.percentile_F(1,1), 'Color', color(1), 'LineWidth', 1.5, 'DisplayName', '$99 perc.$', 'LineStyle', '--');
plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.percentile_F(1:size_loop_vec_1,2)/statistics{1}.percentile_F(1,2), 'Color', color(1), 'LineWidth', 1.5, 'DisplayName', '$90 perc.$', 'LineStyle', '-.');
% plot(loop_vec_1, statistics{1}.iqr_F/statistics{1}.iqr_F(1), 'Color', color(3), 'LineWidth', 1.5, 'DisplayName', '$IQR$');

yyaxis right % plot the quantities related to the distribution
plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.std_F(1:size_loop_vec_1)/statistics{1}.std_F(1), 'Color', color(2), 'LineWidth', 1.5, 'DisplayName', '$\sigma(F)$', 'LineStyle', '-');
plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.range_F(1:size_loop_vec_1)/statistics{1}.range_F(1), 'Color', color(2), 'LineWidth', 1.5, 'DisplayName', '$Range$', 'LineStyle', '-.');
lg = legend();
lg.Interpreter = 'latex';
lg.Location = 'southoutside';
lg.FontSize = 6.5;
lg.ItemTokenSize = [10 10];
lg.NumColumns = 6;

yyaxis left
yl = ylabel('Normalized');
yl.Interpreter = 'latex';
yl.FontSize = 6.5;
yl = gca;
yl.YColor = color(1);
yyaxis right
yr = ylabel('Normalized');
yr.Interpreter = 'latex';
yr.FontSize = 6.5;
yr = gca;
yr.YColor = color(2);

xl = xlabel(x_label);
xl.Interpreter = 'latex';
ax = gca;
ax.FontSize = 6.5;
set(gca,'TickLabelInterpreter','latex')
fig.Units = "centimeters";
fig.Position = [0 0 8.8 6];
if plot_param.print_figure == 1
  export_figure(fig, 'ISS_convergence_statistics_normalized_1GTRECDG_2025_12_04.pdf', '..\report\figure');
end

%% Convergence of the statistics
fig = figure('Color','w'); grid on; box on; hold on;
% plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.mean_F, 'Color', color(1), 'LineWidth', 1.5, 'DisplayName', '$\bar{F}$');
% plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.median_F, 'Color', color(2), 'LineWidth', 1.5, 'DisplayName', '$Median$');
% plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.iqr_F, 'Color', color(3), 'LineWidth', 1.5, 'DisplayName', '$IQR$');
% plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.std_F, 'Color', color(4), 'LineWidth', 1.5, 'DisplayName', '$\sigma(F)$');
% plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.range_F, 'Color', color(5), 'LineWidth', 1.5, 'DisplayName', '$Range$');
yyaxis left % plot the quantitites in [dollars]
plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.mean_F(1:size_loop_vec_1)/1e6, 'Color', color(1), 'LineWidth', 1.5, 'DisplayName', '$\bar{F}$', 'LineStyle', '-');
plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.median_F(1:size_loop_vec_1)/1e6 , 'Color', color(1), 'LineWidth', 1.5, 'DisplayName', '$Median$', 'LineStyle', ':');
% plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.percentile_F(1:size_loop_vec_1,1)/1e6, 'Color', color(1), 'LineWidth', 1.5, 'DisplayName', '$99-percentile$', 'LineStyle', '--');
plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.percentile_F(1:size_loop_vec_1,2)/1e6, 'Color', color(1), 'LineWidth', 1.5, 'DisplayName', '$90-perc.$', 'LineStyle', '-.');

yyaxis right % plot the quantities related to the distribution
plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.std_F(1:size_loop_vec_1)/1e6, 'Color', color(2), 'LineWidth', 1.5, 'DisplayName', '$\sigma(F)$', 'LineStyle', '-');
plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.range_F(1:size_loop_vec_1)/1e6, 'Color', color(2), 'LineWidth', 1.5, 'DisplayName', '$Range$', 'LineStyle', '--');
% plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.iqr_F/1e6, 'Color', color(3), 'LineWidth', 1.5, 'DisplayName', '$IQR$');
lg = legend();
lg.Interpreter = 'latex';
% lg.Location = 'east';
lg.Location = 'southoutside';
lg.FontSize = 6.5;
lg.ItemTokenSize = [13, 12];
lg.NumColumns = 5;

yyaxis left
yl = ylabel('Mean, Median, Perc. [M\$]');
yl.Interpreter = 'latex';
yl.FontSize = 6.5;
yl = gca;
yl.YColor = color(1);
yyaxis right
yr = ylabel('$\sigma$, Range [M\$]');
yr.Interpreter = 'latex';
yr.FontSize = 6.5;
yr = gca;
yr.YColor = color(2);

xl = xlabel(x_label);
xl.Interpreter = 'latex';
ax = gca;
ax.FontSize = 6.5;
set(gca,'TickLabelInterpreter','latex')
fig.Units = "centimeters";
fig.Position = [0 0 8.8 6];
if plot_param.print_figure == 1
  export_figure(fig, 'ISS_convergence_statistics_1GTRECDG_2025_12_04.pdf', '..\report\figure');
end

%% Convergence of the statistics{1}
fig = figure('Color','w'); grid on; box on; hold on;
% plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.mean_F, 'Color', color(1), 'LineWidth', 1.5, 'DisplayName', '$\bar{F}$');
plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.median_F(1:size_loop_vec_1) , 'Color', color(1), 'LineWidth', 1.5, 'DisplayName', '$Median$');
% plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.iqr_F, 'Color', color(3), 'LineWidth', 1.5, 'DisplayName', '$IQR$');
% plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.std_F, 'Color', color(4), 'LineWidth', 1.5, 'DisplayName', '$\sigma(F)$');
plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.range_F(1:size_loop_vec_1), 'Color', color(2), 'LineWidth', 1.5, 'DisplayName', '$Range$');
plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.percentile_F(1:size_loop_vec_1,1), 'Color', color(3), 'LineWidth', 1.5, 'DisplayName', '$99-perc.$');
plot(loop_vec_1(1:size_loop_vec_1), statistics{1}.percentile_F(1:size_loop_vec_1,2), 'Color', color(4), 'LineWidth', 1.5, 'DisplayName', '$90-perc.$');
lg = legend();
lg.Interpreter = 'latex';
lg.Location = 'northwest';
lg.FontSize = 6.5;
lg.ItemTokenSize = [10 10];
yl = ylabel('[\$]');
yl.Interpreter = 'latex';
xl = xlabel(x_label);
xl.Interpreter = 'latex';
ax = gca;
ax.FontSize = 6.5;
set(gca,'TickLabelInterpreter','latex')
fig.Units = "centimeters";
fig.Position = [0 0 8.8 5];
if plot_param.print_figure == 1
  export_figure(fig, 'ISS_convergence_statistics_some_stats_1GTRECDG_2025_12_04.pdf', '..\report\figure');
end

% %% Installed power
% fig = figure('Color','w');hold on; grid on; box on;
% for a=1:size_loop_vec_1
%   for b=1:size_loop_vec_2
%       pl = plot(loop_vec_1(a), values_solution{a,b,1}.P_TOT_REC/1e6);
%       pl.Marker = marker_vec(1);
%       if idx_include(a,b,1) == 0
%         pl.Color = 'r';
%       else
%         pl.Color = 'k';
%       end
%       pl.LineStyle = 'none';
%   end
% end
% yl = ylabel('[MW]');
% yl.Interpreter = "latex";
% yl.FontSize = 6.5;
% xl = xlabel(x_label);
% xl.FontSize = 6.5;
% xl.Interpreter = 'latex';
% ax = gca;
% ax.FontSize = 6.5;
% set(gca,'TickLabelInterpreter','latex')
% tl = title('Total REC installed power');
% tl.FontSize = 6.5;
% tl.Interpreter = 'latex';
% fig.Units = "centimeters";
% fig.Position = [0 0 8.8 5];
% if plot_param.print_figure == 1
%   export_figure(fig, 'P_res_nominal_1GTRECDG_2025_12_04.pdf', '..\report\figure');
% end

%% Convergence of the solution
idx_sum = sum(idx_include,2);
fig = figure('Color','w');hold on; grid on; box on;
for a=1:size_loop_vec_1
  optimal_sol = 0;
  for b=1:size_loop_vec_2
      yyaxis left
      if ~strcmp(values_solution{a,b,1}.min_info.message, 'INFEASIBLE') 
          pl = plot(loop_vec_1(a), values_solution{a,b,1}.min_info.relativegap);
          pl.Marker = marker_vec(1);
            if idx_include(a,b,1) == 0
              pl.Color = 'r';
            else
              pl.Color = 'k';
            end
          pl.LineStyle = 'none';   
      end
  end
end
yyaxis right
pl = plot(loop_vec_1(1:size_loop_vec_1),idx_sum);
pl.Marker = marker_vec(2);
pl.Color = 'r';
pl.LineStyle = 'none';
yyaxis left
ylin = yline(1e-3*100);
ylin.Color = 'r';
ylin.LineStyle = '--';
ylin.Label = 'Convergence threshold';
yl.Color = 'r';
yl = ylabel('Rel. gap');
yl.Interpreter = "latex";
yl.FontSize = 6.5;
yyaxis right
yl = ylabel('Optimal solution');
yl.Interpreter = "latex";
yl.FontSize = 6.5;
yl.Color = 'b';
% ylim([-0.1 1.1])
xl = xlabel(x_label);
xl.FontSize = 6.5;
xl.Interpreter = 'latex';
ax = gca;
ax.FontSize = 6.5;
set(gca,'TickLabelInterpreter','latex')
tl = title('Relative gap and optimla solution');
tl.FontSize = 6.5;
tl.Interpreter = 'latex';
fig.Units = "centimeters";
fig.Position = [0 0 8.8 5];
if plot_param.print_figure == 1
  export_figure(fig, 'optimal_sol_1GTRECDG_2025_12_04.pdf', '..\report\figure');
end

%% Cost fraction not normalized

fig = figure('Color', 'w'); hold on; grid on; box on;
nrows = ceil((size_loop_vec_1-1)/2) + 1;
for a=1:size_loop_vec_1
  num_costs =  size([values_solution{1,1,1}.cost_fraction(:).val], 2);
  cost_frac_not_norm = zeros(size_loop_vec_2, num_costs, 1);
  axesHandles(a) = subplot(nrows, 2, a);
  for b=1:size_loop_vec_2
    if idx_include(a,b) == 1
      cost_frac_not_norm(b,1:num_costs,1) = [values_solution{a,b,1}.cost_fraction(:).val]*values_minvalue{a,b,1};
    end
  end

  b_plot = bar(cost_frac_not_norm/1e6,'stacked');
  % for i=1:size(b_plot, 2)
  %   b_plot(i).FaceColor  = color(i);
  % end
  b_plot(1).FaceColor  = color(1); % GT operation
  b_plot(4).FaceColor  = color(3); % installed REC
  b_plot(6).FaceColor  = color(6); % GT installation
  b_plot(8).FaceColor  = color(2); % installed BAT

  set(gca,'xtick',[])
  set(gca,'xticklabel',[])
  set(gca,'TickLabelInterpreter','latex')
  tl = title([x_label, ' = ', num2str(loop_vec_1(a))]);
  tl.Interpreter = 'latex';
  tl.FontSize = 6.5;

  if a == size_loop_vec_1 || a == size_loop_vec_1-1
    xlabel('Experiment','Interpreter','latex','FontSize',15)
    % xticks(loop_vec_2);
    % xticklabels(loop_vec_2);
    set(gca,'TickLabelInterpreter','latex')
  end
end

axLegend = subplot(nrows, 2, a+1); 
axis off; % hide axis for legend-only subplot
% lg = legend([{values_solution{1,1}.cost_fraction(:).name}, 'CO$_{2}$ reduction']);%, '$q^{T}y_{Pv}$');
lg = legend(axLegend, b_plot, {values_solution{1,1}.cost_fraction(:).name});
lg.Interpreter = 'latex';
lg.NumColumns = 2;
lg.ItemTokenSize = [5 5];
lg.Location = 'southoutside';
set(gca,'TickLabelInterpreter','latex')

tl = sgtitle('Contribution to the daily cost $F$ [M\$]');
tl.Interpreter = 'latex';
tl.FontSize = 6.5;
fig.Units = "centimeters";
fig.Position = [0 0 2*8.8 5*6];
if plot_param.print_figure == 1
  export_figure(fig, 'cost_fraction_not_normalized_base_case_2025_08_07.pdf', '..\report\figure');
end

