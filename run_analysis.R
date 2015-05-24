
# First load all available data
activityLabels <- read.table(
    "activity_labels.txt",
    sep = " ",
    col.names = c("Activity.Id","Activity.Name"))

featureLabels <- read.table(
    "features.txt",
    sep = " ",
    col.names = c("Feature.Id","Feature.Name"))

testSubjects <- read.table("test/subject_test.txt",col.names="Subject.Id")
testActivities <- read.table("test/y_test.txt",col.names="Activity.Id")
testSet <- read.table("test/x_test.txt", col.names=featureLabels$Feature.Name)

trainSubjects <- read.table("train/subject_train.txt",col.names="Subject.Id")
trainActivities <- read.table("train/y_train.txt",col.names="Activity.Id")
trainSet <- read.table("train/x_train.txt", col.names=featureLabels$Feature.Name)


# We only want mean and std measurements
indexOfMeanOrStdFeatures <- grepl("mean|std",featureLabels$Feature.Name)
namesOfMeanOrStdFeatures <- featureLabels[indexOfMeanOrStdFeatures]


#Combine test Subjects, Activities, and test set (mean and std only) into one dataset
testSetCombined <- 
    cbind(
        Set.Type="Test",
        merge(testActivities,activityLabels),
        testSubjects,
        testSet[,indexOfMeanOrStdFeatures]
        )

trainSetCombined <- 
    cbind(
        Set.Type="Train",
        merge(trainActivities,activityLabels),
        trainSubjects,
        trainSet[,indexOfMeanOrStdFeatures]
    )

mergedTestAndTrainSet <- rbind(testSetCombined,trainSetCombined)


# Extrac tidy data set with averages by Activity and Subject
tidySet <- select(
    aggregate(mergedTestAndTrainSet,
              FUN=mean,
              by=list(
                  Activity=mergedTestAndTrainSet$Activity.Name,
                  Subject=mergedTestAndTrainSet$Subject.Id)
              ),
    -c(Activity.Id,Set.Type,Activity.Name,Subject.Id)
    )

write.table(tidySet, file = "tidyset.txt", row.names = FALSE)

tidySet