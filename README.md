# United States Vaccine Rollout Dashboard Discussion and Analysis
Spencer Wolf

## Data

My data for this project was downloaded from the OurWorldInData github repository
found here:

https://github.com/owid/covid-19-data/blob/master/public/data/vaccinations/us_state_vaccinations.csv

## Methods

I used shiny in order to create an interactable UI that allows average people
to interact with this dataset.

## Results

I was able to create an app with the following features:

- 50 states selectable at the same time for comparison
- A dynamically updating table that gives stats for selected states
- A clear button to quickly wipe selected states
- An interactable plot visualization of how many people have been vaccinated in 
  each state over time
- A tooltip to allow for detailed analysis of plot data


## Getting Started

To get started I am going to walk you through using the dashboard to investigate
and compare the vaccination rates of Ohio and Indiana.

1. Install packages at the top of the file and run the R code to open the
   dashboard.
2. Scroll down to the bottom of the page and click the clear all button
   which is bright red.
3. Look through the select states list and select Ohio and Indiana
4. Scroll to the top of the page. You will see that the graph now contains the
   two states that we will be analyzing.
5. Hover your mouse over the data points to get more detailed information about
   each data point.
6. Look at the datatable below your graph to see detailed information on each
   state you have selected.
7. Click on the headers to sort the datatable by ascending (one click) and
   descending (two clicks).
   