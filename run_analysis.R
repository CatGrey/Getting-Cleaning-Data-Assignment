#download file
if(!file.exists("./data")){
      dir.create("./data")}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#setwd to ./data/UCI HAR Dataset folder that has been created

library(data.table)

# merge Features (X) Data
featureTrain <- read.table("./train/X_train.txt")
featureTest <- read.table("./test/X_test.txt")
featuresData <- rbind(featureTrain, featureTest)

#merge Activity (Y) Data
activityTrain <- read.table("./train/Y_train.txt", header = FALSE)
activityTest <- read.table("./test/Y_test.txt", header = FALSE)
activityData <- rbind(activityTrain, activityTest)

#merge subject data
subjectTrain <- read.table("./train/subject_train.txt", header = FALSE)
subjectTest <- read.table("./test/subject_test.txt", header = FALSE)
subjectData <- rbind(subjectTrain, subjectTest)

#Subset Features (X) to only include mean and standard deviation variables
mean.sd.Features <- grep("mean\\(\\)|std\\(\\)", featureLabels[,2])
featuresData <- featuresData[,mean.sd.Features]

#Replace Activity code variables with descriptions
activityData[,1] <- activityLabels[activityData[,1],2]

#Labels Data
featureLabels <- read.table("./features.txt")
activityLabels <- read.table("./activity_labels.txt")

#Name variables with descriptors
featureNames <- featureLabels[mean.sd.Features,2]
names(featuresData) <- featureNames
names(subjectData) <- c("subject")
names(activityData) <- c("activity")

#Combine into 1 tidy data set odered by subject then activity
library(plyr)
tidyData <- aggregate(. ~ subject + activity, allData, mean)
tidyData <- tidyData[order(tidyData$subject, tidyData$activity),]
write.table(tidyData, file = "./tidydata.txt", row.name = FALSE)
