% Specify the path and filename of the Excel file
filename = 'D:\PlexonData\230310\Analyzed\B-2.211,-3.017,3.902.xls';

format longG %giving the actual values
% Read the data from the Excel file
[num, txt, raw] = xlsread (filename);

% Extract variables from the data
Channel = num(:, 1); % extract the first column of numerical data
Unit = num(:, 2); % extract the second column of numerical data
Timestamp = num(:,3);
Peak = num(:, 4);
Valley = num(:, 5);
Energy = num(:,6);
PeakValley = num(:,7);



% Find the unique values of the unit column
uniqueUnits = unique(Unit);

close all

f1 = figure;
hold on;
f2 = figure;
hold on;

% Loop through the unique units and extract the corresponding data
for i = 1:length(uniqueUnits)
    % Find the rows corresponding to the current unit
    unitRows = Unit == uniqueUnits(i);
    
    % Extract the data for the current unit
    unitChannel = Channel(unitRows);
    unitTimestamp = Timestamp(unitRows);
    unitPeak = Peak(unitRows);
    unitValley = Valley(unitRows);
    unitEnergy = Energy(unitRows);
    unitPeakValley = PeakValley(unitRows);

      % Calculate the ISI for the current unit
    isi = diff(unitTimestamp);
    avg_isi = mean(isi);

    % Create a vector of ones with the same length as isi
    onesVector = ones(size(isi));
    
    % Plot the timestamps as a scatter plot with the average ISI
    figure(f1)
    scatter(unitTimestamp(1:end-1), uniqueUnits(i) * onesVector, 10, 'k', 'filled');
    text(max(unitTimestamp), uniqueUnits(i), sprintf('%.2f', avg_isi), ...
         'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle');


    figure(f2)
    plot(unitTimestamp, unitPeak)
end

figure(f1)
xlabel('Time (s)');
ylabel('Unit');
ylim([0, length(uniqueUnits) + 1]);
xlim([min(Timestamp), max(Timestamp)]); % set the x-axis limits to the min and max timestamp values

hold off;

figure(f2)
plot(unitTimestamp, unitPeak)
xlabel('Time (s)');
ylabel('Peak (uV)');
title('Peak values over time');
hold off;


% Loop through the unique units and extract the corresponding data
for i = 1:length(uniqueUnits)
    % Find the rows corresponding to the current unit
    unitRows = Unit == uniqueUnits(i);
    
    % Extract the data for the current unit
    unitChannel = Channel(unitRows);
    unitTimestamp = Timestamp(unitRows);
    unitPeak = Peak(unitRows);
    unitValley = Valley(unitRows);
    unitEnergy = Energy(unitRows);
    unitPeakValley = PeakValley(unitRows);
%Calculating average values per unit


    % Calculate the average values for relevent variables
    avgPeak = mean(unitPeak);
    avgValley = mean(unitValley);
    avgEnergy = mean(unitEnergy);
    avgPeakValley = mean(unitPeakValley);
    
    % Print out the average values for each unit
    fprintf('Unit %d:\n', uniqueUnits(i));
    fprintf('Average ISI: %f\n', avg_isi);
    fprintf('Average Peak: %f\n', avgPeak);
    fprintf('Average Valley: %f\n', avgValley);
    fprintf('Average Energy: %f\n', avgEnergy);
    fprintf('Average Peak Valley: %f\n', avgPeakValley)
end


%Making Graphs of variables for the Units

% Loop through the unique units and extract the corresponding data
%PEAK
avgPeak = zeros(length(uniqueUnits), 1);
for i = 1:length(uniqueUnits)
    % Find the rows corresponding to the current unit
    unitRows = Unit == uniqueUnits(i);
    
    % Extract the data for the current unit
    unitPeak = Peak(unitRows);
    
    % Calculate the average peak value for the current unit
    avgPeak(i) = mean(unitPeak);
end

% Create a bar graph of the average peak value for each unit
figure;
bar(uniqueUnits, avgPeak);
xlabel('Unit');
ylabel('Average Peak Value (uV');
title('Average Peak Value per Unit');

% Add labels to the bar graph with the average value for each unit
for i = 1:length(uniqueUnits)
    text(uniqueUnits(i), avgPeak(i), sprintf('%.2f', avgPeak(i)), ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')
end

%Valley
avgValley = zeros(length(uniqueUnits), 1);
for i = 1:length(uniqueUnits)
    % Find the rows corresponding to the current unit
    unitRows = Unit == uniqueUnits(i);
    
    % Extract the data for the current unit
    unitValley = Valley(unitRows);
    
    % Calculate the average peak value for the current unit
    avgValley(i) = mean(unitValley);
end

% Create a bar graph of the average Valley value for each unit
figure;
bar(uniqueUnits, avgValley);
xlabel('Unit');
ylabel('Average Valley Value (uV)');
title('Average Valley Value per Unit');

% Add labels to the bar graph with the average value for each unit
for i = 1:length(uniqueUnits)
    text(uniqueUnits(i), avgValley(i), sprintf('%.2f', avgValley(i)), ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')
end

%Energy
avgEnergy = zeros(length(uniqueUnits), 1);
for i = 1:length(uniqueUnits)
    % Find the rows corresponding to the current unit
    unitRows = Unit == uniqueUnits(i);
    
    % Extract the data for the current unit
    unitEnergy = Energy(unitRows);
    
    % Calculate the average peak value for the current unit
    avgEnergy(i) = mean(unitEnergy);
end

% Create a bar graph of the average Energy value for each unit
figure;
bar(uniqueUnits, avgEnergy);
xlabel('Unit');
ylabel('Average Energy Value');
title('Average Energy per Unit');

% Add labels to the bar graph with the average value for each unit
for i = 1:length(uniqueUnits)
    text(uniqueUnits(i), avgEnergy(i), sprintf('%.2f', avgEnergy(i)), ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')
end

%PeakValley
avgPeakValley = zeros(length(uniqueUnits), 1);
for i = 1:length(uniqueUnits)
    % Find the rows corresponding to the current unit
    unitRows = Unit == uniqueUnits(i);
    
    % Extract the data for the current unit
    unitPeakValley = PeakValley(unitRows);
    
    % Calculate the average  value for the current unit
    avgPeakValley(i) = mean(unitPeakValley);
end

% Create a bar graph of the average Peak Valley value for each unit
figure;
bar(uniqueUnits, avgPeakValley);
xlabel('Unit');
ylabel('Average PeakValley Value');
title('Average PeakValley per Unit');

% Add labels to the bar graph with the average value for each unit
for i = 1:length(uniqueUnits)
    text(uniqueUnits(i), avgPeakValley(i), sprintf('%.2f', avgPeakValley(i)), ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')
end