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

describe("activate_left_on_closed()", function()
  before_each(helper.before_each)
  after_each(function()
    local ok, err = pcall(vim.api.nvim_clear_autocmds, { group = "wintablib_activate_left" })
    if not ok and not vim.startswith(err, "invalid augroup: ") then
      error(err)
    end
    helper.after_each()
  end)

  it("activates left tab on tabclose", function()
    wintablib.activate_left_on_closed()

    vim.cmd.tabedit()
    vim.cmd.tabedit()
    vim.cmd.tabprevious()
    vim.cmd.tabclose()

    assert.tab(1)
  end)

  it("does not activate left tab on tabonly", function()
    wintablib.activate_left_on_closed()

    vim.cmd.edit("tab1")
    vim.cmd.tabedit("tab2")
    vim.cmd.tabedit("tab3")
    vim.cmd.tabprevious()
    vim.cmd.tabonly()

    assert.buffer_name("tab2")
  end)

  it("does nothing on the last tab closed", function()
    wintablib.activate_left_on_closed()

    vim.cmd.tabedit()
    vim.cmd.tabclose()

    assert.tab(1)
  end)

  it("does nothing if current tab is the first", function()
    wintablib.activate_left_on_closed()

    vim.cmd.tabedit()
    vim.cmd.tabedit()
    vim.cmd.tabfirst()
    vim.cmd.tabclose()

    assert.tab(1)
  end)

  it("does nothing if previous tab is closed", function()
    wintablib.activate_left_on_closed()

    vim.cmd.tabedit()
    vim.cmd.tabedit()
    vim.cmd.tabclose({ range = { vim.fn.tabpagenr() - 1 } })

    assert.tab(2)
  end)
end)
