# upload Nashville Housing Data
create database if not exists nashville;
use nashville;
create table housing
(UniqueID             int,
ParcelID            varchar(255),
LandUse             varchar(255),
PropertyAddress     varchar(255),
SaleDate            varchar(255),
SalePrice           double,
LegalReference      varchar(255),
SoldAsVacant        varchar(255),
OwnerName           varchar(255),
OwnerAddress        varchar(255),
Acreage            double,
TaxDistrict         varchar(255),
LandValue          double,
BuildingValue      double,
TotalValue         double,
YearBuilt          double,
Bedrooms           double,
FullBath           double,
HalfBath           double
);
set global local_infile=1;
load data local infile '/Users/yangzhongda/Desktop/data science/portfolio/sql 2/Nashville Housing Data for Data Cleaning.csv'
into table housing
fields terminated by ','
ENCLOSED BY '"' ESCAPED BY "\\"
ignore 1 rows;

select *
from housing;