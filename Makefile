PLUGIN_NAME:=$(basename $(notdir $(abspath .)))
SPEC_DIR:=./spec/lua/${PLUGIN_NAME}

test:
	vusted --shuffle
.PHONY: test

doc:
	rm -f ./doc/${PLUGIN_NAME}.nvim.txt
	nvim --headless -i NONE -n +"lua dofile('${SPEC_DIR}/doc.lua')" +"quitall!"
	cat ./doc/${PLUGIN_NAME}.nvim.txt
.PHONY: doc

vendor:
	nvim --headless -i NONE -n +"lua require('vendorlib').install('${PLUGIN_NAME}', '${SPEC_DIR}/vendorlib.lua')" +"quitall!"
.PHONY: vendor
