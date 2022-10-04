if vim.g.started_by_firenvim then
	do return end
end

local api = vim.api

local file_exists = function(name)
	local f = io.open(name, "r")
	if f ~= nil then io.close(f) return true else return false end
end

NO_SUDO = file_exists(os.getenv("HOME") .. "/.no_sudo_indicator")
IS_REMOTE = file_exists(os.getenv("HOME") .. "/.remote_indicator")

split_if_not_exist = function(is_vsplit)
	if is_vsplit then
		pos_index = 1
		split_command = 'vsplit'
	else
		pos_index = 2
		split_command = 'split'
	end

	local win_ids = api.nvim_tabpage_list_wins(api.nvim_get_current_tabpage())
	local current_win = api.nvim_get_current_win()

	local current_win_pos = api.nvim_win_get_position(current_win)[pos_index]

	for _, win_id in ipairs(win_ids) do
		if win_id ~= current_win then
			local floating = api.nvim_win_get_config(win_id).relative ~= ''
			local file_type = api.nvim_buf_get_option(api.nvim_win_get_buf(win_id), 'filetype')
			if file_type ~= 'NvimTree' and not floating then
				local row = api.nvim_win_get_position(win_id)[pos_index]
				if current_win_pos == row then
					api.nvim_win_set_buf(win_id, api.nvim_win_get_buf(0))
					api.nvim_win_set_cursor(win_id, api.nvim_win_get_cursor(current_win))
					api.nvim_set_current_win(win_id)
					return
				end
			end
		end
	end

	-- Didnt return create new split
	vim.fn.execute(split_command)
end

local finish_title = function(amount_of_lines)
	local filler_amount = (selected_len - string.len(selected_title) - 2) / 2
	local filler = ""
	for _ = 1, filler_amount, 1 do
		filler = filler .. selected_filler
	end

	local output_title = filler .. ' ' .. selected_title .. ' ' .. filler
	local wrapped_line = ""
	for _ = 1, selected_len, 1 do
		wrapped_line = wrapped_line .. selected_filler
	end

	local lines = {}
	for _ = 1, amount_of_lines / 2, 1 do
		table.insert(lines, wrapped_line)
	end
	table.insert(lines, output_title)
	for _ = 1, amount_of_lines / 2, 1 do
		table.insert(lines, wrapped_line)
	end

	local pos = api.nvim_win_get_cursor(0)[1] - 1
	api.nvim_buf_set_lines(0, pos, pos, false, lines)
end

local select_amount_of_lines = function(input)
	selected_filler = input
	vim.ui.input({ prompt = "Amount of lines: ", default = "1" }, finish_title)
end

local select_filler = function(input)
	selected_len = input
	vim.ui.input({ prompt = "Filler", default = "-" }, select_amount_of_lines)
end

local select_len = function(input)
	selected_title = input
	vim.ui.input({ prompt = "Title Length: ", default = "60" }, select_filler)
end

local select_title = function()
	vim.ui.input({ prompt = "Title: " }, select_len)
end

api.nvim_create_user_command('Title', select_title, {})

smart_split = function(direction)
	local ft = api.nvim_buf_get_option(0, 'filetype')
	if ft == 'toggleterm' then
		open_new_terminal(direction)
	else
		if direction == 'vertical' then
			api.nvim_input('<cmd>vsplit<cr>')
		else
			api.nvim_input('<cmd>split<cr>')
		end
	end
end

local buf_is_visible = function(bufnr)
	return api.nvim_buf_is_loaded(bufnr) and vim.fn.bufwinnr(bufnr) > 0
end

close_pane = function()
	local bufnr = api.nvim_get_current_buf()
	if #api.nvim_list_wins() == 1 then -- Sometimes its reports 2 instead of 1
		api.nvim_feedkeys(':q\n', 'n', false)
		return
	end
	api.nvim_win_close(0, true)
	if not buf_is_visible(bufnr) then
		if api.nvim_buf_is_loaded(bufnr) then
			require('bufdelete').bufdelete(bufnr, true)
		end
	end
end

local get_range = function(mode)
	if mode == 'v' then
		start_pos = api.nvim_buf_get_mark(0, "<")
		end_pos = api.nvim_buf_get_mark(0, ">")
	elseif mode == 'n' then
		start_pos = api.nvim_buf_get_mark(0, "[")
		end_pos = api.nvim_buf_get_mark(0, "]")
	end

	return start_pos, end_pos
end

local get_current_line_text = function(mode)
	current_line = api.nvim_get_current_line()
	start_pos, end_pos = get_range(mode)

	return string.sub(current_line, start_pos[2] + 1, end_pos[2] + 1)
end

live_grep = function(opts, mode)
	opts = opts or {}
	opts.prompt_title = 'Live Grep Raw (-t[ty] include, -T exclude -g"[!] [glob]")'
	if not opts.default_text then
		if mode then
			opts.default_text = '-F "' .. get_current_line_text(mode) .. '"'
		else
			opts.default_text = '-F "'
		end
	end

	require('telescope').extensions.live_grep_args.live_grep_args(opts)
end

goto_def = function()
	local ft = api.nvim_buf_get_option(0, 'filetype')
	if ft == 'man' then
		api.nvim_command(':Man ' .. vim.fn.expand('<cWORD>'))
	elseif ft == 'help' then
		api.nvim_command(':help ' .. vim.fn.expand('<cword>'))
	else
		require 'telescope.builtin'.lsp_definitions({
			show_line = false
		})
	end
end

center_screen = function()
	api.nvim_feedkeys('zz', 'n', false)
end

local catch = function(what)
	return what[1]
end

local try = function(what)
	status, result = pcall(what[1])
	if not status then
		what[2](result)
	end
	return result
end

api.nvim_create_user_command('CloseAllButCurrent', function()
	for _, bufnr in pairs(api.nvim_list_bufs()) do
		if not buf_is_visible(bufnr) then
			if api.nvim_buf_is_valid(bufnr) then
				try {
					function()
						require('bufdelete').bufdelete(bufnr, true)
					end,
					catch {
						function()
							-- print('Failed to delete buffer: ' .. bufnr)
						end
					}
				}
			end
		end
	end
end, {})

api.nvim_create_user_command('CloseBuffersLeft', function()
	api.nvim_command('BufferLineCloseLeft')
end, {})
api.nvim_create_user_command('CloseBuffersRight', function()
	api.nvim_command('BufferLineCloseRight')
end, {})

goto_next_diag = function()
	local next = vim.diagnostic.get_next()
	if next == nil then
		return
	end
	api.nvim_win_set_cursor(0, { next.lnum + 1, next.col })
	center_screen()
end

goto_prev_diag = function()
	local prev = vim.diagnostic.get_prev(opts)
	if not prev then
		return
	end
	api.nvim_win_set_cursor(0, { prev.lnum + 1, prev.col })
	center_screen()
end

get_current_lsp_server_name = function()
	local msg = '———'
	local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
	local clients = vim.lsp.get_active_clients()
	if next(clients) == nil then
		return msg
	end
	for _, client in ipairs(clients) do
		local filetypes = client.config.filetypes
		if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
			return client.name
		end
	end
	return msg
end

node_relative_path = function(node)
	return vim.fn.fnamemodify(node.absolute_path, ":~:.")
end

find_in_path = function(node)
	opts = {}
	opts.default_text = '-g"' .. node_relative_path(node) .. '/**" "'
	require('telescope').extensions.live_grep_args.live_grep_args(opts)
end

git_hist_path = function(node)
	vim.fn.execute('DiffviewFileHistory ' .. node_relative_path(node))
end
