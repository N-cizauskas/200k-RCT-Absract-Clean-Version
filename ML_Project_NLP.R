setwd("C:/Users/nicol/Downloads")

# packages
library(tidyverse)
library(dplyr)
library(data.table)


train_data <- read.delim("C:/Users/nicol/Downloads/train (1)/train.txt", row.names=NULL)

test_data <- read.delim("C:/Users/nicol/Downloads/test.txt", row.names=NULL)


# CLEANING

# column names

names(test_data)[names(test_data) == "X...24562799"] <- "text"
names(test_data)[names(test_data) == "row.names"] <- "category"


names(train_data)[names(train_data) == "X...24491034"] <- "text"
names(train_data)[names(train_data) == "row.names"] <- "category"


# remove junk

test_table <- data.table(test_data)
to_drop <- test_table[category %ilike% "###"]
test_table_drop <- anti_join (test_table, to_drop)
test_clean <- as.data.frame(test_table_drop)


train_table <- data.table(train_data)
to_drop_tr <- train_table[category %ilike% "###"]
train_table_drop <- anti_join (train_table, to_drop_tr)
train_clean <- as.data.frame(train_table_drop)

# fake text
# removal strategy = remove all rows below a certain length

mean(nchar(test_clean$text))
min(nchar(test_clean$text))

# remove all under 30

nchar(test_clean$text) < 30

test_clean <- subset(test_clean, nchar(as.character(text)) >= 30)
train_clean <- subset(train_clean, nchar(as.character(text)) >= 30)

# this should denoise the data enough to ensure model accuracy - doesn't matter if one or two are off



# categories counts and freq tables

dplyr::count(test_clean, category)
barplot(prop.table(table(test_clean$category)))

dplyr::count(train_clean, category)
barplot(prop.table(table(train_clean$category)))



# EXPORT TO TXT FOR PYTHON


write.csv(test_clean, "C:/Users/nicol/Downloads/test_clean.csv", row.names=FALSE)

write.csv(train_clean, "C:/Users/nicol/Downloads/train_clean.csv", row.names=FALSE)


