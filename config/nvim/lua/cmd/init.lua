-- Auto-load all Lua files in cmd/
local cmd_dir = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
for _, file in ipairs(vim.fn.glob(cmd_dir .. "*.lua", true, true)) do
	local name = file:match(".*/(.*)%.lua$")
	if name ~= "init" then
		require("cmd." .. name)
	end
end
