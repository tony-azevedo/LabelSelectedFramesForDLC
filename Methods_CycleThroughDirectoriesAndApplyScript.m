%% Script to label points in randomly selected frames.
% Use Step1 code in python to collect random Frames. See Myconfig file for
% all the different inputs

% directory of images to label. Change this for every set of images, e.g.
% if you have selected random frames from several movies.
folder = 'C:\Users\tony\Code\DeepLabCut_Tony\Generating_a_Training_Set\data-femurTibiaJoint_IR5X\';
% folder = pwd; %'C:\Users\tony\Code\DeepLabCut_Tony\Generating_a_Training_Set\data-femurTibiaJoint_IR5X\EpiFlash2T_Image_180621_F1_C1_29_20180621T131616';

cd(folder)
a = dir;
isdir = false(size(a));
for dname = 1:length(a)
    isdir(dname) = a(dname).isdir & length(a(dname).name)>2;
end

a = a(isdir);

for dname = 1:length(a)
    cd(a(dname).name)
    Methods_SelectSubsetOfLabeledFramesForDLC;
    cd(folder)
end
