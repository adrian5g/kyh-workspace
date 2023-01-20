function floating_button(action)
	gg.setVisible(false)
	while true do
		if gg.isVisible() then
			break
		end

		gg.sleep(300)
	end
	
	if action == "revert_values" then
		gg.setVisible(false)
		gg.setValues(revert)
		gg.clearResults()	
		gg.toast("Values Reversed, its now safe to buy.")
		floating_button("reopen_tournament_hats_menu")
	end
	
	if action == "reopen_tournament_hats_menu" then
		tournament_hats_menu()
	end
end

function unlock_wear_by_string(word)
	gg.setVisible(false)
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber(";" .. word, gg.TYPE_WORD)
	count = gg.getResultCount()
	revert = gg.getResults(count)
	gg.editAll(0, gg.TYPE_WORD)
	gg.toast("Select item, then click the gameguardian icon.")
	floating_button("revert_values")
end

function tournament_hats_menu()
	hats = {"tiara", "brain", "mushroom", "afro", "cowboy"}
	menu = gg.choice({"Burning Tiara", "Evil Brain", "Mushroom Hat", "Afro", "Cowboy Hat"}, nil, "Select the hat you want.")
	
	i = 0
	while not (i == #hats) do
		i = i + 1
		
		if menu == i then
			unlock_wear_by_string(hats[i])
		end
	end
end

gg.toast("script by kyh#8317 | method by Michael1541#9506")
tournament_hats_menu()
