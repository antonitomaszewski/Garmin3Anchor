PRODUCT ?= fenix6xpro
PRG_FILE ?= bin/Garmin3Anchor.prg

build:
	monkeyc -d $(PRODUCT) -f monkey.jungle -o $(PRG_FILE) -y private_key.der -w — debug-log-level=3
	monkeydo $(PRG_FILE) $(PRODUCT) -a “myapp-settings.json:GARMIN/Settings/myapp-settings.json”

publish:
	rm -rf bin/
	mkdir bin/
	monkeyc -f monkey.jungle -o ./bin/ myapp.iq -y private_key.der -e -r -w -O=3z

release: clean publish

clean:
	rm -rf gen/*
	rm -f myapp.prg
	rm -f myapp.prg.debug.xml


# PRODUCT ?= fenix6xpro
# PRG_FILE ?= bin/Garmin3Anchor.prg

# build:
#     monkeyc -d $(PRODUCT) -f monkey.jungle -o $(PRG_FILE) -y private_key.der --debug

# run: build
#     monkeydo $(PRG_FILE) $(PRODUCT)

# publish: build
#     @echo "Aplikacja zbudowana w $(PRG_FILE)"

# release: clean publish

# clean:
#     rm -rf bin/*
#     rm -rf gen/*