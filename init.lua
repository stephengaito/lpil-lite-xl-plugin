-- mod-version:3

-- This is the "main" (init.lua) file which pulls in all of the parts of
-- the lpil-plugin

local core = require "core"

require "plugins.lpil_tools.lpil_compile"

local lpil_tools = { }



core.log_quiet("Loaded LPiL Tools")

return lpil_tools
