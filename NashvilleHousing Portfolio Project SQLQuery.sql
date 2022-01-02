/*

Cleaning Data in SQL Queries

*/

select *
from [Portfolio Project].dbo.NashvilleHousing

-- Standardize Date Format

select SaleDateConverted, CONVERT(date,SaleDate)
from [Portfolio Project].dbo.NashvilleHousing

Update NashvilleHousing
Set SaleDate = CONVERT(Date,SaleDate)

alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing
Set SaleDateConverted = CONVERT(date,SaleDate)

-- Populate Property Address Data

select *
from [Portfolio Project].dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID
-- parcelID is directly linked to unique address

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Project].dbo.NashvilleHousing a
JOIN [Portfolio Project].dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Project].dbo.NashvilleHousing a
JOIN [Portfolio Project].dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
from [Portfolio Project].dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as Address
from [Portfolio Project].dbo.NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress nvarchar(255);

update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

alter table NashvilleHousing
add PropertySplitCity nvarchar(255);

update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

select *
from [Portfolio Project].dbo.NashvilleHousing

-- Alternate Way

select OwnerAddress
from [Portfolio Project].dbo.NashvilleHousing

select
PARSENAME(replace(OwnerAddress, ',', '.') , 3)
,PARSENAME(replace(OwnerAddress, ',', '.') , 2)
,PARSENAME(replace(OwnerAddress, ',', '.') , 1)
from [Portfolio Project].dbo.NashvilleHousing

alter table NashvilleHousing
add OwnerSplitAddress nvarchar(255);

update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',', '.') , 3)

alter table NashvilleHousing
add OwnerSplitCity nvarchar(255);

update NashvilleHousing
Set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',', '.') , 2)

alter table NashvilleHousing
add OwnerSplitState nvarchar(255);

update NashvilleHousing
Set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',', '.') , 1)


select *
from [Portfolio Project].dbo.NashvilleHousing

-- Change Y and N to Yes and No in "Sold as Vacant" Field

select distinct (SoldAsVacant), COUNT(SoldAsVacant)
from [Portfolio Project].dbo.NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
from [Portfolio Project].dbo.NashvilleHousing

update NashvilleHousing
Set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end

-- Remove Duplicates

with RowNumCTE as(
Select *, 
	ROW_NUMBER() over (
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by
					UniqueID
					) row_num

from [Portfolio Project].dbo.NashvilleHousing
--order by ParcelID
)

select *
from RowNumCTE
where row_num > 1
order by PropertyAddress

Select *
from [Portfolio Project].dbo.NashvilleHousing


-- Delete Unused Columns

Select *
from [Portfolio Project].dbo.NashvilleHousing

alter table [Portfolio Project].dbo.NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table [Portfolio Project].dbo.NashvilleHousing
drop column SaleDate
