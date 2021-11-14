SELECT * FROM PortfolioProjects..CowidDeaths
WHERE continent is not null
order by 3,4

--SELECT * FROM PortfolioProjects..CowidVaccinations
--order by 3,4

--SELECT that Data we are going to use 

SELECT Location, date, total_cases, new_cases total_deaths, population FROM PortfolioProjects..CowidDeaths
order by 1,2

--Looking at total cases vs total deaths
--Shows the likelihood of people dying due to covid in india

SELECT Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage FROM PortfolioProjects..CowidDeaths
WHERE location like '%india%'
order by 1,2




--Looking at the total cases vs Population 
--This will show us the percentage of people who got covid in india 

SELECT Location, date,population,total_cases, (total_cases/population)*100 as DeathPercentage FROM PortfolioProjects..CowidDeaths
--WHERE location like '%india%'
order by 1,2

--Looking at countries with highest infection rate compared to population

SELECT Location,population,MAX(total_cases) as HighestInfectionRate, MAX((total_cases/population))*100 as PercentagePopulationInfected FROM PortfolioProjects..CowidDeaths
--WHERE location like '%india%'
Group by Location,population
order by PercentagePopulationInfected desc

--Showing the countries with the highest death count per population 


SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathRate
FROM PortfolioProjects..CowidDeaths
--WHERE location like '%india%'
Where continent is not null
Group by Location
order by TotalDeathRate desc



-- By Continent

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathRate
FROM PortfolioProjects..CowidDeaths
--WHERE location like '%india%'
Where continent is not null
Group by continent
order by TotalDeathRate desc

--Total Population vs Total Vaccinations

SELECT dea.continent, dea.date, dea.location, dea.population, vac.new_vaccinations
FROM PortfolioProjects..CowidDeaths dea
Join PortfolioProjects..CowidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
	 where dea.continent is not null
	 order by 2,3

--END

