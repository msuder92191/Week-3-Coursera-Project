## choosing the packages 

library(reshape2)

## set working directory
### please set own working directory that contains the UCI HAR dataset to properly run code
setwd("/R/Coursera UVF/Coursera projects/Week 3/week 4")


## loading activity label
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <-  as.character(activity_labels[,2])

## Loading Features
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

## getting the Means and Standard Deviations
features_wanted <- grep(".*mean.*|.*std.*", features[,2])
features_names <- features[features_wanted,2]
features_names = gsub('-mean', 'Mean', features_names)
features_names = gsub('-std', 'Std', features_names)
features_names <- gsub('[-()]', '', features_names)

#loading the desired data for Training 
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")[features_wanted]
y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
Subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(Subject_train, y_train, x_train)

## loading the desired data for Testing
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")[features_wanted]
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
Subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(Subject_test, y_test, x_test)

## merging data tables

hwdata <- rbind(train, test)
colnames(hwdata) <- c("subject", "activity", features_names)


## changing data into factors

hwdata$activity <- factor(hwdata$activity, levels = activity_labels[,1], labels = activity_labels[,2])
hwdata$subject <- as.factor(hwdata$subject)

### melting Data
hwdata_melt <- melt(hwdata, id = c("subject", "activity"))

### getting the means of the data
hwdata_new_mean <- dcast(hwdata_melt, subject + activity ~ variable, mean)

### writing new table

write.table(hwdata_new_mean, "tidy.txt", row.names = FALSE, quote = FALSE)
