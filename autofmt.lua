VERSION = "2.1.0"

local config = import("micro/config")
local filepath = import("path/filepath")
local micro = import("micro")

local fmtNames = {}
fmtNames["yapf"] = "yapf -i"
fmtNames["ruff"] = "ruff format -s"
fmtNames["black"] = "black -q"
fmtNames["clang-format"] = "clang-format -i"
fmtNames["prettier"] = "prettier --write --log-level silent"
fmtNames["rustfmt"] = "rustfmt"
fmtNames["rustfmt+nightly"] = "rustfmt +nightly"
fmtNames["gofmt"] = "gofmt -w"
fmtNames["raco-fmt"] = "raco fmt --width 80 --max-blank-lines 2 -i"
fmtNames["forge-fmt"] = "forge fmt"

local fmtAvailable = {}
fmtAvailable["python"] = {"yapf", "ruff", "black"}
fmtAvailable["c"] = {"clang-format"}
fmtAvailable["c++"] = {"clang-format"}
fmtAvailable["csharp"] = {"clang-format"}
fmtAvailable["racket"] = {"raco-fmt"}
fmtAvailable["rust"] = {"rustfmt", "rustfmt+nightly"}
fmtAvailable["go"] = {"gofmt"}
fmtAvailable["solidity"] = {"forge-fmt"}
fmtAvailable["javascript"] = {"prettier"}
fmtAvailable["json"] = {"prettier"}
fmtAvailable["html"] = {"prettier"}

config.RegisterCommonOption("autofmt", "fmt-onsave", true)
for lang, formatters in pairs(fmtAvailable) do
    config.RegisterCommonOption("autofmt", "for-" .. lang, formatters[1])
end

function init()
    config.MakeCommand("fmt", tryFmt, config.NoComplete)
    config.AddRuntimeFile("fmt", config.RTHelp, "help/autofmt.md")
end

function onSave(bp)
    if bp.Buf.Settings["autofmt.fmt-onsave"] then
        tryFmt(bp)
    end
end

function tryFmt(bp)
    local lang = bp.Buf:FileType()
    if fmtAvailable[lang] == nil then return end
    local chosen = bp.Buf.Settings["autofmt.for-" .. lang]
    local cmd = fmtNames[chosen]
    if cmd == nil then
        micro.InfoBar():Error("autofmt: unknown formatter '" .. chosen .. "' for " .. lang)
        return
    end
    doFmt(bp, cmd)
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
