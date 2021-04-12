--Joins

-- "Olivander's Inventory"
--  Write a query to print the id, age, coins_needed, and power of the wands that Ron's interested in, sorted in order of descending power. If more than one wand has same power, sort the result in order of descending age.

SELECT a.id, b.age, a.coins_needed, a.power
FROM wands as a
LEFT JOIN wands_property as b
ON a.code = b.code
WHERE b.is_evil = 0
AND a.coins_needed in (
    SELECT MIN(a1.coins_needed)
    FROM wands as a1
    JOIN wands_property as b1
    ON a1.code = b1.code
    WHERE a1.power = a.power
    AND b1.age = b.age)
ORDER BY a.power DESC, b.age DESC
;

-- "Challenges"
-- get hacker_id, name, and the total number of challenges created by each student. Sort your results by the total number of challenges in descending order. If more than one student created the same number of challenges, then sort the result by hacker_id. If more than one student created the same number of challenges and the count is less than the maximum number of challenges created, then exclude those students from the result.

SELECT a.hacker_id, b.name, COUNT(a.challenge_id)
FROM challenges a
LEFT JOIN hackers b
ON a.hacker_id = b.hacker_id
GROUP BY a.hacker_id, b.name
HAVING COUNT(a.challenge_id) = (
    SELECT TOP 1 COUNT(challenge_id)
    FROM challenges
    GROUP BY hacker_id
    ORDER BY COUNT(challenge_id) DESC)
OR COUNT(a.challenge_id) in (
    SELECT counts
    FROM(SELECT hacker_id, COUNT(challenge_id) as counts
        FROM challenges
        GROUP BY hacker_id)CountTbl
    GROUP BY counts
    HAVING COUNT(counts) = 1)
ORDER BY count(a.challenge_id) DESC, a.hacker_id
;

-- "Constest Leaderboard"
-- Write a query to print the hacker_id, name, and total score of the hackers ordered by the descending score. If more than one hacker achieved the same total score, then sort the result by ascending hacker_id. Exclude all hackers with a total score of 0 from your result.

SELECT BestTBl.hacker_id, b.name, SUM(BestTBl.best_score)
FROM (
    SELECT hacker_id, challenge_id, MAX(SCORE) as best_score
    FROM submissions
    GROUP BY hacker_id, challenge_id
    )BestTBl
JOIN hackers b
ON BestTBl.hacker_id = b.hacker_id
GROUP BY BestTBl.hacker_id, b.name
HAVING SUM(BestTBl.best_score) > 0
ORDER BY SUM(best_score) DESC, BestTBl.hacker_id
;

-- "SQL Project Planning"
-- Write a query to output the start and end dates of projects listed by the number of days it took to complete the project in ascending order. If there is more than one project that have the same number of completion days, then order by the start date of the project.

SELECT start_date, end_date
FROM
    (SELECT start_date, ROW_NUMBER() OVER (ORDER BY start_date) as idx
    FROM projects
    WHERE start_date NOT IN (
        SELECT end_date
        FROM projects))StartTbl
LEFT JOIN
    (SELECT end_date, ROW_NUMBER() OVER (ORDER BY end_date) as idx
    FROM projects
    WHERE end_date NOT IN (
        SELECT start_date
        FROM projects))EndTbl
ON StartTbl.idx = EndTbl.idx
ORDER BY DATEDIFF(d, start_date, end_date), start_date
;

-- "Placements"
-- Write a query to output the names of those students whose best friends got offered a higher salary than them. Names must be ordered by the salary amount offered to the best friends. It is guaranteed that no two students got same salary offer.

WITH names_null AS (
SELECT
CASE WHEN friend_salary > salary THEN name END as names,
friend_salary
FROM (
    SELECT a.id, a.name, c.salary as salary, b.friend_id, d.salary as friend_salary
    FROM students as a
    JOIN friends as b
    ON a.id = b.id
    JOIN packages as c
    ON a.id = c.id
    JOIN packages as d
    ON b.friend_id = d.id)Tbl)
SELECT names FROM names_null
WHERE names IS NOT NULL
ORDER BY friend_salary
;

-- "Symmetric Pairs"
-- You are given a table, Functions, containing two columns: X and Y. Two pairs (X1, Y1) and (X2, Y2) are said to be symmetric pairs if X1 = Y2 and X2 = Y1. Write a query to output all such symmetric pairs in ascending order by the value of X. List the rows such that X1 ≤ Y1.

SELECT a.x, a.y
FROM functions as a
INNER JOIN
functions as b
ON a.x = b.y
AND a.y = b.x
GROUP BY a.x, a.y
HAVING COUNT(*) > 1 OR a.x <a.y
ORDER BY a.x
;

-- "Interviews"
-- Samantha interviews many candidates from different colleges using coding challenges and contests. Write a query to print the contest_id, hacker_id, name, and the sums of total_submissions, total_accepted_submissions, total_views, and total_unique_views for each contest sorted by contest_id. Exclude the contest from the result if all four sums are 0 Note: A specific contest can be used to screen candidates at more than one college, but each college only holds 1 screening 

SELECT a.contest_id
    , a.hacker_id
    , a.name
    , SUM(total_submissions)
    , SUM(total_accepted_submissions)
    , SUM(total_views)
    , SUM(total_unique_views)
FROM contests as a
JOIN colleges as b
ON a.contest_id = b.contest_id
JOIN challenges as c
ON b.college_id = c.college_id
LEFT JOIN (
    SELECT challenge_id
        , SUM(total_submissions) as total_submissions
        , SUM(total_accepted_submissions) as total_accepted_submissions
    FROM submission_stats
    GROUP BT challenge_id) d
ON c.challenge_id = d.challenge_id
LEFT JOIN (
    SELECT challenge_id
        , SUM(total_views) as total_views
        , SUM(total_unique_views) as total_unique_views
    FROM views_stats
    GROUP BY challenge_id) e
ON c.challenge_id = e.challenge_id
GROUP BY a.contest_id
    , a.hacker_id
    , a.name
HAVING SUM(total_submissions) + SUM(total_accepted_submissions) + SUM(total_views) + SUM(total_unique_views) > 0
ORDER BY a.contest_id
;
