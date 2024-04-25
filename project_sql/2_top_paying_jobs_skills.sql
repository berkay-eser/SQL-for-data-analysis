/*

    Question: What skills are required for the top-paying data analyst jobs?
    
    - Use the top 10 highest-paying Data Analyst jobs from first query.
    - Add the specific skills required for these roles.
    - Why? It provides a detailed look at which high-paying jobs demand certain skills,
    helping job seekers understand which skills to develop that align with top salaries.

*/

WITH top_10_jobs AS (
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
    LIMIT 10
)

SELECT 
    top_10_jobs.company_name,
    top_10_jobs.job,
    skills_dim.skills AS skill,
    top_10_jobs.salary
FROM 
    skills_job_dim
INNER JOIN top_10_jobs ON
    top_10_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON
    skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
    top_10_jobs.salary DESC;

/*

    Here's the breakdown of the most demanded skills for data analysts in 2023, based on job postings:
    - SQL is leading with a bold count of 8.
    - Python follows closely with a bold count of 7.
    - Tableau is also highly sought after, with a bold count of 6.
    - Other skills like R, Snowflake, Pandas, and Excel show varying degrees of demand.

*/