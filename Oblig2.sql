-- Oppgave 2
--a
SELECT *
FROM timelistelinje t
WHERE t.timelistenr = 3;


--b
SELECT COUNT(*)
FROM timeliste;

--c
SELECT COUNT(*)
FROM timeliste t
WHERE t.utbetalt IS NULL; --Denne sjekker bare de som ikke er utbetalt.

SELECT COUNT(*)
FROM timeliste t
WHERE t.levert IS NOT NULL AND t.utbetalt IS NULL; -- Denne sikrer også at timelisten er gyldig (levert).


--D
SELECT COUNT(*)
FROM timelistelinje
UNION
SELECT COUNT(pause)
FROM timelistelinje t
WHERE t.pause IS NOT NULL; --Denne gav udelikat output.

SELECT COUNT(*) AS antall, COUNT(pause) AS antallmedpause
FROM timelistelinje; --Denne gir output likt obligteksten


--E
SELECT *
FROM timelistelinje t
WHERE t.pause IS NULL;


--Oppgave 3
--A
SELECT SUM(varighet)/60 AS ikkeUtbetalt
FROM timeliste t
INNER JOIN varighet
ON t.timelistenr = varighet.timelistenr
WHERE t.levert IS NOT NULL AND t.utbetalt IS NULL;


--B
SELECT DISTINCT t.timelistenr, t.beskrivelse
FROM timeliste t
INNER JOIN timelistelinje tll
ON t.timelistenr = tll.timelistenr
WHERE tll.beskrivelse LIKE '%test%' or tll.beskrivelse LIKE '%Test%';


--C
SELECT SUM(varighet)*200 as utbetalt
FROM timeliste t
INNER JOIN varighet v
ON t.timelistenr = v.timelistenr
WHERE t.levert IS NOT NULL AND t.utbetalt IS NOT NULL;


--Oppgave 4
--A
/*De to spørringene gir ikke likt svar fordi INNER JOIN slår sammen tabellene der timelistenr er like,
mens NATURAL JOIN slår sammen de kolonnene som har identisk timelistenr og beskrivelse.*\

--B
/*Den første spørringen joiner timeliste med viewet varighet på relasjnen timelistenr.
Den andre legger sammen kolonner med sammen innhold, derfor gir de likt svar.*\
