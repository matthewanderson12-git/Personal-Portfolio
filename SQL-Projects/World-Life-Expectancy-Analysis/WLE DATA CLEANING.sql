#Data cleaning
select *
from world_life_expectancy;


-- identifies duplicates 
SELECT country, year, concat(country,year), count(concat(country,year))
FROM world_life_expectancy
group by country, year, concat(country,year)
having count(concat(country,year)) > 1;

-- cant do this
select row_id, concat(country,year),
row_number() over(partition by concat(country,year) order by concat(country,year)) as rn
from world_life_expectancy
where rn > 1;

-- instead must do this subquery in the from statement
-- dont forget the secondary alias of subquery 
select row_id
from(
select row_id, concat(country,year),
row_number() over(partition by concat(country,year) order by concat(country,year)) as rn
from world_life_expectancy) as row_table
where rn > 1;

-- deleted duplicates
delete from world_life_expectancy
where row_id in (select row_id
from(
select row_id, concat(country,year),
row_number() over(partition by concat(country,year) order by concat(country,year)) as rn
from world_life_expectancy) as row_table
where rn > 1);

-- replacing null values
-- identifies unique values 
select *
from world_life_expectancy
where status = '';

-- finds all countrys that have developing status
select distinct(country)
from world_life_expectancy
where status = 'Developing';

-- doesnt work (cant use subquery)
update world_life_expectancy
set status = 'Developing'
where country in (select distinct(country)
from world_life_expectancy
where status = 'Developing');

-- heres the work around have to use a self join 
update world_life_expectancy t1
join world_life_expectancy t2
	on t1.country = t2.country
set t1.status = 'Developing'
where t1.status = ''
and t2.status != ''
and t2.status = 'Developing';

-- update statement
update world_life_expectancy t1
join world_life_expectancy t2
	on t1.country = t2.country
set t1.status = 'Developed'
where t1.status = ''
and t2.status != ''
and t2.status = 'Developed';

-- finds all blank life expectancy rows
select * 
from world_life_expectancy
where `Life expectancy` = '';

-- put the life expectancy for the prior year and the next year on the same row as the blanks
select t1.country, t1.year, t1.`Life expectancy`, 
t2.country, t2.year, t2.`Life expectancy`, 
t3.country, t3.year, t3.`Life expectancy`, (t2.`Life expectancy`+t3.`Life expectancy`)/2 as maths
from world_life_expectancy t1
join world_life_expectancy t2
	on t1.country = t2.country and t1.year = t2.year-1
join world_life_expectancy t3
	on t1.country = t3.country and t1.year = t3.year+1
where t1.`Life expectancy` = '';

-- update statement
update world_life_expectancy t1
join world_life_expectancy t2
	on t1.country = t2.country and t1.year = t2.year-1
join world_life_expectancy t3
	on t1.country = t3.country and t1.year = t3.year+1
set t1.`Life expectancy` = round((t2.`Life expectancy`+t3.`Life expectancy`)/2,1)
where t1.`Life expectancy` = '';


select * 
from world_life_expectancy;




