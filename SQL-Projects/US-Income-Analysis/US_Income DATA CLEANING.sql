-- data cleaning

select *
from us_household_income;

select *
from us_household_income_statistics;

alter table us_household_income_statistics
rename column `ï»¿id` to `id`;

select count(id)
from us_household_income_statistics;

select count(id)
from us_household_income;


select id, count(id)
from us_household_income
group by id
having count(id) > 1;

select row_id, 
id,
row_number() over(partition by id order by row_id desc) as rn
from us_household_income
;

select row_id
from(select row_id, 
id,
row_number() over(partition by id order by id desc) as rn
from us_household_income) as row_table
where rn > 1;

-- now delete those duplicates
delete from us_household_income
where row_id in (
				select row_id
				from(select row_id, 
				id,
				row_number() over(partition by id order by id desc) as rn
				from us_household_income) as row_table
				where rn > 1
				);
                
select id, count(id)
from us_household_income_statistics
group by id
having count(id) > 1;

select State_Name, count(State_Name)
from us_household_income
group by State_Name;

update us_household_income
set state_name = 'Georgia'
where state_name = 'georia';

update us_household_income
set state_name = 'Alabama'
where state_name = 'alabama';

select *
from us_household_income
where place = '';

select *
from us_household_income
where place = 'Autauga County';

update us_household_income
set place = 'Autaugaville'
where county = 'Autauga County'
and city = 'Vinemont';


select type, count(type)
from us_household_income
group by type;

update us_household_income
set type = 'Borough'
where type = 'Boroughs';

select aland, AWater
from us_household_income
where ALand = 0
or awater = 0;