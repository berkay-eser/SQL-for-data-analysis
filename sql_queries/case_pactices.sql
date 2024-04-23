/*

    Categorize the salaries from each job postings. To see if it fits in
    desired salary range.
        - Put salary into different buckets.
        - Define what's a high, standart or low salary with our own conditions.
        - Only look at 'Data Analyst' roles.
        - Order from highest to lowest.

    Desired salary range:
        salary < 60000 = low
        60000 <= salary < 150000 = standart
        150000 <= salary = high
*/

SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
         WHEN salary_year_avg < 60000 THEN 'low'
         WHEN salary_year_avg BETWEEN 60000 AND 149999 THEN 'standart'
         WHEN salary_year_avg >= 150000 THEN 'high'
    END AS salary_range
FROM 
    job_postings_fact
WHERE
    (job_title_short = 'Data Analyst' OR 
    job_title_short = 'Senior Data Analyst') AND
    salary_year_avg IS NOT NULL
GROUP BY
    salary_range
ORDER BY
    number_of_jobs DESC;