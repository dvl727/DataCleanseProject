 The run_anaysis.R script reads the data files you have unzipped into your working directory and combines the needed data files into a tidy dataset.
 The script assumes that the datafiles have been unzipped into your working directory. The unzipping process will create subdirectories which should be left as is after unzipping.
 The script also assumes that the following R packages are installed: plyr, reshape2, dplyr, tidyr
 The script performs the following activities:
 1.  Loads the needed R Packages/libraries
 2.  Reads and sets the current working directory
 3.  From the working directory, it determines the location of the data files using relative file paths from the working directory
 4.  It reads the 'features.txt', 'activity_labels.txt', 'X_test.txt', 'Y_test.txt', 'X_train', 'Y_train', and 'subject_test.txt' data files.
 5.  Renames the subject_id and activity_id columns in the subject_test.txt and activity_label files.
 6.  Adds the subject_id and activity_id records to the test and train data files.
 7.  Adds the feature names as columns to the datasets
 8.  Merges the test and train datasets into a combined dataset with the same columns (features).
 9.  Limits data to only features related to the mean and standard devation features.
 10.  Relabels the merged dataset columns per standards (CamelCase, consistency, remove errors in name i.e. BodyBody)
 11.  Summarizes the dataset by Subject_Id and Activity_ID and calculates the average value for each feature.