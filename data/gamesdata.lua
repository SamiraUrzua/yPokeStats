-- This file contains the titles and memory adresses for every game.
-- You might have to modify the file if your game isn't supported.
-- However, all PAL languages should be supported. 
-- The console output should have reported the GAME TITLE and LANGUAGE if your game wasn't in this list
-- Here is the structure :

-- GAME TITLE is the game title. Look at your rom info to find it.
-- In theory, all games already have at least one language added.
--
-- LANGUAGE is the language letter - E for US, F for FR, J for Japan and all the other letters

-- If you don't know how to find the pokemon adresses, you'd better Google it. A comment in a script is not the place to learn.
-- Pro-tip : I think most EUR languages and US use the same adresses
-- 
-- games["GAME TITLE"]["LANGUAGE"][1] = Title for display
-- games["GAME TITLE"]["LANGUAGE"][2] = Player pokemon adress
-- games["GAME TITLE"]["LANGUAGE"][3] = Enemy pokemon adress
-- games["GAME TITLE"]["LANGUAGE"][4] = Offset between Pokemon

-- Here's and example you can copy and paste at the end of the file (it matters)
-- (You have to remove the "--" or it'll stay a comment
--
-- For Pokemon Ruby FR (but all PAL are treated as FR)
-- games["POKEMON RUBY"]["F"][1] = {"Pokemon Rubis (FR)", 0x03004360, 0x30045C0, 0x64}

-- This creates the arrays to hold the game data, don't change it (excepted if I forgot a game)
games["POKEMON RED"],games["POKEMON BLUE"],games["POKEMON YELL"],games["POKEMON GREE"]={},{},{},{}
games["POKEMON_GLDA"],games["POKEMON_SLVA"],games["PM_CRYSTALB"]={},{},{}
games["POKEMON RUBY"],games["POKEMON SAPP"],games["POKEMON EMER"],games["PKMN EMER P "],games["POKEMON FIRE"],games["POKEMON LEAF"]={},{},{},{},{},{} -- Gen 3
games["POKEMON D"],games["POKEMON P"],games["POKEMON PL"],games["POKEMON HG"],games["POKEMON SS"]={},{},{},{},{} -- Gen 4
games["POKEMON B"],games["POKEMON W"],games["POKEMON B2"],games["POKEMON W2"]={},{},{},{} -- Gen 5

-- These are used to identify gen 1 & 2 games
games["lan"]={}
games["lan"][1]={}
games["lan"][2]={}
games["lan"][1]["J"]={0xc1a2,0x36dc,0xd5dd,0x299c,0x47F5} -- JAP gen 1
games["lan"][1]["E"]={0xe691,0xa9d,0x7c04} -- US gen 1
games["lan"][1]["F"]={0xd289,0x9c5e,0xdc5c,0xbc2e,0x4a38,0xd714,0xfc7a,0xa456,0x8f4e,0xfb66,0x3756,0xc1b7} -- PAL gen 1
games["lan"][2]["J"]={0x409A,0x341D,0x708A} -- JAP gen 2
games["lan"][2]["E"]={0xAE0D,0xD218,0x2D68} -- US gen 2
games["lan"][2]["F"]={0xC66F,0xE2F2,0x5073,0x97DC,0x8249,0x6ECD,0xF442,0x5393,0x4B06,0x8CFB,0xBADB,0x0CCE} -- PAL gen 2

-- Gen 1
games["POKEMON RED"]["F"]={"Pokemon Red (PAL)",{ptr=0xD170},{ptr=0xCFEA},44}
games["POKEMON RED"]["E"]={"Pokemon Red (US)",{ptr=0xD16B},{ptr=0xCFE5},44}
games["POKEMON RED"]["J"]={"Pokemon Red (JAP)",{ptr=0xD12B},{ptr=0xCFCC},44}

games["POKEMON BLUE"]["F"]={"Pokemon Blue (PAL)",{ptr=0xD170},{ptr=0xCFEA},44}
games["POKEMON BLUE"]["E"]={"Pokemon Blue (US)",{ptr=0xD16B},{ptr=0xCFE5},44}
games["POKEMON BLUE"]["J"]={"Pokemon Blue (JAP)",{ptr=0xD12B},{ptr=0xCFCC},44}

games["POKEMON YELL"]["F"]={"Pokemon Yellow (PAL)",{ptr=0xD16F},{ptr=0xCFE9},44}
games["POKEMON YELL"]["E"]={"Pokemon Yellow (US)",{ptr=0xD16A},{ptr=0xCFE4},44}
games["POKEMON YELL"]["J"]={"Pokemon Yellow (JAP)",{ptr=0xD12B},{ptr=0xCFCC},44}

games["POKEMON GREE"]["J"]={"Pokemon Green (JAP)",{ptr=0xD12B},{ptr=0xCFCC},44}

-- Gen 2
games["POKEMON_GLDA"]["F"]={"Pokemon Gold (PAL)",{ptr=0xDA2A},{ptr=0xD0EF},48}
games["POKEMON_GLDA"]["E"]={"Pokemon Gold (US)",{ptr=0xDA2A},{ptr=0xD0EF},48}
games["POKEMON_GLDA"]["J"]={"Pokemon Gold (JAP)",{ptr=0xD9F0},{ptr=0xD0E1},48}

games["POKEMON_SLVA"]["F"]={"Pokemon Silver (PAL)",{ptr=0xDA2A},{ptr=0xD0EF},48}
games["POKEMON_SLVA"]["E"]={"Pokemon Silver (US)",{ptr=0xDA2A},{ptr=0xD0EF},48}
games["POKEMON_SLVA"]["J"]={"Pokemon Silver (JAP)",{ptr=0xD9F0},{ptr=0xD0E1},48}

games["PM_CRYSTALB"]["E"]={"Pokemon Crystal 1.1 (US)",{ptr=0xDCDF},{ptr=0xD206},48}
games["PM_CRYSTALB"]["F"]={"Pokemon Crystal 1.1 (PAL)",{ptr=0xDCDF},{ptr=0xD206},48}
games["PM_CRYSTALB"]["J"]={"Pokemon Crystal 1.1 (JAP)",{ptr=0xDCA5},{ptr=0xD237},48}


-- Gen 3
games["POKEMON RUBY"]["E"]={"Pokemon Ruby (US)",{ptr=0x03004360},{ptr=0x030045C0},100} -- RUBY US - OK
games["POKEMON RUBY"]["F"]={"Pokemon Ruby (PAL)",{ptr=0x03004370},{ptr=0x030045D0},100} -- RUBY FR - OK
games["POKEMON RUBY"]["J"]={"Pokemon Ruby (JAP)",{ptr=0x03004290},{ptr=0x030044F0},100} -- RUBY J - OK

games["POKEMON SAPP"]["E"]={"Pokemon Sapphire (US)",{ptr=0x03004360},{ptr=0x030045C0},100} -- SAPPHIRE US - OK
games["POKEMON SAPP"]["F"]={"Pokemon Sapphire (PAL)",{ptr=0x03004370},{ptr=0x030045D0},100} -- SAPPHIRE FR - OK
games["POKEMON SAPP"]["J"]={"Pokemon Sapphire (JAP)",{ptr=0x03004290},{ptr=0x030044F0},100} -- SAPPHIRE J - OK

games["POKEMON EMER"]["E"]={"Pokemon Emerald (US)",{ptr=0x020244EC},{ptr=0x02024744},100} -- EMERALD US - OK
games["POKEMON EMER"]["F"]={"Pokemon Emerald (PAL)",{ptr=0x020244EC},{ptr=0x02024744},100} -- EMERALD FR - OK
games["PKMN EMER P "]["F"]={"Pokemon Emeraude+",{ptr=0x020244EC},{ptr=0x02024744},100} -- EMERAUDE PLUS - OK
games["POKEMON EMER"]["J"]={"Pokemon Emerald (JAP)",{ptr=0x02024190},{ptr=0x020242E8},100} -- EMERALD J - OK

games["POKEMON FIRE"]["E"]={"Pokemon Fire Red (US)",{ptr=0x02024284},{ptr=0x0202402C},100} -- FIRE RED US - OK
games["POKEMON FIRE"]["F"]={"Pokemon Fire Red (PAL)",{ptr=0x02024284},{ptr=0x0202402C},100} -- FIRE RED FR - OK
games["POKEMON FIRE"]["J"]={"Pokemon Fire Red (JAP)",{ptr=0x020241E4},{ptr=0x02023F8C},100} -- FIRE RED JAP - OK

games["POKEMON LEAF"]["E"]={"Pokemon Leaf Green (US)",{ptr=0x02024284},{ptr=0x0202402C},100} -- LEAF GREEN US - OK
games["POKEMON LEAF"]["F"]={"Pokemon Leaf Green (PAL)",{ptr=0x02024284},{ptr=0x0202402C},100} -- LEAF GREEN FR - OK
games["POKEMON LEAF"]["J"]={"Pokemon Leaf Green (JAP)",{ptr=0x020241E4},{ptr=0x02023F8C},100} -- LEAF GREEN JAP - OK

-- Gen 4
games["POKEMON D"]["F"]={"Pokemon Diamond (PAL)",{ptr=0x0210712C,add=0xD2AC},{ptr=0x0210712C,chain={0x364C8},add=0x774},0xEC} -- OK
games["POKEMON D"]["E"]={"Pokemon Diamond (US)", {ptr=0x0210712C,add=0xD2AC},{ptr=0x0210712C,chain={0x364C8},add=0x774},0xEC} -- OK
games["POKEMON D"]["J"]={"Pokemon Diamond (JAP)",{ptr=0x0210712C,add=0xD2AC},{ptr=0x0210712C,chain={0x364C8},add=0x774},0xEC} -- UNTESTED

games["POKEMON P"]["F"]={"Pokemon Pearl (PAL)",  {ptr=0x0210712C,add=0xD2AC},{ptr=0x0210712C,chain={0x364C8},add=0x774},0xEC} -- OK
games["POKEMON P"]["E"]={"Pokemon Pearl (US)",   {ptr=0x0210712C,add=0xD2AC},{ptr=0x0210712C,chain={0x364C8},add=0x774},0xEC} -- OK
games["POKEMON P"]["J"]={"Pokemon Pearl (JAP)",  {ptr=0x0210712C,add=0xD2AC},{ptr=0x0210712C,chain={0x364C8},add=0x774},0xEC} -- UNTESTED

games["POKEMON PL"]["F"]={"Pokemon Platinum (PAL)",{ptr=0x02101D2C,add=0xD094},{ptr=0x02101D2C,chain={0x352F4},add=0x7A0},0xEC} -- OK
games["POKEMON PL"]["E"]={"Pokemon Platinum (US)", {ptr=0x02101D2C,add=0xD094},{ptr=0x02101D2C,chain={0x352F4},add=0x7A0},0xEC} -- OK
games["POKEMON PL"]["J"]={"Pokemon Platinum (JAP)",{ptr=0x02101D2C,add=0xD094},{ptr=0x02101D2C,chain={0x352F4},add=0x7A0},0xEC} -- UNTESTED

games["POKEMON SS"]["F"]={"Pokemon SoulSilver (PAL)",{ptr=0x021D110C,add=0x12},{ptr=0x021D110C,add=0x4EFD2},0xEC} -- OK
games["POKEMON SS"]["E"]={"Pokemon SoulSilver (US)", {ptr=0x021D10EC,add=0x12},{ptr=0x021D10EC,add=0x4EFD2},0xEC} -- OK
games["POKEMON SS"]["J"]={"Pokemon SoulSilver (JAP)",{ptr=0x021D10EC,add=0x12},{ptr=0x021D10EC,add=0x4EFD2},0xEC} -- UNTESTED

games["POKEMON HG"]["F"]={"Pokemon HeartGold (PAL)",{ptr=0x021D110C,add=0x12},{ptr=0x021D110C,add=0x4EFD2},0xEC} -- OK
games["POKEMON HG"]["E"]={"Pokemon HeartGold (US)", {ptr=0x021D10EC,add=0x12},{ptr=0x021D10EC,add=0x4EFD2},0xEC} -- OK
games["POKEMON HG"]["J"]={"Pokemon HeartGold (JAP)",{ptr=0x021D10EC,add=0x12},{ptr=0x021D10EC,add=0x4EFD2},0xEC} -- UNTESTED

-- Gen 5
games["POKEMON B"]["E"] = {"Pokemon Black (US)", {ptr=0x02234934}, {ptr=0x0226AC74}, 0xDC} -- UNTESTED
games["POKEMON B"]["J"] = {"Pokemon Black (JAP)", {ptr=0x02234934}, {ptr=0x0226AC74}, 0xDC} -- UNTESTED
games["POKEMON B"]["F"] = {"Pokemon Black (PAL)", {ptr=0x02234934}, {ptr=0x0226AC74}, 0xDC} -- OK
games["POKEMON B"]["O"] = {"Pokemon Black (USA, Europe)", {ptr=0x022349B4}, {ptr=0x0226ACF4}, 0xDC} -- OK

games["POKEMON W"]["E"] = {"Pokemon White (US)", {ptr=0x02234954}, {ptr=0x0226AC94}, 0xDC} -- UNTESTED
games["POKEMON W"]["J"] = {"Pokemon White (JAP)", {ptr=0x02234954}, {ptr=0x0226AC94}, 0xDC} -- UNTESTED
games["POKEMON W"]["F"] = {"Pokemon White (PAL)", {ptr=0x02234954}, {ptr=0x0226AC94}, 0xDC} -- OK

games["POKEMON B2"]["E"] = {"Pokemon Black 2 (US)", {ptr=0x0221E3EC}, {ptr=0x02258834}, 0xDC} -- UNTESTED
games["POKEMON B2"]["J"] = {"Pokemon Black 2 (JAP)", {ptr=0x0221E3EC}, {ptr=0x02258834}, 0xDC} -- UNTESTED
games["POKEMON B2"]["F"] = {"Pokemon Black 2 (PAL)", {ptr=0x0221E3EC}, {ptr=0x02258834}, 0xDC} -- OK

games["POKEMON W2"]["E"] = {"Pokemon White 2 (US)", {ptr=0x0221E42C}, {ptr=0x02258874}, 0xDC} -- UNTESTED
games["POKEMON W2"]["J"] = {"Pokemon White 2 (JAP)", {ptr=0x0221E42C}, {ptr=0x02258874}, 0xDC} -- UNTESTED
games["POKEMON W2"]["F"] = {"Pokemon White 2 (PAL)", {ptr=0x0221E42C}, {ptr=0x02258874}, 0xDC} -- OK