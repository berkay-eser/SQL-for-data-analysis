# Introduction
Fİrst of all, the data used for queries and project belongs to [Luke Barousse](https://github.com/lukebarousse). This is the [video](https://www.youtube.com/watch?v=7mz73uXD9DA) that guided me through this tutorial and project. You can also check this [link](https://www.lukebarousse.com/sql). This project explores top paying jobs, in demand skills and where high demand meets high salary in data analytics. The dataset also includes different job titles but this project  focuses on data analyst title. Check the [SQL queries](/project_sql/).

# Background
Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.

### The questions to answer through SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

However, if this is insufficient, more questions can be answered or information about different jobs can be analyzed.

# Tools

- **SQL:** The backbone of analysis, allowing to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code:** Used for database management and executing SQL queries.
- **Git & GitHub:** Essential for version control and sharing SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:

### 1. Top Paying Data Analyst Jobs

First 'job_postings_fact' and 'company_dim' tables joined then filtered data analyst positions by average yearly salary and locations. Also focused on remote jobs. This query show top 10 highest paying data analyst jobs.

```sql
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
```
Here's the breakdown of the top data analyst jobs in 2023:
- **Wide Salary Range:** Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.
- **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.
- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.

### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, the job postings joined with the skills data, providing insights into what employers value for high-compensation roles.

```sql
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
```
Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:
- **SQL** is leading with a count of 8.
- **Python** follows closely with a count of 7.
- **Tableau** is also highly sought after, with a count of 6.
- Other skills like **R**, **Snowflake**, **Pandas**, and **Excel** show varying degrees of demand.

### 3. In-Demand Skills for Data Analysts

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT
    skills_dim.skills AS skill,
    COUNT(job_postings_fact.job_id) AS number_of_demand
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON 
    job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON
    skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    (job_postings_fact.job_title_short = 'Data Analyst' OR
    job_postings_fact.job_title_short = 'Senior Data Analyst') AND
    job_postings_fact.job_work_from_home = TRUE
GROUP BY
    skill
ORDER BY
    number_of_demand DESC
LIMIT 5;
```

Here's the breakdown of the most demanded skills for data analysts in 2023
- **SQL** and **Excel** remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
- **Programming** and **Visualization Tools** like **Python**, **Tableau**, and **Power BI** are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.

| Skills   | Demand Count |
|----------|--------------|
| SQL      | 9015         |
| Excel    | 5384         |
| Python   | 5311         |
| Tableau  | 4744         |
| Power BI | 3070         |

*Table of the demand for the top 5 skills in data analyst job postings*

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
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
ORDER BY
    average_salary DESC
LIMIT 20;
```

Here's a breakdown of the results for top paying skills for Data Analysts:
- **High Demand for Big Data & ML Skills:** Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modeling capabilities.
- **Software Development & Deployment Proficiency:** Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.
- **Cloud Computing Expertise:** Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics.

| Skills        | Average Salary ($) |
|---------------|-------------------:|
| pyspark       |            208,172 |
| bitbucket     |            189,155 |
| couchbase     |            160,515 |
| watson        |            160,515 |
| datarobot     |            155,486 |
| gitlab        |            154,500 |
| swift         |            153,750 |
| jupyter       |            152,777 |
| pandas        |            151,821 |
| elasticsearch |            145,000 |

*Table of the average salary for the top 10 paying skills for data analysts*

### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
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
```

| Skills     | Demand Count | Average Salary ($) |
|------------|--------------|-------------------:|
| pandas     | 13           |            146,476 |
| databricks | 18           |            135,379 |
| go         | 40           |            118,777 |
| snowflake  | 63           |            115,615 |
| c          | 17           |            115,614 |
| hadoop     | 26           |            115,240 |
| bigquery   | 20           |            115,240 |
| azure      | 41           |            113,543 |
| java       | 21           |            113,129 |
| aws        | 38           |            112,958 |

*Table of the most optimal skills for data analyst sorted by salary*

# What I Learned

- **SQL SKills:** I learned simple and advanced techniques about SQL by writing many SQL queries.
- **Data Aggregation:** During this project, I gained valuable experience in aggregating data using SQL to extract meaningful insights.
- **Problem-Solving Skills:** Leveled up my real-world skills, turning questions into actionable, insightful SQL queries.

# Conclusions

### Insights
From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
2. **Skills for Top-Paying Jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
3. **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value**: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

### Closing Thoughts

This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.