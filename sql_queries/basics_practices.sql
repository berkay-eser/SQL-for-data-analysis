/*

    PRACTICE 1

    Get the unique (distinct) job location in the job_posting_fact table. Order in alphabetical
    order (ascending order).

*/

SELECT DISTINCT job_location
FROM job_postings_fact
ORDER BY job_location ASC;

/*

    PRACTICE 2

    In the job_posting_fact table get the columns job_id, job_title_short, job_location,
    and job_via columns. And order it in ascending order by job_location.

*/

SELECT job_id, job_title_short, job_location, job_via
FROM job_postings_fact
ORDER BY job_location ASC;

/*

    PRACTICE 3

    In the job_posting_fact table get the columns job_id, job_title_short, job_location,
    job_via and salary_year_avg columns. And only look at rows where job_title_short is 'Data Engineer'.

*/

SELECT job_id, job_title_short, job_location, job_via, salary_year_avg
FROM job_postings_fact
WHERE job_title_short = 'Data Engineer';


/*

    PRACTICE 4

    In the job_posting_fact table only get jobs that have an average yearly salary $65,000 or greater. Also
    get the job_id, job_title_short, job_location, job_via and salary_year_avg columns.

*/

SELECT job_id, job_title_short, job_location, job_via, salary_year_avg
FROM job_postings_fact
WHERE salary_year_avg >= 65000
ORDER BY salary_year_avg ASC;

/*

    PRACTICE 5

    In the job_posting_fact table only get jobs that have an average yearly salary $55,000. Also
    get the job_id, job_title_short, job_location, job_via and salary_year_avg columns.

*/

SELECT job_id, job_title_short, job_location, job_via, salary_year_avg
FROM job_postings_fact
WHERE salary_year_avg > 55000
ORDER BY salary_year_avg ASC;

/*

    FINAL PRACTICE 1

    - Get job details for both 'Data Analyst' or 'Business Analyst' positions
        * For Data Analyst get jobs > $100K
        * For Business Analyst get jobs > $70K
    - Only include jobs located in either:
        * 'Boston, MA'
        * 'Anywhere'

*/

SELECT job_title_short, job_location, salary_year_avg
FROM job_postings_fact
WHERE
    (
        (job_title_short = 'Data Analyst' AND salary_year_avg > 100000) OR
        (job_title_short = 'Business Analyst' AND salary_year_avg > 70000)
    ) AND
    job_location IN ('Boston, MA', 'Anywhere') 

ORDER BY salary_year_avg ASC;

/*

    PRACTICE 6

    In the company_dim table find all company names that include 'Tech' immediately followed by
    any single character. Return the name column.

*/

SELECT name FROM company_dim
WHERE name LIKE '%Tech%';

/*

    PRACTICE 7

    Find all job postings int he job_postings_fact where the job title is exactly 'Engineer' and 
    one character followed after the term. Get the job_id, job_title and job_posted_date.

*/

SELECT job_id, job_title, job_posted_date
FROM job_postings_fact
WHERE job_title LIKE 'Engineer_';

/*
    FINAL PRACTICE 2

    - Look for non-senior data analyst or business analyst roles
    - Get the job title, location and average yearly salary

*/

SELECT job_title, job_location, salary_year_avg
FROM job_postings_fact
WHERE 
    (job_title LIKE '%Data%' OR job_title LIKE '%Business%') AND
    job_title LIKE '%Analyst%' AND
    job_title NOT LIKE '%Senior%';

/*

    PRACTICE 8

    In the job_posting_fact table calculate the total sum of the salary_year_avg
    for all job posting that are marked as fully remote (job_work_from_home is TRUE)
    and divide it by the total count of salary_year_avg to get the total average yearly
    salary for fully remote jobs. Ensure to only include job postings where a yearly
    salary is not NULL.

*/

SELECT 
    SUM(salary_year_avg) / COUNT(salary_year_avg) AS total_avg_yearly_salary
FROM job_postings_fact
WHERE 
    job_work_from_home = TRUE AND
    salary_year_avg IS NOT NULL; 

/*

    PRACTICE 9

    In the job_posting_fact table count the total number of jobs postings that offer health
    insurance. (job_health_insurance = TRUE)

*/

SELECT
    COUNT(*) as total_health_insurance_jobs
FROM job_postings_fact
WHERE job_health_insurance = TRUE;

/*

    PRACTICE 10

    In the job_posting_fact table count the number of job postings avaible for each country.
    Use the job_country column to group the job postings, and count the number of job postings (job_id)
    within each country group.

*/

SELECT COUNT(job_id) AS total_avaible_job_post, job_country
FROM job_postings_fact
GROUP BY job_country
ORDER BY total_avaible_job_post DESC;

/*

    PRACTICE 11

    We are going to check that all skills that do not have a category assigned to it. This can be useful
    for validating data. So, get all skills from the skills_dim table that don't have a type classification(other?) 
    assigned to them. Return the skills_id and skills.

*/

SELECT
    skill_id, skills
FROM 
    skills_dim
WHERE
    type='other';

/*

    PRACTICE 12

    Identify all job postings that have neither an annual average salary nor an hourly average salary
    int he job_postings_fact table. Return the job_id, job_title, salary_year_avg, salary_hour_avg. 
    This can be useful to look at postings where there is no compensation. 

*/

SELECT job_id, job_title, salary_year_avg, salary_hour_avg
FROM job_postings_fact
WHERE
    salary_hour_avg IS NULL AND 
    salary_year_avg IS NULL;

/*

    PRACTICE 13

    Retrieve the list of job titles(job_title) and the corresponding company names(name) for all
    job postings that mention 'Data Scientist' in the job title. Use the job_posting_fact and 
    company_dim tables for this query.

*/

SELECT
    job_postings.job_title,
    job_postings.company_id,
    companies.name AS company_name
FROM
    job_postings_fact AS job_postings
LEFT JOIN company_dim AS companies
    ON job_postings.company_id = companies.company_id
WHERE
    job_postings.job_title LIKE '%Data Scientist%';

/*

    PRACTICE 14

    Fetch all job postings, including their job titles(job_title)  and the names of the skills required
    (skills) even if no skills  are listed for a job. Ensure that the job is located in 'New York' and 
    offers 'Health Insurance'. Use the job_posting_fact, skills_job_dim and skills_dim tables.

*/

SELECT
    job_postings_fact.job_title,
    job_postings_fact.job_location,
    job_postings_fact.job_health_insurance,
    skills_dim.skills
FROM
    job_postings_fact
INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_health_insurance = TRUE AND
    job_postings_fact.job_location = 'New York, NY'

/*

    FINAL PRACTICE 3

    Find the average salary and number of job postings for each skill.

*/

SELECT
    skills_dim.skills AS skill_name,
    COUNT(job_postings_fact.job_id) AS number_of_job,
    SUM(job_postings_fact.salary_year_avg) / COUNT(job_postings_fact.salary_year_avg) AS avg_yearly_salary
FROM
    job_postings_fact
LEFT JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
    skill_name
