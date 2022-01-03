local lsp_installer = require("nvim-lsp-installer")

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)

    local opts = {}
	--Custom settings for servers
	if server.name == "sumneko_lua" then
		opts={
			  settings = {
				Lua = {
				  diagnostics = {
					enable = true,
					globals = {"vim","packer_plugins"}
				  },
				  runtime = {version = "LuaJIT"},
				  workspace = {
					library = vim.list_extend({[vim.fn.expand("$VIMRUNTIME/lua")] = true},{}),
					  },
				  telemetry = {
					  enable = false
				  }
				},
			 }
		}
	end

	--Setup completion
	local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
	require('lspconfig')[server.name].setup{
	capabilities = capabilities
	}
    server:setup(opts)
end)

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Enable underline, use default values
    underline = true,
    -- Enable virtual text, override spacing to 4
    virtual_text = false,
    signs = {
      enable = true,
      priority = 20
    },
    -- Disable a feature
    update_in_insert = false,
})
