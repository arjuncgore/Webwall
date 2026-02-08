-- ==== IMPORTS
local waywall = require("waywall")
local helpers = require("helpers")
local json    = require("dkjson")


-- ==== PARSE JSON
local cfg_path = os.getenv("HOME") .. "/.config/waywall/cfg.json"
local cfg_json = ""

local f = io.open(cfg_path, "r")
if not f then
    print("Error: cfg.json file not found")
    return
end
if f ~= nil then
    cfg_json = f:read("*a")
    f:close()
end

local cfg = json.decode(cfg_json)
if cfg == nil then
    print("Error: Invalid cfg.json")
    return
end


-- ==== DEFAULTS
if cfg ~= nil then
    print("cfg loaded")
else
    cfg = {
        config = {
            input = {
                layout = "us",
                repeat_rate = 40,
                repeat_delay = 300,

                sensitivity = 1.0,
                confine_pointer = false,
            },
            theme = {
                background = "#303030ff"
            },
            window = {
                fullscreen_width = 0,
                fullscreen_height = 0,
            },
        },
        resolutions = {
            thin = {
                key = "*-B",
                w = 300,
                h = 1080,
                mirrors = {
                    {
                        x = 10,
                        y = 10,
                        w = 10,
                        h = 10,
                        colorkeys = {
                            a000011 = "#110000",
                            a000022 = "#220000"
                        }
                    },
                    {
                        x = 10,
                        y = 10,
                        w = 10,
                        h = 10,
                        colorkeys = {
                            a000011 = "#110000",
                            a000022 = "#220000"
                        }
                    }
                }
            }
        }
    }
end



-- ==== MAIN CONFIG
local config = {
    input = cfg.config.input,
    theme = cfg.config.theme,
    window = cfg.config.window,
}

local resolutions = {}
for name, res in ipairs(cfg.resolutions) do
    resolutions[name] = waywall.ingame_only(helpers.toggle_res(res.w, res.h))()
    config.actions[res.key] = resolutions[name]
end

return config
