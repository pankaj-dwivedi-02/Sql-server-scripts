DECLARE @counter1 int
DECLARE @counter2 int
DECLARE @name VARCHAR(50) -- db name  
DECLARE @path VARCHAR(256) -- path for backup files  
DECLARE @fileName VARCHAR(256) -- filename for backup  
DECLARE @fileDate VARCHAR(20) -- date to concat with file name
 
-- specify database backup directory
SET @path = 'C:\Backup\'  
 
-- specify filename format
SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) 
SELECT @counter1 = min(database_id) ,@counter2 = max(database_id)
FROM master.sys.databases 
WHERE name NOT IN ('master','model','msdb','tempdb')  -- exclude these databases
AND state = 0 -- database is online
AND is_in_standby = 0 -- not read only

while (@counter1 is not null AND @counter1 <= @counter2)
begin
SELECT @name = name 
FROM master.sys.databases 
WHERE name NOT IN ('master','model','msdb','tempdb')  -- exclude these databases
AND state = 0 -- database is online
AND is_in_standby = 0 -- not read only
AND database_id = @counter1
SET @fileName = @path + @name + '_' + @fileDate + '.BAK'  
BACKUP DATABASE @name TO DISK = @fileName  
set @counter1 = @counter1 + 1
end


