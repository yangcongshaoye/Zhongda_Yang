# upload coviddeaths document
create database if not exists covid;
use covid;
create table coviddeaths
(
iso_code varchar(255),
continent varchar(255),
location varchar(255),
date date,
population Double,
total_cases Double,
new_cases Double,
new_cases_smoothed Double,
total_deaths Double,
new_deaths Double,
new_deaths_smoothed Double,
total_cases_per_million Double,
new_cases_per_million Double,
new_cases_smoothed_per_million Double,
total_deaths_per_million Double,
new_deaths_per_million Double,
new_deaths_smoothed_per_million Double,
reproduction_rate Double,
icu_patients Double,
icu_patients_per_million Double,
hosp_patients Double,
hosp_patients_per_million Double,
weekly_icu_admissions Double,
weekly_icu_admissions_per_million Double,
weekly_hosp_admissions Double,
weekly_hosp_admissions_per_million Double
);
set global local_infile=1;
load data local infile '/Users/yangzhongda/Desktop/data science/portfolio/CovidDeaths.csv'
into table coviddeaths
fields terminated by ','
ignore 1 rows;

select *
from coviddeaths;


# upload covidvaccinations document
use covid;
create table covidvaccinations
(iso_code varchar(255),
continent varchar(255),
location varchar(255),
date date,
new_tests double,
total_tests double,
total_tests_per_thousand double,
new_tests_per_thousand double,
new_tests_smoothed double,
new_tests_smoothed_per_thousand double,
positive_rate double,
tests_per_case double,
tests_units varchar(255),
total_vaccinations double,
people_vaccinated double,
people_fully_vaccinated double,
new_vaccinations double,
new_vaccinations_smoothed double,
total_vaccinations_per_hundred double,
people_vaccinated_per_hundred double,
people_fully_vaccinated_per_hundred double,
new_vaccinations_smoothed_per_million double,
stringency_index double,
population_density double,
median_age double,
aged_65_older double,
aged_70_older double,
gdp_per_capita double,
extreme_poverty double,
cardiovasc_death_rate double,
diabetes_prevalence double,
female_smokers double,
male_smokers double,
handwashing_facilities double,
hospital_beds_per_thousand double,
life_expectancy double,
human_development_index double);
set global local_infile = 1;
load data local infile '/Users/yangzhongda/Desktop/data science/portfolio/CovidVaccinations.csv'
into table covidvaccinations
fields terminated by ','
ignore 1 rows;

select *
from covidvaccinations;