clear; clc; close all;

%% Read the .csv
raw_data = readtable("..\sim_data\4_6_Ric.csv", 'VariableNamingRule', 'preserve');

%% Convert dB to linear and to kilo units
linear = db2mag(raw_data{:,2}) / 1000000;

%% Plot
figure
set(gcf, 'Position',  [100, 100, 660, 340]);
grid on, grid minor;

% change axis tick labels size
ax = gca;
ax.FontSize = 11;
ax.TickLabelInterpreter = 'latex';

% x-axis
xlim([1e1 1e2])
% set x-axis tick locations and labels
xticks = [10, 20, 30, 40, 50, 60, 70, 80, 90 100];
xticklabels = {'10Hz', '20Hz', '30Hz', '40Hz', '50Hz', '60Hz', '70Hz', '80Hz', '90Hz', '100Hz'};
set(gca, 'XTick', xticks, 'XTickLabel', xticklabels);

% left side
yyaxis left; 
plot(raw_data{:,1}, linear, 'Color', [0 0 0], 'LineWidth', 1.5); hold on;
set(gca, 'YColor', [0 0 0])  % change left y-axis color to black
% ylim([25.2 25.8])
ylim([1.4 2])
set_axis_labels(gca().YAxis(1), 'M$\Omega$'); % add kilo-ohm symbol to y-axis tick labels

% right side
yyaxis right; 
plot(raw_data{:,1}, raw_data{:,3}, '--', 'Color', [0.3 0.3 0.3], 'LineWidth', 1.5);
set(gca, 'YColor', [0.1 0.1 0.1])  % change right y-axis color to gray
ylim([177 183])
% ylim([-3 3])
set_axis_labels(gca().YAxis(2), '$^\circ$'); % add degree symbol to y-axis tick labels

%% Functions
% Adds a symbol to the y-axis tick labels
function set_axis_labels(axis, unit)
    axis.Exponent = 0;  % disable scientific notation
    tick_values = get(axis, 'TickValues');
    tick_labels = arrayfun(@(x)[num2str(x), unit], tick_values, 'UniformOutput', false);
    set(axis, 'TickLabels', tick_labels);
end