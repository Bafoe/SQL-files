select *
from amazon_kitchenware

-----------------------------------------------------
--Delecting unused column

alter table amazon_kitchenware
drop column [price/currency]

-----------------------------------------------------
--spliting title using the comma demiliter

select title,
case
	when charindex(',' , title)>0 then SUBSTRING(title, 1, charindex(',' , title) -1) 
	else  title
end as product
from amazon_kitchenware

alter table amazon_kitchenware
add Product nvarchar(255)

update amazon_kitchenware
set Product = case
	when charindex(',' , title)>0 then SUBSTRING(title, 1, charindex(',' , title) -1) 
	else  title
end 

---------------------------------
--Using parsname
Select
Replace(title, ',' , '.')
from amazon_kitchenware

update amazon_kitchenware
set title = Replace(title, ',' , '.')

select
PARSENAME(title, 4) as cat4,
PARSENAME(title, 3) as cat3,
PARSENAME(title, 2) as cat2,
PARSENAME(title, 1) as cat1

from amazon_kitchenware


alter table amazon_kitchenware
add cat4 nvarchar(255)
update amazon_kitchenware
set cat4 = PARSENAME(title, 4)
--------------------------------------------------------------------------------

--Gruping various cat

select cat4, cat3, cat2, cat1
from amazon_kitchenware

SELECT isnull(cat4, '') + '.' + isnull(cat3, '') + '.' + isnull(cat2, '') + '.' + isnull(cat1, '') + '.'  as cat
from amazon_kitchenware

update amazon_kitchenware
set cat4 = isnull(cat4, '') + '.' + isnull(cat3, '') + '.' + isnull(cat2, '') + '.' + isnull(cat1, '')

-- removing  ....
select
Replace(cat4, '....', ''),
replace(cat4, '..', '')
from amazon_kitchenware

update amazon_kitchenware
set cat4 =--Replace(cat4, '....', '')
replace(cat4, '...', '')

select 
case
when cat4 like '.%' then replace(cat4, '.', '')
else cat4
end as cat
from amazon_kitchenware

update amazon_kitchenware
set cat4 = case
when cat4 like '.%' then replace(cat4, '.', '')
else cat4
end 

--------------------------------------------------------
--dropping cat1, cat2, cat3 columns and rename
alter table amazon_kitchenware
--drop column cat1, cat3, cat2
--Rename column cat4 to details2  can't do rename why?

------------------------------------------------------------
--spliting BreadCrumps column

select breadCrumbs
--REPLACE(breadCrumbs, '›', '.') as breadCrumbs_replaced
from amazon_kitchenware

--Update amazon_kitchenware
--set breadCrumbs = REPLACE(breadCrumbs, '›', '.')

select breadCrumbs,
SUBSTRING(breadCrumbs, 1, CHARINDEX('Dining', breadcrumbs))
--SUBSTRING(breadCrumbs, CHARINDEX('.', breadcrumbs), CHARINDEX('.', breadcrumbs))
----SUBSTRING(breadCrumbs, CHARINDEX('n', breadcrumbs), CHARINDEX('.', breadcrumbs))
from amazon_kitchenware

select *
--replace(breadcrumbs, '.P', 'P')
--PARSENAME(breadcrumbs,4) AS Bread1,
--PARSENAME(breadcrumbs,3) AS Bread2,
--PARSENAME(breadcrumbs,2) AS Bread3,
--PARSENAME(breadcrumbs,1) AS Bread4
from amazon_kitchenware

alter table amazon_kitchenware
add bread1 nvarchar(100), bread2 nvarchar(100), bread3 nvarchar(100)

update amazon_kitchenware
set bread4 = PARSENAME(breadcrumbs,1)
				  --PARSENAME(breadcrumbs,3) AS Bread2,
				  --PARSENAME(breadcrumbs,2) AS Bread3,
				  --PARSENAME(breadcrumbs,1) AS Bread4


--------------------------------------------------------------------------------------------------------
--adding  bread1, bread2, bread3, and 2

select ISNULL(bread1, '') + '.' + isnull(bread2, '') + ', ' + isnull(bread3, '') + ', ' + ISNULL(bread4, '') as New_bread
from amazon_kitchenware

alter table amazon_kitchenware
add New_bread nvarchar(250)

update amazon_kitchenware
set New_bread = ISNULL(bread1, '') + '.' + isnull(bread2, '') + '.' + isnull(bread3, '') + '.' + ISNULL(bread4, '')

select breadCrumbs
--REPLACE(new_bread, 'K', 'K')
from amazon_kitchenware

update amazon_kitchenware
set new_bread = REPLACE(new_bread, '.', 'P')

alter table amazon_kitchenware
DROP COLUMN bread1, bread2, bread3, bread4


select 

PARSENAME(breadcrumbs,3) AS Bread1,
PARSENAME(breadcrumbs,2) AS Bread2,
PARSENAME(breadcrumbs,1) AS Bread3
from amazon_kitchenware

update amazon_kitchenware
set bread3 = 
PARSENAME(breadcrumbs,1)

SELECT *,

    CASE
        -- If bread1 is null, concatenate bread2 with bread1
        WHEN concatenated_bread like '' THEN COALESCE(bread3, '') + COALESCE(concatenated_bread, '')
        
        -- If bread1 is null and bread2 is null, concatenate bread3 with bread1
        --WHEN bread1 IS NULL AND bread2 IS NULL THEN COALESCE(bread3, '') + COALESCE(bread1, '')

        -- If bread1 is null and bread2 is not null, concatenate bread2 with bread1
        --WHEN bread1 IS NULL AND bread2 IS NOT NULL THEN COALESCE(bread2, '') + COALESCE(bread1, '')
        
        -- If bread1 is null and bread2 is null, concatenate bread3 with bread1
        --WHEN bread1 IS NULL AND bread2 IS NULL THEN COALESCE(bread3, '') + COALESCE(bread1, '')
        -- If none of the above conditions match, return bread1 as is
        ELSE concatenated_bread
    END AS new_concatenated_bread
FROM amazon_kitchenware;

alter table amazon_kitchenware
add concatenated_bread nvarchar(255)

update amazon_kitchenware	
set concatenated_bread =  CASE
			
		when concatenated_bread like '%Cookware%' then SUBSTRING(concatenated_bread, 1,8)
		when concatenated_bread like '%Home&Kitchen%' then replace(concatenated_bread, 'Home&KitchenBathBathroomAccessoriesHolders&DispensersSoapDishes','Home&KitchenStorage')


   -- If bread1 is null, concatenate bread2 with bread1
       -- WHEN concatenated_bread like '' THEN COALESCE(bread3, '') + COALESCE(concatenated_bread, '') 
        
        -- If bread1 is null and bread2 is null, concatenate bread3 with bread1
        --WHEN bread1 IS NULL AND bread2 IS NULL THEN COALESCE(bread3, '') + COALESCE(bread1, '')

        -- If bread1 is null and bread2 is not null, concatenate bread2 with bread1
        --WHEN bread1 IS NULL AND bread2 IS NOT NULL THEN COALESCE(bread2, '') + COALESCE(bread1, '')
        
        -- If bread1 is null and bread2 is null, concatenate bread3 with bread1
        --WHEN bread1 IS NULL AND bread2 IS NULL THEN COALESCE(bread3, '') + COALESCE(bread1, '')
        -- If none of the above conditions match, return bread1 as is
        ELSE concatenated_bread
    END 




select *
from amazon_kitchenware
--group by concatenated_bread

--where concatenated_bread like '%kitchenUtensils%'

select concatenated_bread,
case
when concatenated_bread like '%Cookware%' then SUBSTRING(concatenated_bread, 1,8)
when concatenated_bread like '%Home&Kitchen%' then replace(concatenated_bread, 'Home&KitchenBathBathroomAccessoriesHolders&DispensersSoapDishes','Home&KitchenStorage')

else concatenated_bread
end as new
from amazon_kitchenware
group by concatenated_bread


alter table amazon_kitchenware
drop column bread2, bread3


select product,
case
when product like '%-%' then SUBSTRING(product, 1, CHARINDEX('-',product))
--replace(product, ' Metal 2-in-1 Lemon Squeezer - Sturdy Max Extraction Hand Juicer Lemon Squeezer Gets Every Last Drop - Easy to Clean Manual Citrus Juicer - Easy-Use Lemon Juicer Squeezer - Yellow/Green', 'Lemon Squeezer')
--SUBSTRING(Product, 27, len(product))
--SUBSTRING(Product, CHARINDEX('Meat Chopper', product),12)
else product
end as updated_product
from amazon_kitchenware
group by product, asin


update amazon_kitchenware
set product = case
					when product like '%-%' then SUBSTRING(product, 1, CHARINDEX('-',product) -1)
--SUBSTRING(concatenated_bread,1,21)
					--when product like '%CAROTE%' then SUBSTRING(product, charindex('knife', product), len(product))
					--when product like '%food storage containers set%' then SUBSTRING(product, 1, CHARINDEX('-', product) -1)
				
					else product
			  end 



select product, brand, concatenated_bread
from amazon_kitchenware
where product like '%-%'
group by product,brand,concatenated_bread,asin


select product 
from amazon_kitchenware
where product like ''