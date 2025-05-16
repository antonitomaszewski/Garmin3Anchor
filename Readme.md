# Alarm kotwiczny
1. Zapisujemy obecną pozycję (P0)
2. Zapisujemy długość wydanego łańcucha kotwicznego (eg. L = 10m)
3. Regularnie pobieramy obecną pozycję GPS (P1, ... , Pn)
4. Jeśli znajdujemy się poza obszarem okręgu (|Pn - P0| > L) włączamy alarm w zegarku
5. Ewentualnie: zaznaczanie wszystkich punktów P na mapie, ewentualnie pozwalamy przesunąć pozycję P0 jeśli widzimy że środek okręgu punktów P jest trochę gdzie indziej (bo źle ustawiliśmy P0). Adnotacja: dobrze żeby osoba rzucająca kotwicę zapisała pozycję (ktoś na dziobie, bo stąd rzucamy)




# NOTATKI

## Jak włączyć aplikację
Generowanie klucza
openssl genpkey -algorithm RSA -out private_key.pem -outform PEM -pkeyopt rsa_keygen_bits:4096
openssl pkcs8 -topk8 -inform PEM -outform DER -in private_key.pem -out private_key.der -nocrypt

Kompilacja
monkeyc -d fenix6xpro -f monkey.jungle -o bin/Garmin3Anchor.prg -y private_key.der

wrzucamy klucz tutaj: /home/atoma/Pulpit/antoni/garmin_keys/private_key.der


monkeyc -d fenix6xpro -f monkey.jungle -o bin/Aplikacja.prg -y /home/atoma/Pulpit/antoni/garmin_keys/private_key.der
connectiq & monkeydo bin/Aplikacja.prg fenix6xpro


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
monkeyc -d fenix6xpro -f monkey.jungle -o bin/Aplikacja.prg -y private_key.der
connectiq
monkeydo bin/Aplikacja.prg fenix6xpro
simulator & monkeydo bin/Aplikacja.prg fenix6xpro

monkeyc -d fenix6xpro -f monkey.jungle -o bin/Aplikacja.prg -y /home/atoma/Pulpit/antoni/garmin_keys/private_key.der & simulator & monkeydo bin/Aplikacja.prg fenix6xpro

### DEBUG
simulator & mdd
file bin/Aplikacja.prg bin/Aplikacja.prg.debug.xml fenix6xpro
break source/Garmin3AnchorMapView.mc:31

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

1. Mamy App:
tu praktycznie jedynie inicjalizujemy: getInitialView -> [View, Delegate]
2. Delegate: 
+ przechowuje zmienną prywatą widok
+ ma metodę onKey -> w zależności od przycisku wywołujemy inne metody na naszym widoku
+ onSelect -> co się dzieje, gdy naciśniemy enter (podobne do onKey)
+ zbędne dla ekranów nie dotykowych: onTap, onSwipe
3. View:
  +  Toybox.Attention.vibrate([(siła, czas), (siła2, czas2)])
  +  w ten sposób definiujemy cykl charakterystki wibrowania
  +  Attention.playTone(loadSong()) zawiera listę krotek: wysokość dźwięku i czas trwania - czyli nuty
  +  loadSong właśnie łąduje nuty z xml i przerabia na dźwięk do playTone

Podsumowanie:
udało mi się to potestować zarówno w symulatorze jak i moim zegarku: wystarczy podłączyć go przez usb i przenieść do folderu Garmin/APPS/
teraz nasza aplikacja będzie się znajdować na dole listy
w fenix 6x pro ani nie ma backlight, ani nie ma tone, jedynie proste wibracje. Nie rozumiem tego, ale nie będziemy narazie się zagrzebywać w te szczegóły.

### Anchor
Plan na kotwice
1. App - główna aplikacja, wywołuje MenuView - żebyśmy mogli od razu ustawić pozycję.
   1. Ma metodę getInitialView -> [new MenuView, new MenuDelegate]
2. MenuView
   1. Set Anchor location - gdy to się kliknie to obecna pozycja zostaje zapisana
   2. Set anchorchain length -> przekierowuje do ustawienia wartości liczbowej
   3. alarm settings
   4. settings
3. MapView
   1. wyświetla mapę (środek w P0, przybliżenie: chainlength * 1.5)
   2. wyświetla punkt P0 na czarno
   3. wyświetla punkty P1...Pn-1 na zielono
   4. wyświetla punkt Pn na niebiesko
   5. wyświetla okrąg |P0 - chainlength| na zielono
4. AnchorChainView
   1. ekran wyboru liczby

Ikony pobieram z https://www.flaticon.com/search?word=circle jako pliki .png

Mamy mieć stos widoków
zawsze na dole stosu jest widok główny (czyli w naszym przypadku mapa)
i do to niej wracamy klikając wstecz
Należy PushView(new view, new delegate(view)) -> PopView() itd

### PositionSample
przetestowałem te aplikację, jest bardzo prosta.
1. APP
   1. onStart - włączamy lokalizację
   2. onStop - wyłączamy
   3. onPosition - wywołujemy ustawianie lokalizacji w Widoku (do tego potrzebujemy mieć zmienną prywatną _positionView, którą inicjalizujemy w initialize)
   4. getInitialView - zwracamy _positionView, tym razem bez delegata (bo nic się tam nie dzieje)
2. PositionSampleView
   1. _lines - tablica, w której trzymamy obecne informacje do wyświetlenia
   2. initialize - ustawiamy "No Position info" jako startowe dane w _lines
   3. onUpdate - przerysowanie na nowo widoku (z użyciem _lines)
   4. setPosition - nasza własna metoda, która pozwala wypełnić tablicę _lines z danymi z najnowszej pozycji
3. Przez to że nie mamy delegata, ani żadnych ustawień to nie mamy kontroli nad :
   1.  tym co wyświetlamy (interesujące nas dane)
   2.  jakich używamy jednostek
4. uwaga do przyszłego rozważenia: mamy funkcję: Heading - z jej pomocą moglibyśmy ustawiać docelowo pozycję kotwicy: Heading + odległość do punktu z zrzutu (czyli np. gdy stoimy za sterem jako kapitan)