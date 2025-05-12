# Alarm kotwiczny
1. Zapisujemy obecną pozycję (P0)
2. Zapisujemy długość wydanego łańcucha kotwicznego (eg. L = 10m)
3. Regularnie pobieramy obecną pozycję GPS (P1, ... , Pn)
4. Jeśli znajdujemy się poza obszarem okręgu (|Pn - P0| > L) włączamy alarm w zegarku
5. Ewentualnie: zaznaczanie wszystkich punktów P na mapie, ewentualnie pozwalamy przesunąć pozycję P0 jeśli widzimy że środek okręgu punktów P jest trochę gdzie indziej (bo źle ustawiliśmy P0). Adnotacja: dobrze żeby osoba rzucająca kotwicę zapisała pozycję (ktoś na dziobie, bo stąd rzucamy)




# NOTATKI
Generowanie klucza
openssl genpkey -algorithm RSA -out private_key.pem -outform PEM -pkeyopt rsa_keygen_bits:4096
openssl pkcs8 -topk8 -inform PEM -outform DER -in private_key.pem -out private_key.der -nocrypt

Kompilacja
monkeyc -d fenix6xpro -f monkey.jungle -o bin/Garmin3Anchor.prg -y private_key.der


przydatny artykuł, udało mi się dojść do punktu 3 z sukcesem:
https://medium.com/@bgallois/garmin-app-development-without-the-visual-studio-code-85628e4b6ba1


## Przykłady APLIKACJI

### Folder z przykładami
/home/atoma/.Garmin/ConnectIQ/Sdks/connectiq-sdk-lin-8.1.1-2025-03-27-66dae750f/samples/

Tu kolejność działań, ażeby puścić aplikację
(może być trzeba dodać fenix6xpro do manifestu)

cd /home/atoma/.Garmin/ConnectIQ/Sdks/connectiq-sdk-lin-8.1.1-2025-03-27-66dae750f/samples/MapSample
mkdir bin
openssl genpkey -algorithm RSA -out private_key.pem -outform PEM -pkeyopt rsa_keygen_bits:4096
openssl pkcs8 -topk8 -inform PEM -outform DER -in private_key.pem -out private_key.der -nocrypt
monkeyc -d fenix6xpro -f monkey.jungle -o bin/MapSample.prg -y private_key.der
connectiq
monkeydo bin/MapSample.prg fenix6xpro

### MapSample
To jest bardzo przydatny projekt
MapView.setPolyline(polyline) - rysuje linie łączące zadane punkty (to dla mnie nie aż tak przydatne chyba)
MapView.setMapMarker(map_markers) - rysuje znaczniki do danych pozycji (to zajmuje bardzo dużo miejsca)
Trzeba dodatkowo ustawić:
+ MapView.setMapVisibleArea - zakres mapy
+ MapView.setScreenVisibleArea - zakres widoczności naszego zegarka, tu wchodzi w grę wielkość ekranu

MapTrackView  - to się przydaje, jeśli chcemy centrować się na naszej pozycji. Ja bym preferował żeby się centrować na pozycji kotwicy, wtedy idealnie to będzie się wyświetlać bo zegarki są okrągłe   

W App definiujemy funkcję getInitialView - to nam mówi co zobaczymy na początku: u nas to powinien być widok: ustaw pozycję kotwicy. W rzeczywistości u nich App jedynie się inicjalizuje i wywołuje pierwszy widok, od którego dopiero zaczyna się nasz program

Wychodzi także tak, że dowolny widok, dla którego chcemy mieć jakieś funkcjonalności potrzebuje mieć swojego delegata.
Struktura plików jest następująca:
+ App - główny projekt
+ View1 (+? Delegate)
+ ...
+ ViewN (+? Delegate)

Dlatego że w naszej aplikacji MapSample nie mamy delegata dla TrackView, to tak naprawdę nie jesteśmy w stanie nic już z tej pozycji przełączać (trochę tak chcemy, gdy ustawimy pozycję kotwicy i długość łańcucha, chcemy mieć też wycentrowany ekran na P0, a pozostałe punkty Pi powinny być zaznaczone delikatnymi kropkami)
w TrackView jesteśmy w stanie przybliżać i oddalać: bo to jest "Mapa". Robimy to wciskając przycisk PG (Prawy górny)
Gdy kliknąłem w widoku TrackView PD (cofanie) to mimo że nie ma zaimplementowanego delegata OnBack to wykonało się poprawnie - przekierowało nas do widoku Menu. Dodatkowo widok Menu teraz jest wycentrowany na pozycji TrackView

wygląd ikon możemy załadować tak: marker.setIcon(WatchUi.loadResource(...))
W takim razie moglibyśmy pewnie załadować pojedyncze delikatne kropki
Naszą obecną pozycję powinniśmy zawsze oznaczać w sposób specyficzny (np. P0 -  czarny X, P1...Pi-1 zielone koło, Pi - zielony okrąg)


### Attention