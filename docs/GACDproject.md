---
title: "Getting and Cleaning Data Course Project"
permalink: /GettingAndCleaningData/CourseProject/
---

# **Introduction** 

One of the most exciting areas in all of data science right now is wearable computing. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data used here represents data collected from the accelerometers from the Samsung Galaxy S smartphone.

The goal is to prepare tidy data that can be used for later analysis.

# **Assignment**

The `run_analysis.R` script performs all required transformations on the data.

The steps of it are as follows:

**1. Download data**
- If the data does not already exist on your computer, it will be downloaded and extracted

**2. Assign data to variables**
- `features` <- `features.txt`. The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ.
- `activities` <- `activity_labels.txt`. List of activities performed when the corresponding measurements were taken and its labels.
- `subject_test` <- `test/subject_test.txt`. Contains test data of 9/30 volunteer test subjects being observed.
- `x_test` <- `test/x_test.txt`. Contains features' test data.
- `y_test` <- `test/y_test.txt`. Contains activities' test data.
- `subject_train` <- `test/subject_train.txt`. Contains train data of 21/30 volunteer subjects being observed.
- `x_train` <- `test/X_train.txt`. Contains features' train data.
- `y_train` <- `test/Y_train.txt`. Contains activities' train data.

**3. Merge the training and the test sets to create one data set**
- `x` is created by merging `x_train` and `x_test` using `rbind()`.
- `y` is created by merging `y_train` and `y_test` using `rbind()`.
- `Subject` is created by merging `subject_train` and `subject_test` using `rbind()`.
- `MergedData` is created by merging `Subject`, `x` and `y` using `cbind()`.

**4. Extract only the measurements on the mean and standard deviation for each measurement**
- `TidyData` is a subset of `MergedData` with columns: `subject` and `code` and that contain `mean` and `std`.

**5. Use descriptive activity names to name the activities in the data set**
- The `code` column of `TidyData` uses the activity names from the `activities` table.

**6. Appropriately label the data set with descriptive variable name**
- The `code` column of `TidyData` is renamed to `activities`.
- `Acc` is replaced to `Accelerometer`.
- `Gyro` is replaced to `Gyroscope`.
- `BodyBody` is replaced to `Body`.
- `Mag` is replaced to `Magnitude`.
- `f` is replaced to `Frequency`.
- `t` is replaced to `Time`.

**7. Create a second, independent tidy data set with the average of each variable for each activity and each subject**
- `FinalData` is created by summarizing `TidyData` by taking the means of each variable for each subject and for each activity.
- Exports `FinalData` into `FinalData.txt`.

# **Code**

```r
##Preparation
library(dplyr)

## Download and extract data if not existing
filename <- "Data.zip"

if(!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method = "curl")
}

if(!file.exists("UCI HAR Dataset")){
  unzip(filename)
}

## Assing each data to variables
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

## Merges all into one data set
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
MergedData <- cbind(Subject, Y, X)

## Extracts only mean and stddev measurements
TidyData <- MergedData %>% select(subject, code, contains("mean"), contains("std"))

## Rename activity and variable names more descriptively
TidyData$code <- activities[TidyData$code, 2]
names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

## Create a new data set with the mean for each variable, for each activity, for each subject
FinalData <- TidyData %>% group_by(subject, activity) %>% summarize_all(funs(mean))

## Output data
write.table(FinalData, "FinalData.txt", row.name=FALSE)
```