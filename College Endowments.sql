-- After working with hedge fund clients, my intrigue with college endowments certainly expanded. 
-- Select universities have massive investment funds that they maintain and grow through diversified
-- investments in hedge funds, private equity, venture capital funds, alternative investments and more.
-- In the last several years, their returns have been incredible, so I have followed this topic for years.

-- Learning about this topic is not simple as the information is seldom readily available for readers 
-- who are outside of the invement management companies of said universities. However, given the investment
-- of colleges' endowments trend increased since David Swensen popularized the practice, I wanted to see
-- what I could learn through the use of data analysis and data from public sources. 


SELECT * FROM PortfolioProject.`tabn333.90 (1)`;
-- This data has been uploaded via an Excel file, with previous cleaning done on Excel as well.

alter table `tabn333.90 (1)` rename to `college`;
-- now the name is fixed, and the table will be refered to as college moving forward 
alter table college
	change column `Beginning of FY` `beginning` varchar(50);
alter table college
	change column `End of FY` `ending` varchar(50);
alter table college
	change column `Percent change` `pct_change` varchar(50);
alter table college
	change column `Rank` `ranking` varchar(50);

UPDATE `PortfolioProject`.`college`
SET `begining` = REPLACE(`begining`, ',', '');
UPDATE `PortfolioProject`.`college`
SET `ending` = REPLACE(`ending`, ',', '');
-- These updated change the numerical data to remove any commas which would interfere with
-- making calculations using the endowment amounts.

select *
from college;


-- 1. Which five colleges have the highest endowments? 
select institution, ranking
from college
where ranking between 1 and 5
order by ranking
;

-- 2. What is the total amount of the top 5 endowments?
select sum(ending) as total_ending
from college 
where ranking between 1 and 5;

-- 3. How does the total of the top 15 endowments compare to the bottom 105?
select 
	sum(case when ranking between 1 and 15 then ending else 0 end) as top_15,
    sum(case when ranking between 16 and 120 then ending else 0 end) as bottom_105
from college;

-- 4. How much do all the institutions hold as of the end of 2021?
select sum(ending) AS total
from college;

-- 5. What percentage of the total endowment amount does the top 15 institutions hold? 

WITH sum_of_top_15 AS (
    SELECT 
        institution, 
        ranking, 
        SUM(ending) AS top_15_ending
    FROM 
        college
    WHERE 
        ranking BETWEEN 1 AND 15
    GROUP BY 
        institution, 
        ranking
),
sum_of_bottom_105 AS (
    SELECT 
        institution, 
        ranking, 
        SUM(ending) AS bottom_105_ending
    FROM 
        college
    WHERE 
        ranking BETWEEN 16 AND 120
    GROUP BY 
        institution, 
        ranking
)
SELECT 
    SUM(st15.top_15_ending) AS total_top_15_ending, 
    SUM(sb105.bottom_105_ending) AS total_bottom_105_ending, 
    SUM(c.ending) AS total_ending, 
    SUM(st15.top_15_ending) / SUM(c.ending) AS percentage
FROM 
    college c
LEFT JOIN 
    sum_of_top_15 st15 ON c.institution = st15.institution
LEFT JOIN 
    sum_of_bottom_105 sb105 ON c.institution = sb105.institution
WHERE
    c.ranking BETWEEN 1 AND 120;


-- 6. Which 10 colleges had the highest endowment returns in 2021?
SELECT institution, pct_change, (ending-begining) as total_change
FROM college
order by pct_change desc
limit 10
;

-- 7. How much did those institutions return in 2021?
SELECT institution, pct_change, (ending - begining) AS annual_return
FROM college
order by pct_change DESC
limit 10;

-- 8. How much did the top 15 college return in 2021?

SELECT institution, (ending-begining) AS return_2023, pct_change
FROM college
WHERE ranking <= 15;
------------ 

-- 9. Which institutions have endowment returns of over 40% in the last year?
SELECT institution, pct_change
FROM college
HAVING pct_change > 40;

-- DOING SOME STATS ON THE DATA
-- 10. AVG and MODE
SELECT ROUND(avg(pct_change),1) AS avg_return,
    (SELECT max(pct_change) as mode_return
    FROM college
    limit 1) AS mode_return
FROM college;

-- 11. Median
WITH ranked AS (
	SELECT pct_change,
		ROW_NUMBER() OVER (ORDER BY pct_change) AS p,
        COUNT(pct_change) OVER () AS c
FROM college
),
median AS (
	SELECT pct_change
    FROM ranked
    where p IN (FLOOR((c+1)/2), CEILING((c+1)/2))
    )
    SELECT avg(pct_change) FROM median;

-- 12. Organize the institutions by the ranking of the returns 
    
SELECT 
    institution,
    pct_change,
    CASE
        WHEN pct_change BETWEEN 0 AND 20 THEN 'Lower Returns'
        WHEN pct_change BETWEEN 20.1 AND 30 THEN 'Medium Returns'
        WHEN pct_change BETWEEN 30.1 AND 45 THEN 'Higher Returns'
        WHEN pct_change BETWEEN 45.1 AND 100 THEN 'Highest Returns'
    END AS returns
FROM 
    college;

--------
create table if not exists lastyear(
	Ranking integer not null primary key,
    Institution varchar(150) not null, 
    City varchar(30) not null, 
    State varchar(2) not null, 
    enrollment_22 integer, 
    mv_23 integer not null,
    mv_22 integer not null, 
    change_mv dec(10,2) not null,
    e_per_student integer
);

SELECT *
FROM lastyear;

-- Note: measurements of market value ("mv") are measures in thousands. The change in market value is show in percents. 

-- 13. Which college had the highest positive changes in their fund market values in 2023?
SELECT institution, mv_22, mv_23, change_mv
FROM lastyear
ORDER BY change_mv desc;

-- To keep track of the change in market value in the 2023 fiscal year, I added another column showing the difference. 
ALTER TABLE lastyear
ADD delta_mv integer AS (mv_23 - mv_22);

select *
from lastyear;

-- 14. What schools have enrollments per student equal to more than $500,000? These are all the schools that pay a 1.4% tax on net investment income.
SELECT institution, e_per_student
from lastyear
WHERE e_per_student >= 500000;

-- 15. What state has the largest sum of endowment funds? 
SELECT State,
	SUM(mv_23) AS sum_23,
    sum(delta_mv) AS delt_23
FROM lastyear
GROUP BY state
ORDER BY sum_23 desc;

-- 16. Which states receive the most tax revenue from endowment funds with e_per_student >= 500,000?
SELECT State,
	SUM(mv_23) AS sum_23,
    sum(delta_mv) AS delt_23
FROM lastyear
WHERE e_per_student >= 500000
GROUP BY State
ORDER BY sum_23 desc;

-- 17. Which cities have the highest sum of endowmend funds?
SELECT City,
	State, 
	SUM(mv_23) AS sum_23,
    sum(delta_mv) AS delt_23
FROM lastyear
GROUP BY City, State
ORDER BY sum_23 desc;

-- 18. Which institutions saw the greatest decreses in their endowment market values in 2023?
SELECT delta_mv, 
	institution
FROM lastyear
ORDER BY delta_mv asc;

-- 19. Which schools had the largest increases in market value?
SELECT delta_mv, 
	institution
FROM lastyear
ORDER BY delta_mv desc;

-- 20. Which universities with endowments over $1billion had increases in mv of over $100?
SELECT institution, 
	delta_mv,
    mv_23
FROM lastyear
WHERE mv_23 > 1000000
order by delta_mv desc; 

-- 21. Were there more general increase or decreases in the mv of endowments in 2023? 

SELECT 
    SUM(CASE WHEN delta_mv > 0 THEN 1 ELSE 0 END) AS positive_delta,
    SUM(CASE WHEN delta_mv < 0 THEN 1 ELSE 0 END) AS negative_delta,
    (SUM(CASE WHEN delta_mv > 0 THEN 1 ELSE 0 END) / 
     (SUM(CASE WHEN delta_mv > 0 THEN 1 ELSE 0 END) + 
      SUM(CASE WHEN delta_mv < 0 THEN 1 ELSE 0 END)))*100 as positive_percent,
    (SUM(CASE WHEN delta_mv < 0 THEN 1 ELSE 0 END) / 
     (SUM(CASE WHEN delta_mv > 0 THEN 1 ELSE 0 END) + 
      SUM(CASE WHEN delta_mv < 0 THEN 1 ELSE 0 END)))*100 as negative_percent
FROM lastyear;


-- 22.Find the quartile ranges of the delta_mv
WITH Quartiles AS (
    SELECT
        delta_mv,
        NTILE(4) OVER (ORDER BY delta_mv) AS Quartile
    FROM
        lastyear
)
SELECT
    Quartile,
    MIN(delta_mv) AS Quartile_Min,
    MAX(delta_mv) AS Quartile_Max
FROM
    Quartiles
GROUP BY
    Quartile;
