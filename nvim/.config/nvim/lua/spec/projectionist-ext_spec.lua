local proj = require('projectionist-ext')
local inspect = require('inspect')

describe("projections-ext", function()
  it('works', function()
    assert.are.same(
      {
        "module MyModule",
        "  module Bar",
        "    class Baz",
      }
      , proj.rb_class_start("my_module/bar/baz"))
  end)

  it('works', function()
    assert.are.same(
      {
        "    end",
        "  end",
        "end",
      }
      , proj.rb_class_end("my_module/bar/baz"))
  end)


  it('works', function()
    assert.are.same(
      "      ",
      proj.rb_class_indent("my_module/bar/baz"))
  end)
end)
