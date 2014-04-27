# read data
# getwd()
testdata <- read.table("./UCI HAR Dataset/test/subject_test.txt")
traindata <- read.table("./UCI HAR Dataset/train/subject_train.txt")

Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")

Ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
Ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")  

# name the activities
Ytest$V1[which(Ytest$V1==1)]<- "WALKING"
Ytest$V1[which(Ytest$V1==2)]<- "WALKING_UPSTAIRS"
Ytest$V1[which(Ytest$V1==3)]<- "WALKING_DOWNSTAIRS"
Ytest$V1[which(Ytest$V1==4)]<- " SITTING"
Ytest$V1[which(Ytest$V1==5)]<- "STANDING"
Ytest$V1[which(Ytest$V1==6)]<- "LAYING"

Ytrain$V1[which(Ytrain$V1==1)]<- "WALKING"
Ytrain$V1[which(Ytrain$V1==2)]<- "WALKING_UPSTAIRS"
Ytrain$V1[which(Ytrain$V1==3)]<- "WALKING_DOWNSTAIRS"
Ytrain$V1[which(Ytrain$V1==4)]<- " SITTING"
Ytrain$V1[which(Ytrain$V1==5)]<- "STANDING"
Ytrain$V1[which(Ytrain$V1==6)]<- "LAYING"


# bind data set
Xdata <- rbind(Xtest, Xtrain)
names(Xdata) <- features$V2
Activity <- rbind(Ytest, Ytrain)
Subject <- rbind(testdata, traindata)
Data <- cbind(Xdata, Activity, Subject)
names(Data)[562] <- paste("Activity")
names(Data)[563] <- paste("Subject")

# duplicated col. names
which(duplicated(names(Data)))
length(which(duplicated(names(Data))))

# add X, Y, Z to duplicated cols
for (n in 303:316) {
    colnames(Data)[n] <- paste(colnames(Data)[n], "X", sep="")
}
for (n in 317:330) {
    colnames(Data)[n] <- paste(colnames(Data)[n], "Y", sep="")
}
for (n in 331:344) {
    colnames(Data)[n] <- paste(colnames(Data)[n], "Z", sep="")
}
for (n in 382:395) {
    colnames(Data)[n] <- paste(colnames(Data)[n], "X",  sep="")
}
for (n in 396:409) {
    colnames(Data)[n] <- paste(colnames(Data)[n], "Y", sep="")
}
for (n in 410:423) {
    colnames(Data)[n] <- paste(colnames(Data)[n], "Z", sep="")
}
for (n in 461:474) {
    colnames(Data)[n] <- paste(colnames(Data)[n], "X",  sep="")
}
for (n in 475:488) {
    colnames(Data)[n] <- paste(colnames(Data)[n], "Y", sep="")
}
for (n in 489:502) {
    colnames(Data)[n] <- paste(colnames(Data)[n], "Z", sep="")
}

# make the names of the variables legal
colnames(Data) <- gsub('\\(|\\)',"",names(Data), perl = TRUE)
colnames(Data) <- gsub('\\-',"",names(Data), perl = TRUE)
colnames(Data) <- gsub('\\,',"",names(Data), perl = TRUE)

# subset the full Data to obtain only the measurements on the mean and standard deviation for each measurement
meancols <- grep("[Mm]ean", colnames(Data), value=TRUE)
stdcols <- grep("[Ss]td", colnames(Data), value=TRUE)
meanColNum <- grep("[Mm]ean", colnames(Data))
stdColNum <- grep("[Ss]td", colnames(Data))
subData <- Data[, c(meanColNum, stdColNum, 562, 563)]

# Obtain the average of each variable for each subject and each activity
library(data.table)
dt<- data.table(subData)
meanData<- dt[, lapply(.SD, mean), by=c("Subject", "Activity")]
meanData <- meanData[order(meanData$Subject),]

# Export data
write.table(meanData, "TidyData.txt")
