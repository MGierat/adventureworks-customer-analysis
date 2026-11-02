# AdventureWorks - analiza klientów i powracających zakupów

## Cel: 

Celem projektu jest analiza powracających zakupów klientów AdventureWorks oraz określenie, które segmenty klientów odpowiadają za największą część wartości zamówień. Raport porównuje również zachowania zakupowe sklepów i klientów indywidualnych oraz przedstawia miesięczne zmiany liczby nowych i powracających klientów.

## Narzędzia: 

PostgreSQL, pgAdmin, Power BI, DAX

## Zakres pracy:

- przygotowanie i wstepna analiza danych w SQL
- utworzenie dwóch widoków w SQL w celi dalszej analizy w PowerBI
- zbudowanie modelu danych z relacjami jeden do wielu
- utworzenie miar DAX oraz tabeli kalendarza
- przygotowanie dwóch stron raportu: analizy miesięcznej i segmentacji klientów.

## Najważniejsze wnioski:

- klienci jednorazowi stanowią około 60,9% wszystkich klientów
- segment z co najmniej czterema zamówieniami stanowi około 4,1% klientów i odpowiada za 73,8% wartości zamówień
- Struktura segmentów wyraźnie różni się w zależności od typu klienta. Wśród sklepów przeważają klienci z co najmniej czterema zamówieniami (około 86,3%), a wśród klientów indywidualnych — klienci jednorazowi (około 62,9%). 

## Definicje i ograniczenia

- W raporcie dane pochodzą z okresu 31.05.2011 – 30.06.2014. Należy zaznaczyć więc, że dane z lat 2011 i 2014 są niepełne.
- Przynależność klienta do segmentu jest stała i dobrana na podstawie całej dostępnej historii. Nie zmienia się w zależności od użytego filtra
- Klient jednorazowy oznacza osobę lub sklep z dokładnie jednym zamówieniem w całej dostępnej historii
- Wartość zamówienia jest obliczana z kolumny subtotal, czyli wartości bez podatku i kosztów transportu
- Odstępy obliczono między kolejnymi zamówieniami tego samego klienta, a pierwsze zamówienie nie ma poprzedzającego odstępu.
- Nowy klient to klient, którego pierwszy zakup w dostępnych danych przypada na analizowany miesiąc.
- Klient powracający to klient aktywny w analizowanym miesiącu, który dokonał pierwszego zakupu wcześniej.
- Filtry zmieniają wyniki prezentowane dla segmentów, ale nie zmieniają przypisania klienta do segmentu.

## Zawartość folderu

- Dokumentacja - Opis celu, przygotowania danych, miar, wniosków i ograniczeń
- PowerBI - Główny raport
- SQL - pliki ze wstępną analizą danych oraz przygotowanymi widokami
- Zrzuty - Zrzuty ekranu z dashboardu PowerBI - modelu relacji oraz dwóch stron raportu.

## Uruchomienie projektu

Raport .pbix zawiera zaimportowane dane i można go przeglądać w Power BI Desktop. Odświeżenie danych wymaga bazy AdventureWorks w PostgreSQL, utworzenia widoków ze skryptu 02_widoki.sql oraz skonfigurowania własnego połączenia z bazą. Zapytania analityczne korzystające z widoków należy uruchamiać po ich utworzeniu.
