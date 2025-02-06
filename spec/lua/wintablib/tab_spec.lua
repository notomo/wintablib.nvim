local helper = require("wintablib.test.helper")
local wintablib = require("wintablib.tab")
local assert = require("assertlib").typed(assert)

describe("close_left()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("does nothing if there is no left tab", function()
    wintablib.close_left()

    assert.tab_count(1)
  end)

  it("closes the all left tab", function()
    vim.cmd.tabedit()
    vim.cmd.tabedit()

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
    vim.cmd.tabedit()
    vim.cmd.tabedit()
    vim.cmd.tabfirst()

    wintablib.close_right()

    assert.tab_count(1)
  end)
end)

describe("close()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("closes the current tab", function()
    vim.cmd.tabedit()
    vim.cmd.tabedit()
    vim.cmd.tabprevious()

    wintablib.close()

    assert.tab_count(2)
    assert.tab_number(1)
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
