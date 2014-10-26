#!/usr/bin/env Rscript
library(dplyr)

featureColNames = as.character(read.table("UCI_HAR_Dataset/features.txt")[,2])
activityNames = as.character(read.table("UCI_HAR_Dataset/activity_labels.txt")$V2)

####################################################################################################
#PART1: Merges the training and the test sets to create one data set
####################################################################################################
#A. Loads data in a list of lists of lists
sets = c("test","train")
dataset = setNames(
lapply(sets, function(type){
    filenames = list.files(sprintf("UCI_HAR_Dataset/%s", type), recursive=T)    #Store filenames in var
    setNames(   #Loop through and read files
    lapply(filenames,function(files){
            read.table(sprintf("UCI_HAR_Dataset/%s/%s", type, files))   #Reads in the data
        }), gsub(x=filenames, pattern="\\s", "_")   #Names of the files
            )
}), sets)
#dataset_original = dataset  #Keeps a copy

####################################################################################################
#PART2: Extracts only the measurements on the mean and standard deviation for each measurement. 
####################################################################################################
test.mean = dataset[["test"]][["X_test.txt"]][,grep(x=(featureColNames), pattern="mean")]
test.sd= dataset[["test"]][["X_test.txt"]][,grep(x=(featureColNames), pattern="std")]

train.mean= dataset["train"][["X_train.txt"]][,grep(x=(featureColNames), pattern="mean")]
train.sd= dataset["train"][["X_train.txt"]][,grep(x=(featureColNames), pattern="std")]

####################################################################################################
#PART3: Uses descriptive activity names to name the activities in the data set
####################################################################################################
for (type in sets) {
    dataset[[type]][[12]]$V1 = factor(as.factor(dataset[[type]][[12]]$V1))
    dataset[[type]][[12]]$V1 = factor(dataset[[type]][[12]]$V1, labels=activityNames)

    #Part4: Appropriately labels the data set with descriptive variable names.
    colnames(dataset[[type]][[12]]) = "activityType"
    colnames(dataset[[type]][[11]]) = featureColNames
    colnames(dataset[[type]][[10]]) = "subjectID"
    for (num in 1:9){
        colnames(dataset[[type]][[num]]) = paste(
              gsub("test|train","",gsub("\\.txt$","",gsub("^\\S+\\/","",names(dataset[[type]])[num]))),
              paste0("reading",1:128),sep="_"
              )
    }
}


#B. Merge into a single data.frame
dataset_Final=do.call(rbind,lapply(sets , function(type){
       df = do.call(cbind,unname(dataset[[type]][10:12]))   #not keeping the df from inertia
       df$type = type
       df
              }))


#30 volunteers 2947 observations
#|  NAME            |   DESCRIPTION         |
#|"subject_test.txt"|   volunteer ID        |
#| "X_test.txt"     |   561-feature Vector  |
#| "y_test.txt"     |   Activity Label      |

####################################################################################################
#PART5:From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
####################################################################################################

#Deals with duplicated column names
for (duplicated in unique(colnames(dataset_Final)[duplicated(colnames(dataset_Final))])){
colnames(dataset_Final)[colnames(dataset_Final) == duplicated] = paste(
          colnames(dataset_Final)[colnames(dataset_Final) == duplicated],
          1:3, sep="___")
}


tidy.df = dataset_Final %>% 
group_by(type, activityType, subjectID) %>%   #for each activity and each subject
summarise_each(funs(mean))

write.table(tidy.df, file="tidyDF.txt")
