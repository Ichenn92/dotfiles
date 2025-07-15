--[[
parse-node-errors.lua

🎯 Objectif :
Créer une commande Neovim pour parser un bloc d’erreurs Node.js/TypeScript
(copié dans le clipboard) et le charger dans la quickfix list.

💡 Contexte :
Dans les projets Node/TypeScript, les erreurs compilateur/test sont souvent
sous la forme :

    Errors  Files
         1  src/file.ts:78
         2  src/other/file.ts:12

Cette commande transforme ces lignes en liens cliquables dans Neovim.

🚀 Utilisation :
1. Copie le texte d’erreurs dans ton clipboard
2. Dans Neovim, exécute :
       :ParseNodeErrors
3. Navigue les erreurs :
       :cnext
       :cprev
       :copen

🌱 Bonus : détecte automatiquement la racine du projet via `git`
pour corriger les chemins relatifs.

--]]

vim.api.nvim_create_user_command("ParseNodeErrors", function()
	-- Obtenir le contenu du clipboard
	local lines = vim.fn.getreg("+", 1, true)
	if #lines == 0 then
		vim.notify("📋 Clipboard is empty", vim.log.levels.WARN)
		return
	end

	-- Déterminer la racine du projet (via git, sinon cwd)
	local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if not root or root == "" then
		root = vim.fn.getcwd()
	end

	-- Parser les lignes et formater pour quickfix
	local qf = {}
	for _, line in ipairs(lines) do
		local file, lnum = line:match("^%s*%d+%s+(%S+):(%d+)")
		if file and lnum then
			table.insert(qf, {
				filename = "functions/" .. file,
				lnum = tonumber(lnum),
				col = 1,
				text = "Node.js/TS error",
			})
		end
	end

	-- Si aucun fichier trouvé
	if #qf == 0 then
		vim.notify("❌ No errors found in clipboard", vim.log.levels.INFO)
		return
	end

	-- Charger la liste dans quickfix et ouvrir
	vim.fn.setqflist(qf, "r")
	vim.cmd("copen")
	vim.notify("✅ Loaded " .. #qf .. " errors into quickfix", vim.log.levels.INFO)
end, {
	desc = "Parse Node.js/TypeScript errors from clipboard into quickfix list",
})
