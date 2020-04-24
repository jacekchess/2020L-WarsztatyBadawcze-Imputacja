# libraries
library(OpenML)
source('./datasets/openml_dataset_897/create_summary_json.R')

# config
set.seed(1)
source <- 'openml'


# download data
list_all_openml_dataset <- listOMLDataSets()

openml_id <- 897L
data_name <- list_all_openml_dataset[list_all_openml_dataset[,'data.id'] == openml_id,'name']

dataset_openml <- getOMLDataSet(data.id = openml_id)
dataset_raw <- dataset_openml$data
target_column <- dataset_openml$target.features


# preprocessing
## cleaning types of columns, removing columns etc.

# Removing not important columns
dataset_raw <- dataset_raw[, c(-1, -2)]

# Changing target class to 0/1 factor
dataset_raw[, 15] <- as.factor(ifelse(dataset_raw[, 15] == "P", 0, 1))

# Changing types of variables
index <- c(11, 12, 13, 14)
for(i in index) {
  dataset_raw[, i] <- as.integer(dataset_raw[, i])
}


## create json
file <- CreateSummary(data = dataset_raw, target_column = target_column, id = openml_id, data_name = data_name, source = 'openml', added_by = 'jacekchess')
write(file, 'dataset.json')
