% Basic reading and processing of data from thingspeak. 
% MST - April 2018, ECEG 100
% created using matlab 2016a
% rooms and thingspeak channel info
%   uncomment the room that you want to analyze, only one at a time
% ----------------
% room = 'BRKI 163'; channelID = 473890; readKey = 'IT6AB60MUHY24S7V'; 
 %room = 'Dana 111'; channelID = 473891; readKey = 'WGFUPRQPPTKL7HN9'; 
%room = 'Dana 303'; channelID = 473892; readKey = 'GGMSYE5S072G8RS7'; 
% room = 'Dana 305'; channelID = 473893; readKey = 'DLS7ZUKV1BAXUPK0'; 
 room = 'Dana 307'; channelID = 473894; readKey = '7R8CVB4RT31YG1U3'; 
% Field numbers for the various fields. 
sensorIdField = 1; 
tempField = 3; 
name = '';
% read data from thingspeak
% check the docs for thingspeakread() for info about call. Here's an
% example that pulls the last X points (NumPoints). The data is returned as
% a matlab 'table'. 
results = thingSpeakRead(channelID,  'Fields', [sensorIdField,... 
    tempField], 'DateRange',[datetime('Apr 23, 2018'),datetime('Apr 24, 2018')], 'ReadKey', readKey, ...
    'OutputFormat', 'table');
% get list of unique sensors IDs in the 'results' data
%sensors = unique(results.sensorID);     
%sensorCount = length(sensors); 
% close all open figure boxes
close all
% plot the temperature values 
figure 
hold on
title(strcat(room,' - Temperature (F)')); 
for i = 1:sensorCount 
    % get the list of timestamps, which are in the first column
    times = results(strcmp(results.sensorID,name),1); 
    % get the data (return value is a table... which won't work) 
    data = results(strcmp(results.sensorID, name),tempField);
    % we can't plot a table, so convert it to an array 
    dataArray = table2array(data);
    dataTime = table2array(times);
    % problem... for some reason, some of the channels are storing the 
    % numeric values as strings (denoted by '' in the data)
    % we need to test for this and convert the data from strings to 
    % numbers if that's the case 
    % is the array full of numbers? 
    if (~isnumeric(dataArray)) 
        % if so, convert them. I used str2double() instead of str2num()
        % because str2num() doesn't operate on whole arrays, just 
        % individual numbers. 
        dataArray = str2double(dataArray); 
    end
    plot(times.Timestamps, dataArray); 
end
legend(name); 
hold off
% Calculate the maximum and minimum temperatures 
[maxTempF,maxTempIndex] = max(dataArray); 
[minTempF,minTempIndex] = min(dataArray); 
   
timeMaxTemp = dataTime(maxTempIndex); 
timeMinTemp = dataTime(minTempIndex);
   
display(maxTempF,'Maximum Temperature for the past 24 hours is'); 
display(minTempF,'Minimum Temperature for the past 24 hours is'); 


