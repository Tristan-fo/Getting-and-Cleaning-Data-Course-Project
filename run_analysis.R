getwd()

# The zip file containing the data must be under the same directory

unzip("getdata_projectfiles_UCI HAR Dataset.zip")


## 1.Merges the training and the test sets to create one data set:

# Test data
XTest <- read.table("UCI HAR Dataset/test/X_test.txt")
YTest <- read.table("UCI HAR Dataset/test/Y_test.txt")
SubjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Train data
XTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
YTrain <- read.table("UCI HAR Dataset/train/Y_train.txt")
SubjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Features & Activities
feat <- read.table("UCI HAR Dataset/features.txt")
act <- read.table("UCI HAR Dataset/activity_labels.txt")


# Merge datasets
X <- rbind(XTest, XTrain)
Y <- rbind(YTest, YTrain)
Subject <- rbind(SubjectTest, SubjectTrain)


## 2. Extracts only the measurements on the mean and standard deviation for each measurement

?grep
index <- grep("mean\\(\\)|std\\(\\)", feat[,2]) # looks for all iterations of 
                                                # "mean" or "std" in the second column of feat 
length(index)

X2 <- X[,index] # Collecting only var with mean or std 
dim(X2) # Dimensions of the newly-created subset

## 3. Uses descriptive activity names to name the activities in the data set

Y[,1] <- act[Y[,1],2]
head(Y)

## 4. Appropriately labels the data set with descriptive variable names

names <- feat[index,2] # Saves all variable names into "names"
names

names(X2) <- names # Replace the current names (V1...) from X2 to the new full "names"
names(Subject) <- "SubjectID" # Rename the only variable name in Subject to "SubjectID"
names(Y) <- "Activity" # Rename the only variable name in Y to "Activity"

Database <- cbind(Subject, Y, X2)
head(Database[,c(1:4)])

## 5. From the data set in step 4, creates a second, 
## independent tidy data set with the average of each variable for 
## each activity and each subject.

install.packages("data.table")
library(data.table)

Database <- data.table(Database)
Data <- Database[,lapply(.SD,mean), by = 'SubjectID,Activity']
dim(Data)

write.table(Data, file = "Data.txt", row.names = FALSE) # Create a txt file of the 
                                                        # final, cleaned dataset

