-- check details for cause and time of death --
SELECT *
FROM forensic_events_large
ORDER BY event_time;
GO

--Checking relation to victim and the number--
SELECT 
		relation_to_victim, 
		count (*) As 'count'
FROM suspects_large
GROUP BY relation_to_victim
ORDER BY count;
GO

--Rivals--
SELECT * FROM suspects_large
WHERE relation_to_victim = 'Rival';
GO

--Checking alibis and movements of rivals
SELECT 
		s.suspect_id, 
		name, 
		role, 
		relation_to_victim, 
		alibi, 
		access_time, 
		door_accessed, 
		success_flag
FROM suspects_large s
left join access_logs_large a
ON s.suspect_id = a.suspect_id
WHERE (access_time BETWEEN '2025-06-01 19:50:00' AND '2025-06-01 20:05:00') AND relation_to_victim = 'Rival' AND success_flag = 1
ORDER BY name, access_time;
GO

--First Suspect VICTOR SHAW--

--Checking alibis and movements of business partners
SELECT 
		s.suspect_id, 
		name, 
		role, 
		relation_to_victim, 
		alibi, 
		access_time, 
		door_accessed, 
		success_flag
FROM suspects_large s
join access_logs_large a
ON s.suspect_id = a.suspect_id
WHERE (access_time BETWEEN '2025-06-01 19:50:00' AND '2025-06-01 20:05:00') AND relation_to_victim = 'business partner' AND success_flag = 1
ORDER BY name, access_time;
GO

--Checking alibis and movements of former partner
SELECT 
		s.suspect_id, 
		name, 
		role, 
		relation_to_victim, 
		alibi, 
		access_time, 
		door_accessed, 
		success_flag
FROM suspects_large s
JOIN access_logs_large a
ON s.suspect_id = a.suspect_id
WHERE (access_time BETWEEN '2025-06-01 19:50:00' AND '2025-06-01 20:05:00') AND relation_to_victim = 'Former partner' AND success_flag = 1
ORDER BY name, access_time;
GO

--Second suspect ROBIN AHMED--

--Checking alibis and movements of staff
SELECT 
		s.suspect_id, 
		name, 
		role, 
		relation_to_victim, 
		alibi, access_time, 
		door_accessed, 
		success_flag
FROM suspects_large s
JOIN access_logs_large a
ON s.suspect_id = a.suspect_id
WHERE (access_time BETWEEN '2025-06-01 19:50:00' AND '2025-06-01 20:05:00') AND relation_to_victim = 'Staff' AND success_flag = 1
ORDER BY name, access_time;
GO

--Checking alibis and movements of others
SELECT 
		s.suspect_id, 
		name, 
		role, 
		relation_to_victim, 
		alibi, access_time, 
		door_accessed, 
        success_flag
FROM suspects_large s
JOIN access_logs_large a
ON s.suspect_id = a.suspect_id
WHERE (access_time BETWEEN '2025-06-01 19:50:00' AND '2025-06-01 20:05:00') AND relation_to_victim IN ('Investor', 'Stranger', 'Guest', 'Friend', 'Relative')
AND success_flag = 1
ORDER BY name, access_time;
GO

--Everyone here checks out--

/*Forensics Analysis
Who last saw the victim alive at 7:57pm?
*/
SELECT 
		s.suspect_id, 
		name,
		role, 
		relation_to_victim, 
		alibi, access_time, 
		door_accessed, 
		success_flag
FROM suspects_large s
JOIN access_logs_large a
ON s.suspect_id = a.suspect_id
WHERE (access_time BETWEEN '2025-06-01 19:56:00' AND '2025-06-01 19:59:00')
ORDER BY name, access_time;
GO

--Robin Ahmed was the last person to see the victim alive--

--Gunshot at 8pm
--CHecking for movements between 7:59 and 8:02
SELECT 
		s.suspect_id, 
		name, 
		role, 
		relation_to_victim, 
		alibi, access_time, 
		door_accessed, 
		success_flag
FROM suspects_large s
JOIN access_logs_large a
ON s.suspect_id = a.suspect_id
WHERE (access_time BETWEEN '2025-06-01 19:59:00' AND '2025-06-01 20:02:00')
ORDER BY name, access_time;
GO

--Jamie Bennett—

--CHecking for calls shortly before and after the gunshot--
SELECT 
		s.name, 
		role, 
		relation_to_victim, 
		recipient_relation, 
		call_time, 
		call_duration
FROM suspects_large s
JOIN call_records_large c
ON s.suspect_id = c.suspect_id
WHERE call_time BETWEEN '2025-06-01 19:58:04' AND '2025-06-01 20:02:00';
GO


--Alex Shaw made a call seconds after the shooting

/*Security feed cut at 8:03
Checking movements around the office at the time
*/
SELECT 
		s.suspect_id, 
		name, 
		role, 
		relation_to_victim, 
		alibi, 
		access_time, 
		door_accessed, 
		success_flag
FROM suspects_large s
JOIN access_logs_large a
ON s.suspect_id = a.suspect_id
WHERE (access_time BETWEEN '2025-06-01 20:00:00' AND '2025-06-01 20:03:00') AND door_accessed = 'Office'
ORDER BY name, access_time;
GO

--Susan knight 

/* An emergency call was placed from the mansion at 8:05:45
Check who made the call
*/

SELECT 
		s.name, 
		role, 
		relation_to_victim, 
		call_time, 
		recipient_relation
FROM suspects_large s
JOIN call_records_large c
ON s.suspect_id = c.suspect_id
WHERE call_time BETWEEN '2025-06-01 20:04:00' AND '2025-06-01 20:06:00';
GO

--None of the suspects made the call or the record isn't shown on the call logs

--Was anyone in the vault room shortly before or after the murder?--
SELECT 
		s.name, 
		s.relation_to_victim, 
		s.alibi, 
		door_accessed,
		access_time,
		success_flag
FROM suspects_large s
JOIN access_logs_large a
ON s.suspect_id = a.suspect_id
WHERE (door_accessed ='Vault room' AND success_flag = 1) AND access_time BETWEEN '2025-06-01 19:55:00' AND '2025-06-01 20:05:00'
ORDER BY name, access_time DESC;
GO
--Victor shaw, Robin Ahmed & Jamie Bennette


-- inconsistencies between access logs and alibi claims
SELECT 
		s.name, 
		s.relation_to_victim, 
		s.alibi, 
		door_accessed,
		access_time,
		success_flag
from suspects_large s
JOIN access_logs_large a
ON s.suspect_id = a.suspect_id
WHERE success_flag = 1
ORDER BY name, access_time;
GO

--Last call to victim was by Susan Knight--

SELECT 
s.name, 
alibi, 
c.call_time, 
recipient_relation
FROM suspects_large s
JOIN call_records_large c
ON s.suspect_id = c.suspect_id
WHERE recipient_relation = 'Victim'
ORDER BY call_time;
GO

--Top suspects- Victor Shaw, Robin Ahmed & Jamie Bennette and Susan Knight

--Culprits--
SELECT * FROM suspects_large
WHERE suspect_id in ( 7, 17, 27, 28)
