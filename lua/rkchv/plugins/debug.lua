return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"leoluz/nvim-dap-go",
		},
		keys = function(_, keys)
			local dap = require("dap")
			return {
				{ "<leader>db", dap.toggle_breakpoint, desc = "Debug: Toggle Breakpoint" },
				{ "<leader>dc", dap.continue, desc = "Debug: Start/Continue" },
				{ "<leader>di", dap.step_into, desc = "Debug: Step Into" },
				{ "<leader>do", dap.step_out, desc = "Debug: Step Out" },
				{ "<leader>j", dap.step_over, desc = "Debug: Step Over" },
			}
		end,
		config = function(_, opts)
			local dap = require("dap")
			local dapgo = require("dap-go")
			local dapui = require("dapui")

			vim.fn.sign_define(
				"DapBreakpoint",
				{ text = "●", texthl = "", linehl = "debugBreakpoint", numhl = "debugBreakpoint" }
			)

			-- vim.fn.sign_define(
			-- 	"DapBreakpointCondition",
			-- 	{ text = "◆", texthl = "", linehl = "debugBreakpoint", numhl = "debugBreakpoint" }
			-- )

			local dapui_opts = {
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 1 },
						},
						size = 0.4,
						position = "bottom",
					},
				},
			}

			dap.set_log_level("TRACE")
			dapgo.setup({
				delve = { path = "dlv", args = { "--check-go-version=false" } },
			})
			dapui.setup(dapui_opts)

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end
		end,
	},
}
