# nvim-java

A small, focused Neovim configuration for Java development, built on
[LazyVim](https://www.lazyvim.org/).

General-purpose Neovim configs tend to accumulate every language and tool you
have ever touched. This one carries only what Java work actually needs: jdtls
via nvim-jdtls, a debugger and test runner, XML/YAML/TOML support for build
files and config, and enough Markdown, Git and Jujutsu support to live in a real
repository. Around 40 plugins in total, most of them LazyVim's own defaults.

It is deliberately unopinionated about everything else. There is no AI tooling,
no note-taking, no second language server — if you want those, add them in
`lua/plugins/`.

## Requirements

- Neovim >= 0.11.2 (LazyVim's minimum)
- A JDK on `PATH` — 21 or newer, since that is what jdtls itself runs on
- `git`, a C compiler and `curl` (for treesitter parsers and Mason downloads)
- A [Nerd Font](https://www.nerdfonts.com/) for the icons
- Optionally [`jj`](https://jj-vcs.github.io/jj/) for the Jujutsu integration

Everything else — jdtls, lemminx, java-debug-adapter, java-test,
yaml-language-server, taplo, marksman, markdownlint-cli2, markdown-toc — is
installed by Mason on first launch.

Gradle and Maven are not wrapped by a plugin. jdtls imports the project itself,
and tasks are best run from a terminal (`<leader>ft` opens one) or with `:!`.

## Installation

### As a separate config (recommended)

`NVIM_APPNAME` lets Neovim keep several configurations side by side. It isolates
the plugin, state and cache directories too, so this config shares nothing with
whatever you already run:

```sh
git clone https://github.com/raysuliteanu/nvim-java ~/.config/nvim-java
NVIM_APPNAME=nvim-java nvim
```

That leaves `~/.config/nvim` untouched. An alias makes it convenient:

```sh
alias jv='NVIM_APPNAME=nvim-java nvim'
```

Directories used: `~/.config/nvim-java`, `~/.local/share/nvim-java`,
`~/.local/state/nvim-java`, `~/.cache/nvim-java`.

### As your default config

If you want this to be what plain `nvim` starts, back up anything already there
first:

```sh
mv ~/.config/nvim{,.bak}
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

git clone https://github.com/raysuliteanu/nvim-java ~/.config/nvim
nvim
```

Remove the `.git` directory afterwards if you would rather track it in your own
dotfiles repo than stay pinned to this one.

Either way, the first launch installs plugins and tools and takes a minute. The
first Java buffer then takes longer still, while jdtls imports the project and
resolves dependencies. Run `:checkhealth` once it settles.

## What's included

LazyVim's base (picker, explorer, statusline, which-key, treesitter, gitsigns,
lazygit, trouble, ...) plus these extras, listed in `lazyvim.json`:

| Extra | Provides |
| --- | --- |
| `lang.java` | nvim-jdtls (jdtls), java-debug-adapter, java-test, `java` parser |
| `lang.yaml` | yaml-language-server + SchemaStore |
| `lang.toml` | taplo LSP + TOML treesitter |
| `lang.markdown` | marksman LSP, render-markdown.nvim, markdown-preview, markdownlint-cli2 |
| `lang.git` | gitcommit/git treesitter parsers |
| `dap.core` | nvim-dap, dap-ui, virtual text, mason-nvim-dap |
| `editor.snacks_picker` | Snacks as the picker |
| `editor.snacks_explorer` | Snacks as the file explorer |

Local overrides in `lua/plugins/`:

- `java.lua` — jdtls settings: library source downloading, decompiled sources,
  static-import favourites for JUnit/Mockito/AssertJ, import order
- `xml.lua` — lemminx LSP plus `xml` and `properties` treesitter parsers
- `jj.lua` — [jj.nvim](https://github.com/NicolasGB/jj.nvim) under `<leader>j`
- `markdown.lua` — blink.cmp completions, prettier dropped from the format chain
- `blink-cmp.lua` — completion sources and signature help

## Keymaps

The Java mappings all come from LazyVim's `lang.java` extra:

### Refactoring — `<leader>c` (in `.java` buffers)

| Key | Action |
| --- | --- |
| `<leader>co` | Organize imports |
| `<leader>cxv` / `<leader>cxc` | Extract variable / constant |
| `<leader>cxm` | Extract method (visual mode) |
| `<leader>cgs` / `<leader>cgS` | Goto super / subjects |

### Testing — `<leader>t`

| Key | Action |
| --- | --- |
| `<leader>tt` | Run all tests in the class |
| `<leader>tr` | Run nearest test |
| `<leader>tT` | Pick a test to run |

Tests run through the debugger, so breakpoints work in them.

### Debugging

`<leader>d` is the general DAP group from `dap.core`. The `lang.java` extra adds
a `Debug (Attach) - Remote` configuration on `127.0.0.1:5005`, and jdtls
generates launch configurations for each main class it finds.

### Jujutsu — `<leader>j`

| Key | Action |
| --- | --- |
| `<leader>jl` / `<leader>js` | Log / status |
| `<leader>jd` / `<leader>jD` | Diff / describe |
| `<leader>jn` / `<leader>jc` | New change / commit |
| `<leader>jS` / `<leader>jr` | Squash / resolve conflicts |
| `<leader>ju` | Undo |
| `<leader>jf` / `<leader>jp` | Fetch / push |
| `<leader>jb` | Blame (annotate) |

Git keeps LazyVim's `<leader>g` mappings, so both work in colocated repos.

## Spring Boot

Spring Boot is deliberately left out: jdtls already understands a Boot project
as an ordinary Gradle or Maven one, and the only real integration needs a
language server that Mason does not package.

If you want bean navigation, endpoint discovery and completion in
`application.properties` / `application.yaml`, add
[spring-boot.nvim](https://github.com/JavaHello/spring-boot.nvim). It drives the
VMware Spring Tools 4 language server, which you have to supply yourself.

Fetch the server jar from the VS Code extension:

```sh
mkdir -p ~/.local/share/spring-boot-ls && cd ~/.local/share/spring-boot-ls
curl -L -o vscode-spring-boot.vsix \
  'https://marketplace.visualstudio.com/_apis/public/gallery/publishers/vmware/vsextensions/vscode-spring-boot/latest/vspackage'
unzip -o vscode-spring-boot.vsix 'extension/language-server/*'
```

Then create `lua/plugins/spring-boot.lua`:

```lua
return {
	{
		"JavaHello/spring-boot.nvim",
		ft = { "java", "yaml", "jproperties" },
		dependencies = { "mfussenegger/nvim-jdtls" },
		opts = {
			ls_path = vim.fn.glob(
				vim.fn.expand("~/.local/share/spring-boot-ls")
					.. "/extension/language-server/spring-boot-language-server-*.jar",
				false,
				true
			)[1],
		},
	},

	-- jdtls needs the Spring Boot extension bundles to answer the language
	-- server's classpath queries. Use the function form of `opts.jdtls` so the
	-- java-debug-adapter / java-test bundles the extra already computed survive.
	{
		"mfussenegger/nvim-jdtls",
		opts = function(_, opts)
			opts.jdtls = function(config)
				config.init_options = config.init_options or {}
				local bundles = config.init_options.bundles or {}
				vim.list_extend(bundles, require("spring_boot").java_extensions())
				config.init_options.bundles = bundles
				return config
			end
		end,
	},
}
```

Without a valid `ls_path` the plugin warns once and does nothing, so it fails
softly if the jar moves.

## Customising

`lazyvim.json` lists the enabled LazyVim extras; add or remove entries there, or
use `:LazyExtras`. Anything beyond that goes in `lua/plugins/` as a normal
lazy.nvim spec — files are picked up automatically.
