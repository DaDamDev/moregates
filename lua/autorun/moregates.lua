moregates = {}
moregates.loaded = {}

function moregates.printLoaded()
	print("+--------------------+\n|     More Gates     |\n|    Loaded Gates    |\n+--------------------+")

	for k, v in pairs(loadedGates) do
		local spaces = ""

		for i = 1, 19-#k, 1 do
			spaces = spaces.." "
		end

		print("| "..k..spaces.."|")
	end

	print("+--------------------+")
end

function moregates.load(gate)
	moregates.loaded[gate] = true
	timer.Create("moregates.printloadedgates", 0.1, 1, printLoadedGates)
end
