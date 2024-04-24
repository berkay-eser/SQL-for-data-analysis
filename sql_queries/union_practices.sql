/*

    - Get the corresponding skill and skill type for each job postings in first quarter(January, February, March)
    - Includes those without any skills too
    - Look at the skills and the type for each job in the first quarter that has a salary > $70,000

*/

WITH quarter_job_postings AS (
    SELECT 
        job_id, 
        job_title_short, 
        salary_year_avg
    FROM (
        SELECT * FROM january_jobs
        UNION ALL
        SELECT * FROM february_jobs
        UNION ALL
        SELECT * FROM march_jobs
    )
    WHERE
        salary_year_avg > 70000 AND
        salary_year_avg IS NOT NULL
)

SELECT
    skills_job_dim.job_id,
    skills_dim.skills AS skill,
    quarter_job_postings.salary_year_avg
FROM 
    skills_job_dim
LEFT JOIN quarter_job_postings ON 
    skills_job_dim.job_id = quarter_job_postings.job_id
LEFT JOIN skills_dim ON
    skills_job_dim.skill_id = skills_dim.skill_id

