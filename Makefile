love=/Applications/love.app/Contents/MacOS/love

all: main

yak:
	@cp -r FEZ/YakManExample build/
	@cp -r FEZ/src build/YakManExample
	$(love) build/YakManExample

main:
	@cp -r engine build/
	#@cp -r FEZ/src build/engine
	@cp -r assets build/engine/
	$(love) build/engine

clean:
	@rm -rf build/*
