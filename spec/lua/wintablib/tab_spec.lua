local helper = require("wintablib/lib/testlib/helper")
local wintablib = require("wintablib.tab")

describe("close_left()", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("does nothing if there is no left tab", function()
    wintablib.close_left()

    assert.tab_count(1)
  end)

  it("closes the all left tab", function()
    vim.cmd("tabedit")
    vim.cmd("tabedit")

    wintablib.close_left()

    assert.tab_count(1)
  end)
end)

describe("close_right()", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("does nothing if there is no right tab", function()
    wintablib.close_right()

    assert.tab_count(1)
  end)

  it("closes the all right tab", function()
    vim.cmd("tabedit")
    vim.cmd("tabedit")
    vim.cmd("tabfirst")

    wintablib.close_right()

    assert.tab_count(1)
  end)
end)

describe("close()", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("closes the current tab", function()
    vim.cmd("tabedit")
    vim.cmd("tabedit")
    vim.cmd("tabprevious")

    wintablib.close()

    assert.tab_count(2)
    assert.tab(1)
  end)
end)

describe("scratch()", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("opens a new scratch tab", function()
    wintablib.scratch()

    assert.tab_count(2)
  end)
end)

describe("line()", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("returns for tabline format string", function()
    vim.cmd("edit tab1")
    vim.cmd("split")

    vim.cmd("tabedit tab2")

    vim.cmd("tabedit")

    local line = wintablib.line()
    assert.is_same("%1T%#TabLine# tab1[2] %T%#TabLineFill#%2T%#TabLine# tab2 %T%#TabLineFill#%3T%#TabLineSel# NONE %T%#TabLineFill#%#TabLineFill#%T", line)
  end)
end)

describe("activate_left_on_closed()", function()

  before_each(helper.before_each)
  after_each(function()
    vim.cmd("autocmd! wintablib_activate_left")
    helper.after_each()
  end)

  it("activates left tab on tabclose", function()
    wintablib.activate_left_on_closed()

    vim.cmd("tabedit")
    vim.cmd("tabedit")
    vim.cmd("tabprevious")
    vim.cmd("tabclose")

    helper.wait()
    assert.tab(1)
  end)

  it("does not activate left tab on tabonly", function()
    wintablib.activate_left_on_closed()

    vim.cmd("edit tab1")
    vim.cmd("tabedit tab2")
    vim.cmd("tabedit tab3")
    vim.cmd("tabprevious")
    vim.cmd("tabonly")

    helper.wait()
    assert.buffer_name("tab2")
  end)

  it("does nothing on the last tab closed", function()
    wintablib.activate_left_on_closed()

    vim.cmd("tabedit")
    vim.cmd("tabclose")

    helper.wait()
    assert.tab(1)
  end)

  it("does nothing if current tab is the first", function()
    wintablib.activate_left_on_closed()

    vim.cmd("tabedit")
    vim.cmd("tabedit")
    vim.cmd("tabfirst")
    vim.cmd("tabclose")

    helper.wait()
    assert.tab(1)
  end)

end)
