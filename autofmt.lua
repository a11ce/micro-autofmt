VERSION = "2.2.0"

local os = import("os")
local filepath = import("filepath")
local config = import("micro/config")
local shell = import("micro/shell")
local micro = import("micro")
local math = import("math")
local strings = import("strings")


local fmtCommands         = {}
fmtCommands["shell"]      = "shfmt -i 2 -ci -w"
fmtCommands["python"]     = "yapf -i"
fmtCommands["c"]          = "clang-format -i"
fmtCommands["c++"]        = "clang-format -i"
fmtCommands["csharp"]     = "clang-format -i"
fmtCommands["racket"]     = "raco fmt --width 80 --max-blank-lines 2 -i"
fmtCommands["html"]       = "prettier --write --log-level silent"
fmtCommands["css"]        = "prettier --write --log-level silent"
fmtCommands["javascript"] = "prettier --write --log-level silent"
fmtCommands["typescript"] = "prettier --write --log-level silent"
fmtCommands["json"]       = "prettier --write --log-level silent"
fmtCommands["rust"]       = "rustfmt +nightly"
fmtCommands["go"]         = "gofmt -w"
fmtCommands["solidity"]   = "forge fmt"


local function BAND(a, b)
    local res = 0
    local bitval = 1
    while a > 0 and b > 0 do
        local abit = a % 2
        local bbit = b % 2
        if abit == 1 and bbit == 1 then
            res = res + bitval
        end
        bitval = bitval * 2
        a = math.Floor(a / 2)
        b = math.Floor(b / 2)
    end
    return res
end


local function resolveSymlink(path)
  info, err = os.Lstat(path)
  if err then
    micro.Log(err)
    return path
  end

  if BAND(info:Mode(), os.ModeSymlink) ~= 0 then
    local resolved, err = filepath.EvalSymlinks(path)
    if err then
      micro.Log(err)
      return path
    end
    return resolved
  end
  return path
end

local function tryFmt(bp)
    if fmtCommands[bp.Buf:FileType()] ~= nil then
        doFmt(bp, fmtCommands[bp.Buf:FileType()])
    end
end

function doFmt(bp, fmtCmd)
    bp:Save()
    local path = resolveSymlink(bp.Buf.AbsPath)
    local _, err = shell.RunCommand(fmtCmd .. " " .. path)
    if err then
        micro.Log(err)
        local cmd = fmtCmd:match("^([%w-]+)")
        micro.InfoBar():Error(cmd .. ": " .. err:Error())
    end
    bp.Buf:ReOpen()
end


function preinit()
    config.RegisterCommonOption("autofmt", "fmt-onsave", true)
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




