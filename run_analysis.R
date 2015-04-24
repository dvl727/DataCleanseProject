# Load Libraries
library(plyr)
library(reshape2)
library(dplyr)
library(tidyr)
# Set Working directory
wd<-getwd()
main_path<-paste(wd,"/UCI HAR Dataset/", sep="")
test_path<-paste(main_path,"test/", sep="")
train_path<-paste(main_path,"train/",sep="")
# Get Data from Working Directory
features<-read.table(paste(main_path,"features.txt", sep=""))
features<-tbl_df(features)
act_labels<-read.table(paste(main_path,"activity_labels.txt",sep=""))
act_labels<-tbl_df(act_labels)
x_test<-read.table(paste(test_path,"X_test.txt",sep=""))
x_test<-tbl_df(x_test)
y_test<-read.table(paste(test_path,"y_test.txt",sep=""))
y_test<-tbl_df(y_test)
subj_test<-read.table(paste(test_path,"subject_test.txt", sep=""))
subj_test<-tbl_df(subj_test)

x_train<-read.table(paste(train_path,"X_train.txt",sep=""))
x_train<-tbl_df(x_train)
y_train<-read.table(paste(train_path,"y_train.txt",sep=""))
y_train<-tbl_df(y_train)
subj_train<-read.table(paste(train_path,"subject_train.txt", sep=""))
subj_train<-tbl_df(subj_train)

#Rename subject and activty columns
colnames(subj_test)<- c("subject_id")
colnames(subj_train)<-c("subject_id")
colnames(y_test)<-c("act_id")
colnames(y_train)<-c("act_id")
colnames(act_labels)<-c("act_id", "activity")

# Add subject and activity to X file records
x_test<-mutate(x_test, subject_id = subj_test$subject_id, act_id=y_test$act_id)
x_train<-mutate(x_train, subject_id = subj_train$subject_id, act_id = y_train$act_id)

# update features table
add_features<-rbind(features,data.frame(V1=562,V2="subject_id"))
add_features<-rbind(add_features,data.frame(V1=563,V2="act_id"))
# Merge Test and Training Data into 1
xy_merge<-rbind(x_test,x_train)
# Change act_id to activity description
xy_merge$act_id<-factor(xy_merge$act_id, levels=as.vector(act_labels$act_id[]), labels=act_labels$activity[])
# Name columns in merged table
colnames(xy_merge)<-add_features$V2
# Limit Data to mean and std dev for each measurement
mnstd<-xy_merge[,grepl('mean|std',colnames(xy_merge))]
mnstd$subject_id<-xy_merge$subject_id
mnstd$act_id<-xy_merge$act_id

# Name the activity names using descriptive variable names

# (Step 4) Label data sets with descriptive variable names
names(mnstd)<-gsub("^t","Time.",names(mnstd))
names(mnstd)<-gsub("^f","Freq.",names(mnstd))
names(mnstd)<-gsub("BodyBody","Body", names(mnstd))
names(mnstd)<-gsub("Body","Body.", names(mnstd))
names(mnstd)<-gsub("Acc","Accel.",names(mnstd))
names(mnstd)<-gsub("Gyro","Gyro.", names(mnstd))
names(mnstd)<-gsub("Gravity","Gravity.", names(mnstd))
names(mnstd)<-gsub("Jerk", "Jerk.", names(mnstd))
names(mnstd)<-gsub("-","",names(mnstd))
names(mnstd)<-gsub("\\(",".",names(mnstd))
names(mnstd)<-gsub("\\)","",names(mnstd))
names(mnstd)<-gsub("mean","Mean.",names(mnstd))
names(mnstd)<-gsub("std","Std.", names(mnstd))
names(mnstd)<-gsub("Mag","Mag.", names(mnstd))
names(mnstd)<-gsub("\\.{2}", ".", names(mnstd))
names(mnstd)<-gsub("[.]+$","",names(mnstd))
names(mnstd)<-gsub("subject_id","SubjectID",names(mnstd))
names(mnstd)<-gsub("act_id","ActvID",names(mnstd))


# From Step 4, create another dataset with the average of each variable for each activity
#mnstd2<-select(mnstd, -(subject_id))
avg_act<- mnstd %>% group_by(SubjectID, ActvID) %>% summarise_each(funs(mean)) %>% arrange(SubjectID, ActvID)

