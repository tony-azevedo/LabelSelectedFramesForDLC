%% Script to select a subset of frames
% Assuming images have already been labeled by Methods_LabelSelectedFramesForDLC.m

% Head to a directory of images to label. Change this for every set of images, e.g.
% if you have selected random frames from several movies.
% folder = 'C:''\Users\tony\';
folder_current = pwd; %'C:\Users\tony\Code\DeepLabCut_Tony\Generating_a_Training_Set\data-femurTibiaJoint_IR5X\EpiFlash2T_Image_180621_F1_C1_29_20180621T131616';

% Create a folder to keep old work
mkdir(folder_current,'original_sampled')

N = 25;

%% Bodyparts
% define the body parts you want to label:
% In this case, find them from them predifined preferences set in Methods_LabelSelectedFramesForDLC.m
bodyparts = getpref('FlyAnalysis','DLCBodyparts');
XLS_EDIT_OK = 1;

%% Select random frames from previously sampled frames
% cd(folder)

bdidx = 1;

% For each of the body points, find the file that goes with it.
fname = dir([bodyparts{bdidx} '.csv']);
if isempty(fname)
    fname = dir([bodyparts{bdidx} '.xls']);
    if isempty(fname)
        uiwait(msgbox(['No Part File: ' bodyparts{bdidx}],'Error: No locations','modal'));
    else
        % if it's an xls, ask about editing it
        if XLS_EDIT_OK
            uiwait(msgbox(['Part files are xls, changing to .csv: ' bodyparts{bdidx}],'Error: No csv','modal'));
            fname1 = fname(1).name;
            movefile(fname1,[bodyparts{bdidx} '.csv']);
            fname = dir([bodyparts{bdidx} '.csv']);
        else
        end
    end
end
fname = fname(1).name;

% Create a table for each body part
eval(['T_' bodyparts{bdidx} ' = readtable(''' fname ''');']);
eval(['T_' bodyparts{bdidx} '.Properties.RowNames = T_' bodyparts{bdidx} '.Img;']);

if height(T_FemurTrochanterDorsal) <=N
    return 
else
    rnd_idx = randperm(height(T_FemurTrochanterDorsal));
    rnd_idx = rnd_idx(1:N);
end
rnd_idx = sort(rnd_idx);

imgfiles = T_FemurTrochanterDorsal.Properties.RowNames;
% Move randomly selected images in to the archive
for imgind = 1:length(imgfiles)
    if ~any(imgind==rnd_idx)
        movefile(imgfiles{imgind},fullfile('original_sampled',imgfiles{imgind}));
    end
end

%% 
% For each of the body points, find the file that goes with it.
for bdidx = 1:length(bodyparts)
    fname = dir([bodyparts{bdidx} '.csv']);
    if isempty(fname)
        fname = dir([bodyparts{bdidx} '.xls']);
        if isempty(fname)
        else
            % if it's an xls, ask about editing it
            if XLS_EDIT_OK
                % uiwait(msgbox(['Part files are xls, changing to .csv: ' bodyparts{bdidx}],'Error: No csv','modal'));
                fname1 = fname(1).name;
                movefile(fname1,[bodyparts{bdidx} '.csv']);
                fname = dir([bodyparts{bdidx} '.csv']);
            else
            end
        end
    end
    fname = fname(1).name;
    % Create a table for each body part
    eval(['T_' bodyparts{bdidx} ' = readtable(''' fname ''');']);
    eval(['T_' bodyparts{bdidx} '.Properties.RowNames = T_' bodyparts{bdidx} '.Img;']);
    eval(['T_' bodyparts{bdidx} ' = T_' bodyparts{bdidx} '(rnd_idx,:);']);
    
    % Move the old tables of coordinates to the archive
    if ~exist(fullfile('original_sampled',fname),'file')
        movefile(fname,fullfile('original_sampled',fname));
    else
        fprintf('%s already exists\n',fullfile('original_sampled',fname));
    end
    
    % Write a new table for just those images in the folder
    eval(['writetable(T_' bodyparts{bdidx} ',''' [bodyparts{bdidx} '.csv'] ''',''WriteRowNames'',false);']);

end



