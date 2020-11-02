local utl = require('utils/utils')
local map = require('utils/keymap')
local log = require('utils/log')
local plg = require('config/plugin')

local function set_lsp_mappings()
    local opts = {silent = true, buffer = true}
    local map_pref = '<localleader>l'
    local cmd_pref = '<cmd>lua vim.lsp.'
    local cmd_suff = '<cr>'
    local mappings = {
        r = 'buf.rename()',
        e = 'buf.declaration()',
        d = 'buf.definition()',
        h = 'buf.hover()',
        i = 'buf.implementation()',
        H = 'buf.signature_help()',
        D = 'buf.type_definition()',
        R = 'buf.references()',
        f = 'buf.formatting()',
        S = 'stop_all_clients()',
        n = 'util.show_line_diagnostics()'
    }
    for lhs, rhs in pairs(mappings) do
        log.trace("lhs = ", map_pref .. lhs, ", rhs = ",
                  cmd_pref .. rhs .. cmd_suff, ", opts = ", opts)
        map.nnoremap(map_pref .. lhs, cmd_pref .. rhs .. cmd_suff, opts)
    end
    if utl.is_mod_available('telescope') then
        cmd_pref = [[<cmd>lua require('telescope.builtin').lsp_]]
        map.nnoremap(map_pref .. 'a', cmd_pref .. 'code_actions()' .. cmd_suff, opts)
        map.nnoremap(map_pref .. 'R', cmd_pref .. 'references()' .. cmd_suff, opts)
        map.nnoremap(map_pref .. 's', cmd_pref .. 'document_symbols()' .. cmd_suff, opts)
        map.nnoremap(map_pref .. 'w', cmd_pref .. 'workspace_symbols()' .. cmd_suff, opts)
    end
end

-- Abstract function that allows you to hook and set settings on a buffer that 
-- has lsp server support
local function on_lsp_attach(client_id)
    if vim.b.did_on_lsp_attach == 1 then
        -- Setup already done in this buffer
        log.debug('on_lsp_attach already setup')
        return
    end

    -- Disable neomake
    if vim.fn.exists(':NeomakeDisableBuffer') == 2 then
        vim.cmd('NeomakeDisableBuffer')
    end
    -- These 2 got annoying really quickly
    -- vim.cmd('autocmd CursorHold <buffer> lua vim.lsp.util.show_line_diagnostics()')
    -- vim.cmd("autocmd CursorHold <buffer> lua vim.lsp.buf.hover()")
    set_lsp_mappings()
    require('config/completion').diagn:on_attach()

    -- Disable tagbar
    vim.b.tagbar_ignore = 1
    require('lsp-status').on_attach(client_id)
    vim.b.did_on_lsp_attach = 1
end

local function on_clangd_attach(client_id)
    if vim.b.did_on_lsp_attach == 1 then
        -- Setup already done in this buffer
        log.debug('on_lsp_attach already setup')
        return
    end

    log.debug('Setting up on_clangd_attach')
    log.debug('client_id = ', client_id)
    local opts = {silent = true, buffer = true}
    map.nnoremap('<localleader>a', [[<cmd>ClangdSwitchSourceHeader<cr>]], opts)
    map.nnoremap('<localleader>A',
                 [[<cmd>vs<cr><cmd>ClangdSwitchSourceHeader<cr>]], opts)
    return on_lsp_attach(client_id)
end

-- TODO
-- Maybe set each server to its own function?
local function lsp_set()
    if not utl.is_mod_available('nvim_lsp') then
        log.error("nvim_lsp was set, but module not found")
        return
    end

    if not utl.is_mod_available('lsp-status') then
        log.error("lsp-status was set, but module not found")
        return
    end

    local lsp_status = require('lsp-status')
    plg.setup_lspstatus()  -- Configure plugin options
    lsp_status.register_progress()
    -- Notice not all configs have a `callbacks` setting
    local nvim_lsp = require('nvim_lsp')
    local pid = tostring(vim.fn.getpid())

    if vim.fn.executable('omnisharp') > 0 then
        log.info("setting up the omnisharp lsp...")
        nvim_lsp.omnisharp.setup {
            on_attach = on_lsp_attach,
            cmd = { "omnisharp", "--languageserver" , "--hostPID", pid},
            capabilities = lsp_status.capabilities,
        }
    end

    if vim.fn.executable('pyls') > 0 then
        log.info("setting up the pyls lsp...")
        nvim_lsp.pyls.setup {
            on_attach = on_lsp_attach,
            cmd = {"pyls"},
            root_dir = nvim_lsp.util.root_pattern(".git", ".svn"),
            capabilities = lsp_status.capabilities
        }
    end

    -- if utl.is_mod_available('nlua.lsp.nvim') then
        -- Requires the sumneko_lua server
        -- This is setup nlua autocompletion of built in functions
        -- To get builtin LSP running, do something like:
        -- NOTE: This replaces the calls where you would have before done
        -- `require('nvim_lsp').sumneko_lua.setup()`
        -- require('nlua.lsp.nvim').setup(require('nvim_lsp'),
            -- {on_attach = nil, globals = { "Color", "c", "Group", "g", "s", } })
    -- end

    if vim.fn.executable('lua-language-server') > 0 then
        log.info("setting up the lua-language-server lsp...")
        nvim_lsp.sumneko_lua.setup {
            on_attach = on_lsp_attach,
            cmd = {"lua-language-server"},
            capabilities = lsp_status.capabilities,
            root_dir = nvim_lsp.util.root_pattern(".git", ".svn")
        }
    end

    if vim.fn.executable('clangd') > 0 then
        log.info("setting up the clangd lsp...")
        nvim_lsp.clangd.setup {
            on_attach = on_clangd_attach,
            callbacks = lsp_status.extensions.clangd.setup(),
            capabilities = lsp_status.capabilities,
            cmd = {
                "clangd", "--all-scopes-completion=true",
                "--background-index=true", "--clang-tidy=true",
                "--completion-style=detailed", "--fallback-style=\"LLVM\"",
                "--pch-storage=memory", "--suggest-missing-includes",
                "--header-insertion=iwyu", "-j=12",
                "--header-insertion-decorators=false"
            },
            filetypes = {"c", "cpp"}
        }
    end
end

return {set = lsp_set}
