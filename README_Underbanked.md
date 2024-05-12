**What neighborhoods are unbanked and underbanked in NYC?**


**Problem**

Access to financial services is a crucial factor in overall financial health. This dataset, while from 2013, provides a valuable baseline to understand the historical landscape of unbanked and underbanked residents in NYC. By analyzing this data, we can assess changes over time and identify areas for improvement in financial inclusion initiatives.

**Data Acquisition and Preprocessing**

Source: [Ratcliffe, Caroline, Signe-Mary McKernan, Emma Kalish, and Steven Martin. 2015. “Where are the Unbanked and Underbanked in New York City?” Washington, DC: Urban Institute.](https://data.cityofnewyork.us/Business/Where-Are-the-Unbanked-and-Underbanked-in-New-York/v5w4-adxa/about_data)

This project uses NYC open data to find out more about the unbanked population in New York City across multiple years. The data includes information, divided by city neighborhood, on the percentages of unbanked residents, foreign-born residents, median incomes and unemployment rates. 

First, I did a preview of the data selecting sub_boro_name, unbanked_2011, unbanked_2013, median_income_2011, unemployment_2011, median_income_2013, unemployment_2013 as the initial columns. Getting an overall quick view of the data helped peak my interest when I noticed that some neighborhoods had unbanked and unemployment metrics unlike most other boroughs. 

**Initial Exploration and Hypothesis Generation**

The preliminary data exploration revealed interesting patterns, particularly in unbanked and unemployment metrics for certain neighborhoods.
Investigating further into the unbanked portion of the data, I wanted to know which neighborhoods had the highest rates of unbanked residents in 2011 and 2013, which are the years of data that the dataset represents. This sort of inquiry would highlight where a fintech business or nonprofit organization could look to make an impact. 
Based on these observations, it is clear the top few dozen neighborhoods show a decreased or consistent rate of unbanked residents, however that may not be the case across all of NYC. The following query searches for increases in unbanked people across the years. 

**Refining the Analysis and Identifying Trends**
Starting with querying the average incomes across neighborhoods, each borough saw an increase in income, with Brooklyn and Manhattan leading the group. 
To understand the broader picture, you subsequently looked for neighborhoods that showed an increase in unbanked residents between 2011 and 2013, even if the increase wasn't substantial.
Given the initial observation of high overall incomes in Manhattan neighborhoods, you compared income data for Brooklyn and Manhattan. This analysis explored if income levels were correlated with changes in the unbanked population.
