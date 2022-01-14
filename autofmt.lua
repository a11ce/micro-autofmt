VERSION = "1.0.0"

local config = import("micro/config")
local shell = import("micro/shell")
local micro = import("micro")

local fmtCommands = {}
fmtCommands["python"] = "yapf -i"
fmtCommands["c"]      = "clang-format -i"
fmtCommands["c++"]      = "clang-format -i"

function init()
    config.RegisterCommonOption("autofmt", "fmt-onsave", true)
    config.MakeCommand("fmt", tryFmt, config.NoComplete)
    config.AddRuntimeFile("fmt", config.RTHelp, "help/autofmt.md")
end

function onSave(bp)
    tryFmt(bp)
end

function tryFmt(bp)
    if bp.Buf.Settings["fmt-onsave"] then
        if fmtCommands[bp.Buf:FileType()] ~= nil then
            doFmt(bp, fmtCommands[bp.Buf:FileType()])
        end
    end
end

function doFmt(bp, fmtCmd)
    bp:Save()
    local _, err = shell.RunCommand(fmtCmd .. " " .. bp.Buf.Path)
    if err ~= nil then
        micro.InfoBar():Error(err)
        return
    end
    bp.Buf:ReOpen()
end
