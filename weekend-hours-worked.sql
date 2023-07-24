SELECT 
  emp_id,
  SUM(
    TIMESTAMPDIFF(HOUR, 
      CASE WHEN DATE_ADD(log_out_time, INTERVAL -1 HOUR) > log_in_time 
        THEN log_in_time 
        ELSE DATE_ADD(log_out_time, INTERVAL -1 HOUR)
      END,
      log_out_time
    )
  ) AS weekend_hours
FROM (
  SELECT 
    emp_id,
    MIN(timestamp) as log_in_time,
    MAX(timestamp) as log_out_time
  FROM attendance   
  WHERE WEEKDAY(timestamp) IN (5, 6) -- 5 & 6 are for Saturday and Sunday.
  GROUP BY DATE(timestamp), emp_id
) as T
GROUP BY emp_id
ORDER BY weekend_hours DESC;
