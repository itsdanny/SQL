USE [syslive]
GO
/****** Object:  StoredProcedure [dbo].[sp_DaysInWarmRoom]    Script Date: 06/03/2014 14:58:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter  PROCEDURE [dbo].[sp_DaysInWarmRoom_danstest]
AS
/*
                DROP TABLE #all_movements
                DROP TABLE #warm_room_movements
                DROP TABLE #pallets
*/
CREATE TABLE #pallets (PalletID INT IDENTITY(1,1), PalletDate DATETIME, pallet_number VARCHAR(20), warehouse VARCHAR(4), product VARCHAR(10), sequence_number VARCHAR(10), TotalDays Int DEFAULT(0)) 
CREATE CLUSTERED INDEX IX_pallet_number ON #pallets(pallet_number)

CREATE TABLE #all_movements                (pallet_number VARCHAR(20), movement_date DATETIME, from_bin_number VARCHAR(15), to_bin_number VARCHAR(15))
CREATE TABLE #warm_room_movements (MovementID INT IDENTITY(1,1), pallet_number VARCHAR(20), movement_date DATETIME, from_bin_number VARCHAR(15), to_bin_number VARCHAR(15))

INSERT                  INTO #pallets
SELECT                  DISTINCT max(a.dated), a.pallet_number, b.warehouse, b.product, b.sequence_number, 0 
FROM        scheme.stkhsttm a WITH (NOLOCK)
INNER JOIN  scheme.stqueam b WITH (NOLOCK)
ON          (a.pallet_number = b.pallet_number)
WHERE       b.warehouse = 'IG'
AND         LEN(a.pallet_number) > 1            
AND         b.product in ('126844')            
--AND         b.product not in ('127638', '109079', '106282', '128421', '127956')            
GROUP BY           a.pallet_number, b.warehouse, b.product, b.sequence_number 
ORDER BY           a.pallet_number

-- OUTER LOOP VARIABLES
DECLARE @CurRow INT
DECLARE @RowCount INT
DECLARE @Pallet VARCHAR(20)
DECLARE @Warehouse VARCHAR(2)
DECLARE @Product VARCHAR(10)
DECLARE @Sequence_Number VARCHAR(10)

-- INNER LOOP VARIABLES
DECLARE @DaysCount INT
DECLARE              @FromBin           VARCHAR(15)
DECLARE              @ToBin VARCHAR(15)
DECLARE              @RowDate         DATETIME
DECLARE              @MovementDate           DATETIME
DECLARE              @StartDate        DATETIME
DECLARE              @EndDate          DATETIME

                -- 'GET CORRESPONDING ROWS FROM MOVEMENT TABLE'
                INSERT INTO	  #all_movements
                SELECT        DISTINCT p.pallet_number, a.movement_date, a.from_bin_number, a.to_bin_number
                FROM          scheme.stkhstm a
                INNER JOIN    scheme.stkhsttm b
                ON            a.warehouse = b.warehouse
                AND           a.product = b.product
                AND           a.sequence_no = b.sequence_no
                AND           a.dated = b.dated 
                INNER JOIN	  #pallets p
                ON            b.pallet_number = p.pallet_number
                WHERE         a.transaction_type = 'BINT'         
                ORDER BY      p.pallet_number, a.movement_date
                
                -- GET ONLY PALLETS THAT HAVE BEEN IN THE WARM ROOM.
                INSERT INTO #warm_room_movements
                SELECT * 
                FROM   #all_movements 
                WHERE pallet_number IN (SELECT DISTINCT pallet_number FROM #all_movements WHERE to_bin_number = 'WR1' OR from_bin_number = 'WR1')
                
                SELECT * 
                FROM   #all_movements 
                
                SELECT * 
                FROM   #warm_room_movements 
                DROP TABLE #all_movements
                                
                SELECT  @RowCount = count(1), @CurRow = 1 
                FROM   #warm_room_movements
                
                -- LOOP THROUGH WARM ROOM MOVEMNT RECORDS
                WHILE @CurRow <= @RowCount
                BEGIN   
                                SELECT  @MovementDate = NULL, @DaysCount = 0, @Pallet = NULL
                                
                                -- GET A PALLET RECORD
                                SELECT  @MovementDate = movement_date, 
                                                                @Pallet = pallet_number,
                                                                @FromBin = from_bin_number, 
                                                                @ToBin = to_bin_number
                                FROM   #warm_room_movements 
                                WHERE MovementID = @CurRow
                                
                                -- WORK OUT THE DATEDIFF BETWEEN THE INS AND OUTS...
                                -- SEE IF IT HAS GONE INTO THE WARM ROOM AND GET THE START DATE
                                IF @ToBin = 'WR1' 
                                BEGIN
                                                SET @StartDate = @MovementDate
                                END
                                ELSE IF @FromBin = 'WR1' -- FIND OUT WHEN IT LEFT THE WARM ROOM AND UPDATE THE PALLET RECORD
                                BEGIN
                                                UPDATE  #pallets
                                                SET                         TotalDays = TotalDays +  DATEDIFF(dd, @StartDate, @MovementDate)
                                                WHERE pallet_number = @Pallet
                                                
                                                SET @StartDate = NULL
                                END                                       
                                
                                SET @CurRow = @CurRow +1 -- NEXT ROW PLEASE
                END
                select * from #pallets
                -- RETURN THE DATA
                SELECT        scheme.stquem.warehouse, 
                                                                  scheme.stquem.product,
                                                                  scheme.stockm.long_description, 
                                                                  scheme.stquem.batch_number, 
                                                                  scheme.stquem.bin_number, 
                                                                  scheme.stquem.lot_number, 
                                                                  scheme.stquem.expiry_date, 
                                                                  scheme.stquem.quantity, 
                                                                  p.pallet_number, 
                                                                  ISNULL(scheme.sttechm.text02, 'NOT SETUP') AS SetUp,
                                                                  p.PalletDate,
                                                                  DATEDIFF(dd, p.PalletDate, GetDate()) as Current_Days_In_WarmRoom,
                                                                  p.TotalDays as Total_Days_In_Warm_Room,
                                                                  scheme.stquem.sequence_number
                FROM          scheme.stquem  WITH (NOLOCK)
                INNER JOIN        #pallets p                                              
                ON                                         scheme.stquem.warehouse = p.warehouse 
                AND                                       scheme.stquem.product = p.product 
                AND                                       scheme.stquem.sequence_number = p.sequence_number 
                LEFT JOIN            scheme.sttechm  WITH (NOLOCK)
                ON                                         scheme.stquem.warehouse = scheme.sttechm.warehouse 
                AND                                       scheme.stquem.product = scheme.sttechm.product 
                AND                                       scheme.sttechm.page_number = '050'              
                INNER JOIN  scheme.stockm WITH (NOLOCK)
                ON                                         scheme.stockm.product = scheme.stquem.product
                AND                                       scheme.stockm.warehouse = scheme.stquem.warehouse
                WHERE       (scheme.stquem.bin_number = 'WR1') 
                AND                                       (scheme.stquem.quantity > 0)

DROP TABLE #warm_room_movements
DROP TABLE #pallets


go

sp_DaysInWarmRoom_danstest

/*
select top 5 * from scheme.stquem a WITH (NOLOCK)
                INNER JOIN        scheme.sttechm b WITH (NOLOCK)
                ON                                         a.warehouse = b.warehouse 
                AND                                       a.product = b.product 
                AND                                       b.page_number = '050'              
                INNER JOIN  scheme.stockm c WITH (NOLOCK)
                ON                                         c.product = a.product
                AND                                       c.warehouse = a.warehouse
                WHERE       (a.bin_number = 'WR1') 
                AND                                       (a.quantity > 0)
and a.warehouse ='IG'
and        a.prod_code = '126844'
'043695A02002'

select *
FROM        scheme.stkhsttm a WITH (NOLOCK)
INNER JOIN  scheme.stqueam b WITH (NOLOCK)
ON          (a.pallet_number = b.pallet_number)
WHERE       b.warehouse = 'IG'
AND         LEN(a.pallet_number) > 1            
AND         b.product in ('126844') 
AND			b.pallet_number ='033053A01002'           
ORDER BY    a.dated, a.pallet_number
*/

