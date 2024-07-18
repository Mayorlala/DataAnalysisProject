SELECT * FROM Portfolio_Project_Covid..CovidDeaths$ order by 3,4;

-- SELECT * FROM Portfolio_Project_Covid..CovidVaccinations$ order by 3,4;

-- Data to be used 
Select location,date,total_cases,new_cases,total_deaths,population 
from Portfolio_Project_Covid..CovidDeaths$
order by location,date

-- Total Cases vs Total Deaths
Select location,date,total_cases,total_deaths,(total_deaths/total_cases) * 100 as DeathRate
from Portfolio_Project_Covid..CovidDeaths$
order by location,date

-- Let me check for Nigeria only
Select location,date,total_cases,total_deaths,(total_deaths/total_cases) * 100 as DeathRate
from Portfolio_Project_Covid..CovidDeaths$
where location like '%Nigeria%'
order by location,date

-- Total number of cases vs Location
-- Percentage of *Nigeria* Population that got Covid
Select location,date,total_cases,population,(total_deaths/population) * 100 as CovidRate
from Portfolio_Project_Covid..CovidDeaths$
--where location like '%Nigeria%'
order by location,date

-- Countries with highest infection rate 
Select location,MAX(total_cases) as HighestCaseCount,population,MAX((total_cases/population)) * 100 as InfectionRate
from Portfolio_Project_Covid..CovidDeaths$
--where location like '%Nigeria%'
group by location, population
order by InfectionRate desc

-- Countries with highest death rate
Select location,MAX(cast(total_deaths as int)) as TotalDeathCount
from Portfolio_Project_Covid..CovidDeaths$
--where location like '%Nigeria%'
where continent is not null
group by location, population
order by TotalDeathCount desc

-- Death Counts By Continent
Select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
from Portfolio_Project_Covid..CovidDeaths$
--where location like '%Nigeria%'
where continent is not null
group by continent
order by TotalDeathCount desc

-- Globally 
Select date,sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathRate
from Portfolio_Project_Covid..CovidDeaths$
-- where location like '%Nigeria%'
where continent is not null
group by date
order by 1,2

Select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathRate
from Portfolio_Project_Covid..CovidDeaths$
-- where location like '%Nigeria%'
where continent is not null
-- group by date
order by 1,2

-- Vaccination Ratio
select death.continent,death.location,death.date,death.population,vaccine.new_vaccinations,sum(cast(vaccine.new_vaccinations as int)) over 
(partition by death.location order by death.location,death.date) as AccumulatedPeopleVaccinated
from Portfolio_Project_Covid..CovidDeaths$ as death
join Portfolio_Project_Covid..CovidVaccinations$ as vaccine
on death.location = vaccine.location
and death.date = vaccine.date
where death.continent is not null
order by 2,3 

With PopvsVac (Continent,location,date,population,new_vaccinations,AccumulatedPeopleVaccinated)
as
(
select death.continent,death.location,death.date,death.population,vaccine.new_vaccinations,sum(cast(vaccine.new_vaccinations as int)) over 
(partition by death.location order by death.location,death.date) as AccumulatedPeopleVaccinated
from Portfolio_Project_Covid..CovidDeaths$ as death
join Portfolio_Project_Covid..CovidVaccinations$ as vaccine
on death.location = vaccine.location
and death.date = vaccine.date
where death.continent is not null
--order by 2,3 
)
select *,(AccumulatedPeopleVaccinated/population) * 100
from PopvsVac
-- USING CTE
With popvsVac

-- TEMP TABLE
drop table if exists #VaccinatedPopulation
create table #VaccinatedPopulation
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
AccumulatedPeopleVaccinated numeric
)
Insert into #VaccinatedPopulation
select death.continent,death.location,death.date,death.population,vaccine.new_vaccinations,sum(cast(vaccine.new_vaccinations as int)) over 
(partition by death.location order by death.location,death.date) as AccumulatedPeopleVaccinated
from Portfolio_Project_Covid..CovidDeaths$ as death
join Portfolio_Project_Covid..CovidVaccinations$ as vaccine
on death.location = vaccine.location
and death.date = vaccine.date
--where death.continent is not null
--order by 2,3

select *,(AccumulatedPeopleVaccinated/population) * 100
from #VaccinatedPopulation

-- Creating view to store data for visualization later
create view VaccinatedPopulation as 
select death.continent,death.location,death.date,death.population,vaccine.new_vaccinations,sum(cast(vaccine.new_vaccinations as int)) over 
(partition by death.location order by death.location,death.date) as AccumulatedPeopleVaccinated
from Portfolio_Project_Covid..CovidDeaths$ as death
join Portfolio_Project_Covid..CovidVaccinations$ as vaccine
on death.location = vaccine.location
and death.date = vaccine.date
where death.continent is not null
-- order by 2,3

select * from VaccinatedPopulation