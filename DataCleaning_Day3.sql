SELECT * 
FROM PortfolioProjects.dbo.DataCleaning

-- Changing the date format
SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM PortfolioProjects.dbo.DataCleaning

Update DataCleaning 
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE DataCleaning
Add SaleDateConverted Date;

Update DataCleaning 
SET SaleDateConverted = CONVERT(Date,SaleDate)

-- Property Address Data 

SELECT *
FROM PortfolioProjects.dbo.DataCleaning
--Where PropertyAddress is null
order by ParcelID

SELECT s.ParcelID, s.PropertyAddress, p.ParcelID, p.PropertyAddress, ISNULL(s.PropertyAddress, p.PropertyAddress)
FROM PortfolioProjects.dbo.DataCleaning s 
JOIN PortfolioProjects.dbo.DataCleaning p
on s.ParcelID = p.ParcelID
AND s.[UniqueID] <> p.[UniqueID]
Where s.PropertyAddress is null

Update s
SET PropertyAddress = ISNULL(s.PropertyAddress, p.PropertyAddress)
FROM PortfolioProjects.dbo.DataCleaning s 
JOIN PortfolioProjects.dbo.DataCleaning p
on s.ParcelID = p.ParcelID
AND s.[UniqueID] <> p.[UniqueID]
Where s.PropertyAddress is null

-- Dividing Address into Individual Columns

SELECT PropertyAddress
FROM PortfolioProjects.dbo.DataCleaning
--Where PropertyAddress is null
--order by ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM PortfolioProjects.dbo.DataCleaning

ALTER TABLE DataCleaning
Add PropertySplitAddress Nvarchar(255);

Update DataCleaning 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE DataCleaning
Add PropertySplitCity Nvarchar(255);

Update DataCleaning 
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT * 
FROM PortfolioProjects.dbo.DataCleaning


SELECT OwnerAddress
FROM PortfolioProjects.dbo.DataCleaning

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 2) 
,PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
FROM PortfolioProjects.dbo.DataCleaning



ALTER TABLE DataCleaning
Add OwnerSplitAddress Nvarchar(255);

Update DataCleaning 
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE DataCleaning
Add OwnerSplitCity Nvarchar(255);

Update DataCleaning 
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE DataCleaning
Add OwnerSplitState Nvarchar(255);

Update DataCleaning 
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)


SELECT * 
FROM PortfolioProjects.dbo.DataCleaning

--Changing y as yes and N as No in soldasvacant columns

SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProjects.dbo.DataCleaning
Group by SoldAsVacant
order by 2



SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
  WHEN SoldAsVacant = 'N' THEN 'No'
  ELSE SoldAsVacant
  END
FROM PortfolioProjects.dbo.DataCleaning


Update DataCleaning
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
  WHEN SoldAsVacant = 'N' THEN 'No'
  ELSE SoldAsVacant
  END


  -- Deleting Duplicate Values 
  
  WITH RowNumCTE AS(
  SELECT *,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				 UniqueID
				 ) row_num 
  FROM PortfolioProjects.dbo.DataCleaning
)
--order by ParcelID
SELECT *
FROM RowNumCTE
Where row_num > 1
order by PropertyAddress


  SELECT *
  FROM PortfolioProjects.dbo.DataCleaning


  --Cleaning unused columns 

  
  SELECT *
  FROM PortfolioProjects.dbo.DataCleaning

  ALTER TABLE PortfolioProjects.dbo.DataCleaning
  DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

  ALTER TABLE PortfolioProjects.dbo.DataCleaning
  DROP COLUMN SaleDate

-- Data Cleaning : Data in the real world is virtually always a mess. 
-- If you need to find truths about data as a data scientist, data analyst 
-- you must first guarantee that the data is clean enough to do so.


  -----THANK YOU ------
