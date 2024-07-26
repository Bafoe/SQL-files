
--These are queries to analyze amazon kitchenware products

alter table sheet1
drop column description

select *
from [Amazon Kitchenware]..sheet1


--Number of brnads producing same products--
with NumBrand (product, brand, DifferentBrandPerProduct) 
as (
select product, brand, count(brand) over (
partition by product) DifferentBrandPerProduct
from sheet1
where product is not null
group by product, brand
--Order by 3 desc
)
select *
from NumBrand
where DifferentBrandPerProduct > 1
order by 3 desc

-----------------------------------------------------------------


--Checking expensive brand among a particular product--

Drop table if EXISTS #Expensive_brand
CREATE TABLE #Expensive_brand(
	 Product varchar(250),
	 Brand varchar(100),
	 No_of_Product numeric,
	 price FLOAT,
	 Expensive_Brand float
	 )

INSERT INTO #Expensive_brand
	Select product, brand, 
	count(product) over (partition by product),
	[price/value], 
	max([price/value]) over (partition by product) 
	from sheet1
	where product is not null
	group by brand, [price/value], Product
	Order by 5 

select *
from #Expensive_brand
where No_of_Product > 1

---------------------------------------------------------------------


--The Brand producing the most of a particular Product--

with BPMP ( product, brand, No_of_brands, MostProducedBrand) as (
select product, brand, count(brand ) as No_of_brands , Max(brand)
over (partition by product) MostProducedBrand
from Sheet1
group by Product, brand
--order by 3 desc
)
select *
from BPMP
where No_of_brands > 1
order by 3 desc

-----------------------------------------------------------------------


--Most Product in Amazon Kitchenwaare--

Select Product, count(asin) TotalNumberOfProduct
from Sheet1
where product is not null 
group by Product
HAVING COUNT(asin) > 2

-------------------------------------------------------------------------


--Most Type of Category in Amazon Kitchenware--

Select concatenated_bread, count(asin) TotalNumberOfCategory
from Sheet1
where product is not null 
group by concatenated_bread
--order by 2 desc
Having count(asin) > 5

---------------------------------------------------------------------------------


--Number of Product under Category in Amazon Kitchenware--

Select concatenated_bread, product, count(asin) TotalNumberOfProduct
from Sheet1
where product is not null 
group by concatenated_bread, Product
order by 3 desc

---------------------------------------------------------------------------------

--Brand Product Review and stars--

select brand, product, avg(reviewsCount), stars
from sheet1 
group by brand, product, stars
order by 3 desc