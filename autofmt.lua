VERSION = "2.0.0"

local config = import("micro/config")
local shell = import("micro/shell")
local filepath = import("path/filepath")
local micro = import("micro")

local fmtCommands = {}
fmtCommands["python"] = "yapf -i"
fmtCommands["c"]      = "clang-format -i"
fmtCommands["c++"]    = "clang-format -i"
fmtCommands["csharp"] = "clang-format -i"
fmtCommands["racket"] = "raco fmt --width 80 --max-blank-lines 2 -i"
fmtCommands["javascript"] = "prettier --write --log-level silent"
fmtCommands["rust"] = "rustfmt +nightly"
fmtCommands["go"] = "gofmt -w"
fmtCommands["solidity"] = "forge fmt"

function init()
    config.RegisterCommonOption("autofmt", "fmt-onsave", true)
    config.MakeCommand("fmt", tryFmt, config.NoComplete)
    config.AddRuntimeFile("fmt", config.RTHelp, "help/autofmt.md")
end

function onSave(bp)
    if config.GetGlobalOption("autofmt.fmt-onsave") then
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
    local dirPath, _ = filepath.Split(bp.Buf.AbsPath)
    local _, err = os.execute("cd \"" .. dirPath .. "\"; " .. fmtCmd .. " " .. bp.Buf.AbsPath)
    if err ~= nil then
        micro.InfoBar():Error(err)
        return
    end
    bp.Buf:ReOpen()
end
