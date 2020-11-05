-- Oppgave 1
SELECT filmcharacter, COUNT(filmcharacter)
FROM filmcharacter
GROUP BY filmcharacter
HAVING COUNT(*) > 2000
ORDER BY COUNT(*) DESC; --DESC = descending


-- Oppgave 2
--a
SELECT f.title, f.prodyear
FROM film f
  INNER JOIN filmparticipation fp ON (f.filmid = fp.filmid)
  INNER JOIN person p ON (fp.personid = p.personid)
WHERE p.firstname = 'Stanley' AND p.lastname = 'Kubrick' AND fp.parttype = 'director'
ORDER BY f.prodyear DESC; --Sorterer etter produksjonsår for ordens skyld

--b
SELECT f.title, f.prodyear
FROM film f
  NATURAL JOIN filmparticipation fp
  NATURAL JOIN person p
WHERE p.firstname = 'Stanley' AND p.lastname = 'Kubrick' AND fp.parttype = 'director'
ORDER BY f.prodyear DESC;

--c
SELECT f.title, f.prodyear
FROM film f, filmparticipation fp, person p
WHERE f.filmid = fp.filmid AND fp.personid = p.personid
AND p.firstname = 'Stanley' AND p.lastname = 'Kubrick' AND fp.parttype = 'director'
ORDER BY f.prodyear DESC;


--Oppgave 3
SELECT p.personid, p.firstname || ' ' || p.lastname AS navn, f.title, fch.filmcharacter, c.country
FROM filmparticipation fp
  INNER JOIN person p ON (fp.personid = p.personid)
  INNER JOIN filmcharacter fch ON (fp.partid = fch.partid)
  INNER JOIN filmcountry c ON (fp.filmid = c.filmid)
  INNER JOIN film f ON (fp.filmid = f.filmid)
WHERE p.firstname = 'Ingrid' AND fch.filmcharacter = 'Ingrid';


--Oppgave 4
SELECT f.filmid, f.title, COUNT(fg.genre) AS Sjangre
FROM film f
  LEFT JOIN filmgenre fg ON (f.filmid = fg.filmid)
WHERE f.title LIKE '%Antonie%'
GROUP BY f.filmid, f.title;


--Oppgave 5
SELECT f.title, fp.parttype, COUNT(fp.parttype) AS antDeltagere
FROM filmparticipation fp
NATURAL JOIN film f
NATURAL JOIN filmitem fi
WHERE f.title LIKE '%Lord of the Rings%' AND fi.filmtype LIKE 'C'
GROUP BY f.title, fp.parttype;


--Oppgave 6
SELECT f.title, f.prodyear
FROM film f
WHERE prodyear = (
  SELECT MIN(prodyear)
  FROM film f
);


--Oppgave 7
SELECT f.title, f.prodyear
FROM film f, filmgenre fg, filmgenre fg2
WHERE f.filmid = fg.filmid AND fg.filmid = fg2.filmid
AND fg.genre = 'Film-Noir' AND fg2.genre = 'Comedy';


--Oppgave 8
SELECT f.title, f.prodyear
FROM film f
WHERE prodyear = (
  SELECT MIN(prodyear)
  FROM film f
)

UNION ALL

SELECT f.title, f.prodyear
FROM film f, filmgenre fg, filmgenre fg2
WHERE f.filmid = fg.filmid AND fg.filmid = fg2.filmid
AND fg.genre = 'Film-Noir' AND fg2.genre = 'Comedy';


--Oppgave 9
SELECT f.title, f.prodyear
FROM film f
  INNER JOIN filmparticipation fp ON (f.filmid = fp.filmid)
  INNER JOIN person p ON (fp.personid = p.personid)
WHERE p.firstname = 'Stanley' AND p.lastname = 'Kubrick' AND fp.parttype = 'director'

INTERSECT

SELECT f.title, f.prodyear
FROM film f
  INNER JOIN filmparticipation fp ON (f.filmid = fp.filmid)
  INNER JOIN person p ON (fp.personid = p.personid)
WHERE p.firstname = 'Stanley' AND p.lastname = 'Kubrick' AND fp.parttype = 'cast';


--Oppgave 10
SELECT s.maintitle
FROM filmrating fr
  INNER JOIN series s ON (fr.filmid = s.seriesid)
WHERE fr.votes > 1000 AND fr.rank = (
  SELECT MAX(fr.rank)
  FROM filmrating fr
  WHERE fr.votes > 1000
);


--Oppgave 11
SELECT DISTINCT fc.country AS Land
FROM filmcountry fc
GROUP BY fc.country
HAVING COUNT(fc.country) = 1;


--Oppgave 12
WITH unikRolle AS(
  SELECT *
  FROM(
    SELECT filmcharacter, COUNT(*)  --unikRolle lager en tabell med alle karakterer som forekommer en gang
    FROM filmcharacter
    GROUP BY filmcharacter
    HAVING COUNT(*) = 1
  )
  AS unikChar, filmcharacter AS fChar
  WHERE unikChar.filmcharacter = fChar.filmcharacter
)

SELECT firstname ||' '|| lastname AS navn, COUNT(*) AS antUnikRolle
FROM person
NATURAL JOIN filmparticipation
NATURAL JOIN unikRolle
GROUP BY navn
HAVING COUNT(*) > 199
ORDER BY antUnikRolle;


--Oppgave 13
SELECT firstname ||' '|| lastname as navn
FROM film
NATURAL JOIN filmparticipation
NATURAL JOIN filmrating
NATURAL JOIN person
WHERE parttype LIKE 'director' AND votes > 60000
GROUP BY navn

EXCEPT

SELECT firstname ||' '|| lastname as navn
FROM film
NATURAL JOIN filmparticipation
NATURAL JOIN filmrating
NATURAL JOIN person
WHERE parttype LIKE 'director' AND votes > 60000 AND rank < 8
GROUP BY navn;
