DECLARE @ChildAndParent table(ParentId int,Id int)

INSERT INTO @ChildAndParent

SELECT NULL,1
UNION
SELECT NULL,2
UNION
SELECT NULL,3
UNION
SELECT 1,4
UNION
SELECT 1,5
UNION
SELECT 1,6
UNION
SELECT 2,7
UNION
SELECT 2,8
UNION
SELECT 2,9
UNION
SELECT 3,10
UNION
SELECT 3,11
UNION
SELECT 3,12
UNION
SELECT 4,13
UNION
SELECT 4,14
UNION
SELECT 10,15
UNION
SELECT 14,15
UNION
SELECT 15,16
UNION
SELECT 5,17

DECLARE @parentid bigint=1
DECLARE @Result TABLE(ParentId int,Id int)

INSERT INTO @Result 
SELECT
	@parentId,
	Id 
FROM 
	@ChildAndParent 
WHERE 
	Parentid=@parentid


WHILE
		(
		 EXISTS (
				SELECT 1 
				FROM 
					@Result R 
				LEFT JOIN 
					@ChildAndParent CP 
				ON 
					R.id=CP.parentid
		        LEFT JOIN 
					@Result R2 
				ON 
					CP.Id=R2.Id AND CP.ParentId=R2.ParentId 
				WHERE 
					CP.ParentId IS NOT NULL AND R2.Id IS NULL
				)
		)
	BEGIN
		INSERT INTO @Result
				
				SELECT 
					 CP.ParentId
					,CP.Id 
				FROM 
					@Result R 
				LEFT JOIN 
					@ChildAndParent CP 
				ON 
					R.id=CP.ParentId
				LEFT JOIN 
					@Result R2
				ON 
					CP.Id=R2.Id AND CP.parentid=R2.ParentId 
				WHERE 
					CP.ParentId IS NOT NULL AND R2.Id IS NULL
	END


SELECT * FROM @Result 
--order by ParentId