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

### Folder z przykładami
/home/atoma/.Garmin/ConnectIQ/Sdks/connectiq-sdk-lin-8.1.1-2025-03-27-66dae750f/samples/
