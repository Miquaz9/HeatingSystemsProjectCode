%12/6/2014

%So far this program reads the file and puts it into arrays. It also plots it.

%Clears all the variables and closes them
%Clears the screen
clear all; close all; clc
set(0,'defaultfigureWindowStyle','docked'); %This line makes it so that when you run the program, the default window style is 'docked'.

%On December 13th, 2014, I deleted the individual MATLAB programs that run individual files. Now you can just uncomment the file which you want to read and plot.

%Open the Log File.
%LogFile = fopen('..\ModuleData\LOG03908.TXT','r'); %Parents' room... first time analyzing data from the module.
%LogFile = fopen('..\ModuleData\LOG03953.TXT','r'); %My room trial 1 - failed with battery pack.
%LogFile = fopen('..\ModuleData\LOG04016.TXT','r'); %Parent's room trial 1 - failed with battery pack.
%LogFile = fopen('..\ModuleData\LOG04039.TXT','r'); %My room test without battery pack.
%LogFile = fopen('..\ModuleData\LOG04040_Cut.TXT','r'); %My room (new) trial 1.
%LogFile = fopen('..\ModuleData\LOG04043_Cut.TXT','r'); %Nitish's house.
%LogFile = fopen('..\ModuleData\LOG04044_Cut.TXT','r'); %Kevin's house.
%LogFile = fopen('..\ModuleData\LOG04048_Cut.TXT','r'); %My house 1 hour without people.
%LogFile = fopen('..\ModuleData\LOG04049.TXT','r'); %Living room with between 0-4 people (not cut to 24 hours).
%LogFile = fopen('..\ModuleData\LOG04049_Cut.TXT','r'); %Living room with between 0-4 people.
%LogFile = fopen('..\ModuleData\LOG04050.TXT','r'); %Basement with 1 person (not cut).
LogFile = fopen('..\ModuleData\LOG04050_Cut.TXT','r'); %Basement with 1 person.

NumLines = inf; %Read the whole file, or change the value for the number of lines you want to read.

%If the computer can't find the file, then it will give an error message.
if LogFile<0

  error('File not found.');

end

if ~isinf(NumLines)

  Data = zeros(NumLines,2);

else

  Data = [];

end

k = 1;

tline = fgets(LogFile); %Read the log file.

while ischar(tline)

  Data(k,:) = sscanf(tline,'%d,%f,%f,%d').'; %Put the data into arrays  - time (natural numbers), temperature (rational numbers), humidity (rational numbers), and CO2 Gas Concentration (natural numbers)

  % work-around for negtive number issue:
  Data(k,1) = k;

  tline = fgets(LogFile);

  if k == NumLines

    break;

  end

  k = k + 1;

end


% convert to hours:
Data(:,1)=Data(:,1)/1800;

figure(1)
plot(Data(:,1),Data(:,2))
title('Analysis Part 1: Time vs. Temperature')
xlabel('Time [Hours]');
ylabel('Temperature [C]')

figure(2)
plot(Data(:,1),Data(:,3))
title('Analysis Part 2: Time vs. Humidity')
xlabel('Time [Hours]');
ylabel('Humidity [%]')

figure(3)
plot(Data(:,1),Data(:,4))
title('Analysis Part 3: Time vs. Gas Concentration')
xlabel('Time [Hours]');
ylabel('Gas Concentration [PPM]')
ylim ([0,5200])

%Print averages (added 02/10/2016), updated average with user input for gas conc. 03/04/2016

prompt = 'How many people in the room? ';
p = input(prompt); %Number of people in the room
c = 54.029138; %Constant average ppm carbon dioxide produced by a person
fprintf('Average CO2 Gas Concentration: %f\n',mean(Data(:,4))-(p*c));

fprintf('Average Temperature: %f\n',mean(Data(:,2)));
fprintf('Average Humidity: %f\n',mean(Data(:,3)));
fprintf('Average Time: %f\n',mean(Data(:,1)));

fclose(LogFile);