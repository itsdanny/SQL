create Table DWCalendar (
    DateId				Integer	IDENTITY(1,1),
    CalenderDate			DateTime NOT NULL,    
    DayNumberOfWeek			Integer	NOT NULL,
    NameOfDay				VarChar (10) NOT NULL,
    NameOfMonth				VarChar (10) NOT NULL,
    WeekOfYear				Integer	NOT NULL,
    JulianDay				Integer	NOT NULL
)


Declare @StartDate  DateTime = '2015-01-01'
Declare @EndDate    DateTime = '2020-12-31'

While @StartDate < @EndDate
Begin
    INSERT INTO DWCalendar  
    (    	
    	CalenderDate, 
    	WeekOfYear,
    	DayNumberOfWeek,
    	NameOfDay,
    	NameOfMonth,
    	JulianDay
    )
    Values 
    (    
    	@StartDate,					-- DateValue
    	DATEPART (ww, @StartDate),	-- WeekOfYear
    	DATEPART (dw, @StartDate),	-- DayNumberOfWeek
    	DATENAME (dw, @StartDate),	-- NameOfDay
    	DATENAME (M, @StartDate),	-- NameOfMonth
    	DATEPART (dy, @StartDate)	-- JulianDay
    )

    Set @StartDate += 1
End

SELECT * FROM DWCalendar 