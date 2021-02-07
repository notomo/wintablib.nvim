local helper = require("wintablib/lib/testlib/helper")
local wintablib = require("wintablib.window")

describe("from_left_tab()", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("does nothing if there is no left tab", function()
    wintablib.from_left_tab()

    assert.tab_count(1)
    assert.window_count(1)
  end)

  it("opens left tab window in the current tab", function()
    helper.input("target")
    vim.cmd("tabedit")

    wintablib.from_left_tab()

    assert.tab_count(1)
    assert.window_count(2)
    assert.no.exists_pattern("target")

    vim.cmd("wincmd w")
    assert.exists_pattern("target")
  end)
end)

describe("from_right_tab()", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("does nothing if there is no right tab", function()
    wintablib.from_right_tab()

    assert.tab_count(1)
    assert.window_count(1)
  end)

  it("opens right tab window in the current tab", function()
    vim.cmd("tabedit")
    helper.input("target")
    vim.cmd("tabprevious")

    wintablib.from_right_tab()

    assert.tab_count(1)
    assert.window_count(2)
    assert.no.exists_pattern("target")

    vim.cmd("wincmd w")
    assert.exists_pattern("target")
  end)
end)

describe("from_alt()", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("opens alternative buffer in the current tab", function()
    vim.cmd("new")
    vim.cmd("only")

    wintablib.from_alt()

    assert.tab_count(1)
    assert.window_count(2)
  end)
end)

describe("to_left_tab()", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("does nothing if there is no splitted window", function()
    wintablib.from_left_tab()

    assert.tab_count(1)
    assert.window_count(1)
  end)

  it("opens the current window in the left tab", function()
    vim.cmd("vnew")
    helper.input("target")

    wintablib.to_left_tab()

    assert.tab_count(2)
    assert.window_count(1)
    assert.exists_pattern("target")

    vim.cmd("tabnext")
    assert.window_count(1)
    assert.no.exists_pattern("target")
  end)
end)

describe("to_right_tab()", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("does nothing if there is no splitted window", function()
    wintablib.from_right_tab()

    assert.tab_count(1)
    assert.window_count(1)
  end)

  it("opens the current window in the left tab", function()
    vim.cmd("vnew")
    helper.input("target")

    wintablib.to_right_tab()

    assert.tab_count(2)
    assert.window_count(1)
    assert.exists_pattern("target")

    vim.cmd("tabprevious")
    assert.window_count(1)
    assert.no.exists_pattern("target")
  end)
end)

describe("duplicate_as_right_tab()", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("duplicates the current window in the right tab", function()
    vim.cmd("vnew")
    helper.input("target")
    vim.cmd("normal! $")
    local pos = vim.api.nvim_win_get_cursor(0)

    wintablib.duplicate_as_right_tab()

    assert.tab_count(2)
    assert.window_count(1)
    assert.exists_pattern("target")
    assert.cursor(pos)

    vim.cmd("tabprevious")
    assert.window_count(2)
    assert.exists_pattern("target")
  end)
end)

describe("close_floating()", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("closes all floating windows", function()
    vim.cmd("vsplit")
    vim.api.nvim_open_win(0, true, {
      width = 10,
      height = 10,
      relative = "editor",
      row = 10,
      col = 10,
      focusable = true,
      external = false,
      style = "minimal",
    })

    wintablib.close_floating()

    assert.window_count(2)
  end)
end)

describe("close_upside()", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("closes all the upside windows", function()
    vim.cmd("new")
    vim.cmd("new")
    vim.cmd("new")
    vim.cmd("wincmd j")
    vim.cmd("wincmd j")
    local current = vim.api.nvim_get_current_win()
    vim.cmd("wincmd j")
    local downside = vim.api.nvim_get_current_win()
    vim.cmd("wincmd k")

    wintablib.close_upside()

    assert.window_count(2)
    assert.window(current)

    vim.cmd("wincmd j")
    assert.window(downside)
  end)
end)

describe("close_downside()", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("closes all the downside windows", function()
    vim.cmd("new")
    vim.cmd("new")
    vim.cmd("new")
    local upside = vim.api.nvim_get_current_win()
    vim.cmd("wincmd j")
    local current = vim.api.nvim_get_current_win()

    wintablib.close_downside()

    assert.window_count(2)
    assert.window(current)

    vim.cmd("wincmd k")
    assert.window(upside)
  end)
end)

describe("close_leftside()", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("closes all the leftside windows", function()
    vim.cmd("vnew")
    vim.cmd("vnew")
    vim.cmd("vnew")
    vim.cmd("wincmd l")
    vim.cmd("wincmd l")
    local current = vim.api.nvim_get_current_win()
    vim.cmd("wincmd l")
    local rightside = vim.api.nvim_get_current_win()
    vim.cmd("wincmd h")

    wintablib.close_leftside()

    assert.window_count(2)
    assert.window(current)

    vim.cmd("wincmd l")
    assert.window(rightside)
  end)
end)

describe("close_rightside()", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("closes all the rightside windows", function()
    vim.cmd("vnew")
    vim.cmd("vnew")
    vim.cmd("vnew")
    local leftside = vim.api.nvim_get_current_win()
    vim.cmd("wincmd l")
    local current = vim.api.nvim_get_current_win()

    wintablib.close_rightside()

    assert.window_count(2)
    assert.window(current)

    vim.cmd("wincmd h")
    assert.window(leftside)
  end)
end)

describe("focus_on_floating()", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can focus on floating window", function()
    local target = vim.api.nvim_open_win(0, false, {
      width = 10,
      height = 10,
      relative = "editor",
      row = 10,
      col = 10,
      focusable = true,
    })
    vim.cmd("vsplit")
    vim.cmd("split")

    wintablib.focus_on_floating()

    assert.window(target)
  end)
end)
