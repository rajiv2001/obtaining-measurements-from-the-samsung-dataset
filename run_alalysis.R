features<-read.table("features.txt",col.names=c("n","functions"))
x_train<-read.table("train/X_train.txt",col.names=features$functions)
y_train<-read.table("train/Y_train.txt",col.names="code")
y_test<-read.table("test/Y_test.txt",col.names="code")
x_test<-read.table("test/X_test.txt",col.names=features$functions)
x<-rbind(x_train,x_test)
y<-rbind(y_train,y_test)
sub1<-read.table("train/Subject_train.txt",col.names="subject")
sub2<-read.table("test/Subject_test.txt",col.names="subject")
subject<-rbind(sub1,sub2)
new_data<-cbind(x,y,subject)
library(dplyr)
bf<-new_data%>%select(subject,code,contains("mean"),contains("std"))
activities<-read.table("activity_labels.txt")
colnames(activities)<-c("code","activity")
he<-activities[bf$code,2]
bf$code<-activities[bf$code,2]


names(bf)<-gsub("Acc", "Accelerometer", names(bf))
names(bf)<-gsub("Gyro", "Gyroscope", names(bf))
names(bf)<-gsub("BodyBody", "Body", names(bf))
names(bf)<-gsub("Mag", "Magnitude", names(bf))
names(bf)<-gsub("^t", "Time", names(bf))
names(bf)<-gsub("^f", "Frequency", names(bf))
names(bf)<-gsub("tBody", "TimeBody", names(bf))
names(bf)<-gsub("-mean()", "Mean", names(bf), ignore.case = TRUE)
names(bf)<-gsub("-std()", "STD", names(bf), ignore.case = TRUE)
names(bf)<-gsub("-freq()", "Frequency", names(bf), ignore.case = TRUE)
names(bf)<-gsub("angle", "Angle", names(bf))
names(bf)<-gsub("gravity", "Gravity", names(bf))

FinalData <- bf%>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)

str(FinalData)