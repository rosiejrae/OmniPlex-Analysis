% Specify the path to the directory containing the Excel files
fileDir = 'D:\PlexonData\230310\Analyzed\';

% Get a list of all the Excel files in the directory
fileList = dir(fullfile(fileDir, '*.xls'));

% Loop through each file and extract the data for each unit
allData = [];
for i = 1:length(fileList)
    % Read the data from the Excel file
    filename = fullfile(fileDir, fileList(i).name);
    [num, txt, raw] = xlsread(filename);

    % Extract the variables from the data
    Channel = num(:, 1);
    Unit = num(:, 2);
    Timestamp = num(:, 3);
    Peak = num(:, 4);
    Valley = num(:, 5);
    Energy = num(:, 6);
    PeakValley = num(:, 7);

    % Loop through the unique units and extract the corresponding data
    uniqueUnits = unique(Unit);
    for j = 1:length(uniqueUnits)
        % Find the rows corresponding to the current unit
        unitRows = Unit == uniqueUnits(j);

        % Extract the data for the current unit
        unitData = [Channel(unitRows), Unit(unitRows), Timestamp(unitRows), ...
                    Peak(unitRows), Valley(unitRows), Energy(unitRows), PeakValley(unitRows)];

        % Concatenate the data for the current unit to the allData array
        allData = [allData; unitData];
    end
end



%Making Graphs of variables for the Units in all files

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