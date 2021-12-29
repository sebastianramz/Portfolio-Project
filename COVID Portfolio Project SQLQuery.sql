select *
from [Portfolio Project]..['CovidDeaths-SQL$']
where continent is not null
order by 3,4

--select *
--from [Portfolio Project]..['CovidVaccinations-SQL$']
--order by 3,4

-- Select Data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from [Portfolio Project]..['CovidDeaths-SQL$']
where continent is not null
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your United States

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [Portfolio Project]..['CovidDeaths-SQL$']
where location like '%states%' and continent is not null
order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got COVID

select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
from [Portfolio Project]..['CovidDeaths-SQL$']
--where location like '%states%'
where continent is not null
order by 1,2

-- Look at Countries with Highest Infection Rate compared to Population

select location, population,  MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from [Portfolio Project]..['CovidDeaths-SQL$']
--where location like '%states%'
Group by Location, population
order by PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project]..['CovidDeaths-SQL$']
--where location like '%states%'
where continent is not NULL
Group by Location
order by TotalDeathCount desc

-- Showing Continents with the highest death rates per population

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project]..['CovidDeaths-SQL$']
--where location like '%states%'
where continent is not NULL
Group by continent
order by TotalDeathCount desc

-- Global Numbers
select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
	SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from [Portfolio Project]..['CovidDeaths-SQL$']
--where location like '%states%' and continent is not null
where continent is not null
--group by date
order by 1,2

-- Looking at Total Population vs Vaccinations

-- Use CTE

With PopvsVac (continent, location, date, population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from [Portfolio Project]..['CovidDeaths-SQL$'] dea
join [Portfolio Project]..['CovidVaccinations-SQL$'] vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not NULL
--Order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac

-- Temp Table

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from [Portfolio Project]..['CovidDeaths-SQL$'] dea
join [Portfolio Project]..['CovidVaccinations-SQL$'] vac
	on dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is not NULL
--Order by 2,3

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated

-- Creating View to store data for later visualizations

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from [Portfolio Project]..['CovidDeaths-SQL$'] dea
join [Portfolio Project]..['CovidVaccinations-SQL$'] vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not NULL
--Order by 2,3

select *
from PercentPopulationVaccinated