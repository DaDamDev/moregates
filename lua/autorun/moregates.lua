moregates = {}
moregates.loaded = {}

function moregates.printLoaded()
	print("+--------------------+")
	print("|     More Gates     |")
	print("|    Loaded Gates    |")
	print("+--------------------+")

	for k, v in pairs(moregates.loaded) do
		print("| "..k..string.rep(" ", 19 - #k).."|")
	end

	print("+--------------------+")
end

function moregates.load(gate)
	moregates.loaded[gate] = true
	timer.Create("moregates.printloadedgates", 0.1, 1, moregates.printLoaded)
end
