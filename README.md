GettingCleaningData_Project
===========================

Course Project submission for "Getting and Cleaning Data" 

This document describes how the submitted R code ("run_analysis.R") flows from beginning to end

## Assume the working directory contains the downloaded project data in a sub-directory titled "UCI HAR Dataset"

## Within the "UCI HAR Dataset" directory are two further sub-directories called "train" and "test" (both referred to as * below) that contain the datasets:
- Ignore the sub-directories called "Inertial Signals"
- Files called "X_*" are the actual measurements of 561 attributes
- Files called "subjects_*" identify subjects in the X_* datasets
- Files called "y_*" identify activities (walking, etc.) in the X_* datasets

## Read the subject datasets first
## Read the y datasets next
## Read the "features.txt" file - it contains the names of the
561 features that will be the column names for the X_* datasets; also find the subset of features related to mean and standard deviations, which will then be used to subset the X_* datasets
## Now read the X_* datasets

## Start stacking the datasets together and cbind() them to get the output dataset
## Also read the file "activity_labels.txt," which contains descriptive activity names for the y_* datasets and merge with output

## Create a second dataset for the average of each factor by subject and activity
