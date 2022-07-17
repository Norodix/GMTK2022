name = DiceDash

zips = $(name)_HTML5.zip $(name)_Linux.zip $(name)_Windows.zip

%.zip: %
	zip -r $@ $(basename $@)

all: $(zips)
