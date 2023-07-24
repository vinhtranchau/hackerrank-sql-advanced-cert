WITH RankedScores AS (
    SELECT 
        event_id, 
        participant_name,
        DENSE_RANK () OVER (
            PARTITION BY event_id 
            ORDER BY MAX(score) DESC
        ) score_rank
    FROM scoretable
    GROUP BY event_id, participant_name
),

RankNames AS (
    SELECT 
        event_id, 
        score_rank,
        GROUP_CONCAT(participant_name ORDER BY participant_name ASC SEPARATOR ',') AS names
    FROM RankedScores
GROUP BY event_id, score_rank)
  
SELECT 
    e.event_id,
    COALESCE(MAX(CASE WHEN r.score_rank = 1 THEN r.names END), '') as rank_1_names,
    COALESCE(MAX(CASE WHEN r.score_rank = 2 THEN r.names END), '') as rank_2_names,
    COALESCE(MAX(CASE WHEN r.score_rank = 3 THEN r.names END), '') as rank_3_names
FROM (SELECT DISTINCT event_id FROM scoretable) e 
LEFT JOIN RankNames r ON e.event_id = r.event_id
GROUP BY e.event_id
ORDER BY e.event_id;
