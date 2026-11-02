SELECT MIN(OrderDate), MAX(OrderDate)
FROM Sales.SalesOrderHeader;

-- Pierwsza transakcja miała miejsce 31.05.2011, natomiast ostatnia 30.06.2014

WITH ilosc_zakupow AS(
SELECT COUNT(*) AS liczba_zakupow, CustomerId 
FROM Sales.SalesOrderHeader
GROUP BY CustomerId),

klienci AS(
SELECT 
	  SUM(CASE WHEN liczba_zakupow >=2 THEN 1 ELSE 0 END) AS liczba_klientow_powracajacych,
	  SUM(CASE WHEN liczba_zakupow = 1 THEN 1 ELSE 0 END) AS liczba_klientow_jednorazowych
FROM ilosc_zakupow)


SELECT 100.0*liczba_klientow_powracajacych/(NULLIF(liczba_klientow_powracajacych,0) + liczba_klientow_jednorazowych) AS procent_klientow_powracajacych,
100.0*liczba_klientow_jednorazowych/(NULLIF(liczba_klientow_powracajacych+ liczba_klientow_jednorazowych,0) AS procent_klientow_jednorazowych
FROM klienci

-- 7470 klientów (około 39%) w ogólności kupiło więcej niż raz
-- 11649 klientów (około 61%) dokonało jednorazowego zakupu

-- Podsumowanie każdego klienta

SELECT CustomerID, COUNT(*) AS liczba_zakupow, MIN(Orderdate) AS data_pierwszego_zakupu, MAX(Orderdate) AS data_ostatniego_zakupu,
	   SUM(subtotal) AS wartosc_zakupow, AVG(subtotal) AS srednia_zakupow
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY wartosc_zakupow DESC

-- Poprzednie zakupy

WITH poprzednie AS(
SELECT CustomerID, SalesOrderID, Orderdate, LAG(orderdate) OVER(PARTITION BY CustomerID ORDER BY orderdate, SalesOrderID) AS data_poprzedniego_zakupu
FROM Sales.SalesOrderHeader
ORDER BY CustomerID)

SELECT *, orderdate::DATE - data_poprzedniego_zakupu::DATE AS liczba_dni_pomiedzy
FROM poprzednie
ORDER BY CustomerID, OrderDate, SalesOrderID

-- Nowi klienci w danym miesiącu

WITH nowi_klienci AS(
SELECT CustomerID, MIN(OrderDate) AS pierwszy_zakup, TO_CHAR(MIN(OrderDate), 'yyyy-MM') AS rok_miesiac
FROM Sales.SalesOrderHeader
GROUP BY CustomerID)

SELECT rok_miesiac, COUNT(*) AS liczba_nowych_klientow
FROM nowi_klienci
GROUP BY rok_miesiac
ORDER BY rok_miesiac

-- Powracający klienci w danym miesiącu

WITH nowi_klienci AS(
SELECT CustomerID, MIN(OrderDate) AS pierwszy_zakup, TO_CHAR(MIN(OrderDate), 'yyyy-MM') AS rok_miesiac_pierwszy_zakup
FROM Sales.SalesOrderHeader
GROUP BY CustomerID),

zakupy AS(
SELECT n.CustomerID, n.pierwszy_zakup, n.rok_miesiac_pierwszy_zakup, TO_CHAR(s.OrderDate, 'yyyy-MM') AS miesiac_zakupu
FROM Sales.SalesOrderHeader s
JOIN nowi_klienci n
ON s.CustomerID = n.CustomerID
),

daty AS(
SELECT *
FROM zakupy
WHERE miesiac_zakupu > rok_miesiac_pierwszy_zakup)

SELECT miesiac_zakupu, COUNT(DISTINCT(customerid)) AS liczba_unikalnych_powracajacych
FROM daty
GROUP BY miesiac_zakupu
ORDER BY miesiac_zakupu

-- Segmentacja klientów

WITH podsumowanie AS(
SELECT CustomerID, COUNT(*) AS liczba_zakupow, MIN(Orderdate) AS data_pierwszego_zakupu, MAX(Orderdate) AS data_ostatniego_zakupu,
	   SUM(subtotal) AS wartosc_zakupow, AVG(subtotal) AS srednia_zakupow
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
),

segmentacja AS(
SELECT *,
	  CASE WHEN liczba_zakupow = 1 THEN 'Jednorazowy'
	  	   WHEN liczba_zakupow >=2 AND liczba_zakupow<= 3 THEN '2-3 zamówienia'
		   WHEN liczba_zakupow>= 4 THEN '4 lub więcej zamówień'
		   END AS segment
FROM podsumowanie)

SELECT segment, COUNT(*) AS liczba_klientow, SUM(wartosc_zakupow) AS laczna_wartosc_zakupow, AVG(wartosc_zakupow) AS srednia_laczna_wartosc_na_klienta
FROM segmentacja
GROUP BY segment;
