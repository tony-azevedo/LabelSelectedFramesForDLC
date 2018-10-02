# LabelSelectedFramesForDLC
Simple script to label imgXXX.png images for training sets for DLC

see https://github.com/AlexEMG/DeepLabCut

Currently, generating a training set for DeepLabCut (DLC) requires opening randomly selected frames in FIJI or another editor. This script allows the user label the random frames in MATLAB and to proofread the labeling.

# Requirements

**Matlab 2018a or later**: Methods_LablelSelectedFramesForDLC.m makes use of matlab "Tables", a data structure similar to DataFrames in pandas or tables in R. The script uses function calls available only in 2018a or later.

# Directions:

First, follow directions on the DeepLabCut readme page to run "Step1_SelectRandomFrames_fromVideos.py". This first step will generate directories containing selected frames, with filenames "imgXXX.png" where XXX is the frame index. Note, this script generates .csv files for each body part, so in **myconfig.py** change the **multibodypartsfile** flag to **False**, as in the DLC reaching example.

# Before running the script 

**(1) edit the bodyparts variable:** 

(line 8) to include, as a 'cell array', the bodyparts listed in the myconfig.py file, the bodyparts you intend to label.

**(2) which parts will move?** 

(line 10) Most parts (or features) will move from frame to frame, such as legs. Other parts can remain static or move rarely, but they should be labeled so as to avoid mistaking that feature for a target feature during training. Change the movingparts variable to indicate the indices of the moving parts in the bodyparts cell array.

**(3) which parts are static?** 

(line 12) Change the staticparts variable to indicate the indices of the static parts in the bodyparts cell array.

**(4) edit the training set directory:** 

(line 15) to navigate to the correct folder, the parent directory containing directories.

# Run the script

**Label body parts**

The first part of the routine is to label static and moving parts. The functionality is as follows:

- For each directory of images, navigate to that directory and show the first image.
  - Label the static parts that won't move from frame to frame. Click on the feature indicated in the top right of the image. 
  - Loop through all images confirming the position of each static feature in each image.
    - If a feature moved a little, drag the dot to the desired location. If a feature dissapeared (obscured or moved off screen, drag that dot to the "invisible location" (see DLC documentation)
    - Once the dots are correctly located, hit the space bar.
  - Label each moving part individually. The user will be alerted when the next feature begins. The user can either
    - Hit the space bar if the feature has not moved. Or,
    - Click on the location of the feature, a magenta dot will appear to indicate the location and the next img will appear.
  
After each feature is labeled, a .csv file is saved with the filename \<bodypart\>_points.csv. The static points are saved to a file "staticpoints.csv". If the labeling routine is interrupted for whatever reason, the script looks for saved "\<bodypart\>_points.csv" files and will skip those features, jumping to features that have not yet been labeled. If you want to relabel features, you can delete the "\<bodypart\>_points.csv" files or change the editing logicals on lines 17, 18, and 19.

Finally, the script saves a file with the naming convention "\<bodypart\>.csv" for each bodypart. These files will be used in the subsequent "Step2_ConvertingLabels2DataFrame.py" routine to create a file "CollectedData_\<Scorer\>.csv" in the parent training set folder.

**Proofread labeling**

Now the routine will loop back through each directory to proofread the labeling. The functionality is as follows:

- For each directory of images, navigate to that directory and show the first image.
  - Drag the label locations to the appropriate feature. The locations of each bodypoint/feature has it's own color.
  - Hit the space bar once the labels are in the correct locations.
  - Loop through all images confirming the position of all the features in each image.

This routine simply edits all of the bodypart.csv files.

**Next Steps**

Now you're ready to move on with the rest of the training as described at https://github.com/AlexEMG/DeepLabCut, starting with "Step2_ConvertingLabels2DataFrame.py".

Happy clicking!

