VERSION = "2.1.0"

local config = import("micro/config")
local shell = import("micro/shell")
local filepath = import("path/filepath")
local micro = import("micro")

local fmtCommands = {
	["python"] = { "ruff check --fix", "ruff format" },
	["c"] = "clang-format -i",
	["c++"] = "clang-format -i",
	["csharp"] = "clang-format -i",
	["racket"] = "raco fmt --width 80 --max-blank-lines 2 -i",
	["javascript"] = "prettier --write --log-level silent",
	["typescript"] = "prettier --write --log-level silent",
	["json"] = "prettier --write --log-level silent",
	["html"] = "prettier --write --log-level silent",
	["css"] = "prettier --write --log-level silent",
	["solidity"] = "forge fmt",
	["rust"] = "rustfmt +nightly",
	["go"] = "gofmt -w",
	["lua"] = "stylua",
	["nix"] = "nixfmt",
}

config.RegisterCommonOption("autofmt", "fmt-onsave", true)

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
	command = fmtCommands[bp.Buf:FileType()]

	if type(command) == "string" then
		command = { command }
	end

	if command ~= nil then
		for _, value in ipairs(command) do
			doFmt(bp, value)
		end
	end
end

function doFmt(bp, fmtCmd)
	bp:Save()
	local dirPath, _ = filepath.Split(bp.Buf.AbsPath)
	local _, err = os.execute('cd "' .. dirPath .. '"; ' .. fmtCmd .. " " .. bp.Buf.AbsPath)
	if err ~= nil then
		micro.InfoBar():Error(err)
		return
	end
	bp.Buf:ReOpen()
end
