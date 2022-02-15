local utils = {}

 local function map(mode, shortcut, command)
	vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

 function utils.nmap(shortcut, command)
	map("n", shortcut, command)
end

 function utils.omap(shortcut, command)
	map("o", shortcut, command)
end

 function utils.imap(shortcut, command)
	map("i", shortcut, command)
end

 function utils.vmap(shortcut, command)
	map("v", shortcut, command)
end

 function utils.cmap(shortcut, command)
	map("c", shortcut, command)
end

 function utils.tmap(shortcut, command)
	map("t", shortcut, command)
end

function utils.xmap(shortcut, command)
	map("x", shortcut, command)
end

return utils
