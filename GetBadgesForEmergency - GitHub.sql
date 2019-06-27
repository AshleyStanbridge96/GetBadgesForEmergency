  WITH BI AS
(
--This CTE is taking an employee's card number and their employee number then joining the two
  SELECT BADGE_C.CARDNO, BADGE_V.BADGE_EMPLOYEE_NO
  FROM BADGE_V 
  INNER join BADGE_C ON BADGE_C.ID = BADGE_V.ID
),
empScans as 
(
--This CTE is primarily selecting the information needed for the report
select evnt_dat, location, CARDNO, fname, lname, PANEL_DESCRP
from EV_LOG
where(EV_LOG.[EVNT_DAT] > GETDATE() - 1)
and (EVNT_DAT is not null)
and (LNAME is not null)
and (upper (PANEL_DESCRP) like 'Pel%')
group by CARDNO, LOCATION, fname, lname, EVNT_DAT, PANEL_DESCRP
)
--This query is tying the CTE's together. There is a subquery for evnt_dat to select the most recent employee scan on the selected
--date range
select * from empScans
inner join BI on BI.cardno = empScans.CARDNO
where (evnt_dat = (select max(evnt_dat) from empScans where empScans.CARDNO = BI.CARDNO
and evnt_dat > '20190625 06:00:00'	--Start Date
and evnt_dat < '20190625 17:00:00')) --End Date
order by lname asc
