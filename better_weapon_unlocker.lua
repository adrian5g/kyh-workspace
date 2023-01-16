configFile = gg.getFile():gsub('%.lua$', '_favorites.cfg')

function list_merge(lists)
	result = {}
	for i = 1, #lists, 1 do
		for j = 1, #lists[i], 1 do
			result[#result + 1] = lists[i][j]
		end
	end
	return result
end

function list_reform(list)
	reformed = {}
	for i = 1, #list, 1 do
		if list[i] ~= nil then
			reformed[#reformed + 1] = list[i]
		end
	end
	return reformed
end

function load_favorites()
	data = loadfile(configFile) 
	
	if data ~= nil then 
		favorites = data()
	else
		favorites = {
			{"177168788", "1594909746", "307472056", "693501208", "1582570772", "1064416293", "1674620181"},
			{"#416 Ultimatum", "#849 Rebel", "#1108 Fake Pistol", "#673 Heroic Epee", "#737 Vertical Grip Device", "#759 Harsh Punisher", "#978 Dislike"}
		} -- default values
	end
end

function save_favorites()
	favorites[1] = list_reform(favorites[1])
	favorites[2] = list_reform(favorites[2])
	gg.saveVariable(favorites, configFile)
end

function unlock_weapon_by_id(id)
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber(id, gg.TYPE_DWORD)

	count = gg.getResultsCount()
	indexes = {3, 4, 4, 4, 5, 6, 7, 8, 9}
	
	if count > 5 and count < 15 then
		gg.getResults(100)
		gg.getResults(gg.getResultsCount() - indexes[gg.getResultsCount() - 5])
		gg.editAll('1', gg.TYPE_DWORD)
		gg.clearResults()
	end
end

function weapons_by_ids_menu(ids, names, favs)
	menu = gg.multiChoice(names, nil, "Choose weapons")
	
	if menu == nil then
		if favs then favorite_weapons_menu() else main() end
	else
		for i = 1, #ids, 1 do
			if menu[i] then
				unlock_weapon_by_id(ids[i])
			end
		end
	end
end

function favorite_weapons_menu()
	menu = gg.choice({" ➡️ Add Weapon", " ➡️ Remove Weapon", " ➡️ Unlock Favorite Weapons"}, nil, 'Favorite Weapons')
	
	if menu == nil then
		main()
	elseif menu == 1 then
		prompt = gg.prompt({'Weapon ID', 'Weapon Name'}, nil, {'text', 'text'})
		
		if prompt ~= nil then
			ids = favorites[2]
			names = favorites[1]
			ids[#ids + 1] = prompt[1]
			names[#names + 1] = prompt[2]
			favorites[1] = ids
			favorites[2] = names
			
			save_favorites()
		end
		
		favorite_weapons_menu()
	elseif menu == 2 then
		menu = gg.multiChoice(favorites[2], nil, "Choose weapons to remove")
		
		if menu ~= nil then
			for i = 1, #favorites[1], 1 do
				if menu[i] then
					favorites[1][i] = nil
					favorites[2][i] = nil
				end
			end
			
			save_favorites()
		end
		favorite_weapons_menu()
	elseif menu == 3 then
		weapons_by_ids_menu(favorites[1], favorites[2], true)
	end
end

function main()
	clan_weps = {
		{"893029663", "1022557565", "1332757687", "371505332", "150121465", "2014352 882", "1050623880", "1839516694", "1718475051", "1497857667", "429167017", "1337213795", "1526449622", "1945738349", "507783760", "1880417961", "1345616674", "1973235416", "498933114", "1010284142", "742787636", "851586844", "976372763", "84097771"},
		{"#240 Excalibur", "#242 Reaper", "#255 Power Fists", "#241 Poseidon Trident", "#238 Third Eye", "#239 Eraser", "#663 Lancelot", "#664 Galahad", "#665 Percival & Lamorak", "#666 Mordred", "#667 Morgana", "#668 Bedivere", "#682 Golden Bros", "#683 Gangsta Shield", "#684 Double Cashback", "#685 Luxury Beats", "#686 Sniper Dude", "#687 Gem Power", "#1057 Rune Buster", "#1058 Ice Wyvern Horns", "#1059 Runic Sentinel", "#1060 Crystal Touch", "#1061 Crystal Bow", "#1062 Enchanted Crystal of Ancients"}
	}

	menu = gg.choice({" ⭐ Favorite Weapons", " ➡️ Unlock Clan Weapons", " ➡️ Unlock All"}, nil, "Made with ❤️ by kyh#8317\n \nVisite my Github:\ngithub.com/Noisier/Kyh-Workspace")

	if menu == 1 then
		favorite_weapons_menu()
	elseif menu == 2
		then weapons_by_ids_menu(clan_weps[1], clan_weps[2], false)
	elseif menu == 3 then
		all_ids = list_merge({favorites[1], clan_weps[1]})
		all_names = list_merge({favorites[2], clan_weps[2]})
		
		values = {}
		for i = 1, #all_names, 1 do
			values[#values + 1] = true 
		end
		
		choices = gg.multiChoice(all_names, values, "Uncheck the weapons you don't want to unlock")
		
		if choices == nil then
			main()
		else
			for i = 1, #all_ids, 1 do
				if choices[i] then
					unlock_weapon_by_id(all_ids[i])
				end
			end
		end
	end
end

load_favorites()
main()
