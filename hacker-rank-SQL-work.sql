--Basic Joins

-- "Challenges"
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