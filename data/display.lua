-- yPokemonStats Display Module
-- Handles all GUI rendering and display functions

Display = {}

local resolution = {x = 0, y = 0}

Display.GRID = {COLSX = 38, ROWSY = 17}

Display.GRID.MAX_COLX = Display.GRID.COLSX - 1
Display.GRID.MAX_ROWY = Display.GRID.ROWSY - 1

function Display.setResolution(res)
	resolution.x = res.x
	resolution.y = res.y
end

function Display.colToPixelX(colX)
	if colX < 0 or colX > Display.GRID.MAX_COLX then
		error("colX must be in range [0, " .. Display.GRID.MAX_COLX .. "]" .. " value is: " .. colX, 2)
	end
	return ((resolution.x-2) * colX) / Display.GRID.COLSX + 2
end

function Display.rowToPixelY(rowY)
	if rowY < 0 or rowY > Display.GRID.MAX_ROWY then
		error("rowY must be in range [0, " .. Display.GRID.MAX_ROWY .. "]" .. " value is: " .. rowY, 2)
	end
	return ((resolution.y-2) * rowY) / Display.GRID.ROWSY + 2
end

function Display.getRightAlignedColumn(text)
	local textLength = string.len(text)
	return Display.GRID.COLSX - textLength
end

function Display.mainRender(pokemon, gen, version, state, lastpid, monitor, key, table)
	-- UI data --
	local tmpcolor = state.selectedPkmnSide == 1 and "green" or "red"
	Display.showHelp(key, state, table)
	Display.statusIndicator((gen <= 2 and 17 or 0), (gen <= 2 and Display.GRID.MAX_ROWY or 0), state.pokemonSlot[1], state.mode, table, tmpcolor)
	Display.frameCounter(Display.colToPixelX(0), Display.rowToPixelY(Display.GRID.MAX_ROWY), version)
	Display.performanceStats(monitor)
	
	-- Pokemon data --
	if pokemon then
		speciesText = pokemon["species"] .. ":" .. pokemon["speciesname"]
	else
		speciesText = "0:No pokemon"
	end

	Display.statsDisplay(pokemon, gen, state.mode, state.pokemonSlot, lastpid, table, tmpcolor)
	
	-- PID (Gen 3+)
	if gen >= 3 then
		local pidStr = pokemon and bit.tohex(lastpid) or "00000000"
		gui.text(Display.colToPixelX(15), Display.rowToPixelY(Display.GRID.MAX_ROWY), "PID: " .. pidStr)
	end
	gui.text((gen <= 2) and Display.colToPixelX(Display.getRightAlignedColumn(speciesText)) or Display.colToPixelX(0), (gen <= 2) and Display.rowToPixelY(0) or Display.rowToPixelY(1), speciesText, pokemon and tmpcolor or "red")

	-- HP display
	local hp = (pokemon and pokemon["hp"]["current"] or 0) .. "/" .. (pokemon and pokemon["hp"]["max"] or 0)
	local hpText = gen <= 2 and (hp .. ":HP") or ("HP:" .. hp)
	if gen <= 2 then
		gui.text(Display.colToPixelX(Display.getRightAlignedColumn(hpText)), Display.rowToPixelY(1), hpText, pokemon and tmpcolor or "red")
	else
		gui.text(Display.colToPixelX(10), Display.rowToPixelY(0), hpText, pokemon and tmpcolor or "red")
	end

	-- Toggles if pokemon
	if pokemon then
		-- Shiny status
		shinyText = pokemon["shiny"] == 1 and "Shiny" or "Not shiny"
		gui.text(Display.colToPixelX(Display.getRightAlignedColumn(shinyText)), Display.rowToPixelY(Display.GRID.MAX_ROWY), shinyText, pokemon["shiny"] == 1 and "green" or "red")
		
		-- "More" menu
		if state.more == 1 then
			local helditem = pokemon["helditem"] == 0 and "none" or table["items"][gen][pokemon["helditem"]]
			Display.moreMenu(pokemon, gen, version, state, table, helditem, lastpid)
		end
	end
	

end

-- Display help menu
function Display.showHelp(key, state, table)
	if state.help ~= 1 then
		return
	end
	gui.box(Display.colToPixelX(2) - 5, Display.rowToPixelY(3) - 5, Display.colToPixelX(Display.GRID.MAX_COLX) - 5, Display.rowToPixelY(12) + 5, "#ffffcc", "#ffcc33")
	gui.text(Display.colToPixelX(2), Display.rowToPixelY(3), "yPokemonStats", "#ee82ee")
	gui.text(Display.colToPixelX(2), Display.rowToPixelY(4), "http://github.com/yling", "#87cefa")
	gui.text(Display.colToPixelX(2), Display.rowToPixelY(5), "-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-", "#ffcc33")
	local helpLines = {	{key.SWITCH_MODE,	": IVs, EVs, Stats and Contest stats", 5},
						{key.SWITCH_SELECTED_POKEMON,	": Player team / Enemy team", 4},
						{key.POKEMON_SLOT,	": Pokemon slot (1-6)", 3},
						{key.TOGGLE_MORE,	": Show more data", 2},
						{key.TOGGLE_HELP,	": Toggle this menu", 1}}
	for i, line in ipairs(helpLines) do
		gui.text(Display.colToPixelX(2), Display.rowToPixelY(6 + i), line[1] .. line[2], table["colors"][line[3]])
	end
end

local labels = {"HP","AT","DF","SA","SD","SP"} -- Stats labels (Keep in the same order)
local contests = {"CO","BE","CU","SM","TH","FE"} -- Contest stats labels (Keep in the same order)
local gen1labels = {"HP","AT","DF","SP","SC"}
local modesorder={"iv","ev","stats","contest"}

function Display.statsDisplay(pokemon, gen, mode, pokemonSlot, lastpid, table, color)
	local statCount = gen <= 2 and 5 or 6
	local statsLabels = mode == 4 and contests or (gen <= 2 and gen1labels or labels)
	
	-- Get IV data based on generation, default to 0s if no pokemon
	local ivData
	if not pokemon then
		ivData = {}
		for i = 1, statCount do
			ivData[i] = 0
		end
	else
		ivData = pokemon[modesorder[mode]]
	end
	
	-- Display stats
	if gen <= 2 then
		-- Gen 1-2: Vertical display on right side with "number:statname" format
		for i = 1, statCount do
			local row = i - 1
			local iv = ivData[i]
			local ivText = mode == 1 and iv == 15 and ( "*" .. iv) or iv
			local displayText = ivText .. ":" .. statsLabels[i]
			
			local rightCol = Display.getRightAlignedColumn(displayText)
			gui.text(Display.colToPixelX(rightCol), Display.rowToPixelY(row+2), displayText, table["colors"][i])
		end
	else
		-- Gen 3+: Horizontal display
		for i = 1, statCount do
			local colX = Display.GRID.COLSX - (i * 3)
			
			-- Label at top
			gui.text(Display.colToPixelX(colX), Display.rowToPixelY(0), statsLabels[statCount + 1 - i], table["colors"][statCount + 1 - i])
			
			-- IV value one row below
			local iv = ivData[statCount + 1 - i]
			local ivText = mode == 1 and iv == 31 and (iv .. "*") or iv
			gui.text(Display.colToPixelX(colX), Display.rowToPixelY(1), ivText, table["colors"][statCount + 1 - i])
			
			-- Nature indicator (not for mode 4/contests)
			if pokemon and mode ~= 4 then
				Display.natureIndicator(colX, 1, i, pokemon, table)
			end
		end
	end
end

-- Display nature stat modifiers (green for boost, red for reduction, grey for neutral)
function Display.natureIndicator(colX, rowY, statIndex, pokemon, table)
	local inc, dec = pokemon["nature"]["inc"], pokemon["nature"]["dec"]
	
	if inc ~= dec then
		if statIndex == table["statsorder"][inc + 2] then
			gui.text(Display.colToPixelX(colX), Display.rowToPixelY(rowY)+2, "__", "green")
		elseif statIndex == table["statsorder"][dec + 2] then
			gui.text(Display.colToPixelX(colX), Display.rowToPixelY(rowY)+2, "__", "red")
		end
	else
		if statIndex == table["statsorder"][inc + 1] then
			gui.text(Display.colToPixelX(colX), Display.rowToPixelY(rowY)+2, "__", "grey")
		end
	end
end

-- Display status indicator (P1, P2, etc.)
function Display.statusIndicator(colX, rowY, pokemonSlot, mode, table, color)
	statModes = {"IVs", "EVs", "Stats", "Cont."}
	local statusText = (color == "green" and "P" or "E") .. pokemonSlot .. " (" .. statModes[mode] .. ")"
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
function Display.moreMenu(pokemon, gen, version, state, table, helditem, lastpid)
	gui.box(Display.colToPixelX(2) - 5, Display.rowToPixelY(3) - 5, Display.colToPixelX(Display.GRID.MAX_COLX) - 5, Display.rowToPixelY(13) + 5, "#ffffcc", "#ffcc33")
	
	if gen >= 3 then
		Display.moreMenuGen3Plus(2, 3, pokemon, gen, table, helditem)
	else
		Display.moreMenuGen12(2, 3, pokemon, gen, version, state, table, helditem)
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
function Display.moreMenuGen12(colX, rowY, pokemon, gen, version, state, table, helditem)
	gui.text(Display.colToPixelX(colX), Display.rowToPixelY(rowY), "TID: " .. pokemon["TID"] .. " / Item: " .. helditem)
	
	if gen == 2 or (version == "POKEMON YELL" and state.pokemonSlot == 1 and pokemon["species"] == 25) then
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
function Display.performanceStats(monitor)
	if monitor.yling ~= 1 then
		return
	end
	gui.text(Display.colToPixelX(2), Display.rowToPixelY(6), "Last clock time: " .. numTruncate(monitor.lastclocktime * 1000, 2) .. "ms")
	gui.text(Display.colToPixelX(2), Display.rowToPixelY(7), "Mean clock time: " .. numTruncate(monitor.meanclocktime * 1000, 2) .. "ms")
	gui.text(Display.colToPixelX(2), Display.rowToPixelY(8), "Most clock time: " .. numTruncate(monitor.highestclocktime * 1000, 2) .. "ms")
	gui.text(Display.colToPixelX(2), Display.rowToPixelY(9), "Data fetched: " .. monitor.count .. "x")
end