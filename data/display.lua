-- yPokemonStats Display Module
-- Handles all GUI rendering and display functions

Display = {}

local resolution = {x = 0, y = 0}

Display.GRID = {COLSX = 40, ROWSY = 16}

Display.GRID.MAX_COLX = Display.GRID.COLSX - 1
Display.GRID.MAX_ROWY = Display.GRID.ROWSY - 1

function Display.setResolution(res)
	resolution.x = res.x
	resolution.y = res.y
end

function Display.colToPixelX(colX)
	if colX < 0 or colX > Display.GRID.MAX_COLX then
		error("colX must be in range [0, " .. Display.GRID.MAX_COLX .. "]" .. "value is: " .. colX, 2)
	end
	return (resolution.x * colX) / Display.GRID.COLSX + 2
end

function Display.rowToPixelY(rowY)
	if rowY < 0 or rowY > Display.GRID.MAX_ROWY then
		error("rowY must be in range [0, " .. Display.GRID.MAX_ROWY .. "]" .. "value is: " .. rowY, 2)
	end
	return (resolution.y * rowY) / Display.GRID.ROWSY + 2
end

function Display.mainRender(settings, pokemon, gen, version, status, mode, substatus, lastpid, more, table)
	-- Prepare display variables
	local tmpcolor = status == 1 and "green" or "red"
	
	-- Display pokemon stats
	Display.statsDisplay(settings, pokemon, gen, mode, substatus, lastpid, table, tmpcolor)
	
	-- Species
	local g = gen <= 2
	gui.text(Display.colToPixelX(0), Display.rowToPixelY(g and 14 or 1), pokemon["species"] .. ":" .. pokemon["speciesname"], tmpcolor)
	
	-- HP display
	gui.text(Display.colToPixelX(g and 0 or 11), Display.rowToPixelY(g and 13 or 0), "HP:" .. pokemon["hp"]["current"] .. "/" .. pokemon["hp"]["max"], tmpcolor)

	-- Frame counter
	Display.frameCounter(Display.colToPixelX(0), Display.rowToPixelY(Display.GRID.MAX_ROWY), version)
	
	-- Shiny status
	gui.text(Display.colToPixelX(30), Display.rowToPixelY(Display.GRID.MAX_ROWY), pokemon["shiny"] == 1 and "Shiny" or "Not shiny", pokemon["shiny"] == 1 and "green" or "red")
	
	-- "More" menu
	if more == 1 then
		local helditem = pokemon["helditem"] == 0 and "none" or table["items"][gen][pokemon["helditem"]]
		Display.moreMenu(settings, pokemon, gen, version, status, table, helditem, lastpid)
	end
end

-- Display "no Pokemon" warning
function Display.noPokemon(settings)
	gui.text(Display.colToPixelX(0), Display.rowToPixelY(0), "No Pokemon", "red")
end

-- Display help menu
function Display.showHelp(settings, table)
	gui.box(Display.colToPixelX(2) - 5, Display.rowToPixelY(3) - 5, Display.colToPixelX(39) - 5, Display.rowToPixelY(12) + 5, "#ffffcc", "#ffcc33")
	gui.text(Display.colToPixelX(2), Display.rowToPixelY(3), "yPokemonStats", "#ee82ee")
	gui.text(Display.colToPixelX(2), Display.rowToPixelY(4), "http://github.com/yling", "#87cefa")
	gui.text(Display.colToPixelX(2), Display.rowToPixelY(5), "-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-", "#ffcc33")
	
	local helpLines = {	{settings["key"].SWITCH_MODE,	": IVs, EVs, Stats and Contest stats", 5},
						{settings["key"].SWITCH_STATUS,	": Player team / Enemy team", 4},
						{settings["key"].SUB_STATUS,	": Pokemon slot (1-6)", 3},
						{settings["key"].TOGGLE_MORE,	": Show more data", 2},
						{settings["key"].TOGGLE_HELP,	": Toggle this menu", 1}}

	for i, line in ipairs(helpLines) do
		gui.text(Display.colToPixelX(2), Display.rowToPixelY(6 + i), line[1] .. line[2], table["colors"][line[3]])
	end
end

function Display.statsDisplay(settings, pokemon, gen, mode, substatus, lastpid, table, color)
	local statCount = gen <= 2 and 5 or 6
	local labels = gen <= 2 and table["gen1labels"] or table["labels"]
	
	-- Get IV data based on generation
	local ivData = pokemon[table["modesorder"][mode]]
	
	-- Display stats
	for i = 1, statCount do
		local colX = Display.GRID.COLSX - (i * 3)
		
		-- Label at top
		gui.text(Display.colToPixelX(colX), Display.rowToPixelY(0), labels[statCount + 1 - i], table["colors"][statCount + 1 - i])
		
		-- IV value one row below
		local iv = ivData[statCount + 1 - i]
		local ivText = iv == 31 and (iv .. "*") or iv
		gui.text(Display.colToPixelX(colX), Display.rowToPixelY(1), ivText, table["colors"][statCount + 1 - i])
		
		-- Nature indicator (Gen 3+, not for mode 4)
		if gen >= 3 and mode ~= 4 then
			Display.natureIndicator(colX, 1, i, pokemon, table)
		end
	end
	
	-- Status indicator
	Display.statusIndicator((gen <= 2 and 15 or 0), (gen <= 2 and Display.GRID.MAX_ROWY or 0), substatus[1], mode, table, color)
	
	-- PID (Gen 3+)
	if gen >= 3 then
		gui.text(Display.colToPixelX(15), Display.rowToPixelY(Display.GRID.MAX_ROWY), "PID: " .. bit.tohex(lastpid))
	end
end

-- Display nature stat modifiers (green for boost, red for reduction, grey for neutral)
function Display.natureIndicator(colX, rowY, statIndex, pokemon, table)
	local inc, dec = pokemon["nature"]["inc"], pokemon["nature"]["dec"]
	
	if inc ~= dec then
		if statIndex == table["statsorder"][inc + 2] then
			gui.text(Display.colToPixelX(colX)+1, Display.rowToPixelY(rowY)+2, "__", "green")
		elseif statIndex == table["statsorder"][dec + 2] then
			gui.text(Display.colToPixelX(colX)+1, Display.rowToPixelY(rowY)+2, "__", "red")
		end
	else
		if statIndex == table["statsorder"][inc + 1] then
			gui.text(Display.colToPixelX(colX)+1, Display.rowToPixelY(rowY)+2, "__", "grey")
		end
	end
end

-- Display status indicator (P1, P2, etc.)
function Display.statusIndicator(colX, rowY, substatus, mode, table, color)
	local statusText = (color == "green" and "P" or "E") .. substatus .. " (" .. table["modes"][mode] .. ")"
	gui.text(Display.colToPixelX(colX), Display.rowToPixelY(rowY), statusText, color)
end

-- Display frame counter
function Display.frameCounter(x, y, version)
	local frame
	if version == "POKEMON EMER" then
		frame = "F. E/R: " .. emu.framecount() .. "/" .. memory.readdwordunsigned(0x020249C0)
	else
		frame = "F. E: " .. emu.framecount()
	end
	gui.text(x, y, frame)
end

-- Display "More" menu with additional Pokemon details
function Display.moreMenu(settings, pokemon, gen, version, status, table, helditem, lastpid)
	gui.box(Display.colToPixelX(2) - 5, Display.rowToPixelY(3) - 5, Display.colToPixelX(39) - 5, Display.rowToPixelY(13) + 5, "#ffffcc", "#ffcc33")
	
	if gen >= 3 then
		Display.moreMenuGen3Plus(2, 3, pokemon, gen, table, helditem)
	else
		Display.moreMenuGen12(2, 3, pokemon, gen, version, status, table, helditem)
	end
	
	-- Hidden Power and Moves (all gens)
	Display.hiddenPower(2, 4, pokemon, table)
	Display.movesList(2, 6, pokemon, table)
end

-- More menu details for Gen 3-5
function Display.moreMenuGen3Plus(colX, rowY, pokemon, gen, table, helditem)
	local naturen = pokemon["nature"]["nature"] > 16 and pokemon["nature"]["nature"] - 16 or pokemon["nature"]["nature"]
	local natureColor = table["typecolor"][naturen]
	
	gui.text(Display.colToPixelX(colX), Display.rowToPixelY(rowY), "Nature")
	gui.text(Display.colToPixelX(colX + 8), Display.rowToPixelY(rowY), table["nature"][pokemon["nature"]["nature"] + 1], natureColor)
	
	local ability = gen == 3 and table["gen3ability"][pokemon["species"]][pokemon["ability"] + 1] or pokemon["ability"]
	local pokerus = pokemon["pokerus"] == 0 and "no" or "yes"
	
	local details = {
		{"OT ID : " .. pokemon["OTTID"]},
		{"OT SID : " .. pokemon["OTSID"]},
		{"XP : " .. pokemon["xp"]},
		{"Item : " .. helditem},
		{"Pokerus : " .. pokerus},
		{"Friendship : " .. pokemon["friendship"]}
	}
	
	for i, detail in ipairs(details) do
		gui.text(Display.colToPixelX(colX + 20), Display.rowToPixelY(rowY + i - 1), detail[1])
	end
	gui.text(Display.colToPixelX(2), Display.rowToPixelY(12), "Ability : " .. table["ability"][ability])
end

-- More menu details for Gen 1-2
function Display.moreMenuGen12(colX, rowY, pokemon, gen, version, status, table, helditem)
	gui.text(Display.colToPixelX(colX), Display.rowToPixelY(rowY), "TID: " .. pokemon["TID"] .. " / Item: " .. helditem)
	
	if gen == 2 or (version == "POKEMON YELL" and status == 1 and pokemon["species"] == 25) then
		gui.text(Display.colToPixelX(colX), Display.rowToPixelY(rowY + 2), "Friendship : " .. pokemon["friendship"])
	end
end

-- Display Hidden Power
function Display.hiddenPower(colX, rowY, pokemon, table)
	gui.text(Display.colToPixelX(colX), Display.rowToPixelY(rowY), "H.Power")
	gui.text(Display.colToPixelX(colX + 8), Display.rowToPixelY(rowY), 
			 table["type"][pokemon["hiddenpower"]["type"] + 1] .. " " .. pokemon["hiddenpower"]["base"],
			 table["typecolor"][pokemon["hiddenpower"]["type"] + 1])
end

-- Display moves list
function Display.movesList(colX, rowY, pokemon, table)
	gui.text(Display.colToPixelX(colX), Display.rowToPixelY(rowY), "Moves:")
	for i = 1, 4 do
		if table["move"][pokemon["move"][i]] ~= nil then
			gui.text(Display.colToPixelX(colX), Display.rowToPixelY(rowY + i), 
					 table["move"][pokemon["move"][i]] .. " - " .. pokemon["pp"][i] .. "PP")
		end
	end
end

-- Display performance stats (secret feature)
function Display.performanceStats(settings, lastclocktime, meanclocktime, highestclocktime, count)
	gui.text(Display.colToPixelX(2), Display.rowToPixelY(6), "Last clock time: " .. numTruncate(lastclocktime * 1000, 2) .. "ms")
	gui.text(Display.colToPixelX(2), Display.rowToPixelY(7), "Mean clock time: " .. numTruncate(meanclocktime * 1000, 2) .. "ms")
	gui.text(Display.colToPixelX(2), Display.rowToPixelY(8), "Most clock time: " .. numTruncate(highestclocktime * 1000, 2) .. "ms")
	gui.text(Display.colToPixelX(2), Display.rowToPixelY(9), "Data fetched: " .. count .. "x")
end