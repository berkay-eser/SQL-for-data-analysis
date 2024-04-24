-- Subqueries and CTEs: Technically, this is a 'temporary result set' and NOT a 'temporary table'.

/*

    Find the companies that have the most job openings.
        - Get the total number of job postings per company id (job_posting_fact)
        - Return the total number of jobs with  the company name (company_dim)

*/

WITH company_job_count AS (
    SELECT 
        company_id,
        COUNT(*) AS total_jobs
    FROM 
        job_postings_fact
    GROUP BY 
        company_id
)

SELECT 
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM 
    company_dim
LEFT JOIN company_job_count ON
    company_dim.company_id = company_job_count.company_id
ORDER BY
    company_job_count.total_jobs DESC;


/*

    Identify the top 5 skills that are most frequently mentioned in remote job postings.
    Use a subquery to find the skill IDs with the highest counts in the skills_job_dim 
    table and then join this result with the skills_dim table to get the skill names.

*/

WITH remote_job_skills AS (
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim
    INNER JOIN job_postings_fact ON 
        job_postings_fact.job_id = skills_job_dim.job_id
    WHERE
        job_postings_fact.job_work_from_home = TRUE AND
        job_postings_fact.job_title_short = 'Data Analyst'
    GROUP BY
        skill_id
)

SELECT
    remote_job_skills.skill_id,
    skills_dim.skills AS skill_name,
    remote_job_skills.skill_count
FROM remote_job_skills
INNER JOIN skills_dim ON skills_dim.skill_id = remote_job_skills.skill_id
ORDER BY
    remote_job_skills.skill_count DESC
LIMIT 5;

/*

    Determine the size category(small, medium or large) for each company by first identifying
    the number of job postings they have. Use a subquery to calculate the total job postings
    per company. A company is considered 'small' if it has less than 10 job postings. 'medium'
    if the number of job postings is between 10 and 50, and 'large' if it has more than 50
    job postings. Implement a subquery to aggregate job counts per company before classifying
    them based on size.

*/

SELECT 
    company_name,
    total_jobs,
    CASE
        WHEN total_jobs < 10 THEN 'small'
        WHEN total_jobs BETWEEN 10 AND 50 THEN 'medium'
        WHEN total_jobs > 50 THEN 'large'
    END AS company_size
FROM (
    SELECT
        company_dim.name AS company_name,
        COUNT(*) AS total_jobs
    FROM
        job_postings_fact
    INNER JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    GROUP BY
        company_name
);