%% Tidy up
clear; clc; close all;

%% Function call
analyze_transfer_function("..\exp_data\scope_9.csv");

%% Function declarations
% Analyze transfer function
function analyze_transfer_function(filename)
    % load data from CSV file
    data = readtable(filename, 'VariableNamingRule', 'preserve');
    x = data{:,2};
    y = data{:,3};

    % compute the derivative
    dy = diff(y) ./ diff(x);
    abs_dy = abs(dy);
    
    % find when the derivative is non-zero (i.e., when the function is not constant)
    is_not_constant = abs_dy > 1e-2;
    idx = find(is_not_constant); % convert logical indices to numerical indices

    % extract windows around zero-crossings
    x_linear = []; y_linear = [];
    zero_crossings = find(diff(sign(x(idx)))~=0); % detect zero-crossings
    window_size = 35; % (how many points to take around each zero crossing)

    for i = 1:length(zero_crossings)
        window_start = max(1, zero_crossings(i) - window_size);
        window_end = min(length(x(idx)), zero_crossings(i) + window_size);
        window_indices = window_start:window_end;
    
        % ensure window_indices do not exceed array bounds
        window_indices = window_indices(window_indices <= length(x(idx)));
        
        x_linear = [x_linear; x(idx(window_indices))];
        y_linear = [y_linear; y(idx(window_indices))];
    end

    % apply regression
    p = polyfit(x_linear, y_linear, 1);
    slope = p(1);

    % display the result
    plot_transfer_function(x,y,p);
    fprintf('The slope of the linear part of the transfer function is: %.3f.\n', slope);
end

% Plot the transfer function and its 'linear part' fitted curve
function plot_transfer_function(x, y, p)
    figure
    set(gcf, 'Position',  [100, 100, 660, 340]);
    plot(x, y, 'Color', [0.0 0.24 0.33], 'LineWidth', 1.75); hold on;
    plot(x, polyval(p,x), 'r--', 'LineWidth', 1.5); hold off;
    grid on; grid minor; 
    
    xlim([-0.5 0.5]);
    legend('Original Data', 'Fitted Line', 'Location', 'southwest');
end