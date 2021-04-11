--Basic Joins

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

-- Constest Leaderboard
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
