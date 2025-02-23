-- exploratory analysis 

select *
from world_life_expectancy;

select country, 
max(`Life expectancy`), 
min(`Life expectancy`),
round( max(`Life expectancy`)- min(`Life expectancy`),2) as Life_Increase_15_Years
from world_life_expectancy
group by country
having min(`Life expectancy`) <> 0 
and max(`Life expectancy`) <> 0
order by Life_Increase_15_Years desc;

select year, 
round(avg(`Life expectancy`),2) as Avg_Expectancy
from world_life_expectancy
where `Life expectancy` <> 0
group by year
order by year desc;

select country, 
round(avg(`Life expectancy`),2) as Life_Exp, 
round(avg(GDP),2) as GDP
from world_life_expectancy
group by country
having GDP <> 0
and Life_Exp <> 0
order by GDP desc;
 
select
sum(case
	when gdp >= 1500 then 1
    else 0
end) High_GDP_Count,
avg(case when gdp >= 1500 then `Life expectancy` else null end) High_GDP_Life_Exp,
sum(case
	when gdp <=1500 then 1
    else 0
end) Low_GDP_COUNT,
avg(case when gdp <=1500 then`Life expectancy` else null end) Low_GDP_Life_Exp
from world_life_expectancy
order by gdp;

select status, round(avg(`Life expectancy`),1), count(distinct country)
from world_life_expectancy
group by status;

select status, count(distinct country)
from world_life_expectancy
group by status;

select country, 
round(avg(`Life expectancy`),2) as Life_Exp, 
round(avg(BMI),2) as BMI
from world_life_expectancy
group by country
having BMI <> 0
and Life_Exp <> 0
order by BMI desc;sssss


select country, 
year, 
`Life expectancy`,
`Adult Mortality`,
sum(`Adult Mortality`) over(partition by country order by year) as Rolling_Total
from world_life_expectancy
where country like '%United%';