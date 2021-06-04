% Script to perform data processing for tire road friction estimation.
clear; clc; close all;

% Setup output directories:
currentFile = mfilename('fullpath');
[pathstr,~,~] = fileparts(currentFile);
relPath = fullfile('..','MuMaxEstimation','data');
dataPath = fullfile(pathstr,relPath);
if ~exist(dataPath, 'dir')
    mkdir(dataPath)
end

% Collect data from AEB with Warning mu=0.8,0.5,0.3:
mus = ["0.80","0.50","0.30"];
start_times = [15,15,20];
end_times = [20,22,27];
for i = 1:length(mus)
    muData = readtable("mu" + mus(i) + ".txt");
    t = muData{:,1};
    iStart = find(t>start_times(i),1);
    iEnd = find(t>end_times(i),1);
    t = t(iStart:iEnd); % Start t at 0
    U = muData{iStart:iEnd,3};
    s = muData{iStart:iEnd,4};
    Fx = muData{iStart:iEnd,5};
    Tb = muData{iStart:iEnd,6};
    w = muData{iStart:iEnd,7};
    Tw = muData{iStart:iEnd,9};
    save(fullfile(dataPath, "mu" + mus(i) + ".mat"),'t','U','s','Fx',...
        'Tb','w','Tw');
    figure();subplot(2,1,1);
    plot(t,s); ylabel('Long. Slip');
    ylim([-1.1,1.1]);
    subplot(2,1,2);
    plot(t,U); xlabel('t [s]'); ylabel('Long. Velocity [m/s]');
end