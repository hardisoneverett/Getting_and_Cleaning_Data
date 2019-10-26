library(dplyr)
dir<-"/UCI_HAR_Dataset"
names<-read.table(paste0(dir,"/features.txt"))

# Read in the test data files
x_test<-read.table(paste0(dir,"/test/X_test.txt"), col.names = names[,2])
y_test<-read.table(paste0(dir,"/test/y_test.txt"), col.names = "activity", colClasses = "numeric")
subject_test<-read.table(paste0(dir,"/test/subject_test.txt"), col.names = "subject")
testdata<-cbind(x_test, y_test, subject_test)

# Read in the training data files 
x_train<-read.table(paste0(dir,"/train/X_train.txt"), col.names = names[,2])
y_train<-read.table(paste0(dir,"/train/y_train.txt"), col.names = "activity", colClasses = "numeric")
subject_train<-read.table(paste0(dir,"/train/subject_train.txt"), col.names = "subject")
traindata<-cbind(x_train, y_train, subject_train)

#Combine the test and train data into a single table
data<-rbind(testdata,traindata)

# Selects activity, subject, and any column names that contain mean or std.  The activity variable is then recoded with the correct 
# descriptive labels from the activity_labels.txt file.
tidy_data<-data%>%
  select( activity, subject, contains("mean"), contains("std"))%>%
  mutate(activity = recode(activity, '1' = "walking", '2' = "walking_upstairs", '3'= "walking_downstairs",
                           '4' = "sitting", '5' = "standing", '6' = "laying"))
# The tidy_data data.frame is grouped by activity and subject.  The measurement variables are then summarized                    
# using the mean() function.
avg_tidy_data<-tidy_data%>%
  group_by(activity, subject)%>%
  summarize_all(mean)



