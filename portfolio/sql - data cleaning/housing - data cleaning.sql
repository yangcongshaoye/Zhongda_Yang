# standardize date format
use nashville;
select  saledate, str_to_date(saledate, '%M %e, %Y')
from housing;
update housing
set saledate = str_to_date(saledate, '%M %e, %Y');


# populate property address data
select a.parcelid, a.PropertyAddress, b.PropertyAddress, 
case when b.PropertyAddress='' then a.PropertyAddress else b.PropertyAddress end
from housing a join housing b on a.parcelid = b.parcelid 
where a.PropertyAddress != '' and b.PropertyAddress ='';

update housing h
join (
    select a.parcelid,
           case when b.PropertyAddress = '' then a.PropertyAddress else b.PropertyAddress end as NewPropertyAddress
    from housing a join housing b on a.parcelid = b.parcelid
    where a.PropertyAddress != '' and b.PropertyAddress = '') as DuplicatesToUpdate on h.parcelid = DuplicatesToUpdate.parcelid
set h.PropertyAddress = DuplicatesToUpdate.NewPropertyAddress;


# breake out adddress into individual columns (address, city, state)
select substring_index(PropertyAddress,',',1) as address, substring_index(PropertyAddress,',',-1) as city
from housing;

alter table housing
add PropertySplitCity varchar(255);
update housing
set PropertySplitCity = substring_index(PropertyAddress,',',-1);
update housing
set PropertyAddress = substring_index(PropertyAddress,',',1);
alter table housing modify PropertySplitCity varchar(255) after PropertyAddress;

select substring_index(OwnerAddress,',',1) as address, 
substring_index(substring_index(OwnerAddress,',',2),',',-1) as city,
substring_index(OwnerAddress,',',-1) as state
from housing;

alter table housing
add OwnerSplitAddress varchar(255);
update housing
set OwnerSplitAddress = substring_index(OwnerAddress,',',1);

alter table housing
add OwnerSplitCity varchar(255);
update housing
set OwnerSplitCity = substring_index(substring_index(OwnerAddress,',',2),',',-1);

alter table housing
add OwnerSplitState varchar(255);
update housing
set OwnerSplitState = substring_index(OwnerAddress,',',-1);


# change Y and N to Yes and No in 'SoldAsVacant' field
select UniqueID, SoldAsVacant
from housing
where SoldAsVacant='Y' or SoldAsVacant='N';

update housing
set SoldAsVacant = case when SoldAsVacant='Y' then 'Yes' when SoldAsVacant='N' then 'No' else SoldAsVacant end;


# remove duplicates
with sub1 as
(select *, 
row_number() over(partition by ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference order by UniqueID) as sqt
from housing)
select *
from sub1
where sqt>1;

delete
from housing
where UniqueID in
(select UniqueID 
from (select *, 
row_number() over(partition by ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference order by UniqueID) as sqt
from housing) as sub2
where sqt>1);


# delete unused columns
alter table housing
drop column OwnerAddress, drop column TaxDistrict;