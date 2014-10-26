#Details#

*Instructions*: Describe the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md.

Assumes data is stored in __UCI_HAR_Dataset__ folder in the working directory


##Variables##

|Variable names| DataType|Description|
|----|----|----|
|featureColnames| character vector| feature descriptions for use in naming columns|
|activityNames| character vector|   assigning activity with descriptions instead of ID|
|sets       |   character vector|   to help with loading of data|
|dataset|list of lists of lists|   contains all the data files (before merging)|
|test.mean|data.frame| test dataset mean |
|test.sd|data.frame| test dataset sd |
|train.mean|data.frame|training dataset mean |
|train.sd|data.frame|training dataset sd |
|dataset_Final|data.frame|merged dataset in a single data.frame|

##Data##

*dataset
*dataset_Final


##Transformations##
1. Read files in __UCI_HAR_Dataset/train__ and  __UCI_HAR_Dataset/test__ folder and stores in list of lists of lists (variable name: __dataset__)
2. Extracts columns in data.frames containing the 561 features with names matching "mean" or "std" (variable names: __test.mean__, __test.sd__, __train.mean__, __train.sd__)
3. Change the activity label from integer vector 1,2,3,4,5,6 to descriptive vector 
4. Change data.frame colnames to be descriptiive
5. Make duplicated colnames not duplicated by adding suffixes
