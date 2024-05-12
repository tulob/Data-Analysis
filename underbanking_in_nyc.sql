create table if not exists banking(
	Sub_Boro_Name varchar(50) not null primary key,
    Borough varchar(20) not null,
    FIPS integer not null,
    Unbanked_2011 decimal(10,4) not null,
    Underbanked_2011 decimal(10,4) not null,
    Unbanked_2013 decimal(10,4) not null,
    Underbanked_2013 decimal(10,4) not null,
    Prepaid_2011 decimal(10,4) not null,
    Prepaid_2013 decimal(10,4) not null,
    Foreign_born_2011 decimal(10,4) not null,
    Poor_2011 decimal(10,4) not null,
    Median_Income_2011 decimal(10,4) not null,
    Unemployment_2011 decimal(10,4) not null, 
    Foreign_born_2013 decimal(10,4) not null,
    Poor_2013 decimal(10,4) not null,
    Median_Income_2013 decimal(10,4) not null,
    Unemployment_2013 decimal(10,4) not null
);

-- Taking a look at the data for unbanked percentage changes, along with median income and unemployment.
SELECT sub_boro_name, 
	unbanked_2011, 
	unbanked_2013, 
	median_income_2011, 
    unemployment_2011, 
    median_income_2013, 
    unemployment_2013
FROM banking;

-- Whic neighborhoods had the highest amount of unbanked residents?
WITH data_2011 AS(
SELECT sub_boro_name, unbanked_2011
FROM banking
ORDER BY unbanked_2011 DESC) -- AND

SELECT b.sub_boro_name, b.unbanked_2013, d.unbanked_2011
FROM banking b
JOIN data_2011 d ON d.sub_boro_name = b.sub_boro_name
ORDER BY unbanked_2013 DESC
;

-- Which neighborhoods in the city experienced worsening unbanked percentages? 
SELECT sub_boro_name, 
	unbanked_2011, 
    unbanked_2013, 
    median_income_2011, 
    unemployment_2011, 
    median_income_2013, 
    unemployment_2013
FROM banking
WHERE unbanked_2013 > unbanked_2011;


-- What was the difference in the average income in Manhattan between 2013 and 2011?
SELECT Borough, 
	AVG(Median_Income_2011) AS 2011_median, 
    AVG(Median_Income_2013) AS 2013_median,
    (AVG(Median_Income_2013) - AVG(Median_Income_2011)) AS difference_in_two_years
FROM banking
WHERE Borough = 'Manhattan'
GROUP BY Borough;

-- This will show that data for all boroughs
SELECT Borough, 
	AVG(Median_Income_2011) AS 2011_median, 
    AVG(Median_Income_2013) AS 2013_median,
    (AVG(Median_Income_2013) - AVG(Median_Income_2011)) AS difference_in_two_years
FROM banking
GROUP BY Borough;

-- What neighborhoods have the highest median incomes and what are their unemployment rates by 2013? 
SELECT sub_boro_name, borough, Median_Income_2013, Unemployment_2013
FROM banking
ORDER by Median_Income_2013 desc
Limit 20;

-- What are the 20 lowest income areas and what are their unemployment rates? 
SELECT sub_boro_name, borough, Median_Income_2013, Unemployment_2013
FROM banking
ORDER by Median_Income_2013 asc
Limit 20;

-- Let's look at the general state of things
SELECT sub_boro_name, 
	borough,
    (unbanked_2013 - unbanked_2011) AS unbaked_diff,
    (underbanked_2013 - underbanked_2011) AS underbanked_diff,
    (foreign_born_2013 - foreign_born_2011) AS foreign_born_diff,
    (median_income_2013 - median_income_2011) AS median_income_diff
FROM banking
ORDER BY median_income_diff desc;

-- is there a correlation between the immigrant population and an increase in median income?
SELECT sub_boro_name, 
	borough,
    (unbanked_2013 - unbanked_2011) AS unbaked_diff,
    (underbanked_2013 - underbanked_2011) AS underbanked_diff,
    (foreign_born_2013 - foreign_born_2011) AS foreign_born_diff,
    (median_income_2013 - median_income_2011) AS median_income_diff
FROM banking
ORDER BY foreign_born_diff asc;

