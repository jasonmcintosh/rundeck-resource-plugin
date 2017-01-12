
all: clean zip

clean:
	rm -rf dist
	mkdir dist
zip: 
	mkdir -p dist/acquire-resource-plugin	
	cp -r acquire-resource-plugin/* dist/acquire-resource-plugin
	(cd dist; zip -r acquire-resource-plugin.zip acquire-resource-plugin)
	mkdir -p dist/release-resource-plugin	
	cp -r release-resource-plugin/* dist/release-resource-plugin		
	(cd dist; zip -r release-resource-plugin.zip release-resource-plugin)

check-env:
ifndef RDECK_BASE
    $(error RDECK_BASE is undefined)
endif

install: zip check-env
	cp dist/acquire-resource-plugin.zip $(RDECK_BASE)/libext/
	cp dist/release-resource-plugin.zip $(RDECK_BASE)/libext/
