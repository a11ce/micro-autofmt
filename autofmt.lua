VERSION = "3.0.0"

local config = import("micro/config")
local filepath = import("path/filepath")
local micro = import("micro")

local fmtNames = {}
fmtNames["yapf"] = "yapf -i"
fmtNames["ruff"] = "ruff format -s"
fmtNames["ruff+check"] = {"ruff check --fix", "ruff format -s"}
fmtNames["black"] = "black -q"
fmtNames["clang-format"] = "clang-format -i"
fmtNames["prettier"] = "prettier --write --log-level silent"
fmtNames["rustfmt"] = "rustfmt"
fmtNames["rustfmt+nightly"] = "rustfmt +nightly"
fmtNames["gofmt"] = "gofmt -w"
fmtNames["raco-fmt"] = "raco fmt --width 80 --max-blank-lines 2 -i"
fmtNames["forge-fmt"] = "forge fmt"
fmtNames["stylua"] = "stylua"
fmtNames["nixfmt"] = "nixfmt"

local fmtFor = {}
fmtFor["python"] = {"yapf", "ruff", "ruff+check", "black"}
fmtFor["c"] = {"clang-format"}
fmtFor["c++"] = {"clang-format"}
fmtFor["csharp"] = {"clang-format"}
fmtFor["racket"] = {"raco-fmt"}
fmtFor["rust"] = {"rustfmt", "rustfmt+nightly"}
fmtFor["go"] = {"gofmt"}
fmtFor["solidity"] = {"forge-fmt"}
fmtFor["javascript"] = {"prettier"}
fmtFor["json"] = {"prettier"}
fmtFor["html"] = {"prettier"}
fmtFor["typescript"] = {"prettier"}
fmtFor["css"] = {"prettier"}
fmtFor["lua"] = {"stylua"}
fmtFor["nix"] = {"nixfmt"}
fmtFor["markdown"] = {"prettier"}

config.RegisterCommonOption("autofmt", "onsave", true)
for lang, formatters in pairs(fmtFor) do
    config.RegisterCommonOption("autofmt", "for-" .. lang, formatters[1])
end

function init()
    config.MakeCommand("fmt", fmtCommand, config.NoComplete)
    config.AddRuntimeFile("fmt", config.RTHelp, "help/autofmt.md")
end

function onSave(bp)
    if bp.Buf.Settings["autofmt.onsave"] then
        tryFmt(bp)
    end
end

function fmtCommand(bp, args)
    if #args == 0 then
        tryFmt(bp)
        return
    end
    local cmd = fmtNames[args[1]]
    if cmd == nil then
        micro.InfoBar():Error("autofmt: unknown formatter '" .. args[1] .. "'")
        return
    end
    doFmt(bp, cmd)
end


function tryFmt(bp)
    local lang = bp.Buf:FileType()
    if fmtFor[lang] == nil then return end
    local fmtName = bp.Buf.Settings["autofmt.for-" .. lang]
    if fmtName == "off" then return end
    local cmd = fmtNames[fmtName]
    if cmd == nil then
        micro.InfoBar():Error("autofmt: unknown formatter '" .. fmtName .. "' for " .. lang)
        return
    end
    doFmt(bp, cmd)
end

function doFmt(bp, fmtCmd)
    bp:Save()
    local dirPath, _ = filepath.Split(bp.Buf.AbsPath)
    local cmds = fmtCmd
    if type(cmds) ~= "table" then
        cmds = {cmds}
    end
    for _, cmd in ipairs(cmds) do
        local _, err = os.execute("cd \"" .. dirPath .. "\"; " .. cmd .. " " .. bp.Buf.AbsPath)
        if err ~= nil then
            micro.InfoBar():Error(err)
            return
        end
    end
    bp.Buf:ReOpen()
end
