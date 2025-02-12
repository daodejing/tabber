local M = {}
-- Created (almost) entirely by Aider

-- Create an augroup for our autocmds
vim.api.nvim_create_augroup("tabber", { clear = true })

local tab_history = {}
local after_close = false

local function push_tab(tabpage)
	if #tab_history == 0 or tab_history[#tab_history] ~= tabpage then
		table.insert(tab_history, tabpage)
	end
end

function M.setup(opts)
	-- On TabEnter, record the current tabpage in our history.
	vim.api.nvim_create_autocmd("TabEnter", {
		group = "tabber",
		pattern = "*",
		callback = function()
			if after_close then
				after_close = false
				return
			end
			local current = vim.api.nvim_get_current_tabpage()
			push_tab(current)
		end,
	})

	-- When a tab is closed, remove any invalid tab entries from tab_history and switch to the last visited tab.
	vim.api.nvim_create_autocmd("TabClosed", {
		group = "tabber",
		pattern = "*",
		callback = function(args)
			local top = tab_history[#tab_history]
			if top then
				table.remove(tab_history, #tab_history)
			end

			-- Remove any entries in tab_history that are no longer valid
			for i = #tab_history, 1, -1 do
				if tonumber(tab_history[i]) == tonumber(top) then
					table.remove(tab_history, i)
				end
			end
			-- Remove consecutive duplicates from tab_history
			local dedup = {}
			for i, tab in ipairs(tab_history) do
				if #dedup == 0 or dedup[#dedup] ~= tab then
					table.insert(dedup, tab)
				end
			end
			tab_history = dedup
			after_close = true
			local last = tab_history[#tab_history]
			if last and vim.api.nvim_tabpage_is_valid(last) then
				vim.schedule(function()
					vim.api.nvim_set_current_tabpage(last)
				end)
			end
		end,
	})
	-- Debug command to print the current tab history
	vim.api.nvim_create_user_command("TabberDebug", function()
		print("Current Tab History: " .. vim.inspect(tab_history))
	end, { desc = "Print the current tab history stack" })
end

return M
