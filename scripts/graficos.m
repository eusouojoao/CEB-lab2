clear; clc; close all;

%%
% Read the .csv
raw_data1 = readtable("..\sim_data\4_2.csv", 'VariableNamingRule', 'preserve');
% call the functions that handle the plots
plot_transfer(raw_data1);
% plot_time(raw_data1);
% plot_4_8(raw_data1);

%% Functions
function plot_transfer(data)
    % plots
    figure
    set(gcf, 'Position',  [100, 100, 660, 340]);
    % vO1 and vO2
    subplot(2,1,1);
    plot(data{:,1}, data{:,2}, 'Color', [0.10 0.25 0.85], 'LineWidth', 1.5); hold on;
    plot(data{:,1}, data{:,4}, 'Color', [0.8500 0.3250 0.0980], 'LineWidth', 1.5); hold on;
    yline(6, '--', 'Color', [0.02 0.02 0.02], 'LineWidth', 1.75); hold on;
    yline(0.9, '--', 'Color', [0.02 0.02 0.02], 'LineWidth', 1.75); hold on;
    xline(0, '--', 'Color', [0.02 0.02 0.02], 'LineWidth', 1.75); hold on;
    plot(0, 3.446, 's', 'MarkerSize', 8, 'MarkerFaceColor', [0.01 0.24 0.33], 'MarkerEdgeColor','none'); hold off;
    grid on, grid minor; 
    legend('$v_{O1}(v_{D})$', '$v_{O2}(v_{D})$', 'FontSize', 12, 'Interpreter', 'latex', ...
        'Location', 'southwest', 'Orientation', 'vertical');
    ylim([0 7]);
    % customise axis labels
    ax = gca;
    ax.FontSize = 11;
    ax.TickLabelInterpreter = 'latex';
    set_axis_labels(gca().YAxis, 'V');
    set_axis_labels(gca().XAxis, 'V');

    % vO12
    subplot(2,1,2); 
    plot(data{:,1}, data{:,3}, 'Color', [0.0 0.24 0.33], 'LineWidth', 1.5); hold on;
    yline(5.1, '--', 'Color', [0.02 0.02 0.02], 'LineWidth', 1.75); hold on;
    yline(-5.1, '--', 'Color', [0.02 0.02 0.02], 'LineWidth', 1.75); hold on;
    xline(0, '--', 'Color', [0.02 0.02 0.02], 'LineWidth', 1.75); hold off;
    grid on, grid minor; 
    legend('$v_{O12}(v_{D})$', 'FontSize', 12, 'Interpreter', 'latex', ...
        'Location', 'southwest', 'Orientation', 'horizontal');
    ylim([-7 7]);
    % customise axis labels
    ax = gca;
    ax.FontSize = 11;
    ax.TickLabelInterpreter = 'latex';
    set_axis_labels(gca().YAxis, 'V');
    set_axis_labels(gca().XAxis, 'V');
end

function plot_time(data)
    % plots
    figure
    set(gcf, 'Position',  [100, 100, 660, 340]);

    t = data{:,1} .* 1000; % convert to ms

    plot(t, data{:,2}, 'Color', [0.82 0.24 0.33], 'LineWidth', 1.5); hold on;           % vD / vC
    plot(t, data{:,3}, 'Color', [0.10 0.25 0.85], 'LineWidth', 1.5); hold on;           % vO1
    plot(t, data{:,4}, 'Color', [0.8500 0.3250 0.0980], 'LineWidth', 1.5); hold on;     % vO2
    plot(t, data{:,5}, 'Color', [0.0 0.24 0.33], 'LineWidth', 1.5); hold off;           % vO12
    grid on, grid minor; 

    lgd = legend('$v_{C}$', '$v_{O1} \equiv v_{O2}$', '$v_{O12}$', 'FontSize', 12, 'Interpreter', 'latex', ...
        'Orientation', 'horizontal');
    % manually specify the location of the legend 
    lgd.Position = [0.668, 0.85, 0.05, 0.05];

    % customise axis labels
    ax = gca;
    ax.FontSize = 11;
    ax.TickLabelInterpreter = 'latex';
    set_axis_labels(gca().YAxis, 'V');
    set_axis_labels(gca().XAxis, 'ms');
end

function plot_4_8(data)
    % plots
    figure
    set(gcf, 'Position',  [100, 100, 660, 340]);

    t = data{:,1} .* 1000; % convert to mV
    V = data{:,2} .* 1000; % convert to mV

    [~, id0x] = min(abs(t)); % find the index where x is closest to zero
    V(id0x)
    [~, id0y] = min(abs(V)); % find the index where y is closest to zero
    t(id0y)

    plot(t, V, 'Color', [0.0 0.24 0.33], 'LineWidth', 1.5); hold on;
    xline(0, '--', 'Color', [0.02 0.02 0.02], 'LineWidth', 1.75); hold on;
    if ~isempty(id0x)
        plot(0, V(id0x), 's', 'MarkerSize', 8, 'MarkerFaceColor', [0.01 0.01 0.01], 'MarkerEdgeColor','none'); hold on;
    end
    yline(0, '--', 'Color', [0.02 0.02 0.02], 'LineWidth', 1.75); hold on;
    if ~isempty(id0y)
        plot(t(id0y), 0, 's', 'MarkerSize', 8, 'MarkerFaceColor', [0.01 0.01 0.01], 'MarkerEdgeColor','none'); hold off;
    end
    grid on, grid minor; 

    % customise axis labels
    ax = gca;
    ax.FontSize = 11;
    ax.TickLabelInterpreter = 'latex';
    set_axis_labels(ax.YAxis, 'mV');
    set_axis_labels(ax.XAxis, 'mV');
end

% Adds a symbol to the y-axis tick labels
function set_axis_labels(axis, unit)
    axis.Exponent = 0;  % disable scientific notation
    tick_values = get(axis, 'TickValues');
    tick_labels = arrayfun(@(x)[num2str(x), unit], tick_values, 'UniformOutput', false);
    set(axis, 'TickLabels', tick_labels);
end

function set_yaxis_labels(axis, unit)
    axis.Exponent = 0;  % disable scientific notation
    tick_values = get(axis, 'TickValues');
    tick_labels = arrayfun(@(x)[sprintf('%.3f', x), unit], tick_values, 'UniformOutput', false);
    set(axis, 'TickLabels', tick_labels);
end