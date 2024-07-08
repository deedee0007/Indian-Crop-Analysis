	USE Monday;

	SELECT * FROM Crop_Data;

	SELECT * FROM Crop_Data
	WHERE Production is null; 
--there are 3,730 rows where production values are null that accounts to only 1.5 per of the overall data so we can remove it 

	Delete  from Crop_Data
	where Production is null;

--State wise Agricultural land

	SELECT State_name , SUM(Area) as Total_area
	FROM Crop_Data
	GROUP BY State_Name
	ORDER BY Total_area desc;

--District_wise Agricultural land

	SELECT District_Name , SUM(Area) as Total_area
	FROM Crop_Data
	GROUP BY District_Name
	ORDER BY Total_area desc;

--agricultural land year wise 

	SELECT Crop_Year , SUM(Area) as Total_area
	FROM Crop_Data
	GROUP BY Crop_Year
	ORDER BY Total_area desc;

--percentage change in agricultural land from 1997 to 2015

	SELECT crop_year, SUM(area) AS total_area FROM Crop_Data GROUP BY crop_year ORDER BY crop_year;


	SELECT
		crop_year,
		ROUND(SUM(area),2) AS total_area,
		ROUND(LAG(SUM(area)) OVER (ORDER BY crop_year),2) AS prev_year_area,
		ROUND((SUM(area) - LAG(SUM(area)) OVER (ORDER BY crop_year)),2) AS area_change
	FROM
		Crop_Data
	GROUP BY
		crop_year
	ORDER BY
		crop_year;


	WITH cte as(
	select sum(area) as Total_area_1997 from Crop_Data
	where crop_year = '1997'),

	cte2 as (
	select sum(area) Total_area_2015 from Crop_Data
	where crop_year = '2015'
	)

	SELECT 'Percentage_change' AS description , ((total_area_2015 - total_area_1997) / total_area_1997) * 100 AS area_difference
	FROM cte
	CROSS JOIN cte2; 

-- Crop Distribution

	SELECT crop , count(*) as count
	FROM Crop_Data
	GROUP BY Crop
	ORDER BY count desc;

--Which crops have the highest total area under cultivation

	SELECT crop , SUM(area) AS total_area
	FROM Crop_Data
	GROUP BY crop
	ORDER BY total_area desc;

--Which crops have the highest total production 

	SELECT crop , SUM(production) AS total_production
	FROM Crop_Data
	GROUP BY crop
	ORDER BY total_production desc;

--Which year have the highest total production 

	SELECT Crop_Year , SUM(production) AS total_production
	FROM Crop_Data
	GROUP BY Crop_Year
	ORDER BY total_production desc;


--Which season have the highest total production 

	SELECT Season , SUM(production) AS total_production
	FROM Crop_Data
	GROUP BY Season
	ORDER BY total_production desc;

--Which state have the highest total production 

	SELECT State_Name , SUM(production) AS total_production
	FROM Crop_Data
	GROUP BY State_Name
	ORDER BY total_production desc;

--Which district have the highest total production 

	SELECT District_Name , SUM(production) AS total_production
	FROM Crop_Data
	GROUP BY District_Name
	ORDER BY total_production desc;


-- Average production per unit area

	SELECT crop, ROUND(AVG(production / area),2) AS average_yield
	FROM Crop_Data
	GROUP BY crop
	ORDER BY average_yield desc;

	SELECT Top 20 State_Name, ROUND(AVG(production / area),2) AS average_yield
	FROM Crop_Data
	GROUP BY State_Name
	ORDER BY average_yield desc
	



--Change in production from 1997 to 2015

	SELECT crop_year, SUM(production) AS total_production FROM Crop_Data GROUP BY crop_year ORDER BY crop_year;


	SELECT
		crop_year,
		ROUND(SUM(production),2) AS total_production,
		ROUND(LAG(SUM(production)) OVER (ORDER BY crop_year),2) AS prev_year_production,
		ROUND((SUM(production) - LAG(SUM(production)) OVER (ORDER BY crop_year)),2) AS production_change
	FROM
		Crop_Data
	GROUP BY
		crop_year
	ORDER BY
		crop_year;


	WITH cte as(
	select sum(production) as Total_production_1997 from Crop_Data
	where crop_year = '1997'),

	cte2 as (
	select sum(production) Total_production_2015 from Crop_Data
	where crop_year = '2015'
	)

	SELECT 'Percentage_change' AS description , ((total_production_2015 - total_production_1997) / total_production_1997) * 100 AS production_difference
	FROM cte
	CROSS JOIN cte2; 


	SELECT * FROM Crop_Data;


-- Crop failure identification , where production is equal to "0"

	SELECT * FROM Crop_Data
	WHERE Production = '0'
	order by area desc;


	SELECT Crop_year, 
		   SUM(CASE WHEN production = 0 THEN 1 ELSE 0 END) AS zero_production_count
	FROM Crop_Data
	WHERE Crop_year BETWEEN 1997 AND 2015
	GROUP BY Crop_year , Area
	ORDER BY zero_production_count DESC ;

	SELECT State_Name ,
		   SUM(CASE WHEN production = 0 THEN 1 ELSE 0 END) AS zero_production_count
	FROM Crop_Data
	WHERE Crop_year BETWEEN 1997 AND 2015
	GROUP BY State_Name
	ORDER BY zero_production_count DESC ;

	SELECT District_Name ,
		   SUM(CASE WHEN production = 0 THEN 1 ELSE 0 END) AS zero_production_count
	FROM Crop_Data
	WHERE Crop_year BETWEEN 1997 AND 2015
	GROUP BY District_Name
	ORDER BY zero_production_count DESC ;

	SELECT Crop ,
		   SUM(CASE WHEN production = 0 THEN 1 ELSE 0 END) AS zero_production_count
	FROM Crop_Data
	WHERE Crop_year BETWEEN 1997 AND 2015
	GROUP BY Crop
	ORDER BY zero_production_count DESC ;

	
--Percentage contribution of each state to total production of a crop 

	SELECT 
		state_name,
		crop, 
		SUM(production) AS total_production,
		CASE 
			WHEN (SELECT SUM(production) FROM Crop_Data WHERE Crop = c.crop) = 0 THEN 0
			ELSE (SUM(production) * 100.0 / (SELECT SUM(production) FROM Crop_Data WHERE Crop = c.crop))
		END AS percentage_contribution
	FROM 
		Crop_Data AS c
	GROUP BY 
		state_name, crop
	ORDER BY 
		crop, percentage_contribution DESC;

--Identify crop rotation pattern

	SELECT 
		District_Name,
		STUFF((
			SELECT 
				', ' + crop
			FROM 
				Crop_Data AS c2
			WHERE 
				c2.District_Name = c1.District_Name
			ORDER BY 
				season
			FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS crop_rotation_pattern
	FROM 
		Crop_Data AS c1
	GROUP BY 
		District_Name;


	select * from Crop_Data;

	SELECT top 1 Season, COUNT(*) as zero_count
	FROM Crop_Data
	WHERE production = 0
	GROUP BY Season
	ORDER BY zero_count DESC;

	SELECT top 20 crop ,sum(production) as total
	FROM Crop_Data
	group by crop
	having sum(production) > 0
	order by total;

