-- mod-version:3
local core = require "core"
local config = require "core.config"
local command = require "core.command"
local common = require "core.common"
local console = require "plugins.console"
local keymap = require "core.keymap"

-- This plugin requires the console plugin to work. It can be found at:
--
-- https://github.com/lite-xl/console
--
-- Before using this plugin add in your user's config file something like:
--
-- config.lpilcompile = {
--   latex_command = "pdflatex",
--   view_command = "evince",
-- }
--
-- as long as the commands are in your PATH.
--
-- Options can be passed as part of the command for example like in:
--
-- latex_command = "latex -pdf -pdflatex -c".
--
-- On Windows, if the commands are not in your PATH, you may use the full path
-- of the executable like, for example:
--
-- config.lpilcompile = {
--   latex_command = [[C:\miktex\miktex\bin\x64\pdflatex.exe]],
--   view_command = [[C:\Program^ Files\SumatraPDF\SumatraPDF.exe]],
-- }
--
-- Note that in the example we have used "^ " for spaces that appear in the path.
-- It is required on Windows for path or file names that contains space characters.

-------------------------------------------------------------------------
-- setup our default configuration

if not config.lpilcompile then
  config.lpilcompile = {
  	latex_command = "lpilMagicRunner",
  	view_command  = "okular"
  }
end

if not config.lpilcompile.latex_command then
  config.lpilcompile.latex_command = "lpilMagicRunner"
end

if not config.lpilcompile.view_command then
  config.lpilcompile.view_command = "okular"
end

-------------------------------------------------------------------------

command.add("core.docview!", {
  ["lpilcompile:lpil-compile"] = function(dv)
    -- The current (La)TeX file and path
    local lpilname = dv:get_name()
    local lpilpath = common.dirname(dv:get_filename())
    local pdfname = lpilname:gsub("%.tex$", ".pdf")

    -- LaTeX compiler as configured in config.lpilcompile
    local lpilcmd = config.lpilcompile and config.lpilcompile.latex_command
    local viewcmd = config.lpilcompile and config.lpilcompile.view_command

    if not lpilcmd then
      core.log("No LaTeX compiler provided in config.")
    else
      core.log("LaTeX compiler is %s, compiling %s", lpilcmd, lpilname)

      console.run {
        command = string.format(
          "%s %s && %s %s", lpilcmd, lpilname, viewcmd, pdfname
        ),
        cwd = lpilpath,
        on_complete = function() core.log("Tex compiling command terminated.") end
      }
    end
  end,
})

keymap.add { ["ctrl+shift+t"] = "lpilcompile:lpil-compile" }

core.log_quiet("Loaded lpil-compile")