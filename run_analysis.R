##Get feature names and select only features of mean or std measures
features <- read.table ("UCI HAR Dataset/features.txt")
selectedfeatures <- grep("std|mean",features$V2)

##Get the train and test feature sets on selected featuresets
trainfeatures <- read.table("UCI HAR Dataset/train/X_train.txt")
selectedtrainfeatures <- trainfeatures[,selectedfeatures]
testfeatures <- read.table("UCI HAR Dataset/test/X_test.txt")
selectedtestfeatures <- testfeatures[,selectedfeatures]

##Combine training and testing, attach column names
totalfeatures <- rbind(selectedtrainfeatures, selectedtestfeatures)
colnames(totalfeatures) <- features[selectedfeatures, 2]

##Combine train and test activity codes
trainactivities <- read.table("UCI HAR Dataset/train/y_train.txt")
testactivities <- read.table("UCI HAR Dataset/test/y_test.txt")
totalactivities <- rbind(trainactivities, testactivities)

##Get activity labels, attach to activity codes
activitylabels <- read.table ("UCI HAR Dataset/activity_labels.txt")
totalactivities$activity <- factor(totalactivities$V1, levels=activitylabels$V1, labels=activitylabels$V2)

##Combine training and testing subjectid
trainsubjects <-read.table("UCI HAR Dataset/train/subject_train.txt")
testsubjects <-read.table("UCI HAR Dataset/test/subject_test.txt")
totalsubjects <- rbind(trainsubjects, testsubjects)

##Combine subjects and activities
subjectsandactivities <- cbind(totalsubjects, totalactivities$activity)
colnames(subjectsandactivities)<-c("subjectid","activity")

##Combine subjects and activities with total features
activityframe<- cbind(subjectsandactivities,totalfeatures)

##Calculate and report means of all measures
resultframe <- aggregate(activityframe[,3:81],by=list(activityframe$subjectid, activityframe$activity),FUN=mean)
colnames(resultframe)[1:2]<- c("subjectid","activity")
write.table(resultframe,file="mean_measures.txt",row.names=FALSE)

