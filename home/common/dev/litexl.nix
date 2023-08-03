{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    lite-xl
  ];
  home.file = {
    # Add proton-ge-updater script to zsh directory
    ".config/lite-xl/init.lua" = {
      text = ''
        -- put user settings here
        -- this module will be loaded after everything else when the application starts
        -- it will be automatically reloaded when saved

        local core = require "core"
        local keymap = require "core.keymap"
        local config = require "core.config"
        local style = require "core.style"


        ------------------------------ Themes ----------------------------------------

        -- light theme:
        -- core.reload_module("colors.summer")
        -- catppuccin mocha theme:
        local style = require "core.style"
        local common = require "core.common"
        style.background = { common.color "#1e1e2e" } -- base
        style.background2 = { common.color "#181825" } -- mantle
        style.background3 = { common.color "#313244" } -- surface0
        style.text = { common.color "#cdd6f4" } -- text
        style.caret = { common.color "#f5e0dc" } -- rosewater
        style.accent = { common.color "#cba6f7" } -- mauve
        style.dim = { common.color "#bac2de" } -- subtext1
        style.divider = { common.color "#cba6f7" } -- mauve
        style.selection = { common.color "#585b70" } -- surface2
        style.line_number = { common.color "#6c7086" } -- overlay0
        style.line_number2 = { common.color "#cba6f7" } -- mauve
        style.line_highlight = { common.color "#313244" } -- surface0
        style.scrollbar = { common.color "#585b70" } -- surface2
        style.scrollbar2 = { common.color "#6c7086" } -- overlay0
        style.scrollbar_track = { common.color "#181825" } -- mantle

        style.syntax["normal"] = { common.color "#f38ba8" } -- red
        style.syntax["symbol"] = { common.color "#b4befe" } -- lavender
        style.syntax["comment"] = { common.color "#6c7086" } -- overlay0
        style.syntax["keyword"] = { common.color "#f38ba8" } -- red
        style.syntax["keyword2"] = { common.color "#f38ba8" } -- red
        style.syntax["number"] = { common.color "#fab387" } -- peach
        style.syntax["literal"] = { common.color "#b4befe" } -- lavender
        style.syntax["string"] = { common.color "#a6e3a1" } -- green
        style.syntax["operator"] = { common.color "#89dceb" } -- sky
        style.syntax["function"] = { common.color "#89b4fa" } -- blue

        --------------------------- Key bindings -------------------------------------

        -- key binding:
        -- keymap.add { ["ctrl+escape"] = "core:quit" }

        -- pass 'true' for second parameter to overwrite an existing binding
        -- keymap.add({ ["ctrl+pageup"] = "root:switch-to-previous-tab" }, true)
        -- keymap.add({ ["ctrl+pagedown"] = "root:switch-to-next-tab" }, true)

        ------------------------------- Fonts ----------------------------------------

        -- customize fonts:
        -- style.font = renderer.font.load(DATADIR .. "/fonts/FiraSans-Regular.ttf", 14 * SCALE)
        style.code_font = renderer.font.load(DATADIR .. "/fonts/JetBrainsMono-Regular.ttf", 14)
        --
        -- DATADIR is the location of the installed Lite XL Lua code, default color
        -- schemes and fonts.
        -- USERDIR is the location of the Lite XL configuration directory.
        --
        -- font names used by lite:
        -- style.font          : user interface
        -- style.big_font      : big text in welcome screen
        -- style.icon_font     : icons
        -- style.icon_big_font : toolbar icons
        -- style.code_font     : code
        --
        -- the function to load the font accept a 3rd optional argument like:
        --
        -- {antialiasing="grayscale", hinting="full", bold=true, italic=true, underline=true, smoothing=true, strikethrough=true}
        --
        -- possible values are:
        -- antialiasing: grayscale, subpixel
        -- hinting: none, slight, full
        -- bold: true, false
        -- italic: true, false
        -- underline: true, false
        -- smoothing: true, false
        -- strikethrough: true, false

        ------------------------------ Plugins ----------------------------------------

        -- enable or disable plugin loading setting config entries:

        -- enable plugins.trimwhitespace, otherwise it is disabled by default:
        -- config.plugins.trimwhitespace = true
        --
        -- disable detectindent, otherwise it is enabled by default
        -- config.plugins.detectindent = false

        ---------------------------- Miscellaneous -------------------------------------

        -- modify list of files to ignore when indexing the project:
        -- config.ignore_files = {
        --   -- folders
        --   "^%.svn/",        "^%.git/",   "^%.hg/",        "^CVS/", "^%.Trash/", "^%.Trash%-.*/",
        --   "^node_modules/", "^%.cache/", "^__pycache__/",
        --   -- files
        --   "%.pyc$",         "%.pyo$",       "%.exe$",        "%.dll$",   "%.obj$", "%.o$",
        --   "%.a$",           "%.lib$",       "%.so$",         "%.dylib$", "%.ncb$", "%.sdf$",
        --   "%.suo$",         "%.pdb$",       "%.idb$",        "%.class$", "%.psd$", "%.db$",
        --   "^desktop%.ini$", "^%.DS_Store$", "^%.directory$",
        -- }
        ------------------------- Plugin Nix Language ----------------------------------
        -- mod-version:3
        -- https://nixos.wiki/wiki/Overview_of_the_Nix_Language
        local syntax = require "core.syntax"

        local function merge_tables(a, b)
          for _, v in pairs(b) do
            table.insert(a, v)
          end
        end

        local default_symbols = {
          ["import"]   = "keyword2",
          ["with"]     = "keyword2",
          ["builtins"] = "keyword2",
          ["inherit"]  = "keyword2",
          ["assert"]   = "keyword2",
          ["let"]      = "keyword2",
          ["in"]       = "keyword2",
          ["rec"]      = "keyword2",
          ["if"]       = "keyword",
          ["else"]     = "keyword",
          ["then"]     = "keyword",
          ["true"]     = "literal",
          ["false"]    = "literal",
          ["null"]     = "literal",
        }

        local default_patterns = {}

        local string_interpolation = {
          { pattern = {"%${", "}"}, type = "keyword2", syntax = {
            patterns = default_patterns,
            symbols = default_symbols,
          }},
          { pattern = "[%S][%w]*", type = "string" },
        }

        merge_tables(default_patterns, {
          { pattern = "#.*",          type = "comment" },
          { pattern = {"/%*", "%*/"}, type = "comment" },
          { pattern = "-?%.?%d+",     type = "number"  },

          -- interpolation
          { pattern = {"%${", "}"}, type = "keyword2", syntax = {
            patterns = default_patterns,
            symbols = default_symbols,
          }},
          { pattern = {'"', '"', '\\'}, type = "string", syntax = {
            patterns = string_interpolation,
            symbols = {},
          }},
          { pattern = {"'' ", " ''        "}, type = "string", syntax = {
                    patterns = string_interpolation,
                    symbols = {},
                  }},

                  -- operators
                  { pattern = "[%+%-%?!>%*]", type = "operator" },
                  { pattern = "/ ",           type = "operator" },
                  { pattern = "< ",           type = "operator" },
                  { pattern = "//",           type = "operator" },
                  { pattern = "&&",           type = "operator" },
                  { pattern = "%->",          type = "operator" },
                  { pattern = "||",           type = "operator" },
                  { pattern = "==",           type = "operator" },
                  { pattern = "!=",           type = "operator" },
                  { pattern = ">=",           type = "operator" },
                  { pattern = "<=",           type = "operator" },

                  -- paths (function because its not used otherwise)
                  { pattern = "%.?%.?/[^%s%[%]%(%){};,:]+", type = "function" },
                  { pattern = "~/[^%s%[%]%(%){};,:]+",      type = "function" },
                  { pattern = {"<", ">"},                   type = "function" },

                  -- every other symbol
                  { pattern = "[%a%-%_][%w%-%_]*", type = "symbol" },
                  { pattern = ";%.,:",             type = "normal" },
                })

                syntax.add {
                  name = "Nix",
                  files = {"%.nix$"},
                  comment = "#",
                  block_comment = {"/*", "*/"},
                  patterns = default_patterns,
                  symbols = default_symbols,
                }

                ------------------------- Plugin selectionhighlight-----------------------------
                -- mod-version:3
                local style = require "core.style"
                local DocView = require "core.docview"

                -- originally written by luveti

                local function draw_box(x, y, w, h, color)
                  local r = renderer.draw_rect
                  local s = math.ceil(SCALE)
                  r(x, y, w, s, color)
                  r(x, y + h - s, w, s, color)
                  r(x, y + s, s, h - s * 2, color)
                  r(x + w - s, y + s, s, h - s * 2, color)
                end


                local draw_line_body = DocView.draw_line_body

                function DocView:draw_line_body(line, x, y)
                  local line_height = draw_line_body(self, line, x, y)
                  local line1, col1, line2, col2 = self.doc:get_selection(true)
                  if line1 == line2 and col1 ~= col2 then
                    local selection = self.doc:get_text(line1, col1, line2, col2)
                    if not selection:match("^%s+$") then
                      local lh = self:get_line_height()
                      local selected_text = self.doc.lines[line1]:sub(col1, col2 - 1)
                      local current_line_text = self.doc.lines[line]
                      local last_col = 1
                      while true do
                        local start_col, end_col = current_line_text:find(
                          selected_text, last_col, true
                        )
                        if start_col == nil then break end
                        -- don't draw box around the selection
                        if line ~= line1 or start_col ~= col1 then
                          local x1 = x + self:get_col_x_offset(line, start_col)
                          local x2 = x + self:get_col_x_offset(line, end_col + 1)
                          local color = style.selectionhighlight or style.syntax.comment
                          draw_box(x1, y, x2 - x1, lh, color)
                        end
                        last_col = end_col + 1
                      end
                    end
                  end
                  return line_height
                end

                ------------------------- Plugin icons ----------------------------------
                -- mod-version:3
                -- Orginal Author: Jipok
                -- Modified by: techie-guy
                -- Doesn't work well with scaling mode == "ui"

                -- This is an extension/modification of the nonicons plugin, https://github.com/lite-xl/lite-xl-plugins/blob/master/plugins/nonicons.lua

                -- Any icon can be searched by it's hex from nerdfonts.com/cheat-sheet

                -- How to use:
                -- 1. Download a nerd font that you like from nerdfonts.com
                -- 2. Unzip the zip file that you downloaded.
                -- 3. Choose a font file from the unzipped directory and install it.
                -- 4. Copy the font file to the .config/lite-xl/fonts and rename it to "icon-nerd-font.ttf".
                -- 5. Restart lite-xl, the icons should appear.

                local core = require "core"
                local common = require "core.common"
                local config = require "core.config"
                local style = require "core.style"
                local TreeView = require "plugins.treeview"
                local Node = require "core.node"

                -- Config
                config.plugins.nerdicons = common.merge({
                  use_default_dir_icons = false,
                  use_default_chevrons = false,
                  draw_treeview_icons = true,
                  draw_tab_icons = true,
                  -- The config specification used by the settings gui
                  config_spec = {
                    name = "Nerdicons",
                    {
                      label = "Use Default Directory Icons",
                      description = "When enabled does not use nerdicon directory icons.",
                      path = "use_default_dir_icons",
                      type = "toggle",
                      default = false
                    },
                    {
                      label = "Use Default Chevrons",
                      description = "When enabled does not use nerdicon expand/collapse arrow icons.",
                      path = "use_default_chevrons",
                      type = "toggle",
                      default = false
                    },
                    {
                      label = "Draw Treeview Icons",
                      description = "Enables file related icons on the treeview.",
                      path = "draw_treeview_icons",
                      type = "toggle",
                      default = true
                    },
                    {
                      label = "Draw Tab Icons",
                      description = "Adds file related icons to tabs.",
                      path = "draw_tab_icons",
                      type = "toggle",
                      default = true
                    },
                  }
                }, config.plugins.nerdicons)

                local icon_font = renderer.font.load(USERDIR .. "${pkgs.nerdfonts}/SymbolsNerdFont-Regular.ttf", 18.5 * SCALE)
                local chevron_width = icon_font:get_width("")
                local previous_scale = SCALE

                local extension_icons = {
                  [".lua"] = { "#405af0", ""},
                  [".md"]  = { "#519aba", "" }, -- Markdown
                  [".powershell"] = { "#519aba", "" },
                  [".bat"] = { "#cbcb41", "" },
                  [".txt"] = { "#ffffff", "" },
                  [".cpp"] = { "#519aba", "ﭱ" },
                  [".c"]   = { "#599eff", "" },
                  [".h"]   = { "#79029b", "h" },
                  [".hpp"] = { "#79029b", "h" },
                  [".py"]  = { "#3572A5", "" }, -- Python
                  [".pyc"]  = { "#519aba", "" },
                  [".pyd"]  = { "#519aba", "" },
                  [".php"] = { "#a074c4", "" },
                  [".cs"] = { "#596706", "" },  -- C#
                  [".conf"] = { "#6d8086", "" }, [".cfg"] = { "#6d8086", "" },
                  [".toml"] = { "#6d8086", "" },
                  [".yaml"] = { "#6d8086", "" }, [".yml"] = { "#6d8086", "" },
                  [".json"] = { "#854CC7", "" },
                  [".css"] = { "#519abc", "" },
                  [".html"] = { "#e34c26", "" },
                  [".js"] = { "#cbcb41", "" },  -- JavaScript
                  [".go"] = { "#519aba", "" },
                  [".jpg"] = { "#a074c4", "" }, [".png"] = { "#a074c4", "" },
                  [".sh"] = { "#4d5a5e", "" }, [".bash"] = { "#4d5a5e", "" },  -- Shell
                  [".java"] = { "#cc3e44", "" },
                  [".scala"] = { "#cc3e44", "" },
                  [".kt"] = { "#F88A02", "" },  -- Kotlin
                  [".pl"] = { "#519aba", "" },  -- Perl
                  [".rb"] = { "#701516", "" },  -- Ruby
                  [".rs"] = { "#c95625", "" },  -- Rust
                  [".rss"] = { "#cc3e44", "" },
                  [".sql"] = { "#dad8d8", "" },
                  [".swift"] = { "#e37933", "ﯣ" },
                  [".ts"] = { "#519aba", "ﯤ" },  -- TypeScript
                  [".diff"] = { "#41535b", "" },
                  [".exe"] = {"#cc3e55", ""},
                  [".make"] = { "#d0bf41", "" },
                  [".svg"] = { "#f7ca39", "ﰟ" },
                  [".ttf"] = {"#dad8d4", ""}, [".otf"] = {"#dad8d4", ""}
                }

                local known_filenames_icons = {
                  ["dockerfile"] = { "#296478", "" },
                  [".gitignore"] = { "#cc3e55", "" },
                  [".gitmodules"] = { "#cc3e56", "" },
                  ["PKGBUILD"] = { "#6d8ccc", "" },
                  ["license"] = { "#d0bf41", "" },
                  ["makefile"] = { "#d0bf41", "" },
                  ["cmakelists.txt"] = { "#cc3e55", "喝" },
                }

                -- Preparing colors
                for k, v in pairs(extension_icons) do
                  v[1] = { common.color(v[1]) }
                end
                for k, v in pairs(known_filenames_icons) do
                  v[1] = { common.color(v[1]) }
                end

                -- Override function to change default icons for dirs, special extensions and names
                local TreeView_get_item_icon = TreeView.get_item_icon
                function TreeView:get_item_icon(item, active, hovered)
                  local icon, font, color = TreeView_get_item_icon(self, item, active, hovered)
                  if previous_scale ~= SCALE then
                    icon_font:set_size(
                      icon_font:get_size() * (SCALE / previous_scale)
                    )
                    chevron_width = icon_font:get_width("")
                    previous_scale = SCALE
                  end
                  if not config.plugins.nerdicons.use_default_dir_icons then
                    icon = "" -- hex ea7b
                    font = icon_font
                    color = style.text
                    if item.type == "dir" then
                      icon = item.expanded and "ﱮ" or "" -- hex f07c and f07b
                    end
                  end
                  if config.plugins.nerdicons.draw_treeview_icons then
                    local custom_icon = known_filenames_icons[item.name:lower()]
                    if custom_icon == nil then
                      custom_icon = extension_icons[item.name:match("^.+(%..+)$")]
                    end
                    if custom_icon ~= nil then
                      color = custom_icon[1]
                      icon = custom_icon[2]
                      font = icon_font
                    end
                    if active or hovered then
                      color = style.accent
                    end
                  end
                  return icon, font, color
                end

                -- Override function to draw chevrons if setting is disabled
                local TreeView_draw_item_chevron = TreeView.draw_item_chevron
                function TreeView:draw_item_chevron(item, active, hovered, x, y, w, h)
                  if not config.plugins.nerdicons.use_default_chevrons then
                    if item.type == "dir" then
                      local chevron_icon = item.expanded and "" or ""
                      local chevron_color = hovered and style.accent or style.text
                      common.draw_text(icon_font, chevron_color, chevron_icon, nil, x+8, y, 0, h) -- added 8 to x to draw the chevron closer to the icon
                    end
                    return chevron_width + style.padding.x
                  end
                  return TreeView_draw_item_chevron(self, item, active, hovered, x, y, w, h)
                end

                -- Override function to draw icons in tabs titles if setting is enabled
                local Node_draw_tab_title = Node.draw_tab_title
                function Node:draw_tab_title(view, font, is_active, is_hovered, x, y, w, h)
                  if config.plugins.nerdicons.draw_tab_icons then
                    local padx = chevron_width + style.padding.x/2
                    local tx = x + padx/16 -- Space for icon
                    w = w + padx
                    Node_draw_tab_title(self, view, font, is_active, is_hovered, tx, y, w, h)
                    if (view == nil) or (view.doc == nil) then return end
                    local item = { type = "file", name = view.doc:get_name() }
                    TreeView:draw_item_icon(item, false, is_hovered, x, y, w, h)
                  else
                    Node_draw_tab_title(self, view, font, is_active, is_hovered, x, y, w, h)
                  end
                end

                ------------------------- Plugin indentguide ----------------------------------
                -- mod-version:3
                local style = require "core.style"
                local config = require "core.config"
                local common = require "core.common"
                local DocView = require "core.docview"

                config.plugins.indentguide = common.merge({
                  enabled = true,
                  -- The config specification used by the settings gui
                  config_spec = {
                    name = "Indent Guide",
                    {
                      label = "Enable",
                      description = "Toggle the drawing of indentation indicator lines.",
                      path = "enabled",
                      type = "toggle",
                      default = true
                    }
                  }
                }, config.plugins.indentguide)

                -- TODO: replace with `doc:get_indent_info()` when 2.1 releases
                local function get_indent_info(doc)
                  if doc.get_indent_info then
                    return doc:get_indent_info()
                  end
                  return config.tab_type, config.indent_size
                end


                local function get_line_spaces(doc, line, dir)
                  local _, indent_size = get_indent_info(doc)
                  local text = doc.lines[line]
                  if not text or #text == 1 then
                    return -1
                  end
                  local s, e = text:find("^%s*")
                  if e == #text then
                    return get_line_spaces(doc, line + dir, dir)
                  end
                  local n = 0
                  for _,b in pairs({text:byte(s, e)}) do
                    n = n + (b == 9 and indent_size or 1)
                  end
                  return n
                end


                local function get_line_indent_guide_spaces(doc, line)
                  if doc.lines[line]:find("^%s*\n") then
                    return math.max(
                      get_line_spaces(doc, line - 1, -1),
                      get_line_spaces(doc, line + 1,  1))
                  end
                  return get_line_spaces(doc, line)
                end

                local docview_update = DocView.update
                function DocView:update()
                  docview_update(self)

                  if not config.plugins.indentguide.enabled or not self:is(DocView) then
                    return
                  end

                  local function get_indent(line)
                    if line < 1 or line > #self.doc.lines then return -1 end
                    if not self.indentguide_indents[line] then
                      self.indentguide_indents[line] = get_line_indent_guide_spaces(self.doc, line)
                    end
                    return self.indentguide_indents[line]
                  end

                  self.indentguide_indents = {}
                  self.indentguide_indent_active = {}

                  local minline, maxline = self:get_visible_line_range()
                  for i = minline, maxline do
                    self.indentguide_indents[i] = get_line_indent_guide_spaces(self.doc, i)
                  end

                  local _, indent_size = get_indent_info(self.doc)
                  for _,line in self.doc:get_selections() do
                    local lvl = get_indent(line)
                    local top, bottom

                    if not self.indentguide_indent_active[line]
                    or self.indentguide_indent_active[line] > lvl then

                      -- check if we're the header or the footer of a block
                      if get_indent(line + 1) > lvl and get_indent(line + 1) <= lvl + indent_size then
                        top = true
                        lvl = get_indent(line + 1)
                      elseif get_indent(line - 1) > lvl and get_indent(line - 1) <= lvl + indent_size then
                        bottom = true
                        lvl = get_indent(line - 1)
                      end

                      self.indentguide_indent_active[line] = lvl

                      -- check if the lines before the current are part of the block
                      local i = line - 1
                      if i > 0 and not top then
                        repeat
                          if get_indent(i) <= lvl - indent_size then break end
                          self.indentguide_indent_active[i] = lvl
                          i = i - 1
                        until i < minline
                      end
                      -- check if the lines after the current are part of the block
                      i = line + 1
                      if i <= #self.doc.lines and not bottom then
                        repeat
                          if get_indent(i) <= lvl - indent_size then break end
                          self.indentguide_indent_active[i] = lvl
                          i = i + 1
                        until i > maxline
                      end
                    end
                  end
                end


                local draw_line_text = DocView.draw_line_text
                function DocView:draw_line_text(line, x, y)
                  if config.plugins.indentguide.enabled and self:is(DocView) then
                    local spaces = self.indentguide_indents[line] or -1
                    local _, indent_size = get_indent_info(self.doc)
                    local w = math.max(1, SCALE)
                    local h = self:get_line_height()
                    local font = self:get_font()
                    local space_sz = font:get_width(" ")
                    for i = 0, spaces - 1, indent_size do
                      local color = style.guide or style.selection
                      local active_lvl = self.indentguide_indent_active[line] or -1
                      if i < active_lvl and i + indent_size >= active_lvl then
                        color = style.guide_highlight or style.accent
                      end
                      local sw = space_sz * i
                      renderer.draw_rect(math.ceil(x + sw), y, w, h, color)
                    end
                  end
                  return draw_line_text(self, line, x, y)
                end

      '';
      recursive = true;
    };
  };
}
