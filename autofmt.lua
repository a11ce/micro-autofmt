VERSION = "2.2.0"

local config = import("micro/config")
local shell = import("micro/shell")
local micro = import("micro")


local fmtCommands         = {}
fmtCommands["python"]     = "yapf -i"
fmtCommands["c"]          = "clang-format -i"
fmtCommands["c++"]        = "clang-format -i"
fmtCommands["csharp"]     = "clang-format -i"
fmtCommands["racket"]     = "raco fmt --width 80 --max-blank-lines 2 -i"
fmtCommands["javascript"] = "prettier --write --log-level silent"
fmtCommands["typescript"] = "prettier --write --log-level silent"
fmtCommands["json"]       = "prettier --write --log-level silent"
fmtCommands["rust"]       = "rustfmt +nightly"
fmtCommands["go"]         = "gofmt -w"
fmtCommands["solidity"]   = "forge fmt"


function init()
    config.RegisterCommonOption("autofmt", "fmt-onsave", true)
    config.MakeCommand("fmt", tryFmt, config.NoComplete)
    config.AddRuntimeFile("fmt", config.RTHelp, "help/autofmt.md")
end

function onSave(bp)
    if bp.Buf.Settings["autofmt.fmt-onsave"] then
        tryFmt(bp)
    end
end

function tryFmt(bp)
    if fmtCommands[bp.Buf:FileType()] ~= nil then
        doFmt(bp, fmtCommands[bp.Buf:FileType()])
    end
end

function doFmt(bp, fmtCmd)
    bp:Save()
    local _, err = shell.RunCommand(fmtCmd .. " " .. bp.Buf.AbsPath)
    if (err) then
        micro.InfoBar():Error(err)
    end
    bp.Buf:ReOpen()
end
