import pandas as pd

dataset = 'public_data.csv'

# Read the data file
public_data = pd.read_csv(dataset)


# Display a summary of the dataset
public_data_info = public_data.info()


public_data_info

# Separate training and test datasets based on 'day_in_period'
train_data = public_data[public_data['day_in_period'] < 4]
test_data = public_data[public_data['day_in_period'] == 4]

# Check for missing values in both datasets
train_missing = train_data.isnull().sum()
test_missing = test_data.isnull().sum()

# Overview of train and test splits
train_shape = train_data.shape
test_shape = test_data.shape

# Display results
train_shape, test_shape, train_missing, test_missing

