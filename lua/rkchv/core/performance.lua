local M = {}

-- Performance tracking
local start_time = vim.loop.hrtime()

function M.get_startup_time()
  local end_time = vim.loop.hrtime()
  return (end_time - start_time) / 1000000 -- Convert to milliseconds
end

function M.log_startup_time()
  local startup_time = M.get_startup_time()
  vim.notify("Neovim startup time: " .. string.format("%.2f", startup_time) .. "ms", vim.log.levels.INFO)
end

-- Plugin load time tracking
local plugin_times = {}

function M.start_plugin_timer(plugin_name)
  plugin_times[plugin_name] = vim.loop.hrtime()
end

function M.end_plugin_timer(plugin_name)
  if plugin_times[plugin_name] then
    local end_time = vim.loop.hrtime()
    local load_time = (end_time - plugin_times[plugin_name]) / 1000000
    vim.notify(plugin_name .. " loaded in " .. string.format("%.2f", load_time) .. "ms", vim.log.levels.DEBUG)
    plugin_times[plugin_name] = nil
  end
end

-- Memory usage tracking
function M.get_memory_usage()
  local mem_info = vim.loop.get_memory_info()
  return {
    rss = mem_info.rss / 1024 / 1024, -- MB
    heap_used = mem_info.heap_used / 1024 / 1024, -- MB
    heap_total = mem_info.heap_total / 1024 / 1024, -- MB
  }
end

function M.log_memory_usage()
  local mem = M.get_memory_usage()
  vim.notify(string.format("Memory: RSS=%.1fMB, Heap=%.1fMB/%.1fMB", 
    mem.rss, mem.heap_used, mem.heap_total), vim.log.levels.INFO)
end

-- Performance optimization helpers
function M.optimize_buffer_settings()
  -- Disable some features for large files
  local line_count = vim.api.nvim_buf_line_count(0)
  if line_count > 10000 then
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.syntax = "off"
    vim.opt_local.conceallevel = 0
  end
end

function M.setup_performance_autocmds()
  -- Optimize large files
  vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
      M.optimize_buffer_settings()
    end,
  })
  
  -- Log startup time when Neovim is fully loaded
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      vim.defer_fn(M.log_startup_time, 100)
    end,
  })
end

return M 