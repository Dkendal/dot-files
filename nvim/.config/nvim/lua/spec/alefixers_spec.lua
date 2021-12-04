local alefixers = require('alefixers')
local inspect = require('inspect')
local lpeg = require('lpeg')

describe("alefixers", function()
  describe("sorbet_sig_format", function ()
    pending('handles indentation', function ()
      local lines = {
        "  sig { void }",
        "  ",
        "  def foo; end",
      }

      local actual = alefixers.sorbet_sig_format(lines)

      assert.are.same({
        "  sig { void }",
        "  def foo; end",
      }, actual)
    end)

    pending('works with empty curly blocks', function ()
      local lines = {
        "sig { void }",
        "",
        "",
        "",
        "def foo; end",
      }

      local actual = alefixers.sorbet_sig_format(lines)

      assert.are.same({
        "sig { void }",
        "def foo; end",
      }, actual)
    end)

    it('handles multiple statements', function ()
      local lines = {
        "    sig { returns(NilClass) }",
        "",
        "    def move_left; end",
        "",
        "    sig { returns(NilClass) }",
      }

      local actual = alefixers.sorbet_sig_format(lines)

      assert.are.same({
        "    sig { returns(NilClass) }",
        "    def move_left; end",
        "",
        "    sig { returns(NilClass) }",
      }, actual)
    end)

    pending('works with do-end blocks', function ()
      local lines = {
        "sig do",
        "",
        "  void",
        "",
        "end",
        "",
        "def foo; end",
      }

      local actual = alefixers.sorbet_sig_format(lines)

      assert.are.same({
        "sig do",
        "  void",
        "end",
        "def foo; end",
      }, actual)
    end)
  end)
end)
