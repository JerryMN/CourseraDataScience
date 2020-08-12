# Getting and Cleaning Data Course Project

This project contains the instructions for running an analysis on the Human Activity dataset.

# Dataset

The data used for this project represents data collected from the accelerometers from the Samsung Galaxy S smartphone.
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# Files

- **CodeBook.md**: describes the variables, the data, and transformations performed upon the data

- **run_analysis.R**: fetches the dataset if it does not exist, merges the training and the test sets to create one data set, extracts only the measurements on the mean and standard deviation for each measurement, uses descriptive activity names to name the activities in the data set, appropriately labels the data set with descriptive variable names and creates a second, independent tidy data set with the average of each variable for each activity and each subject.

- **FinalData.txt**: is the exported final data after going through all the sequences described above.
