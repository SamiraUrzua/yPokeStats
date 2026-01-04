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
version, lan, gen, resolution = gamedata[1], gamedata[2], gamedata[3], gamedata[4]
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

settings={}
settings["key"] = {	SWITCH_MODE		= "J", -- Switch mode (EV,IV,Stats)
					SWITCH_STATUS	= "K", -- Switch status (Enemy / player)
					SUB_STATUS		= "L", -- Sub Status + (Pokemon Slot)
					TOGGLE_MORE		= "M", -- Show more data
					TOGGLE_HELP		= "H"} -- Toggle help

status, mode, help= 1, 1, 1 -- Default status and substatus - 1,1,1 is Player's first Pokémon
substatus={1, 1, 1}
lastpid,lastchecksum=0, 0 -- Will be useful to avoid re-loading the same pokemon over and over again
count,clockcount,totalclocktime,lastclocktime,highestclocktime,yling=0, 0, 0, 0, 0, 0 -- Monitoring - useless

local prev = input.get() -- Preparing the input tables - allows to check if a key has been pressed

function main() -- Main function - display (check memory.lua for calculations)
	nClock = os.clock() -- Set the clock (for performance monitoring -- useless)
	statusChange(input.get()) -- Check for key input and changes status
	
	if help==1 then -- Help screen display
		Display.showHelp(settings, table)
	end
	
	if status == 1 then -- Resolve pokemon memory address
		base = resolveBase(games[version][lan][2]) -- Player pokemon
	else 
		base = resolveBase(games[version][lan][3]) -- Enemy pokemon
	end
	size = games[version][lan][4]
	start = base + size * (substatus[status] - 1)
	
	if start and (memory.readdwordunsigned(start) ~= 0 or memory.readbyteunsigned(start) ~= 0) then
		if checkLast(lastpid, lastchecksum, start, gen) == 0 or not pokemon or not pokemon["species"] then
			local fetched = fetchPokemon(start)
			count = count + 1
			
			if fetched and fetched["species"] and fetched["speciesname"] then
				if fetched["hp"] and fetched["hp"]["max"] > 0 and fetched["hp"]["max"] < 1000 then -- Check that stats loaded correctly
					pokemon = fetched
					if gen >= 3 then
						lastpid = pokemon["pid"]
						lastchecksum = pokemon["checksum"]
					else
						lastpid = pokemon["species"]
						lastchecksum = pokemon["ivs"]
					end
				end
			end
		end
		Display.mainRender(settings, pokemon, gen, version, status, mode, substatus, lastpid, more, table)
	else -- No PID found
		if status == 1 then -- If player team just reset to slot 1
			substatus[1] = 1
		else -- If enemy team just reset to slot 1
			substatus[2] = 1
		end
		Display.noPokemon(settings)
	end
	
	-- Script performance (useless)
	clocktime = os.clock()-nClock
	clockcount = clockcount + 1
	totalclocktime = totalclocktime+clocktime
	lastclocktime = clocktime ~= 0 and clocktime or lastclocktime
	highestclocktime = clocktime > highestclocktime and clocktime or highestclocktime
	meanclocktime = totalclocktime/clockcount
	if yling==1 then -- I lied, there's a secret key to display script performance, but who cares besides me? (It's Y)
		Display.performanceStats(settings, lastclocktime, meanclocktime, highestclocktime, count)
	end
end

gui.register(main)