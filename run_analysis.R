## This file does the following: 
## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement. 
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive activity names. 
## Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


## Download project zip file
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "Dataset.zip")
unzip("Dataset.zip")

## Timestamp
date()

## Retrieve activity labels
activity.labels = read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = F)[,2]

## Read test and train data into separate dataframes
test.data <- read.table("UCI HAR Dataset/test/X_test.txt")
train.data <- read.table("UCI HAR Dataset/train/X_train.txt")

## Read corresponding activity labels for test and train datasets
test.activity.labels <- read.table("UCI HAR Dataset/test/y_test.txt")
train.activity.labels <- read.table("UCI HAR Dataset/train/y_train.txt")

## Read corresponding subjects labels for test and train datasets
test.subject.labels <- read.table("UCI HAR Dataset/test/subject_test.txt")
train.subject.labels <- read.table("UCI HAR Dataset/train/subject_train.txt")

## merge test and train dataframes
merged.data = rbind(test.data,train.data)


## Calculate mean for each row
merged.data.mean <- rowMeans(merged.data)


## Calculate standard deviation for each row
merged.data.sd <- apply(merged.data,1,sd)

## Merge activity labels
merged.activity.labels <- rbind(test.activity.labels,train.activity.labels)

## Merge subject labels
merged.subject.labels <- rbind(test.subject.labels,train.subject.labels)

##Assemble 4 columns created above into final dataframe. 
final.data <- cbind(merged.subject.labels, merged.activity.labels, merged.data.mean,merged.data.sd)

## Give names to columns.
names(final.data) <- c("subject", "activity", "mean", "standard_deviation")

## Convert "activity" and "subject" columns to factors
final.data[,1] <- as.factor(final.data[,1])
final.data[,2] <- as.factor(final.data[,2])

levels(final.data[,2]) <- activity.labels
head(final.data)

## Create a second, independent tidy data set with the average of each variable for each activity and each subject
ind <- list( final.data$subject,final.data$activity)

tidy.data<-tapply(final.data$mean, ind, ave)
tidy.data<-cbind(tidy.data,tapply(final.data$standard_deviation, ind, ave))

names(tidy.data) <- c ("ave_mean","ave_sd" )

## Return tidy data set with the average of each variable for each activity and each subject
tidy.data

