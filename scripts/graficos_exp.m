%% Tidy up
clear; clc; close all;

%% Function call
raw_data1 = readtable("..\exp_data\scope_12.csv", 'VariableNamingRule', 'preserve');
raw_data2 = readtable("..\exp_data\scope_13.csv", 'VariableNamingRule', 'preserve');
plot_time(raw_data1, raw_data2);

%% Function declarations
function plot_time(data1, data2)
    % gather data
    t1  = data1{:,1} .* 1000; % convert to ms
    v11 = data1{:,2};
    vO1 = data1{:,3};

    t2  = data2{:,1} .* 1000; % convert to ms
    v12 = data2{:,2};
    vO2 = data2{:,3};

    % plot pairs
    plot_pair(t1, v11, "$v_{1}$", vO1, "$v_{o1}$");
    plot_pair(t2, v12, "$v_{1}$", vO2, "$v_{o2}$");
    plot_pair(t1, v11, "$v_{1}$", vO1-vO2, "$v_{o12}$");
end

function plot_pair(t, y1, y1_legend, y2, y2_legend)
    % plots
    figure
    set(gcf, 'Position',  [100, 100, 660, 340]);

    plot(t, y1, 'Color', [0.82 0.24 0.33], 'LineWidth', 1.5); hold on;
    plot(t, y2, 'Color', [0.0 0.24 0.33], 'LineWidth', 1.5); hold off;
    grid on, grid minor;

    legend(y1_legend, y2_legend, 'FontSize', 12, 'Interpreter', 'latex', ...
        'Location', 'southwest', 'Orientation', 'vertical');

    % calculate RMS values
    y1_rms = rms(y1)
    y2_rms = rms(y2)
    ans = y2_rms/y1_rms

    % customise axis labels
    ax = gca;
    ax.FontSize = 11;
    ax.TickLabelInterpreter = 'latex';
    set_axis_labels(gca().YAxis, 'V');
    set_axis_labels(gca().XAxis, 'ms');
end

% Adds a symbol to the y-axis tick labels
function set_axis_labels(axis, unit)
    axis.Exponent = 0;  % disable scientific notation
    tick_values = get(axis, 'TickValues');
    tick_labels = arrayfun(@(x)[num2str(x), unit], tick_values, 'UniformOutput', false);
    set(axis, 'TickLabels', tick_labels);
end