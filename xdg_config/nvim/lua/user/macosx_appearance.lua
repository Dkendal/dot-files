-- Auto-sync Neovim background with macOS appearance mode
local M = {}

-- Configuration
local config = {
  poll_interval = 2000, -- Check every 2 seconds (in milliseconds)
  debug = false         -- Set to true for debug output
}

-- Check current macOS appearance mode
local function get_macos_appearance(callback)
  vim.system(
    { 'defaults', 'read', '-g', 'AppleInterfaceStyle' },
    { text = true },
    function(result)
      local appearance = "light" -- default to light

      if result.code == 0 and result.stdout then
        -- If command succeeds and returns "Dark", we're in dark mode
        if result.stdout:match("Dark") then
          appearance = "dark"
        end
      end
      -- If command fails (exit code != 0), we're in light mode

      callback(appearance)
    end
  )
end

-- Set Neovim background based on appearance
local function set_background(appearance)
  if appearance == "dark" then
    if vim.o.background ~= "dark" then
      vim.o.background = "dark"
      if config.debug then
        print("Switched to dark background")
      end
    end
  else
    if vim.o.background ~= "light" then
      vim.o.background = "light"
      if config.debug then
        print("Switched to light background")
      end
    end
  end
end

-- Main sync function
local function sync_background()
  get_macos_appearance(set_background)
end

-- Start the polling timer
local function start_polling()
  -- Set initial background
  sync_background()

  -- Create timer for polling
  local timer = vim.loop.new_timer()
  if timer then
    timer:start(0, config.poll_interval, vim.schedule_wrap(function()
      sync_background()
    end))
  end
end

-- Setup function to initialize the sync
function M.setup(opts)
  -- Merge user config with defaults
  if opts then
    config = vim.tbl_extend("force", config, opts)
  end

  -- Only run on macOS
  if vim.fn.has("mac") == 1 then
    start_polling()
  elseif config.debug then
    print("macOS appearance sync: Not running on macOS")
  end
end

-- Manual sync function (useful for testing)
function M.sync_now()
  sync_background()
end

-- Enable debug mode
function M.enable_debug()
  config.debug = true
end

return M
