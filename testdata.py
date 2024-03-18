# Created by Kelly Rhoden
# Calculates the pearson coefficient for northern migration and SC HPI
# Then calculates the pearson coefficient for total migrations from SC and total migrations to SC
# Created Nov 24 2023

# Imports
import pandas as pd
from scipy import stats

# Create dataframe from testdata.csv
data = pd.read_csv("testdata.csv")

# Calculate pearson coefficient for northern migration and SC HPI
northern_HPI_corr = stats.pearsonr(data["Northern_Migration_to_SC"],data["NSA_HPI"])

# Calculate pearson coefficient for non-northern migration and SC HPI
nonnorthern_HPI_corr = stats.pearsonr(data["NonNorthern_Migration_to_SC"],data["NSA_HPI"])

# Calculate pearson coefficient for total migrations from SC and total migrations to SC
all_migration_corr = stats.pearsonr(data["Total_Migration_to_SC"],data["Total_Leaving_SC"])

# Print results
print(northern_HPI_corr)
print(nonnorthern_HPI_corr)
print(all_migration_corr)