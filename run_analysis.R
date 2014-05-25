## Assume the working directory contains the downloaded project data
## in a sub-directory titled "UCI HAR Dataset"

## Within the "UCI HAR Dataset" directory are two further sub-directories called
## "train" and "test" (both referred to as * below) that contain the datasets:
## - Ignore the sub-directories called "Inertial Signals"
## - Files called "X_*" are the actual measurements of 561 attributes
## - Files called "subjects_*" identify subjects in the X_* datasets
## - Files called "y_*" identify activities (walking, etc.) in the X_* datasets

## Read the subject datasets first
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",
                            col.names = c('subject_id'),
                            colClasses = "factor"
                            )
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",
                           col.names = c('subject_id'),
                           colClasses = "factor"
                           )

y_train <- read.table("UCI HAR Dataset/train/y_train.txt",
                      col.names = c('activity_id'),
                      colClasses = "factor"
                      )
y_test <- read.table("UCI HAR Dataset/test/y_test.txt",
                     col.names = c('activity_id'),
                     colClasses = "factor"
                     )

## Read the "features.txt" file first - it contains the names of the
## 561 features that will be the column names for the X_* datasets
## Also find the subset of features related to mean and standard deviations,
## which will then be used to subset the X_* datasets
features <- read.table("UCI HAR Dataset/features.txt",
                        colClasses = "character"
                       )
a <- grep("mean()|std()", features$V2)
# For some reason, a also picks up meanFreq(), so need to drop those features
b <- grep("meanFreq()", features$V2)
mean_std_features <- a[(!a %in% b)]

## Now read the X_* datasets
X_train <- read.table("UCI HAR Dataset/train/X_train.txt",
                      col.names = features$V2,
                      colClasses = "numeric")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt",
                     col.names = features$V2,
                     colClasses = "numeric")

## Start stacking the datasets together and cbind() them to get the output dataset
## Also read the file "activity_labels.txt," which contains descriptive activity
## names for the y_* datasets
stack_subject <- rbind(subject_train, subject_test)
stack_y <- rbind(y_train, y_test)
stack_X <- rbind(X_train, X_test)[, mean_std_features]
output_data <- cbind(stack_subject, stack_y, stack_X)

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt",
                              col.names = c('activity_id', 'activity_name'),
                              sep = " ",
                              colClasses = "factor"
)

output_data_final <- merge(output_data, activity_labels,
                            by.x = "activity_id",
                            by.y = "activity_id",
                            all = TRUE)
output_data_final$activity_id <- as.factor(as.character(output_data_final$activity_id))

write.table(output_data_final, file = "output_data_final.txt", row.names = FALSE)

## Create a second dataset for the average of each factor by subject and activity
vars <- !(colnames(output_data_final) %in% c('subject_id', 'activity_id', 'activity_name'))
summary_vars <- colnames(output_data_final)[vars]

summary_out <- aggregate(fBodyAcc.mean...X ~ subject_id + activity_name,
                         data = output_data_final,
                         FUN="mean")

write.table(summary_out, file = "attrib_average_subject_activity.txt", row.names = FALSE)