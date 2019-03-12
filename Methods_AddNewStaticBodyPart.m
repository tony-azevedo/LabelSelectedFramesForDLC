%% Script to label points in randomly selected frames.
% Use Step1 code in python to collect random Frames. See Myconfig file for
% all the different inputs

% directory of images to label. Change this for every set of images, e.g.
% if you have selected random frames from several movies.
folder = 'C:''\Users\tony\';
folder = pwd; %'C:\Users\tony\Code\DeepLabCut_Tony\Generating_a_Training_Set\data-femurTibiaJoint_IR5X\EpiFlash2T_Image_180621_F1_C1_29_20180621T131616';


%% New Bodyparts
% define the body parts you want to label:
bodyparts = getpref('FlyAnalysis','DLCBodyparts');
XLS_EDIT_OK = 1;

%% Cleanup: Going to replace xls files anyways, so delete them here.

for bp = 1:length(bodyparts)
    xlfile = dir([bodyparts{bp} '.xls']);
    if ~isempty(xlfile)
        delete(xlfile.name)
    end
end


%% Compare current bodyparts to original set. If there is no "_point" files, open the static points

fname = '';
hasfile = false(size(bodyparts));
isstatic = false(size(bodyparts));
for bdidx = length(bodyparts):-1:1
    fname = dir([bodyparts{bdidx} '_points.csv']);
    if ~isempty(fname)
        hasfile(bdidx) = 1;
    end
end

T_static = readtable('staticpoints.csv');
T_static.Properties.RowNames = T_static.Img;
for bdidx = length(bodyparts):-1:1
    if any(contains(T_static.Properties.VariableNames,[bodyparts{bdidx} '_X']))
        isstatic(bdidx) = 1;
    end
end

not_found = ~hasfile & ~isstatic;
newbdprts = bodyparts(not_found);

for bdidx = 1:length(newbdprts)
    T_static.([newbdprts{bdidx} '_X']) = 3*ones(height(T_static),1);
    T_static.([newbdprts{bdidx} '_Y']) = (bdidx+3)*ones(height(T_static),1);
end

writetable(T_static,'staticpoints.csv','WriteRowNames',false);

movingparts = bodyparts(~isstatic & hasfile);
T_moving = [];
for prtidx = 1:length(movingparts)
    part = movingparts{prtidx};
    partpoints = readtable([part '_points.csv']); 
    T_moving = [T_moving, partpoints];
end

imgfiles = T_static.Properties.RowNames;
selectimgfiles = dir('img*.png');
selected_idx = false(size(imgfiles));
for fn = 1:length(selectimgfiles)
    selected_idx(contains(imgfiles,selectimgfiles(fn).name)) = true;
end

T_all = [T_static(selected_idx,:),T_moving(selected_idx,:)];

for bprtidx = 1:length(bodyparts)
    part = bodyparts{bprtidx};
    indxs = find(contains(T_all.Properties.VariableNames,part));
    T = T_all(:,[1,indxs]);
    T.Properties.VariableNames = {'Img','X','Y'};
    writetable(T,[part '.csv'],'WriteRowNames',false)
end

