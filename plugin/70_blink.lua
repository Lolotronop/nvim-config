vim.pack.add({
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range('1.x')
	}
})

local thing = 12

thing = 12 + thing

require("blink.cmp").setup({
	completion = {
		documentation = {
			auto_show = true,
		},
		menu = {
			-- TODO: fix transparency on completion menu
			winblend = 0,
			draw = {
				components = {
					kind_icon = {
						text = function(ctx)
							-- good lsps render the actual color when needed
							-- but mini icons ignore that. so we leave it be
							if ctx.kind == "Color" then
								return ctx.kind_icon
							end
							local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
							return kind_icon
						end,
						-- (optional) use highlights from mini.icons
						highlight = function(ctx)
							if ctx.kind == "Color" then
								return ctx.kind_hl
							end
							local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
							return hl
						end,
					},
					kind = {
						-- (optional) use highlights from mini.icons
						highlight = function(ctx)
							local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
							return hl
						end,
					},
				},
			},
		},
		accept = {
			auto_brackets = {
				enabled = true,
			},
		},
		list = {
			selection = {
				preselect = function(ctx)
					return ctx.mode ~= "cmdline"
				end,
			},
		},
	},
	keymap = {
		preset = "default",
		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-p>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-e>"] = { "hide" },
		["<CR>"] = { "accept", "fallback" },
		["<C-y>"] = { "select_and_accept" },

		["<C-j>"] = { "select_next", "fallback" },
		["<C-k>"] = { "select_prev", "fallback" },

		["<C-b>"] = { "scroll_documentation_up", "fallback" },
		["<C-f>"] = { "scroll_documentation_down", "fallback" },

		["<C-l>"] = { "snippet_forward", "fallback" },
		["<C-h>"] = { "snippet_backward", "fallback" },
	},

	appearance = {
		-- use_nvim_cmp_as_default = true,
		nerd_font_variant = "mono",
	},

	sources = {
		per_filetype = {
			lua = {
				"lazydev", "lsp", "snippets", "path", "buffer"
			},
		},
		default = { "lsp", "snippets", "path", "buffer" },
		providers = {
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				-- make lazydev completions top priority (see `:h blink.cmp`)
				score_offset = 100,
			},
		},
	},

	fuzzy = {
		implementation = "prefer_rust_with_warning",

		sorts = {
			function(a, b)
				if (a.client_name == nil or b.client_name == nil) or (a.client_name == b.client_name) then
					return
				end
				return b.client_name == "emmet_ls"
			end,
			-- default sorts
			"score",
			"sort_text",
		},
	},
})

-- OR build from source
-- local function build_blink(params)
--   vim.notify('Building blink.cmp', vim.log.levels.INFO)
--   local obj = vim.system({ 'cargo', 'build', '--release' }, { cwd = params.path }):wait()
--   if obj.code == 0 then
--     vim.notify('Building blink.cmp done', vim.log.levels.INFO)
--   else
--     vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
--   end
-- end


-- vim.api.nvim_create_autocmd('PackChanged', { callback = function(ev)
-- 	local name, kind = ev.data.spec.name, ev.data.kind
-- 	if name == 'blink.cmp' and kind == 'update' then
-- 		if not ev.data.active then vim.cmd.packadd('') end
-- 	end
-- end })
