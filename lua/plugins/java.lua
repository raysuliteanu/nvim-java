-- jdtls itself, the debugger and the <leader>t test runner all come from the
-- LazyVim `lang.java` extra. This only tunes the server settings.
return {
	{
		"mfussenegger/nvim-jdtls",
		opts = {
			settings = {
				java = {
					-- Pull down library sources so goto-definition lands in real
					-- code instead of a class-file stub, and decompile whatever
					-- still has no sources attached.
					eclipse = { downloadSources = true },
					maven = { downloadSources = true },
					references = { includeDecompiledSources = true },

					signatureHelp = { enabled = true },

					-- Static imports jdtls will offer unprompted; without these
					-- assertions and matchers never complete in test files.
					completion = {
						favoriteStaticMembers = {
							"org.assertj.core.api.Assertions.*",
							"org.junit.jupiter.api.Assertions.*",
							"org.junit.jupiter.api.Assumptions.*",
							"org.junit.jupiter.api.DynamicContainer.*",
							"org.junit.jupiter.api.DynamicTest.*",
							"org.mockito.ArgumentMatchers.*",
							"org.mockito.Answers.*",
							"org.mockito.Mockito.*",
							"java.util.Objects.requireNonNull",
							"java.util.Objects.requireNonNullElse",
						},
						importOrder = { "java", "javax", "jakarta", "com", "org", "" },
					},

					sources = {
						organizeImports = {
							starThreshold = 9999,
							staticStarThreshold = 9999,
						},
					},
				},
			},
		},
	},
}
