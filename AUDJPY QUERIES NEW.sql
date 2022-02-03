




---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--AUDJPY SQL EXPLORATION 

--NOTE FTP ~ Fixed Take Profit & TSL ~ Trailing Stop Loss 


SELECT * 
FROM AUDJPY 

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Duration In Which All Trades Were Taken 

SELECT COUNT(TradeID) TotalTrades,DATEDIFF(month,'2021-08-02','2021-10-27') DurationMonths
FROM AUDJPY



--Trades With An Above Average Profit 

SELECT Session,
       ProfitLossFTP,
       (SELECT AVG(ProfitLossFTP) FROM AUDJPY) AvgProfitFTP
FROM AUDJPY 
WHERE ProfitLossFTP > (SELECT AVG(ProfitLossFTP) FROM AUDJPY) 



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----Profit & Percent for each session 

SELECT * 
FROM TOTALFTP ftp
	INNER JOIN TOTALTSL tsl
	ON ftp.session = tsl.session 



SELECT Session,SUM(ProfitLossFTP) TotalProfitBeforeSplitFTP,SUM(ProfitLossFTP) * 0.8 TotalProfitAfterSplitFTP,ROUND(AVG(ProfitLossFTP),2) AvgProfitFTP,SUM(ProfitLossTSL) TotalProfitBeforeSplitTSL,SUM(ProfitLossTSL) * 0.8 TotalProfitAfterSplitTSL,ROUND(AVG(ProfitLossTSL),2) AvgProfitTSL
FROM AUDJPY 
GROUP BY Session 



SELECT Session,Confluence,ProfitLossFTP,COUNT(ProfitLossFTP) OccuredNumTimes,(ProfitLossFTP * COUNT(ProfitLossFTP) *  0.8) TotalProfit
FROM AUDJPY 
GROUP BY Session,Confluence,ProfitLossFTP
ORDER BY 1,5 DESC



SELECT Session,Confluence,ProfitLossTSL,COUNT(ProfitLossTSL) OccuredNumTimes,(ProfitLossTSL * COUNT(ProfitLossTSL) *  0.8) TotalProfit
FROM AUDJPY 
GROUP BY Session,Confluence,ProfitLossTSL
ORDER BY 1,5 DESC



--Most Profitable Confluences for each session FTP

SELECT DISTINCT(Session),Confluence,ProfitLossFTP
FROM AUDJPY 
GROUP BY Session,Confluence,ProfitLossFTP
ORDER BY 1,3 DESC



--Most Profitable Confluences for each session TSL

SELECT DISTINCT(Session),Confluence,ProfitLossTSL
FROM AUDJPY 
GROUP BY Session,Confluence,ProfitLossTSL
ORDER BY 1,3 DESC



--Profit For FTP 

SELECT Session,ROUND(MIN(ProfitLossFTP),2) MinProfitFTP, ROUND(MAX(ProfitLossFTP),2) MaxProfitFTP, ROUND(AVG(ProfitLossFTP),2) AvgProfitFTP,ROUND(AVG(ProfitLossFTP),2) * 0.8 AvgProfitFTPSplit,ROUND(SUM(ProfitLossFTP),2) TotalProfitFTP,ROUND(SUM(ProfitLossFTP),2) * 0.8 TotalProfitSplitFTP 
FROM AUDJPY 
GROUP BY Session



--Percent For FTP

SELECT Session,ROUND(MIN(FTPPercent),4) * 100 MinPercentFTP, ROUND(MAX(FTPPercent),4) * 100 MaxPercentFTP, ROUND(AVG(FTPPercent),4) * 100 AvgPercentFTP,ROUND(SUM(FTPPercent),4) TotalPercentFTP
FROM AUDJPY 
GROUP BY Session



--Profit For TSL

SELECT Session,ROUND(MIN(ProfitLossTSL),2) MinProfitTSL, ROUND(MAX(ProfitLossTSL),2) MaxProfitTSL, ROUND(AVG(ProfitLossTSL),2) AvgProfitTSL,ROUND(AVG(ProfitLossTSL),2) * 0.8 AvgProfitTSLSplit,ROUND(SUM(ProfitLossTSL),2) TotalProfitTSL,ROUND(SUM(ProfitLossTSL),2) * 0.8 TotalProfitSplitTSL
FROM AUDJPY 
GROUP BY Session



--Percent For TSL

SELECT Session,ROUND(MIN(TSLPercent),4) * 100 MinPercentTSL, ROUND(MAX(TSLPercent),4) * 100 MaxPercentTSL, ROUND(AVG(TSLPercent),4) * 100  AvgPercentTSL,ROUND(SUM(TSLPercent),4) TotalPercentTSL
FROM AUDJPY 
GROUP BY Session



--Combined Profit 

SELECT Session,ROUND(MIN(CombinedProfit),2) MinCombinedProfit,ROUND(MAX(CombinedProfit),2) MaxCombinedProfit,ROUND(AVG(CombinedProfit),2) AvgCombinedProfit,ROUND(AVG(CombinedProfit),2) * 0.8 AvgProfitCombinedSplit,ROUND(SUM(CombinedProfit),2) CombinedTotalProfit
FROM AUDJPY 
GROUP BY Session



--Combined Percent

SELECT Session,ROUND(MIN(CombinedPercent),4) * 100  MinCombinedPercent,ROUND(MAX(CombinedPercent),4) * 100 MaxCombinedPercent,ROUND(AVG(CombinedPercent),4) * 100 AvgCombinedPercent,ROUND(SUM(CombinedPercent),4) CombinedTotalPercent
FROM AUDJPY 
GROUP BY Session



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Total Wins/Losses for Buys & Sells FTP & TSL

SELECT * 
FROM BUYFTP buy 
	INNER JOIN SELLFTP sell 
	ON buy.session = sell.session 
	
	

--FTP Overall Win Percentage For All Sessions Combined

SELECT ROUND(SUM(TradeID) / (COUNT(OutcomeFTP)),1) WinPercentageFTP
FROM AUDJPY 
WHERE OutcomeFTP = 'Win';



--Wins Per Session,Total Trades,Total Wins & Win Percetange Per Session For FTP

WITH FXCTE AS
(
SELECT Session,COUNT(OutcomeFTP) TotalWinsFTP,(SELECT COUNT(OutcomeFTP) FROM AUDJPY) TotalTrades,ROUND(SUM(TradeID) / (COUNT(OutcomeFTP)),1) WinPercentageFTP
FROM AUDJPY 
WHERE OutcomeFTP = 'Win' 
GROUP BY Session,OutcomeFTP
)
SELECT Session,(SELECT COUNT(OutcomeFTP) FROM AUDJPY) TotalTrades,TotalWinsFTP TotalWinsBySession,(SELECT(SUM(TotalWinsFTP)) FROM FXCTE) TotalWinsCombined,WinPercentageFTP WinPercentageBySession
FROM FXCTE;



--TSL Overall Win Percentage Fro All Sessions Combined

SELECT ROUND(SUM(TradeID) / (COUNT(OutcomeTSL)),1) WinPercentageTSL
FROM AUDJPY 
WHERE OutcomeTSL = 'Win';



--Wins Per Session,Total Trades,Total Wins & Win Percetange Per Session For TSL

WITH FXCTE AS
(
SELECT Session,COUNT(OutcomeTSL) TotalWinsTSL,(SELECT COUNT(OutcomeTSL) FROM AUDJPY) TotalTrades,ROUND(SUM(TradeID) / (COUNT(OutcomeTSL)),1) WinPercentageTSL
FROM AUDJPY 
WHERE OutcomeTSL = 'Win' 
GROUP BY Session,OutcomeTSL
)
SELECT Session,(SELECT COUNT(OutcomeTSL) FROM AUDJPY) TotalTrades,TotalWinsTSL TotalWinsBySession,(SELECT(SUM(TotalWinsTSL)) FROM FXCTE) TotalWinsCombined,WinPercentageTSL WinPercentageBySession
FROM FXCTE;



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--TOTAL BUY & SELL POSITIONS

SELECT Position,
       COUNT(Position) PositionOccurence
FROM AUDJPY 
	GROUP BY Position 



--POSITIVE & NEGATIVE FTP For Each Confluence

SELECT ProfitLossFTP,
       Confluence,
       COUNT(ProfitLossFTP) FTPOccurence
FROM AUDJPY 
	GROUP BY ProfitLossFTP,
	         Confluence
	ORDER BY FTPOccurence DESC;



--POSITIVE FTP PROFIT 

SELECT ProfitLossFTP,
       COUNT(ProfitLossFTP) FTPOccurence
FROM AUDJPY
WHERE ProfitLossFTP > 0 
	GROUP BY ProfitLossFTP
	ORDER BY ProfitLossFTP DESC,
	         FTPOccurence DESC;



--PROFIT BEFORE AND AFTER 70%  PROFIT SPLIT

SELECT SUM(ProfitLossFTP) ProfitBeforeSplit,
       SUM(ProfitLossFTP) * 0.7 ProfitAfterSplit
FROM AUDJPY 



--POSITIVE & NEGATIVE TSL

SELECT ProfitLossTSL,
       COUNT(ProfitLossTSL) TSLOccurence
FROM AUDJPY 
	GROUP BY ProfitLossTSL 
	ORDER BY TSLOccurence DESC;



--POSITIVE TSL PROFIT

SELECT ProfitLossTSL,
       COUNT(ProfitLossTSL) TSLOccurence
FROM AUDJPY
WHERE ProfitLossTSL > 0 
	GROUP BY ProfitLossTSL
	ORDER BY ProfitLossTSL DESC,
	         TSLOccurence DESC;



--FTP PROFIT BEFORE AND AFTER 70% PROFIT SPLIT 

SELECT SUM(ProfitLossFTP) ProfitBeforeSplit,
       SUM(ProfitLossFTP) * 0.7 ProfitAfterSplitFTP
FROM AUDJPY 



--TSL PROFIT BEFORE AND AFTER 70% PROFIT SPLIT 

SELECT SUM(ProfitLossTSL) ProfitBeforeSplit,
       SUM(ProfitLossTSL) * 0.7 ProfitAfterSplitTSL
FROM AUDJPY 



--COMPARING FTP & TSL BEFORE & AFTER SPLITS (PBS = Profit Before Split , PAS = Profit After Split)

SELECT SUM(ProfitLossFTP) PBSFTP,
       SUM(ProfitLossFTP) * 0.7 PASFTP,
       SUM(ProfitLossTSL) PBSTSL,
       SUM(ProfitLossTSL) * 0.7 PASTSL
FROM AUDJPY 



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--FINDING THE MOST COMMON TYPE OF CONFLUENCE OVERALL

SELECT COUNT(DISTINCT(Confluence)) TotalNumConfluences
FROM AUDJPY;



SELECT DISTINCT(Confluence)
FROM AUDJPY;



SELECT Confluence,
       COUNT(Confluence) TypeConfluence
FROM AUDJPY
	GROUP BY Confluence
	ORDER BY TypeConfluence DESC;




--MOST COMMON OCCURENCES FOR FTP

SELECT ProfitLossFTP,
       COUNT(ProfitLossFTP) FTPOccurence
FROM AUDJPY 
	GROUP BY ProfitLossFTP 
HAVING COUNT(ProfitLossFTP) >= 2
	ORDER BY FTPOccurence DESC



--MOST COMMON OCCURENCES FOR TSL

SELECT ProfitLossTSL,
       COUNT(ProfitLossTSL) TSLOccurence
FROM AUDJPY 
	GROUP BY ProfitLossTSL 
HAVING COUNT(ProfitLossTSL) >= 2
	ORDER BY TSLOccurence DESC



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--TOTAL TRADES TAKEN DURING EACH SESSION 

SELECT Session,
       COUNT(Session)TradesTaken
FROM AUDJPY
	GROUP BY Session
	ORDER BY TradesTaken DESC



--TYPE OF POSITION HELD DURING EACH SESSION 

SELECT Session,
       Position, 
       COUNT(Position) SumPosition
FROM AUDJPY
	GROUP BY Session,
		 Position
	ORDER BY Session,
		 SumPosition DESC;



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Bearish Hammer

--NUMBER OF BEARISH & BULLISH HAMMER CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) Hammer,SUM(ProfitLossFTP) TotalHammerProfit
FROM AUDJPY
WHERE Confluence = 'Bearish Hammer'
	GROUP BY Confluence
	ORDER BY Hammer DESC;



--USE CTE TO FIND PROFIT & NUMBER OF BEARISH & BULLISH HAMMER OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(ProfitLossFTP) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Bearish Hammer'
	GROUP BY Confluence, 
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF BEARISH & BULLISH HAMMER OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(ProfitLossTSL) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Bearish Hammer'
	GROUP BY Confluence,
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;
	


SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearHamTSL
) Total
WHERE Confluence = 'Bearish Hammer'



--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearHamTSL
) Total
WHERE Confluence = 'Bearish Hammer'
	GROUP BY Confluence;



--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearHamTSL
) Total
WHERE Confluence = 'Bearish Hammer'
	GROUP BY Confluence;



--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearHamTSL
) Total
WHERE Confluence = 'Bearish Hammer'
	GROUP BY Confluence;



--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearHamTSL
) Total
WHERE Confluence = 'Bearish Hammer'
	GROUP BY Confluence;
	
	

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Bullish Hammer

--NUMBER OF BEARISH & BULLISH HAMMER CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) Hammer,SUM(ProfitLossFTP) TotalHammerProfit
FROM AUDJPY
WHERE Confluence = 'Bullish Hammer'
	GROUP BY Confluence
	ORDER BY Hammer DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF BEARISH & BULLISH HAMMER OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(ProfitLossFTP) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Bullish Hammer'
	GROUP BY Confluence,
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;



--USE CTE TO FIND PROFIT & NUMBER OF BEARISH & BULLISH HAMMER OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(ProfitLossTSL) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Bullish Hammer'
	GROUP BY Confluence,
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;



SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullHamTSL
) Total
WHERE Confluence = 'Bullish Hammer'



--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullHamTSL
) Total
WHERE Confluence = 'Bullish Hammer'
	GROUP BY Confluence;



--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullHamTSL
) Total
WHERE Confluence = 'Bullish Hammer'
	GROUP BY Confluence;



--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullHamTSL
) Total
WHERE Confluence = 'Bullish Hammer'
	GROUP BY Confluence;



--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullHamTSL
) Total
WHERE Confluence = 'Bullish Hammer'
	GROUP BY Confluence;
	
	

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--B&R

--NUMBER OF B&R CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) BnR
FROM AUDJPY
WHERE Confluence = 'B&R' 
	GROUP BY Confluence
	ORDER BY BnR DESC;



--USE CTE TO FIND PROFIT & NUMBER OF B&R OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'B&R'
	GROUP BY Confluence, 
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF B&R OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'B&R' 
	GROUP BY Confluence,
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;



--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRTSL
) Total
WHERE Confluence = 'B&R'
	GROUP BY Confluence;
	
	

--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRTSL
) Total
WHERE Confluence = 'B&R'
	GROUP BY Confluence;
	
	

--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRTSL
) Total
WHERE Confluence = 'B&R'
	GROUP BY Confluence;
	
	

--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRTSL
) Total
WHERE Confluence = 'B&R'
	GROUP BY Confluence;



--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRTSL
) Total
WHERE Confluence = 'B&R'
	GROUP BY Confluence;
	
	

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--BEARISH ENGULFING 

--NUMBER OF BEARISH ENGULFING CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) BearEng, SUM(ProfitLossFTP) TotalBearEngProfit
FROM AUDJPY
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence
	ORDER BY BearEng DESC;



--USE CTE TO FIND PROFIT & NUMBER OF BEARISH ENGULFING OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Bearish Engulfing'
	GROUP BY Confluence,
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF BEARISH ENGULFING OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence,
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;
	
	

--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngTSL
) Total
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence;
	
	

--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngTSL
) Total
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence;
	
	

--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngTSL
) Total
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence;
	
	

--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngTSL
) Total
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence;
	
	

--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngTSL
) Total
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence;
	
	

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--B&R w/ Bearish Engulfing

--NUMBER OF B&R W/ BEARISH ENGULFING CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) BnRBearEng
FROM AUDJPY
WHERE Confluence = 'B&R w/ Bearish Engulfing' 
	GROUP BY Confluence
	ORDER BY BnRBearEng DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF B&R W/ BEARISH ENGULFING OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'B&R w/ Bearish Engulfing'
	GROUP BY Confluence,
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;



--USE CTE TO FIND PROFIT & NUMBER OF B&R W/ BEARISH ENGULFING OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'B&R w/ Bearish Engulfing' 
	GROUP BY Confluence, 
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;
	
	

--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBearEngTSL
) Total
WHERE Confluence = 'B&R w/ Bearish Engulfing' 
	GROUP BY Confluence;
	
	

--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBearEngTSL
) Total
WHERE Confluence = 'B&R w/ Bearish Engulfing' 
	GROUP BY Confluence;



--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBearEngTSL
) Total
WHERE Confluence = 'B&R w/ Bearish Engulfing' 
	GROUP BY Confluence;



--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBearEngTSL
) Total
WHERE Confluence = 'B&R w/ Bearish Engulfing' 
	GROUP BY Confluence;



--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBearEngTSL
) Total
WHERE Confluence = 'B&R w/ Bearish Engulfing' 
	GROUP BY Confluence;
	
	

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--B&R w/ Bearish Hammer

--NUMBER OF B&R W/ BEARISH HAMMER CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) BnRBearHammer
FROM AUDJPY
WHERE Confluence = 'B&R w/ Bearish Hammer' 
	GROUP BY Confluence
	ORDER BY BnRBearHammer DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF B&R W/ BEARISH HAMMER OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'B&R w/ Bearish Hammer'
	GROUP BY Confluence,
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF B&R W/ BEARISH HAMMER OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'B&R w/ Bearish Hammer' 
	GROUP BY Confluence, 
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;
	
	

--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBearHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBearHamTSL
) Total
WHERE Confluence = 'B&R w/ Bearish Hammer' 
	GROUP BY Confluence;
	
	

--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBearHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBearHamTSL
) Total
WHERE Confluence = 'B&R w/ Bearish Hammer' 
	GROUP BY Confluence;



--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBearHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBearHamTSL
) Total
WHERE Confluence = 'B&R w/ Bearish Hammer' 
	GROUP BY Confluence;
	
	

--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBearHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBearHamTSL
) Total
WHERE Confluence = 'B&R w/ Bearish Hammer' 
	GROUP BY Confluence;



--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBearHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBearHamTSL
) Total
WHERE Confluence = 'B&R w/ Bearish Hammer' 
	GROUP BY Confluence;
	
	

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--B&R w/ Bullish Engulfing, Continuation

--NUMBER OF B&R W/ BULLISH ENGULFING, CONTINUATION CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) BnRBullEngCont
FROM AUDJPY
WHERE Confluence = 'B&R w/ Bullish Engulfing, Continuation' 
	GROUP BY Confluence
	ORDER BY BnRBullEngCont DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF B&R W/ BULLISH ENGULFING, CONTINUATION OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'B&R w/ Bullish Engulfing, Continuation'
	GROUP BY Confluence,
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF B&R W/ BULLISH ENGULFING, CONTINUATION OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'B&R w/ Bullish Engulfing, Continuation' 
	GROUP BY Confluence, 
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;



--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBullEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBullEngContTSL
) Total
WHERE Confluence = 'B&R w/ Bullish Engulfing, Continuation'
	GROUP BY Confluence;



--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBullEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBullEngContTSL
) Total
WHERE Confluence = 'B&R w/ Bullish Engulfing, Continuation'
	GROUP BY Confluence;



--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBullEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBullEngContTSL
) Total
WHERE Confluence = 'B&R w/ Bullish Engulfing, Continuation'
	GROUP BY Confluence;



--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBullEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBullEngContTSL
) Total
WHERE Confluence = 'B&R w/ Bullish Engulfing, Continuation'
	GROUP BY Confluence;
	
	

--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBullEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBullEngContTSL
) Total
WHERE Confluence = 'B&R w/ Bullish Engulfing, Continuation'
	GROUP BY Confluence;
	
	

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--B&R w/ Bullish Hammer

--NUMBER OF B&R W/ BULLISH HAMMER CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) BnRBullHammer
FROM AUDJPY
WHERE Confluence = 'B&R w/ Bullish Hammer' 
	GROUP BY Confluence
	ORDER BY BnRBullHammer DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF B&R W/ BULLISH HAMMER OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'B&R w/ Bullish Hammer'
	GROUP BY Confluence,
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF B&R W/ BULLISH HAMMER OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'B&R w/ Bullish Hammer' 
	GROUP BY Confluence,
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;
	
	

--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBullHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBullHamTSL
) Total
WHERE Confluence = 'B&R w/ Bullish Hammer' 
	GROUP BY Confluence;
	
	

--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBullHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBullHamTSL
) Total
WHERE Confluence = 'B&R w/ Bullish Hammer' 
	GROUP BY Confluence;
	
	

--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBullHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBullHamTSL
) Total
WHERE Confluence = 'B&R w/ Bullish Hammer' 
	GROUP BY Confluence;



--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBullHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBullHamTSL
) Total
WHERE Confluence = 'B&R w/ Bullish Hammer' 
	GROUP BY Confluence
	
	

--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBullHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBullHamTSL
) Total
WHERE Confluence = 'B&R w/ Bullish Hammer' 
	GROUP BY Confluence;
	
	

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--B&R, Morning Star

--NUMBER OF B&R, MORNING STAR CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) BnRMornStar
FROM AUDJPY
WHERE Confluence = 'B&R, Morning Star' 
	GROUP BY Confluence
	ORDER BY BnRMornStar DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF B&R, MORNING STAR OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'B&R, Morning Star'
	GROUP BY Confluence, 
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF B&R, MORNING STAR OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'B&R, Morning Star' 
	GROUP BY Confluence, 
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;
	
	

--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRMorningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRMorningStarTSL
) Total
WHERE Confluence = 'B&R, Morning Star' 
	GROUP BY Confluence;
	
	

--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRMorningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRMorningStarTSL
) Total
WHERE Confluence = 'B&R, Morning Star' 
	GROUP BY Confluence;



--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRMorningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRMorningStarTSL
) Total
WHERE Confluence = 'B&R, Morning Star' 
	GROUP BY Confluence;



--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRMorningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRMorningStarTSL
) Total
WHERE Confluence = 'B&R, Morning Star' 
	GROUP BY Confluence;



--AVERAGE PROFIT

SELECT Confluence,
       AVG(ProfitLossFTP) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRMorningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRMorningStarTSL
) Total
WHERE Confluence = 'B&R, Morning Star' 
	GROUP BY Confluence;



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--BEARISH ENGULFING 

--NUMBER OF BEARISH ENGULFING CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) BearEng
FROM AUDJPY
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence
	ORDER BY BearEng DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF BEARISH ENGULFING OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Bearish Engulfing'
	GROUP BY Confluence,
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF BEARISH ENGULFING OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence, 
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;



--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngTSL
) Total
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence;



--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngTSL
) Total
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence;



--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngTSL
) Total
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence;



--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngTSL
) Total
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence;
	
	

--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngTSL
) Total
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence;



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Bearish Engulfing, Continuation

--NUMBER OF BEARISH ENGULFING, CONTINUATION CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) BearEngCont
FROM AUDJPY
WHERE Confluence = 'Bearish Engulfing, Continuation' 
	GROUP BY Confluence
	ORDER BY BearEngCont DESC;



--USE CTE TO FIND PROFIT & NUMBER OF BEARISH ENGULFING, CONTINUATION OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Bearish Engulfing, Continuation'
	GROUP BY Confluence,
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF BEARISH ENGULFING, CONTINUATION OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Bearish Engulfing, Continuation' 
	GROUP BY Confluence, 
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
WHERE Confluence = 'Bearish Engulfing, Continuation' 
	ORDER BY OutcomeFrequency DESC;
	
	
	
--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngContTSL
) Total
WHERE Confluence = 'Bearish Engulfing, Continuation' 
	GROUP BY Confluence;



--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngContTSL
) Total
WHERE Confluence = 'Bearish Engulfing, Continuation' 
	GROUP BY Confluence;



--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngContTSL
) Total
WHERE Confluence = 'Bearish Engulfing, Continuation' 
	GROUP BY Confluence;



--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngContTSL
) Total
WHERE Confluence = 'Bearish Engulfing, Continuation' 
	GROUP BY Confluence;
	
	

--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngContTSL
) Total
WHERE Confluence = 'Bearish Engulfing, Continuation' 
	GROUP BY Confluence;



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Bullish Engulfing

--NUMBER OF BULLISH ENGULFING CONFLUENCES

SELECT Confluence,
       COUNT(Confluence) BullEng
FROM AUDJPY
WHERE Confluence = 'Bullish Engulfing' 
	GROUP BY Confluence
	ORDER BY BullEng DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF BULLISH ENGULFING OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Bullish Engulfing'
	GROUP BY Confluence, 
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;



--USE CTE TO FIND PROFIT & NUMBER OF BULLISH ENGULFING OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Bullish Engulfing' 
	GROUP BY Confluence, 
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;
	
	

--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullEngTSL
) Total
WHERE Confluence = 'Bullish Engulfing' 
	GROUP BY Confluence;



--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullEngTSL
) Total
WHERE Confluence = 'Bullish Engulfing' 
	GROUP BY Confluence;



--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullEngTSL
) Total
WHERE Confluence = 'Bullish Engulfing' 
	GROUP BY Confluence;



--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullEngTSL
) Total
WHERE Confluence = 'Bullish Engulfing' 
	GROUP BY Confluence;
	
	

--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullEngTSL
) Total
WHERE Confluence = 'Bullish Engulfing' 
	GROUP BY Confluence;



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Bullish Engulfing, Continuation

--NUMBER OF BULLISH ENGULFING, CONTINUATION CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) BullEngCont
FROM AUDJPY
WHERE Confluence = 'Bullish Engulfing, Continuation' 
	GROUP BY Confluence
	ORDER BY BullEngCont DESC;



--USE CTE TO FIND PROFIT & NUMBER OF BULLISH ENGULFING, CONTINUATION OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Bullish Engulfing, Continuation'
	GROUP BY Confluence, 
 	         ProfitLossFTP
--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF BULLISH ENGULFING, CONTINUATION OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Bullish Engulfing, Continuation' 
	GROUP BY Confluence, 
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;
	
	

--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullEngContTSL
) Total
WHERE Confluence = 'Bullish Engulfing, Continuation' 
	GROUP BY Confluence;
	
	

--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullEngContTSL
) Total
WHERE Confluence = 'Bullish Engulfing, Continuation' 
	GROUP BY Confluence;
	
	

--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullEngContTSL
) Total
WHERE Confluence = 'Bullish Engulfing, Continuation' 
	GROUP BY Confluence;
	
	

--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullEngContTSL
) Total
WHERE Confluence = 'Bullish Engulfing, Continuation' 
	GROUP BY Confluence;
	
	

--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullEngContTSL
) Total
WHERE Confluence = 'Bullish Engulfing, Continuation' 
	GROUP BY Confluence;



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Continuation

--NUMBER OF CONTINUATION CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) Cont
FROM AUDJPY
WHERE Confluence = 'Continuation' 
	GROUP BY Confluence
	ORDER BY Cont DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF CONTINUATION OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Continuation'
	GROUP BY Confluence, 
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF CONTINUATION OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Continuation' 
	GROUP BY Confluence, 
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;
	
	
	
--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM ContinuationFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM ContinuationTSL
) Total
WHERE Confluence = 'Continuation' 
	GROUP BY Confluence;
	
	

--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM ContinuationFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM ContinuationTSL
) Total
WHERE Confluence = 'Continuation' 
	GROUP BY Confluence;



--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM ContinuationFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM ContinuationTSL
) Total
WHERE Confluence = 'Continuation' 
	GROUP BY Confluence;
	
	

--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM ContinuationFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM ContinuationTSL
) Total
WHERE Confluence = 'Continuation' 
	GROUP BY Confluence;
	
	

--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM ContinuationFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM ContinuationTSL
) Total
WHERE Confluence = 'Continuation' 
	GROUP BY Confluence;
	
	

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Evening Star

--NUMBER OF EVENING STAR CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) EveningStar
FROM AUDJPY
WHERE Confluence = 'Evening Star' 
	GROUP BY Confluence
	ORDER BY EveningStar DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF EVENING STAR OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Evening Star'
	GROUP BY Confluence,
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF EVENING STAR OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Evening Star' 
	GROUP BY Confluence, 
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;
	
	

--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM EveningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM EveningStarTSL
) Total
WHERE Confluence = 'Evening Star' 
	GROUP BY Confluence;
	
	

--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM EveningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM EveningStarTSL
) Total
WHERE Confluence = 'Evening Star' 
	GROUP BY Confluence;
	
	

--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM EveningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM EveningStarTSL
) Total
WHERE Confluence = 'Evening Star' 
	GROUP BY Confluence;
	
	

--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM EveningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM EveningStarTSL
) Total
WHERE Confluence = 'Evening Star' 
	GROUP BY Confluence;



--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM EveningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM EveningStarTSL
) Total
WHERE Confluence = 'Evening Star' 
	GROUP BY Confluence;



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Morning Star

--NUMBER OF MORNING STAR CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) MorningStar
FROM AUDJPY
WHERE Confluence = 'Morning Star' 
	GROUP BY Confluence
	ORDER BY MorningStar DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF MORNING STAR OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Morning Star'
	GROUP BY Confluence, 
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF MORNING STAR OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Morning Star' 
	GROUP BY Confluence, 
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;
	
	

--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM MorningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM MorningStarTSL
) Total
WHERE Confluence = 'Morning Star' 
	GROUP BY Confluence;
	
	

--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM MorningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM MorningStarTSL
) Total
WHERE Confluence = 'Morning Star' 
	GROUP BY Confluence;
	
	

--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM MorningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM MorningStarTSL
) Total
WHERE Confluence = 'Morning Star' 
	GROUP BY Confluence;
	
	

--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM MorningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM MorningStarTSL
) Total
WHERE Confluence = 'Morning Star' 
	GROUP BY Confluence;



--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM MorningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM MorningStarTSL
) Total
WHERE Confluence = 'Morning Star' 
	GROUP BY Confluence;



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Trending

--NUMBER OF TRENDING CONFLUENCES

SELECT Confluence,
       COUNT(Confluence) Trending
FROM AUDJPY
WHERE Confluence = 'Trending' 
	GROUP BY Confluence
	ORDER BY Trending DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF TRENDING OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Trending'
	GROUP BY Confluence,
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;



--USE CTE TO FIND PROFIT & NUMBER OF TRENDING OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Trending' 
	GROUP BY Confluence,
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;
	
	

--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM TrendingFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM TrendingTSL
) Total
WHERE Confluence = 'Trending' 
	GROUP BY Confluence;



--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM TrendingFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM TrendingTSL
) Total
WHERE Confluence = 'Trending' 
	GROUP BY Confluence;
	
	

--SMALLEST PROFIT

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM TrendingFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM TrendingTSL
) Total
WHERE Confluence = 'Trending' 
	GROUP BY Confluence;
	
	

--LARGEST PROFIT 

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM TrendingFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM TrendingTSL
) Total
WHERE Confluence = 'Trending' 
	GROUP BY Confluence;
	
	

--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM TrendingFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM TrendingTSL
) Total
WHERE Confluence = 'Trending' 
	GROUP BY Confluence;



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--B&R

--NUMBER OF B&R CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) BnR
FROM AUDJPY
WHERE Confluence = 'B&R' 
	GROUP BY Confluence
	ORDER BY BnR DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF B&R OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'B&R'
	GROUP BY Confluence,
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF B&R OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'B&R' 
	GROUP BY Confluence, 
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;
	
	

--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRTSL
) Total
WHERE Confluence = 'B&R'
	GROUP BY Confluence;
	
	
--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRTSL
) Total
WHERE Confluence = 'B&R'
	GROUP BY Confluence;
	
	

--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRTSL
) Total
WHERE Confluence = 'B&R'
	GROUP BY Confluence;
	
	
	
--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRTSL
) Total
WHERE Confluence = 'B&R'
	GROUP BY Confluence;
	
	

--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRTSL
) Total
WHERE Confluence = 'B&R'
	GROUP BY Confluence;
	
	
	
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--BEARISH ENGULFING 

--NUMBER OF BEARISH ENGULFING CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) BearEng, 
       SUM(ProfitLossFTP) TotalBearEngProfit
FROM AUDJPY
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence
	ORDER BY BearEng DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF BEARISH ENGULFING OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Bearish Engulfing'
	GROUP BY Confluence, 
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF BEARISH ENGULFING OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence, 
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;



--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngTSL
) Total
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence;
	
	

--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngTSL
) Total
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence;
	
	

--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngTSL
) Total
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence;
	
	

--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngTSL
) Total
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence;



--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngTSL
) Total
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence;



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--B&R w/ Bearish Engulfing

--NUMBER OF B&R W/ BEARISH ENGULFING CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) BnRBearEng
FROM AUDJPY
WHERE Confluence = 'B&R w/ Bearish Engulfing' 
	GROUP BY Confluence
	ORDER BY BnRBearEng DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF B&R W/ BEARISH ENGULFING OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
 	ProfitLossFTP,
 	COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'B&R w/ Bearish Engulfing'
	GROUP BY Confluence,
 		 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF B&R W/ BEARISH ENGULFING OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
 	ProfitLossTSL,
 	COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'B&R w/ Bearish Engulfing' 
	GROUP BY Confluence,
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;
	
	

--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBearEngTSL
) Total
WHERE Confluence = 'B&R w/ Bearish Engulfing' 
	GROUP BY Confluence;



--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBearEngTSL
) Total
WHERE Confluence = 'B&R w/ Bearish Engulfing' 
	GROUP BY Confluence;



--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBearEngTSL
) Total
WHERE Confluence = 'B&R w/ Bearish Engulfing' 
	GROUP BY Confluence;
	
	

--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBearEngTSL
) Total
WHERE Confluence = 'B&R w/ Bearish Engulfing' 
	GROUP BY Confluence;
	
	

--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBearEngTSL
) Total
WHERE Confluence = 'B&R w/ Bearish Engulfing' 
	GROUP BY Confluence;
	
	

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--B&R w/ Bearish Hammer

--NUMBER OF B&R W/ BEARISH HAMMER CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) BnRBearHammer
FROM AUDJPY
WHERE Confluence = 'B&R w/ Bearish Hammer' 
	GROUP BY Confluence
	ORDER BY BnRBearHammer DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF B&R W/ BEARISH HAMMER OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'B&R w/ Bearish Hammer'
	GROUP BY Confluence, 
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF B&R W/ BEARISH HAMMER OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'B&R w/ Bearish Hammer' 
	GROUP BY Confluence,
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;
	
	

--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBearHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBearHamTSL
) Total
WHERE Confluence = 'B&R w/ Bearish Hammer' 
	GROUP BY Confluence;
	
	

--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBearHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBearHamTSL
) Total
WHERE Confluence = 'B&R w/ Bearish Hammer' 
	GROUP BY Confluence;



--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBearHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBearHamTSL
) Total
WHERE Confluence = 'B&R w/ Bearish Hammer' 
	GROUP BY Confluence;



--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBearHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBearHamTSL
) Total
WHERE Confluence = 'B&R w/ Bearish Hammer' 
	GROUP BY Confluence;



--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBearHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBearHamTSL
) Total
WHERE Confluence = 'B&R w/ Bearish Hammer' 
	GROUP BY Confluence;



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--B&R w/ Bullish Engulfing, Continuation

--NUMBER OF B&R W/ BULLISH ENGULFING, CONTINUATION CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) BnRBullEngCont
FROM AUDJPY
WHERE Confluence = 'B&R w/ Bullish Engulfing, Continuation' 
	GROUP BY Confluence
	ORDER BY BnRBullEngCont DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF B&R W/ BULLISH ENGULFING, CONTINUATION OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'B&R w/ Bullish Engulfing, Continuation'
	GROUP BY Confluence, 
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;



--USE CTE TO FIND PROFIT & NUMBER OF B&R W/ BULLISH ENGULFING, CONTINUATION OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'B&R w/ Bullish Engulfing, Continuation' 
	GROUP BY Confluence, 
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;



--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBullEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBullEngContTSL
) Total
WHERE Confluence = 'B&R w/ Bullish Engulfing, Continuation'
	GROUP BY Confluence;
	
	

--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBullEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBullEngContTSL
) Total
WHERE Confluence = 'B&R w/ Bullish Engulfing, Continuation'
	GROUP BY Confluence;



--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBullEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBullEngContTSL
) Total
WHERE Confluence = 'B&R w/ Bullish Engulfing, Continuation'
	GROUP BY Confluence;
	
	

--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBullEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBullEngContTSL
) Total
WHERE Confluence = 'B&R w/ Bullish Engulfing, Continuation'
	GROUP BY Confluence;



--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBullEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBullEngContTSL
) Total
WHERE Confluence = 'B&R w/ Bullish Engulfing, Continuation'
	GROUP BY Confluence;
	
	

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--B&R w/ Bullish Hammer

--NUMBER OF B&R W/ BULLISH HAMMER CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) BnRBullHammer
FROM AUDJPY
WHERE Confluence = 'B&R w/ Bullish Hammer' 
	GROUP BY Confluence
	ORDER BY BnRBullHammer DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF B&R W/ BULLISH HAMMER OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'B&R w/ Bullish Hammer'
	GROUP BY Confluence,
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF B&R W/ BULLISH HAMMER OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'B&R w/ Bullish Hammer' 
	GROUP BY Confluence, 
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;
	
	

--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBullHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBullHamTSL
) Total
WHERE Confluence = 'B&R w/ Bullish Hammer' 
	GROUP BY Confluence;
	
	

--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBullHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBullHamTSL
) Total
WHERE Confluence = 'B&R w/ Bullish Hammer' 
	GROUP BY Confluence;



--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBullHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBullHamTSL
) Total
WHERE Confluence = 'B&R w/ Bullish Hammer' 
	GROUP BY Confluence;
	
	

--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBullHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBullHamTSL
) Total
WHERE Confluence = 'B&R w/ Bullish Hammer' 
	GROUP BY Confluence



--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRBullHamFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRBullHamTSL
) Total
WHERE Confluence = 'B&R w/ Bullish Hammer' 
	GROUP BY Confluence;
	
	

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--B&R, Morning Star

--NUMBER OF B&R, MORNING STAR CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) BnRMornStar
FROM AUDJPY
WHERE Confluence = 'B&R, Morning Star' 
	GROUP BY Confluence
	ORDER BY BnRMornStar DESC;



--USE CTE TO FIND PROFIT & NUMBER OF B&R, MORNING STAR OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'B&R, Morning Star'
	GROUP BY Confluence,
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF B&R, MORNING STAR OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,ProfitLossTSL,COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'B&R, Morning Star' 
	GROUP BY Confluence, 
         ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;
	
	

--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRMorningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRMorningStarTSL
) Total
WHERE Confluence = 'B&R, Morning Star' 
	GROUP BY Confluence;



--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRMorningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRMorningStarTSL
) Total
WHERE Confluence = 'B&R, Morning Star' 
	GROUP BY Confluence;
	
	

--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRMorningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRMorningStarTSL
) Total
WHERE Confluence = 'B&R, Morning Star' 
	GROUP BY Confluence;
	
	

--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRMorningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRMorningStarTSL
) Total
WHERE Confluence = 'B&R, Morning Star' 
	GROUP BY Confluence;



--AVERAGE PROFIT

SELECT Confluence,
       AVG(ProfitLossFTP) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BnRMorningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BnRMorningStarTSL
) Total
WHERE Confluence = 'B&R, Morning Star' 
	GROUP BY Confluence;



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--BEARISH ENGULFING 

--NUMBER OF BEARISH ENGULFING CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) BearEng
FROM AUDJPY
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence
	ORDER BY BearEng DESC;



--USE CTE TO FIND PROFIT & NUMBER OF BEARISH ENGULFING OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Bearish Engulfing'
	GROUP BY Confluence,
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF BEARISH ENGULFING OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence, 
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;
	
	

--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngTSL
) Total
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence;



--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngTSL
) Total
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence;
	
	

--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngTSL
) Total
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence;
	
	

--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngTSL
) Total
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence;
	
	

--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngTSL
) Total
WHERE Confluence = 'Bearish Engulfing' 
	GROUP BY Confluence;



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Bearish Engulfing, Continuation

--NUMBER OF BEARISH ENGULFING, CONTINUATION CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) BearEngCont
FROM AUDJPY
WHERE Confluence = 'Bearish Engulfing, Continuation' 
	GROUP BY Confluence
	ORDER BY BearEngCont DESC;



--USE CTE TO FIND PROFIT & NUMBER OF BEARISH ENGULFING, CONTINUATION OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Bearish Engulfing, Continuation'
GROUP BY Confluence, 
         ProfitLossFTP
--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF BEARISH ENGULFING, CONTINUATION OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Bearish Engulfing, Continuation' 
GROUP BY Confluence, 
         ProfitLossTSL
--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
WHERE Confluence = 'Bearish Engulfing, Continuation' 
	ORDER BY OutcomeFrequency DESC;



--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngContTSL
) Total
WHERE Confluence = 'Bearish Engulfing, Continuation' 
	GROUP BY Confluence;



--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngContTSL
) Total
WHERE Confluence = 'Bearish Engulfing, Continuation' 
	GROUP BY Confluence;



--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngContTSL
) Total
WHERE Confluence = 'Bearish Engulfing, Continuation' 
	GROUP BY Confluence;
	
	

--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngContTSL
) Total
WHERE Confluence = 'Bearish Engulfing, Continuation' 
	GROUP BY Confluence;



--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BearEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BearEngContTSL
) Total
WHERE Confluence = 'Bearish Engulfing, Continuation' 
	GROUP BY Confluence;



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Bullish Engulfing

--NUMBER OF BULLISH ENGULFING CONFLUENCES

SELECT Confluence,
       COUNT(Confluence) BullEng
FROM AUDJPY
WHERE Confluence = 'Bullish Engulfing' 
	GROUP BY Confluence
	ORDER BY BullEng DESC;



--USE CTE TO FIND PROFIT & NUMBER OF BULLISH ENGULFING OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Bullish Engulfing'
	GROUP BY Confluence, 
 	         ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF BULLISH ENGULFING OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Bullish Engulfing' 
	GROUP BY Confluence,
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;
	
	
	
--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullEngTSL
) Total
WHERE Confluence = 'Bullish Engulfing' 
	GROUP BY Confluence;
	
	

--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullEngTSL
) Total
WHERE Confluence = 'Bullish Engulfing' 
	GROUP BY Confluence;



--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullEngTSL
) Total
WHERE Confluence = 'Bullish Engulfing' 
	GROUP BY Confluence;
	
	

--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullEngTSL
) Total
WHERE Confluence = 'Bullish Engulfing' 
	GROUP BY Confluence;
	
	

--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullEngFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullEngTSL
) Total
WHERE Confluence = 'Bullish Engulfing' 
	GROUP BY Confluence;



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Bullish Engulfing, Continuation

--NUMBER OF BULLISH ENGULFING, CONTINUATION CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) BullEngCont
FROM AUDJPY
WHERE Confluence = 'Bullish Engulfing, Continuation' 
	GROUP BY Confluence
	ORDER BY BullEngCont DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF BULLISH ENGULFING, CONTINUATION OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Bullish Engulfing, Continuation'
	GROUP BY Confluence,
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF BULLISH ENGULFING, CONTINUATION OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Bullish Engulfing, Continuation' 
	GROUP BY Confluence, 
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;



--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullEngContTSL
) Total
WHERE Confluence = 'Bullish Engulfing, Continuation' 
	GROUP BY Confluence;



--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullEngContTSL
) Total
WHERE Confluence = 'Bullish Engulfing, Continuation' 
	GROUP BY Confluence;



--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullEngContTSL
) Total
WHERE Confluence = 'Bullish Engulfing, Continuation' 
	GROUP BY Confluence;



--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullEngContTSL
) Total
WHERE Confluence = 'Bullish Engulfing, Continuation' 
	GROUP BY Confluence;
	
	
	
--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM BullEngContFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM BullEngContTSL
) Total
WHERE Confluence = 'Bullish Engulfing, Continuation' 
	GROUP BY Confluence;
	
	

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Continuation

--NUMBER OF CONTINUATION CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) Cont
FROM AUDJPY
WHERE Confluence = 'Continuation' 
	GROUP BY Confluence
	ORDER BY Cont DESC;



--USE CTE TO FIND PROFIT & NUMBER OF CONTINUATION OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Continuation'
	GROUP BY Confluence,
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF CONTINUATION OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Continuation' 
	GROUP BY Confluence,
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;



--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM ContinuationFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM ContinuationTSL
) Total
WHERE Confluence = 'Continuation' 
	GROUP BY Confluence;
	
	

--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM ContinuationFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM ContinuationTSL
) Total
WHERE Confluence = 'Continuation' 
	GROUP BY Confluence;
	
	

--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM ContinuationFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM ContinuationTSL
) Total
WHERE Confluence = 'Continuation' 
	GROUP BY Confluence;



--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM ContinuationFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM ContinuationTSL
) Total
WHERE Confluence = 'Continuation' 
	GROUP BY Confluence;



--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM ContinuationFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM ContinuationTSL
) Total
WHERE Confluence = 'Continuation' 
	GROUP BY Confluence;
	
	

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Evening Star

--NUMBER OF EVENING STAR CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) EveningStar
FROM AUDJPY
WHERE Confluence = 'Evening Star' 
	GROUP BY Confluence
	ORDER BY EveningStar DESC;



--USE CTE TO FIND PROFIT & NUMBER OF EVENING STAR OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Evening Star'
	GROUP BY Confluence, 
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF EVENING STAR OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Evening Star' 
	GROUP BY Confluence, 
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;
	
	

--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
           ProfitLossFTP
    FROM EveningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM EveningStarTSL
) Total
WHERE Confluence = 'Evening Star' 
	GROUP BY Confluence;
	
	

--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM EveningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM EveningStarTSL
) Total
WHERE Confluence = 'Evening Star' 
	GROUP BY Confluence;
	
	

--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM EveningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM EveningStarTSL
) Total
WHERE Confluence = 'Evening Star' 
	GROUP BY Confluence;
	
	

--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM EveningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM EveningStarTSL
) Total
WHERE Confluence = 'Evening Star' 
	GROUP BY Confluence;
	
	

--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM EveningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM EveningStarTSL
) Total
WHERE Confluence = 'Evening Star' 
	GROUP BY Confluence;
	
	

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Morning Star

--NUMBER OF MORNING STAR CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) MorningStar
FROM AUDJPY
WHERE Confluence = 'Morning Star' 
	GROUP BY Confluence
	ORDER BY MorningStar DESC;



--USE CTE TO FIND PROFIT & NUMBER OF MORNING STAR OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Morning Star'
	GROUP BY Confluence,
                 ProfitLossFTP
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF MORNING STAR OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Morning Star' 
	GROUP BY Confluence, 
                 ProfitLossTSL
	--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;
	
	

--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM MorningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM MorningStarTSL
) Total
WHERE Confluence = 'Morning Star' 
	GROUP BY Confluence;



--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM MorningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM MorningStarTSL
) Total
WHERE Confluence = 'Morning Star' 
	GROUP BY Confluence;



--SMALLEST PROFIT 

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM MorningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM MorningStarTSL
) Total
WHERE Confluence = 'Morning Star' 
	GROUP BY Confluence;
	
	

--LARGEST PROFIT

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM MorningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM MorningStarTSL
) Total
WHERE Confluence = 'Morning Star' 
	GROUP BY Confluence;
	
	

--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM MorningStarFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM MorningStarTSL
) Total
WHERE Confluence = 'Morning Star' 
	GROUP BY Confluence;



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Trending

--NUMBER OF TRENDING CONFLUENCES

SELECT Confluence, 
       COUNT(Confluence) Trending
FROM AUDJPY
WHERE Confluence = 'Trending' 
	GROUP BY Confluence
	ORDER BY Trending DESC;



--USE CTE TO FIND PROFIT & NUMBER OF TRENDING OCCURENCES FTP

WITH FTP AS 
(SELECT Confluence,
        ProfitLossFTP,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Trending'
	GROUP BY Confluence, 
                 ProfitLossFTP
--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM FTP
	ORDER BY OutcomeFrequency DESC;
	
	

--USE CTE TO FIND PROFIT & NUMBER OF TRENDING OCCURENCES TSL

WITH TSL AS 
(SELECT Confluence,
        ProfitLossTSL,
        COUNT(Confluence) OutcomeFrequency
FROM AUDJPY
WHERE Confluence = 'Trending' 
	GROUP BY Confluence, 
         ProfitLossTSL
--ORDER BY OutcomeFrequency DESC
)
SELECT *
FROM TSL
	ORDER BY OutcomeFrequency DESC;



--PROFIT BEFORE SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) TotalProfitBeforeSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM TrendingFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM TrendingTSL
) Total
WHERE Confluence = 'Trending' 
	GROUP BY Confluence;



--PROFIT AFTER 70% SPLIT

SELECT Confluence,
       SUM(ProfitLossFTP) * 0.7 TotalProfitAfterSplit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM TrendingFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM TrendingTSL
) Total
WHERE Confluence = 'Trending' 
	GROUP BY Confluence;
	
	

--SMALLEST PROFIT

SELECT Confluence,
       MIN(ProfitLossFTP) SmallestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM TrendingFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM TrendingTSL
) Total
WHERE Confluence = 'Trending' 
	GROUP BY Confluence;



--LARGEST PROFIT 

SELECT Confluence,
       MAX(ProfitLossFTP) LargestProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM TrendingFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM TrendingTSL
) Total
WHERE Confluence = 'Trending' 
	GROUP BY Confluence;
	
	

--AVERAGE PROFIT

SELECT Confluence,
       ROUND(AVG(ProfitLossFTP),2) AverageProfit
FROM
(
    SELECT Confluence,
	   ProfitLossFTP
    FROM TrendingFTP
    UNION ALL
    SELECT Confluence,
	   ProfitLossTSL
    FROM TrendingTSL
) Total
WHERE Confluence = 'Trending' 
	GROUP BY Confluence;
	
	

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------







