-- XML support: pom.xml, Spring bean definitions, logback/web.xml. LazyVim has
-- no xml extra, so lemminx is wired up directly; mason installs it from the
-- `servers` table.
return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				lemminx = {},
			},
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "xml", "properties" } },
	},
}
