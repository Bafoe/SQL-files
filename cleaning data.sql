/*
Cleaning 
*/

select *
from [Nashville Housing]
-------------------------------------------------------------


-- standardize date format
select SaleDate, convert(DATE,SaleDate)
from [Nashville Housing]

/* --This don't work and i don't know why
UPDATE [Nashville Housing]
SET SaleDate = convert(DATE,SaleDate)
*/

ALTER Table [Nashville Housing]
add SaleDateConverted date

UPDATE [Nashville Housing]
SET SaleDateConverted = convert(DATE,SaleDate)

--------------------------------------------------------------------


--Populate Property address
--This check where there is same parcel ID but one of them has a property address of null and equate it to the one without null

select a.PropertyAddress, a.ParcelID, b.PropertyAddress, b.ParcelID, ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Nashville Housing] a
JOIN [Nashville Housing] b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

UPDATE a
SET propertyaddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Nashville Housing] a
JOIN [Nashville Housing] b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-----------------------------------------------------------------------------------------------------------------

/*
--BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMN

*/
SELECT 
SUBSTRING(propertyaddress, 1, CHARINDEX(',' , propertyaddress)-1 ) as address
,SUBSTRING(propertyaddress, CHARINDEX(',' , propertyaddress)+1 , LEN(Propertyaddress)) as address
FROM [Nashville Housing]

ALTER Table [Nashville Housing]
add PropertySplitAddress nvarchar(250)

ALTER Table [Nashville Housing]
add PropertyCity nvarchar(250)

UPDATE [Nashville Housing]
SET PropertySplitAddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',' , propertyaddress)-1 )

UPDATE [Nashville Housing]
SET PropertyCity = SUBSTRING(propertyaddress, CHARINDEX(',' , propertyaddress)+1 , LEN(Propertyaddress))

--YOU CAN ALSO YOU THE PARSENAME


--OWNER'S  ADDRESS (USING PARSENAME)
select 
PARSENAME(REPLACE(owneraddress, ',' , '.'), 3) AS OwnerStreetAddress,
PARSENAME(REPLACE(owneraddress, ',' , '.'), 2) AS OwnerCity,
PARSENAME(REPLACE(owneraddress, ',' , '.'), 1) AS OwnerState
from [Nashville Housing]


ALTER Table [Nashville Housing]
add OwnerCity nvarchar(250)

ALTER Table [Nashville Housing]
add OwnerState nvarchar(250)

ALTER Table [Nashville Housing]
add OwnerStreetAddress nvarchar(250)

UPDATE [Nashville Housing]
SET OwnerState = PARSENAME(REPLACE(owneraddress, ',' , '.'), 1)

UPDATE [Nashville Housing]
SET OwnerStreetAddress = PARSENAME(REPLACE(owneraddress, ',' , '.'), 3)

------------------------------------------------------------------------------------------------------------------------------

/*
changing y and n to yes and no respectively
*/
select SoldAsVacant, count(soldasvacant)
from [Nashville Housing]
group by soldasvacant


--Using when statement
--You can't use replace because replace will find any N, whether it is the world or standing alone, in the column and replace with No
select 
case
	when SoldAsVacant = 'N' then 'No'
	when soldasvacant = 'Y' then 'Yes'
	else SoldAsVacant
end
from [Nashville Housing]

Update [Nashville Housing]
Set SoldAsVacant = case
						when SoldAsVacant = 'N' then 'No'
						when soldasvacant = 'Y' then 'Yes'
						else SoldAsVacant
					end

-------------------------------------------------------------------------------------------------------------------------

/*
		   REMOVING DUPLICATE
This one check all the five items and number it 1 if there is a repetion of all the 5 from what has already be numbered then it will number it 2
later now, you write a code to remove of the those numbered 2 since is a duplicate
*/

with rownumber as
(
SELECT *,
ROW_NUMBER() OVER ( PARTITION BY
					ParcelID,
					propertyaddress,
					SaleDate,
					SalePrice,
					LegalReference
					ORDER BY UniqueID
					) Row_Num
FROM [Nashville Housing]
)
delete
from rownumber
where Row_Num > 1

---------------------------------------------------------------------------------------------------------------


/*
					Removing uncessary columns
it is advisable to use the drop button so that you don't mistakenly delete a wanted column since that one cannot be revised
*/
select *
from [Nashville Housing]


ALTER TABLE [Nashville Housing]
Drop COLUMN Propertyaddress, SaleDate, OwnerAddress, TaxDistrict




























