/*

    Question: What are the top-paying jobs for the given role?
    
    - Identify the top 10 highest-paying Data Analyst roles that are avaible remotely.
    - Focuses on job postings with specified salaries(remove nulls).
    - Why? Highlight the top-paying oppurtunities for Data Analyst, offering insights into employment options.
    - BONUS: Include company names.

*/

SELECT
    job_postings_fact.job_id,
    company_dim.name AS company_name,
    job_postings_fact.job_title AS job,
    job_postings_fact.job_schedule_type AS schedule,
    job_postings_fact.salary_year_avg AS salary
FROM
    job_postings_fact
LEFT JOIN company_dim 
    ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary DESC
LIMIT 10;