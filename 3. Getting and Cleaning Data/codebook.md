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

**3. Merges the training and the test sets to create one data set**
- `x` is created by merging `x_train` and `x_test` using `rbind()`.
- `y` is created by merging `y_train` and `y_test` using `rbind()`.
- `Subject` is created by merging `subject_train` and `subject_test` using `rbind()`.
- `MergedData` is created by merging `Subject`, `x` and `y` using `cbind()`.

**4. Extracts only the measurements on the mean and standard deviation for each measurement**
- `TidyData` is a subset of `MergedData` with columns: `subject` and `code` and that contain `mean` and `std`.

**5. Uses descriptive activity names to name the activities in the data set**
- The `code` column of `TidyData` uses the activity names from the `activities` table.

**6. Appropriately labels the data set with descriptive variable name**
- The `code` column of `TidyData` is renamed to `activities`.
- `Acc` is replaced to `Accelerometer`.
- `Gyro` is replaced to `Gyroscope`.
- `BodyBody` is replaced to `Body`.
- `Mag` is replaced to `Magnitude`.
- `f` is replaced to `Frequency`.
- `t` is replaced to `Time`.

**7. Creates a second, independent tidy data set with the average of each variable for each activity and each subject**
- `FinalData` is created by summarizing `TidyData` by taking the means of each variable for each subject and for each activity.
- Exports `FinalData` into `FinalData.txt`.