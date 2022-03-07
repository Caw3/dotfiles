require("null-ls").setup({
	sources = {
		require("null-ls").builtins.formatting.stylua,
		require("null-ls").builtins.formatting.reorder_python_imports,
		require("null-ls").builtins.formatting.autopep8,
		require("null-ls").builtins.formatting.json_tool,
		require("null-ls").builtins.formatting.trim_newlines,
		require("null-ls").builtins.formatting.trim_whitespace,
		require("null-ls").builtins.formatting.prettier.with({ extra_args = { "--use-tabs" } }),
		require("null-ls").builtins.diagnostics.zsh,
	},
})
