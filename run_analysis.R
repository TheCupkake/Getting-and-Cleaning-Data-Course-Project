library(reshape2)

#downloading the data
file <- "cleaning_data_dataset.zip"

if (!file.exists(file)){
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", file, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
    unzip(file) 
}

#reading the data

x_test <- read.table("X_test.txt")
f <- read.table("features.txt")
testsubjects <- read.table("subject_test.txt")
testlabels <- read.table("y_test.txt")
factors <- read.table("activity_labels.txt")
x_train <- read.table("X_train.txt")
trainlabels <- read.table("y_train.txt")
trainsubjects <- read.table("subject_train.txt")

#creating subjects and activities columns as factor variable
subjects <- as.factor(append(testsubjects$V1,trainsubjects$V1))
labels <- factor(append(testlabels$V1,trainlabels$V1),levels = factors[,1],labels=factors[,2])

#merging the two datasets
final <- rbind(x_test,x_train)

#subsetting the combined datasets and extracting wanted variables
features <- grep(".*mean.*|.*std.*", f[,2])
colnames <- f[features,2]
final <- final[features]

#adding subjects and activities variables
final <- cbind(labels,subjects,final)

#adding appropriate column names
colnames(final) <- c("activity","subject", colnames)

#creating the mean dataset
meltedfinal <- melt(final, id = c("activity","subject"))
finalmean <- dcast(meltedfinal, activiry + subject ~ variable, mean)

#saving the result
write.table(finalmean, "final.txt", row.names = FALSE, quote = FALSE)
