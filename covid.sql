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
use covid;
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
use covid;
load data local infile '/Users/yangzhongda/Desktop/data science/portfolio/CovidVaccinations.csv'
into table covidvaccinations
fields terminated by ','
ignore 1 rows;
select *
from covidvaccinations;

# looking at total cases vs total deaths
# shows likelihood of dying if infected covid in Canada
select location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100,2) as death_percentage
from coviddeaths
where location='Canada'
order by 1,2;

# looking at total cases vs population
# show what percentage of population got covid
select location, date, total_cases, population, round((total_cases/population)*100,2) as infection_percentage
from coviddeaths
where location='Canada'
order by 1,2;

# looking at countries with highest infection rate compared to population
select location, max(total_cases) as highest_infection_count, population, 
round((max(total_cases)/population)*100,2) as highest_infection_percentage
from coviddeaths
where continent != ''
group by location
order by 4 desc;

# looking at countries with highest death count
select location, max(total_deaths) as highest_death_count, population
from coviddeaths
where continent != ''
group by location
order by 2 desc;

# looking at continents with highest death count
select continent, sum(highest_death_count_countries) as highest_death_count_continents
from
(select continent, location, max(total_deaths) as highest_death_count_countries
from coviddeaths
where continent != ''
group by continent, location) as sub1
group by continent
order by 2 desc;

# looking at global numbers
select date, sum(new_cases) as daily_cases, sum(new_deaths) as daily_deaths, 
round(sum(new_deaths)/sum(new_cases)*100,2) as daily_death_percentage
from coviddeaths
where continent != ''
group by date
order by 1;

# looking at total population vs vaccinations
with sub2 as
(select a.continent, a.location, a.date, a.population, b.new_vaccinations, 
sum(b.new_vaccinations) over(partition by a.location order by a.location, a.date) as cumulative_vaccinations
from coviddeaths a left join covidvaccinations b on a.location=b.location and a.date=b.date
where a.continent != ''
order by 2,3)
select *, round(cumulative_vaccinations/population*100,2) as vaccination_percentage
from sub2
order by location, date;

# store data for later visualizations
create view vaccination_rate as
select a.continent, a.location, a.date, a.population, b.new_vaccinations, 
sum(b.new_vaccinations) over(partition by a.location order by a.location, a.date) as cumulative_vaccinations
from coviddeaths a left join covidvaccinations b on a.location=b.location and a.date=b.date
where a.continent != '';
