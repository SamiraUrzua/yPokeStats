-- yPokeStats 
-- by YliNG
-- v2.2
-- https://github.com/yling

if emu and not memory then
	console:log("This script is made to work with VBA-rr. It will not work with mGBA.")
	return false
end

dofile "data/tables.lua"  -- Tables with games data, and various data - including names
dofile "data/memory.lua"  -- Functions and Pokemon table generation
dofile "data/display.lua" -- Display module

local gamedata = getGameInfo() -- Gets game info
local version, lan, gen, resolution = gamedata[1], gamedata[2], gamedata[3], gamedata[4]
Display.setResolution(resolution)

-- Note : "O" seems to be the letter used in DSi enhanced games 
-- (Couldn't find any source for this, NDSi Enhanced french version of pokemon black still shows "F", Spanish NDSi Enhanced version still shows "S")
-- "O" seems to be (USA, Europe)
-- https://wiki.no-intro.org/index.php?title=Nintendo_-_Nintendo_DSi_(Digital)_(CDN)_dat_notes#Region_Code_to_No-Intro_Region_Map
if games[version][lan] == nil then -- If language is not available default to french
	if lan == "D" or lan == "H" or lan == "I" or lan == "O" or lan == "S" or lan == "X" or lan == "Y" or lan == "Z" then
		lan = "F"
	end
end

if version == 0 or not games[version] or not games[version][lan] then
	if games[version] and games[version]["E"] then
		print("This version is supported, but not in this language. Check gamesdata.lua to add it.")
	else
		print("This game isn't supported. Is it a hackrom ? It might work but you'll have to add it yourself. Check gamesdata.lua")
	end
	print("Version: "..version)
	print("Language: "..lan)
	print("Language: "..bit.tohex(lan))
	return
end

print("Welcome to yPokeStats Unified ")
print("Game :", games[version][lan][1])

pkmnSide = {PLAYER = 1, ENEMY = 2}

local key = {	SWITCH_MODE					= "J", -- Switch mode (EV,IV,Stats)
				SWITCH_SELECTED_POKEMON		= "K", -- Switch pokemon side (Enemy / player)
				POKEMON_SLOT				= "L", -- Pokemon Slot
				TOGGLE_MORE					= "M", -- Show more data
				TOGGLE_HELP					= "H"} -- Toggle help

local state = {selectedPkmnSide = pkmnSide.PLAYER, mode = 3, help = 0, more = 0, pokemonSlot = {1, 1}}
local cache = {lastpid = 0, lastchecksum = 0, lastPokemonSide = 1}
local pokemon = nil
local monitor = {yling = 0, count = 0, clockcount = 0, totalclocktime = 0, lastclocktime = 0, highestclocktime = 0, meanclocktime = 0}

local prev = input.get() -- Preparing the input tables - allows to check if a key has been pressed

function main() -- Main function - display (check memory.lua for calculations)
	nClock = os.clock() -- Set the clock (for performance monitoring)
	statusChange(input.get()) -- Check for key input and changes status
	
	-- Clear pokemon data when status changes to prevent displaying wrong pokemon
	if cache.lastPokemonSide ~= state.selectedPkmnSide then
		pokemon = nil
	end
	cache.lastPokemonSide = state.selectedPkmnSide
	
	-- Resolve pokemon memory address
	if state.selectedPkmnSide == pkmnSide.PLAYER then
		base = resolveBase(games[version][lan][2]) -- Player pokemon
	else 
		base = resolveBase(games[version][lan][3]) -- Enemy pokemon
	end
	
	size = games[version][lan][4]
	start = base + size * (state.pokemonSlot[state.selectedPkmnSide] - 1)
	
	-- Fetch pokemon data if valid memory found
	if start and (memory.readdwordunsigned(start) ~= 0 or memory.readbyteunsigned(start) ~= 0) then
		if checkLast(cache.lastpid, cache.lastchecksum, start, gen, state.selectedPkmnSide) == 0 or not pokemon or not pokemon["species"] then
			local fetched = fetchPokemon(start, gen, state.selectedPkmnSide)
			monitor.count = monitor.count + 1
			
			if fetched and fetched["species"] and fetched["speciesname"] then
				if fetched["hp"] and fetched["hp"]["max"] > 0 and fetched["hp"]["max"] < 1000 then
					pokemon = fetched
					if gen >= 3 then
						cache.lastpid = pokemon["pid"]
						cache.lastchecksum = pokemon["checksum"]
					else
						cache.lastpid = pokemon["species"]
						cache.lastchecksum = pokemon["ivs"]
					end
				end
			end
		end
	else
		-- No PID found - reset pokemonSlot
		if state.selectedPkmnSide == pkmnSide.PLAYER then
			state.pokemonSlot[1] = 1
		else
			state.pokemonSlot[2] = 1
		end
	end
	
	-- Script performance monitoring
	clocktime = os.clock() - nClock
	monitor.clockcount = monitor.clockcount + 1
	monitor.totalclocktime = monitor.totalclocktime + clocktime
	monitor.lastclocktime = clocktime ~= 0 and clocktime or monitor.lastclocktime
	monitor.highestclocktime = clocktime > monitor.highestclocktime and clocktime or monitor.highestclocktime
	monitor.meanclocktime = monitor.totalclocktime / monitor.clockcount
	
	-- Render
	Display.mainRender(pokemon, gen, version, state, cache.lastpid, monitor, key, table)
end

gui.register(main)

function statusChange(input)
	if input[key.SWITCH_MODE] and not prev[key.SWITCH_MODE] then 
		local max = (gen <= 2) and 3 or 4
		state.mode = (state.mode < max) and (state.mode + 1) or 1
	end
	if input[key.SWITCH_SELECTED_POKEMON] and not prev[key.SWITCH_SELECTED_POKEMON] then 
		state.selectedPkmnSide = (state.selectedPkmnSide == 1) and 2 or 1
	end
	if input[key.POKEMON_SLOT] and not prev[key.POKEMON_SLOT] then
		if gen <= 2 and state.selectedPkmnSide == pkmnSide.ENEMY then
			state.pokemonSlot[2] = 1
		else
			state.pokemonSlot[state.selectedPkmnSide] = (state.pokemonSlot[state.selectedPkmnSide] < 6) and (state.pokemonSlot[state.selectedPkmnSide] + 1) or 1
		end
	end
	if input[key.TOGGLE_MORE] and not prev[key.TOGGLE_MORE] then 
		state.help = 0
		state.more = (state.more == 1) and 0 or 1
	end
	if input[key.TOGGLE_HELP] and not prev[key.TOGGLE_HELP] then
		state.more = 0
		state.help = (state.help == 1) and 0 or 1
	end
	if input["Y"] and not prev["Y"] then
		state.more = 0
		state.help = 0
		monitor.yling = (monitor.yling == 1) and 0 or 1
	end
	prev = input
end