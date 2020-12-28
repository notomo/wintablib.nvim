test:
	vusted --shuffle
.PHONY: test

doc:
	nvim --headless -i NONE -n +"lua dofile('./spec/doc.lua')" +"quitall!"
	cat ./doc/wintablib.nvim.txt
.PHONY: doc
