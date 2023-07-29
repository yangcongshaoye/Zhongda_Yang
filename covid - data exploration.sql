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
