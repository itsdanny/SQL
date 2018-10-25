
--select		element1, account_code, journal_number, journal_date, journal_desc, journal_amount into #ONE
--FROM		scheme.nltranm a 
--where		a.element1 like '4%'
--and			a.journal_date between '2015-04-28 00:00:00.000' and '2015-04-30 00:00:00.000'
----and			a.journal_amount > 0

--select		element1, account_code, journal_number, journal_date, journal_desc, journal_amount into #TWO
--FROM		scheme.nltranm a 
--where		a.element1 like '1%'
--and			a.journal_date between '2015-04-28 00:00:00.000' and '2015-04-30 00:00:00.000'
----and			a.journal_amount < 0

--select * from #ONE where journal_number in (select journal_number from #TWO)
--select * from #TWO where journal_number in (select journal_number from #ONE)

--select * 
--from		#ONE a 
--inner join	#TWO b
--on			a.journal_number = b.journal_number


--drop table #ONE
--drop table #TWO


DECLARE @Journals AS TABLE (Id INT IDENTITY(1,1), JournalNumber NVARCHAR(50))
DECLARE @BadJournals AS TABLE (Id INT IDENTITY(1,1), element1 nvarchar(20), account_code nvarchar(20), journal_number nvarchar(20), transaction_date date, post_date datetime, journal_date datetime, journal_desc nvarchar(50), journal_amount money, discrepancy money)

INSERT INTO @Journals (JournalNumber) SELECT DISTINCT journal_number FROM scheme.nltranm a WITH (NOLOCK) WHERE a.post_date BETWEEN '2015-04-28' AND '2015-04-30' and element1 like '4%'

--SELECT COUNT(*) FROM @Journals
DECLARE @ROWS INT = (SELECT COUNT(1) FROM @Journals)
DECLARE @ROW INT = 1
DECLARE @JOURNALAMOUNT MONEY = 0.00
DECLARE @TOTAL MONEY = 0.00

DECLARE @JOURNAL  NVARCHAR(50)
WHILE @ROW < @ROWS
BEGIN
	SELECT @JOURNAL = JournalNumber, @JOURNALAMOUNT = 0 FROM @Journals WHERE Id = @ROW
	SELECT @JOURNALAMOUNT = SUM(cast(journal_amount as money)) FROM scheme.nltranm WITH (NOLOCK) WHERE journal_number = @JOURNAL and post_date BETWEEN '2015-04-28' AND '2015-04-30'
	--SELECT @JOURNALAMOUNT, SUM(journal_amount) FROM scheme.nltranm WHERE journal_number = @JOURNAL
	--IF @JOURNALAMOUNT <> 0
	BEGIN	
		--SET @TOTAL = @TOTAL + @JOURNALAMOUNT		
		insert into @BadJournals(element1, account_code, journal_number, transaction_date, post_date, journal_date, journal_desc, journal_amount, discrepancy)
		SELECT element1, account_code, journal_number, post_date, transaction_date, journal_date, journal_desc, journal_amount, @JOURNALAMOUNT FROM scheme.nltranm WITH (NOLOCK) WHERE journal_number = @JOURNAL and post_date BETWEEN '2015-04-28' AND '2015-04-30'
	END
	SET @ROW = @ROW + 1 
END
select element1, account_code, journal_number, transaction_date, post_date, journal_date, journal_desc, journal_amount, discrepancy from @BadJournals

--	select * from scheme.nltranm with(nolock) WHERE journal_number   = '1504390'