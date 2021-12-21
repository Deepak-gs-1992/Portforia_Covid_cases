/*
Checking for the database - Nictsql
*/

show databases;
use nictsql;

/*
Start the table name : Tatol_cases_portfolia
*/

/*
select * from total_cases_portfolia
limit 10 ;
*/
 
 select * from total_cases_death_portfolia
 limit 10;
 
 select location, date, total_cases, new_cases, total_deaths, population
 from Total_cases_death_portfolia
 order by 1,2; 
 
 /*
 Total cases vs Total deaths
 Shows likelyhood at dying if you contray in country
 */
 
 select location, population, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
 from Total_cases_death_portfolia
 where location like '%state%'
 order by 1,2; 
 
  /*
 Looking at total cases vs population 
 Shows percentable populations
 */
 
 select location, date, total_cases, population,  
 (total_cases/population)*100 as DeathPercentage, (total_deaths/total_cases)*100 as DeathPercentage
 from Total_cases_death_portfolia
 /*where location like '%state%'*/
 order by 1,2; 
 
 
 /*
 Courtries with highest Infection rates
 */
 
 select location, population, max(total_cases), max(total_cases)/population*100 as Highest_percentage from Total_cases_death_portfolia
 group by location, population
 order by Highest_percentage desc;
 
 
 /*
 Highest death rates
 */
 
 select location,population,  max(total_deaths) as Max_death_rate
 from Total_cases_death_portfolia
 group by location, population
 order by Max_death_rate asc
 
 /*
Add continent with total cases
 */
select * from total_cases_death_portfolia
where continent is not null;
 
 
select location, population, total_cases, total_deaths, (total_deaths/total_cases)*100 as TotalDeaths
from Total_cases_death_portfolia
where continent is not null;


/*Need to check the cast in sql*/

select location, max(Total_deaths) as TotalDeathcount
from Total_cases_death_portfolia
/*where location like '%state%'*/
where continent is not null
group by location;


/*
Global numbers
*/


select date, sum(new_cases), sum(new_deaths), sum(new_cases-new_deaths)/sum(new_deaths)*100 from Total_cases_death_portfolia
where continent is not null
group by date
order by 1,2;

/*
Total_population versus Vaccinations
T.continents, T.location, T.date, T.population, T2.vaccinations
*/

select T.continent, T.location,T.date, T.population, T2.new_vaccinations,
sum(new_vaccinations) over (partition by Location order by location, date) as RollingVaccine from Total_cases_death_portfolia as T
join
Total_cases_portfolia as T2
on T.location=T2.location
and T.date=T2.date
where T.continent is not null
group by 1,2,3,4,5
order by 2,3
;

/*
Add a view Rolling views
*/

create view RollingPercentagePopulations as 
select T.continent, T.location,T.date, T.population, T2.new_vaccinations,
sum(new_vaccinations) over (partition by Location order by location, date) as RollingVaccine from Total_cases_death_portfolia as T
join
Total_cases_portfolia as T2
on T.location=T2.location
and T.date=T2.date
where T.continent is not null
group by 1,2,3,4,5
order by 2,3
;

/*
View is done in the SQL report*/
select * from rollingpercentagepopulations