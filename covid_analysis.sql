SELECT * FROM covid.covid_deaths;



-- compare total deaths to the number of cases 
-- this shows the likelihood of dying if you contract covid in your country
select location,date, total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage 
from covid_deaths
where location = 'Kenya'
order by location, date;

-- look at total cases vs population
-- shows the percentage of population that has contracted covid
select location,date, total_cases,population,(total_cases/population)*100 as percent_population_infected
from covid_deaths
--where location = 'Africa'
order by date;

-- Looking at countries with highest infection rate compared to population
select location, max(total_cases) as highest_infection_count, population,max((total_cases/population))*100 as percent_population_infected
from covid_deaths
-- where location = 'Africa'
group by location,population
order by percent_population_infected desc;

-- showing countries with highest death count per population
select location, max(total_deaths) as total_death_count
from covid_deaths
where continent is not null
group by location
order by total_death_count desc;

-- show death count per continent
select continent, max(total_deaths) as total_death_count
from covid_deaths
where continent is not null
group by continent
order by total_death_count desc;

-- looking at the numbers on a global scale

-- how was the covid infection recorded daily?
select date, sum(new_cases) as total_no_of_cases, sum(new_deaths) as total_number_of_deaths, (sum(new_deaths)/sum(new_cases))*100 as percent_death_of_cases
from covid_deaths
group by date;

-- what was the total infection and total deaths globally?
select sum(new_cases) as total_cases_globally, sum(new_deaths) as total_deaths_globally, (sum(new_deaths)/sum(new_cases))*100 as percent_death_of_cases
from covid_deaths;


-- having a look at the vaccinations recorded (total vaccination vs total population)
-- we will create a cte to perform the analysis on 

with cte as (
select cd.continent, cd.location, cd.date, cd.population ,cv.new_vaccinations , sum(cv.new_vaccinations) over (partition by cd.location order by cd.location, cd.date) total_vaccinations_done
from covid_deaths as cd
join covid_vaccinations as cv
on cd.location = cv.location
and cd.date = cv.date
where cd.continent is not null 
order by cd.location, cd.date)

select *, (total_vaccinations_done/population)*100 as rolling_perc_of_people_vaccinated from cte; 

-- create view for later visualisations
create view death_per_continent as
select continent, max(total_deaths) as total_death_count
from covid_deaths
where continent is not null
group by continent
order by total_death_count desc;

select * from death_per_continent;



 

