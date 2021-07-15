SELECT 
Location,
date, 
total_cases,
new_cases,
total_deaths,
population

from `noted-app-312422.demos.Covid_Deaths`

order by 1,2;

--Looking at Total Cases Vs Total Deaths
-- Shows likelihood of contracting covid in your country
SELECT 
Location,
date, 
total_cases,
round((total_deaths/total_cases)*100,2)||"%" as MuertesxCasos

from `noted-app-312422.demos.Covid_Deaths`
Where location like ('%Taiwan%')
order by 1,2

--Looking Total Cases Vs Population in Italy
;
SELECT 
Location,
date, 
total_cases,
population,
round((total_cases/population)*100,2)||"%" as PoblacionxCasos

from `noted-app-312422.demos.Covid_Deaths`
Where location like ('%Italy%')
order by 1,2;

-- Looking at countries with highest infection rate compare to populations

SELECT 
Location,
population,
Max(total_cases) as Casos_Totales,

Max(round((total_cases/population)*100,2))||"%" as Poblacion_Infectada

from `noted-app-312422.demos.Covid_Deaths`

Group by 1,2
order by Poblacion_Infectada desc;

--Showing Countries with highest death count per population



SELECT 
location,
Max(total_deaths) as Muertes_Totales,

--Max(round((total_deaths/population)*100,2))||"%" as Poblacion_Infectada

from `noted-app-312422.demos.Covid_Deaths`
where continent is null
Group by location
order by Muertes_Totales desc ;

--showing the continents with highest death per pop

SELECT 
continent,
Max(total_deaths) as Muertes_Totales,

--Max(round((total_deaths/population)*100,2))||"%" as Poblacion_Infectada

from `noted-app-312422.demos.Covid_Deaths`
where continent is not null
Group by continent
order by Muertes_Totales desc ;


--USE CTE
--Total population vs Vaccionation
--New Vaccinations per date. make a rolling count , addup
--WITH PopVsVac as (continent, Location, Date, population, new_vaccinations, Vac_per_Country, Rolling_Vac_per_Country)
 WITH PopVsVac as 
(
SELECT 
Dea.continent,
Dea.location,
Dea.date,
Dea.population,
Vac.new_vaccinations,
Sum(Cast(Vac.new_vaccinations as Int)) over (PARTITION BY Dea.location) as Vac_per_Country,
Sum(Cast(Vac.new_vaccinations as Int)) over (PARTITION BY Dea.location order by Dea.continent,Dea.date) as Rolling_Vac_per_Country
,

from `noted-app-312422.demos.Covid_Deaths` Dea
    join `noted-app-312422.demos.Covid_A` Vac
        on Dea.date=Vac.date and Dea.location=Vac.location
where Dea.continent is not null
and Dea.date >= '2021-01-01'
) 
Select 
*,
round((Rolling_Vac_per_Country/population)*100,2) as perc_Vaccinated
from PopVsVac
;

    

