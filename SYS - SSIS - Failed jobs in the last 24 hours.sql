USE [PRD_ActiveOps_Central]
GO
/****** Object:  StoredProcedure [dbo].[GetSSISJobFailures]    Script Date: 22/08/2017 18:30:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[GetSSISJobFailures]
AS
BEGIN

--Jobs that have failed in last 24 hours from executing this script

SELECT
	j.name AS [Job Name]
	, jh.server AS [Cluster]
	, CASE
		WHEN jh.run_status = 0 THEN 'FAILED'
		ELSE 'CANCELLED'
	END AS [Job Status]
	, jh.run_date AS [Run Date]
	, msdb.dbo.agent_datetime(jh.run_date, jh.run_time) AS [Execution Time]
FROM msdb.dbo.sysjobs j
	INNER JOIN msdb.dbo.sysjobsteps AS js ON js.job_id = j.job_id
	INNER JOIN msdb.dbo.sysjobhistory AS jh ON jh.job_id = j.job_id 
WHERE jh.run_status IN (0,3)
	AND DATEDIFF(hour, msdb.dbo.agent_datetime(jh.run_date, jh.run_time), GETDATE()) < 24
	AND j.name LIKE 'PRD%'
GROUP BY
	j.name
	, jh.server
	, CASE WHEN jh.run_status = 0 THEN 'FAILED' ELSE 'CANCELLED' END
	, jh.run_date
	, msdb.dbo.agent_datetime(jh.run_date, jh.run_time)

UNION

SELECT
	j.name AS [Job Name]
	, jh.server AS [Cluster]
	, CASE
		WHEN jh.run_status = 0 THEN 'FAILED'
		ELSE 'CANCELLED'
	END AS [Job Status]
	, jh.run_date AS [Run Date]
	, msdb.dbo.agent_datetime(jh.run_date, jh.run_time) AS [Execution Time]
FROM [UK-PRD-SCL-0002\INST0021].msdb.dbo.sysjobs j
	INNER JOIN [UK-PRD-SCL-0002\INST0021].msdb.dbo.sysjobsteps AS js ON js.job_id = j.job_id
	INNER JOIN [UK-PRD-SCL-0002\INST0021].msdb.dbo.sysjobhistory AS jh ON jh.job_id = j.job_id 
WHERE jh.run_status IN (0,3)
	AND DATEDIFF(hour, msdb.dbo.agent_datetime(jh.run_date, jh.run_time), GETDATE()) < 24
	AND j.name LIKE 'PRD%'
GROUP BY
	j.name
	, jh.server
	, CASE WHEN jh.run_status = 0 THEN 'FAILED' ELSE 'CANCELLED' END
	, jh.run_date
	, msdb.dbo.agent_datetime(jh.run_date, jh.run_time)

END