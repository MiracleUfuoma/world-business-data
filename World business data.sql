-- Analysis for world business data
--oldest and newest founding year from the business table
SELECT MIN(year_founded) AS oldest_year_found, MAX(year_founded) AS newest_year_found
FROM [dbo].[businesses]


--How many businesses were found before year 1000
SELECT COUNT(*) AS count
FROM [dbo].[businesses]
WHERE year_founded < 1000 


--Which businesses were found before year 1000
SELECT *
FROM [dbo].[businesses]
WHERE year_founded < 1000 
ORDER BY year_founded


--Businesses founded before the year 1000
SELECT 
      business, year_founded, [dbo].[businesses].category_code, country_code, category
    FROM 
	   [world oldest business].[dbo].[businesses] 
    INNER JOIN 
	       [world oldest business].[dbo].[categories] 
       ON 
	    businesses.category_code = [categories].category_code
    WHERE year_founded < 1000
	ORDER BY year_founded


--count of business category
SELECT category, COUNT(category) AS countN
    FROM [world oldest business].[dbo].[businesses] 
    INNER JOIN [world oldest business].[dbo].[categories] 
       ON businesses.category_code = [categories].category_code
	GROUP BY category
	ORDER BY category 

--Oldest business according to continent using CTE	  
WITH RankedBusinesses AS (
    SELECT
        continent,
        business,
        year_founded,
        ROW_NUMBER() OVER (PARTITION BY continent 
		ORDER BY year_founded) AS row_num
    FROM
        dbo.businesses
    JOIN
        dbo.countries ON countries.country_code = businesses.country_code)
SELECT
    continent,
    business,
    year_founded
FROM
    RankedBusinesses
WHERE
    row_num = 1;

--oldest industries(category)
SELECT 
     MIN(year_founded) AS oldest_year_founded, category, business
FROM
    dbo.businesses
JOIN 
   dbo.categories ON businesses.category_code = categories.category_code
	GROUP BY business, category
	ORDER BY MIN(year_founded)


--Count of industries
SELECT 
    COUNT(category) AS category_n, category
FROM  
    dbo.businesses
JOIN 
   dbo.categories ON businesses.category_code = categories.category_code
	GROUP BY category
	ORDER BY category_n DESC


--Joining all three tables
SELECT 
    year_founded,business, country, continent
FROM 
   dbo.businesses
JOIN 
   dbo.categories 
ON 
  businesses.category_code = categories.category_code
JOIN 
   dbo.countries
ON 
  businesses.country_code = countries.country_code


--Counting categories by continent
SELECT 
   category,COUNT(business) AS business_n, continent
FROM 
   dbo.businesses
JOIN 
   dbo.categories 
ON 
  businesses.category_code = categories.category_code
JOIN 
  dbo.countries
ON 
 businesses.country_code = countries.country_code
GROUP BY continent,category
HAVING COUNT (business) > 5
ORDER BY business_n DESC


--Total years in business of each industry(category)
 SELECT 
   category,MIN(year_founded) AS oldest,
   YEAR(GETDATE()) - MIN (year_founded) AS total_years_in_business
FROM 
   dbo.businesses
JOIN 
   dbo.categories 
ON 
  businesses.category_code = categories.category_code
JOIN 
  dbo.countries
ON 
 businesses.country_code = countries.country_code
 GROUP BY
 category 
 ORDER BY total_years_in_business DESC






