select *
from us_household_income;

select *
from us_household_income_statistics;

select state_name, sum(awater), sum(aland)
from us_household_income
group by state_name
order by 2 desc
limit 10;

select u.state_name, round(avg(mean),1), round(avg(median),1)
from us_household_income u
join us_household_income_statistics us
on u.id = us.id
where mean <> 0
group by u.state_name
order by 2 asc
limit 5;

select u.state_name, round(avg(mean),1), round(avg(median),1)
from us_household_income u
join us_household_income_statistics us
on u.id = us.id
where mean <> 0
group by u.state_name
order by 2 desc
limit 5;


-- could use a having clause to eliminate the 'outliers' as well
-- ie: having count(type) >= 100
select type, count(type), round(avg(mean),1), round(avg(median),1)
from us_household_income u
join us_household_income_statistics us
on u.id = us.id
where mean <> 0
group by type
order by 2;

select state_name
from us_household_income
where type = 'Community';


select u.state_name, city, round(avg(mean),1)
from us_household_income u
join us_household_income_statistics us
on u.id = us.id
group by u.state_name, city
order by 3 desc;