-- Widok klientów: podsumowanie zakupów, segment i typ klienta
CREATE OR REPLACE VIEW public.klienci_analiza AS
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

SELECT k.*, 
CASE WHEN c.storeid IS NOT NULL THEN 'Sklep'
	 WHEN c.personid IS NOT NULL THEN 'Klient indywidualny'
	 ELSE 'Nieustalono'
	 END AS typ_klienta
FROM segmentacja k
LEFT JOIN sales.customer c
ON k.CustomerID = c.CustomerID;

-- Widok zamówień: poprzedni zakup i odstęp między zakupami

CREATE VIEW public.zamowienia_analiza AS
WITH poprzednie AS(
SELECT CustomerID, SalesOrderID, SubTotal, Orderdate, LAG(orderdate) OVER(PARTITION BY CustomerID ORDER BY orderdate, SalesOrderID) AS data_poprzedniego_zakupu
FROM Sales.SalesOrderHeader
ORDER BY CustomerID)

SELECT
    CustomerID,
    SalesOrderID,
    OrderDate::date AS data_zamowienia,
    SubTotal,
    data_poprzedniego_zakupu::date AS data_poprzedniego_zakupu,
    OrderDate::date - data_poprzedniego_zakupu::date AS liczba_dni_pomiedzy
FROM poprzednie
ORDER BY CustomerID, OrderDate, SalesOrderID;

