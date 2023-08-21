clear
clc
close all

% Open a xls file
% this will bring up the file-open dialog
xlsFile = 'D:\PlexonData\230609\.995,-3.254,6602 sorted.xls';

format longG % giving the actual values

% Load your data from the Excel file (assuming 'num' is the data matrix)
num = xlsread(xlsFile); % Uncomment this line if 'num' is not defined

% Extract variables from the data
Channel = num(:, 1); % extract the first column of numerical data
Unit = num(:, 2); % extract the second column of numerical data
Timestamp = num(:, 3);
Energy = num(:, 4);
Peak = num(:, 5);
Area = num(:, 6);

% Find the unique values of the unit column
uniqueUnits = unique(Unit);

% Loop through the unique units and extract the corresponding data
for i = 1:length(uniqueUnits)
    % Find the rows corresponding to the current unit
    unitRows = Unit == uniqueUnits(i);

    % Extract the data for the current unit
    unitChannel = Channel(unitRows);
    unitTimestamp = Timestamp(unitRows);
    unitEnergy = Energy(unitRows);
    unitPeak = Peak(unitRows);
    unitArea = Area(unitRows);

    % Calculate the average values for the current unit
    avgEnergy = mean(unitEnergy);
    avgPeak = mean(unitPeak);
    avgArea = mean(unitArea);

   
end

% Print out the total number of unique units
fprintf('Total number of unique units: %d\n', length(uniqueUnits));
 fprintf('Unit %d:\n', uniqueUnits(i));
%___________________________________________________________________________
% LC Unit validation from clonidine injection
% Create a figure for the raster plot
figure;
hold on;

% Loop through the unique units and plot the raster for each unit
for i = 1:length(uniqueUnits)
    unitRows = Unit == uniqueUnits(i);
    unitTimestamp = Timestamp(unitRows)/60; %convert to minutes
    unitPeak = Peak(unitRows);
    
    % Plot spikes for the current unit
    scatter(unitTimestamp, ones(size(unitTimestamp))*i, [], unitPeak, 'filled');
end

% Set plot labels and title
xlabel('Time(min)');
ylabel('Unit');
title('Unit Firing Across Time');

% Add a colorbar to indicate peak values
colorbar('eastoutside');

% Calculate suitable color scale limits based on your data
colorMin = min(Peak);
colorMax = max(Peak);
caxis([colorMin, colorMax]);

% Adjust y-axis ticks to show unique unit numbers
yticks(1:length(uniqueUnits));
yticklabels(arrayfun(@num2str, uniqueUnits, 'UniformOutput', false));

% Invert y-axis to have the first unit at the top
set(gca, 'YDir', 'reverse');

% Add an arrow at 35 minutes on the X-axis
annotation('arrow', [0.5, 0.5], [0.92, 0.88], 'Color', 'red', 'LineWidth', 1.5);

% Show the plot
hold off;
%___________________________________________________________________________
%Isolating bursts
% Loop through the unique units and extract burst-related information
for i = 1:length(uniqueUnits)
    unitRows = Unit == uniqueUnits(i);
    unitTimestamp = Timestamp(unitRows);
    
    % Set burst detection criteria (e.g., ISI threshold)
    isiMin = 0.08; % Minimum ISI
    isiMax = 0.16; % Maximum ISI
    
    % Find bursts (based on ISI criteria)
    isi = diff(unitTimestamp);
    burst_starts = [];
    burst_ends = [];
    burst_count = 0;
    
    for j = 1:length(isi)-1
        if isi(j) >= isiMin && isi(j) <= isiMax
            burst_count = burst_count + 1;
        else
            if burst_count > 1
                burst_starts(end+1) = j - burst_count + 1;
                burst_ends(end+1) = j;
            end
            burst_count = 0;
        end
    end
    
    % Calculate the number of bursts for the current unit
    numBursts = length(burst_starts);
    
    % Calculate ISIs within each burst for the current unit
    burst_isis = {}; % Cell array to store ISIs within each burst
    
    for j = 1:length(burst_starts)
        burstIndices = burst_starts(j):burst_ends(j);
        burst_isis{j} = isi(burstIndices);
    end    
    
    % Store ISIs within each burst for the current unit
    burst_isis_by_unit{i} = burst_isis;
    
  
    
    % Calculate and display the average burst ISI for the unit
    avg_burst_isis = cellfun(@mean, burst_isis);
    avg_burst_isi = mean(avg_burst_isis);
    fprintf('Average Burst ISI for Unit %d: %.4f ms\n\n', uniqueUnits(i), avg_burst_isi * 1000); % Convert to milliseconds

    
    
end

%______________________________________________________________
%Burst Duration
% Calculate and display the average burst duration for each unit
for i = 1:length(uniqueUnits)
    avg_burst_durations = cellfun(@sum, burst_isis_by_unit{i}) + (length(burst_isis_by_unit{i}) - 1) * isiMin;
    avg_burst_duration = mean(avg_burst_durations);
    fprintf('Average Burst Duration for Unit %d: %.4f ms\n', uniqueUnits(i), avg_burst_duration * 1000); % Convert to milliseconds
end

%_____________________________________________________________________________________________
% Calculate and display the average number of spikes per burst for each unit
% Initialize a cell array to store burst starts for each unit
burst_starts_by_unit = cell(length(uniqueUnits), 1);

% Initialize a cell array to store burst ends for each unit
burst_ends_by_unit = cell(length(uniqueUnits), 1);

% Initialize a cell array to store burst ISIs for each unit
burst_isis_by_unit = cell(length(uniqueUnits), 1);

% Initialize an array to store burst durations for each unit
burst_durations_by_unit = zeros(length(uniqueUnits), 1);

% Initialize an array to store average number of spikes per burst for each unit
avg_spikes_per_burst_by_unit = zeros(length(uniqueUnits), 1);

% Loop through the unique units and extract burst-related information
for i = 1:length(uniqueUnits)
    unitRows = Unit == uniqueUnits(i);
    unitTimestamp = Timestamp(unitRows);
    
    % Set burst detection criteria (e.g., ISI threshold)
    isiMin = 0.08; % Minimum ISI
    isiMax = 0.16; % Maximum ISI
    
    % Find bursts (based on ISI criteria)
    isi = diff(unitTimestamp);
    burst_starts = [];
    burst_ends = [];
    burst_count = 0;
    
    for j = 1:length(isi)-1
        if isi(j) >= isiMin && isi(j) <= isiMax
            burst_count = burst_count + 1;
        else
            if burst_count > 1
                burst_starts(end+1) = j - burst_count + 1;
                burst_ends(end+1) = j;
            end
            burst_count = 0;
        end
    end
    
    % Store burst starts and ends for the current unit
    burst_starts_by_unit{i} = burst_starts;
    burst_ends_by_unit{i} = burst_ends;
    
    % Calculate ISIs within each burst for the current unit
    burst_isis = cell(length(burst_starts), 1);
    for j = 1:length(burst_starts)
        burstIndices = burst_starts(j):burst_ends(j);
        burst_isis{j} = isi(burstIndices);
    end
    
    % Store ISIs within each burst for the current unit
    burst_isis_by_unit{i} = burst_isis;
    
    % Calculate burst durations for the current unit
    burst_durations = burst_ends - burst_starts;
    burst_durations_by_unit(i) = mean(burst_durations);
    
    % Calculate average number of spikes per burst for the current unit
    avg_spikes_per_burst_by_unit(i) = mean(burst_durations + 1); % Adding 1 to account for bursts with 2 spikes
    
end

% Display average number of spikes per burst for each unit
for i = 1:length(uniqueUnits)
    fprintf('Average Spikes Per Burst for Unit %d: %.2f\n', uniqueUnits(i), avg_spikes_per_burst_by_unit(i));
end

%_______________________________________________________________________________________________________________
%Interburst interval


