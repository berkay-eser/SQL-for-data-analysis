/*
    
    PRACTICE 1

    Write a query to find the average salary both yearly (salary_year_avg)and hourly
    (salary_hour_avg) for jobs that were posted after June 1, 2023. Group the results by
    job schedule type.

*/

SELECT
    job_schedule_type,
    AVG(salary_year_avg) AS avg_salary_yearly,
    AVG(salary_hour_avg) AS avg_salary_hourly
    
FROM job_postings_fact
WHERE job_posted_date > '2023-06-01'
GROUP BY job_schedule_type

/*

    PRACTICE 2

    Write a query to count  the number  of job postings for each month in 2023, adjusting the
    job_posted_date to be 'America/New York' time zone before extracting (hint) the mount.
    Assume the job_posted_date is stored in UTC. Group by and order by the month.

*/

SELECT
    EXTRACT(MONTH FROM job_posted_date) as date_month,
    COUNT(*) AS number_of_postings
FROM
    job_postings_fact
GROUP BY
    date_month
ORDER BY
    date_month;

/*

    PRACTICE 3

    Write a query to find companies (include company name) that have posted jobs offering health insurance(BOOLEAN),
    where these posting were made in the second quarter of 2023. Use date extraction to filter by quarter.

*/

SELECT
    job_postings_fact.company_id,
    company_dim.name AS company_name,
    job_postings_fact.job_health_insurance
    
FROM
    job_postings_fact
LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_postings_fact.job_health_insurance = TRUE AND
    EXTRACT(QUARTER FROM job_postings_fact.job_posted_date) = 2
GROUP BY
    job_postings_fact.company_id, company_name, job_postings_fact.job_health_insurance
ORDER BY
    job_postings_fact.company_id ASC;

/*

    FINAL PRACTICE 

    - Create three tables:
        * Jan 2023 jobs
        * Feb 2023 jobs
        * Mar 2023 jobs
    --- FORESHADOWING: This will be used in another practice problem below. ---
*/

CREATE TABLE january_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

