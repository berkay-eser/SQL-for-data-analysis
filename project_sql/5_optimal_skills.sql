/*
    Question: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill)?
    - Identify skills in high demand and associated with high average salaries for Data Analyst roles
    - Concentrates on remote positions with specified salaries
    - Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), 
    offering strategic insights for career development in data analysis
*/

WITH skills_demand_and_salary AS (
    SELECT
        skills_dim.skills AS skill,
        COUNT(job_postings_fact.job_id) AS number_of_demand,
        ROUND(AVG(job_postings_fact.salary_year_avg)) AS average_salary
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim ON 
        job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON
        skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        (job_postings_fact.job_title_short = 'Data Analyst' OR
        job_postings_fact.job_title_short = 'Senior Data Analyst') AND
        job_postings_fact.job_work_from_home = TRUE AND
        job_postings_fact.salary_year_avg IS NOT NULL
    GROUP BY
        skill
)

SELECT * FROM skills_demand_and_salary
WHERE
    number_of_demand > 10
ORDER BY
    average_salary DESC,
    number_of_demand DESC
LIMIT 25;

