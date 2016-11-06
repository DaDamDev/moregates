--[[
	Array gates
]]

loadedGate("Array")

GateActions("Array")

GateActions["array_length"] = {
	name = "Length",
	inputs = { "A" },
	inputtypes = { "ARRAY" },
	outputtypes = { "NORMAL" },
	output = function(gate, A)
		if !A then return 0 end
		return #A
	end,
	label = function(Out, A)
		return string.format("length(%s) = %s", A, Out)
	end
}

GateActions["array_remove"] = {
	name = "Remove",
	inputs = { "A" , "Index" },
	inputtypes = { "ARRAY" , "NORMAL" },
	outputtypes = { "ARRAY" },
	output = function(gate, A, B)
		if A and B and B <= #A then table.remove(A, B) end
		return A
	end,
	label = function(Out, A)
		return string.format("length(%s) = %s", A, Out)
	end
}

GateActions["array_slice"] = {
	name = "Slice",
	inputs = { "Array" , "Start" , "End" },
	inputtypes = { "ARRAY" , "NORMAL" , "NORMAL" },
	outputtypes = { "ARRAY" },
	output = function(gate, A, B, C)
		local tbl = {}
		
		if A and B and C then
			B = math.Clamp(B, 1, #A)
			C = math.Clamp(C, 1, #A)
			
			for i = B, C, 1 do
				table.insert(tbl, A[i])
				print("for: "..i)
			end
		end
		
		return tbl
	end,
	label = function(Out, A, B, C)
		return string.format("slice(%s, %s, %s)", A, B, C)
	end
}

-- Composer
GateActions["array_composer"] = {
	name = "Composer",
	inputs = { "A" , "Clk", "Reset" },
	inputtypes = { "NORMAL" , "NORMAL" , "NORMAL" },
	outputtypes = { "ARRAY" },
	output = function(gate, A, Clk, Reset)
		local clk = (Clk > 0)
		local reset = (Reset > 0)

		if gate.PrevValue != clk then
			gate.PrevValue = clk
			if clk then
				if gate.Memory == nil then
					gate.Memory = {A}
				else
					table.insert(gate.Memory, A)
				end
			end
		end

		if gate.PrevReset != reset then
			gate.PrevReset = reset
			if reset then
				gate.Memory = {}
			end
		end

		return gate.Memory
	end,
	label = function(Out, A, Clk, Reset)
		return string.format("Array insert(%s)", A)
	end
}

GateActions["array_composer_string"] = {
	name = "Composer (string)",
	inputs = { "A" , "Clk", "Reset" },
	inputtypes = { "STRING" , "NORMAL" , "NORMAL" },
	outputtypes = { "ARRAY" },
	output = function(gate, A, Clk, Reset)
		local clk = Clk > 0
		local reset = Reset > 0

		if gate.PrevValue != clk then
			gate.PrevValue = clk
			if clk then
				if gate.Memory == nil then
					gate.Memory = {A}
				else
					table.insert(gate.Memory, A)
				end
			end
		end

		if gate.PrevReset != reset then
			gate.PrevReset = reset
			if reset then
				gate.Memory = {}
			end
		end

		return gate.Memory
	end,
	label = function(Out, A, Clk, Reset)
		return string.format("Array insert(\"%s\")", A)
	end
}

GateActions["array_composer_vector"] = {
	name = "Composer (vector)",
	inputs = { "A" , "Clk", "Reset" },
	inputtypes = { "VECTOR" , "NORMAL" , "NORMAL" },
	outputtypes = { "ARRAY" },
	output = function(gate, A, Clk, Reset)
		local clk = Clk > 0
		local reset = Reset > 0

		if gate.PrevValue != clk then
			gate.PrevValue = clk
			if clk then
				if gate.Memory == nil then
					gate.Memory = {A}
				else
					table.insert(gate.Memory, A)
				end
			end
		end

		if gate.PrevReset != reset then
			gate.PrevReset = reset
			if reset then
				gate.Memory = {}
			end
		end

		return gate.Memory
	end,
	label = function(Out, A, Clk, Reset)
		return string.format("Array insert(%s,%s,%s)", A.x, A.y, A.z)
	end
}

GateActions["array_composer_angle"] = {
	name = "Composer (angle)",
	inputs = { "A" , "Clk", "Reset" },
	inputtypes = { "ANGLE" , "NORMAL" , "NORMAL" },
	outputtypes = { "ARRAY" },
	output = function(gate, A, Clk, Reset)
		local clk = Clk > 0
		local reset = Reset > 0

		if gate.PrevValue != clk then
			gate.PrevValue = clk
			if clk then
				if gate.Memory == nil then
					gate.Memory = {A}
				else
					table.insert(gate.Memory, A)
				end
			end
		end

		if gate.PrevReset != reset then
			gate.PrevReset = reset
			if reset then
				gate.Memory = {}
			end
		end

		return gate.Memory
	end,
	label = function(Out, A, Clk, Reset)
		return string.format("Array insert(%s,%s,%s)", A.p, A.y, A.r)
	end
}

GateActions["array_composer_entity"] = {
	name = "Composer (entity)",
	inputs = { "A" , "Clk", "Reset" },
	inputtypes = { "ENTITY" , "NORMAL" , "NORMAL" },
	outputtypes = { "ARRAY" },
	output = function(gate, A, Clk, Reset)
		local clk = Clk > 0
		local reset = Reset > 0

		if gate.PrevValue != clk then
			gate.PrevValue = clk
			if clk then
				if gate.Memory == nil then
					gate.Memory = {A}
				else
					table.insert(gate.Memory, A)
				end
			end
		end

		if gate.PrevReset != reset then
			gate.PrevReset = reset
			if reset then
				gate.Memory = {}
			end
		end

		return gate.Memory
	end,
	label = function(Out, A, Clk, Reset)
		return string.format("Array insert(%s)", A)
	end
}

GateActions["array_composer_ranger"] = {
	name = "Composer (ranger)",
	inputs = { "A" , "Clk", "Reset" },
	inputtypes = { "RANGER" , "NORMAL" , "NORMAL" },
	outputtypes = { "ARRAY" },
	output = function(gate, A, Clk, Reset)
		local clk = Clk > 0
		local reset = Reset > 0

		if gate.PrevValue != clk then
			gate.PrevValue = clk
			if clk then
				if gate.Memory == nil then
					gate.Memory = {A}
				else
					table.insert(gate.Memory, A)
				end
			end
		end

		if gate.PrevReset != reset then
			gate.PrevReset = reset
			if reset then
				gate.Memory = {}
			end
		end

		return gate.Memory
	end,
	label = function(Out, A, Clk, Reset)
		return string.format("Array insert(%s)", A)
	end
}

GateActions["array_composer_array"] = {
	name = "Composer (array)",
	inputs = { "A" , "Clk", "Reset" },
	inputtypes = { "ENTITY" , "NORMAL" , "NORMAL" },
	outputtypes = { "ARRAY" },
	output = function(gate, A, Clk, Reset)
		local clk = Clk > 0
		local reset = Reset > 0

		if gate.PrevValue != clk then
			gate.PrevValue = clk
			if clk then
				if gate.Memory == nil then
					gate.Memory = {A}
				else
					table.insert(gate.Memory, A)
				end
			end
		end

		if gate.PrevReset != reset then
			gate.PrevReset = reset
			if reset then
				gate.Memory = {}
			end
		end

		return gate.Memory
	end,
	label = function(Out, A, Clk, Reset)
		return string.format("Array insert(%s)", A)
	end
}

-- Insert
GateActions["array_insert"] = {
	name = "Insert",
	inputs = { "Array", "A" },
	inputtypes = { "ARRAY" , "NORMAL" },
	outputtypes = { "ARRAY" },
	output = function(gate, A, B)
		if A and B then table.insert(A, B) end
		return A
	end,
	label = function(Out, A, B)
		return string.format("insert(%s, %s)", A, B)
	end
}

GateActions["array_insert_string"] = {
	name = "Insert (string)",
	inputs = { "Array", "A" },
	inputtypes = { "ARRAY" , "STRING" },
	outputtypes = { "ARRAY" },
	output = function(gate, A, B)
		if A and B then table.insert(A, B) end
		return A
	end,
	label = function(Out, A, B)
		return string.format("insert(%s, \"%s\")", A, B)
	end
}

GateActions["array_insert_vector"] = {
	name = "Insert (vector)",
	inputs = { "Array", "A" },
	inputtypes = { "ARRAY" , "VECTOR" },
	outputtypes = { "ARRAY" },
	output = function(gate, A, B)
		if A and B then table.insert(A, B) end
		return A
	end,
	label = function(Out, A, B)
		return string.format("insert(%s, (%s,%s,%s))", A, B.x, B.y, B.z)
	end
}

GateActions["array_insert_angle"] = {
	name = "Insert (angle)",
	inputs = { "Array", "A" },
	inputtypes = { "ARRAY" , "ANGLE" },
	outputtypes = { "ARRAY" },
	output = function(gate, A, B)
		if A and B then table.insert(A, B) end
		return A
	end,
	label = function(Out, A, B)
		return string.format("insert(%s, (%s,%s,%s))", A, B.p, B.y, B.r)
	end
}

GateActions["array_insert_entity"] = {
	name = "Insert (entity)",
	inputs = { "Array", "A" },
	inputtypes = { "ARRAY" , "ENTITY" },
	outputtypes = { "ARRAY" },
	output = function(gate, A, B)
		if A and B then table.insert(A, B) end
		return A
	end,
	label = function(Out, A, B)
		return string.format("insert(%s, %s)", A, B)
	end
}

GateActions["array_insert_ranger"] = {
	name = "Insert (ranger)",
	inputs = { "Array", "A" },
	inputtypes = { "ARRAY" , "RANGER" },
	outputtypes = { "ARRAY" },
	output = function(gate, A, B)
		if A and B then table.insert(A, B) end
		return A
	end,
	label = function(Out, A, B)
		return string.format("insert(%s, %s)", A, B)
	end
}

GateActions["array_insert_array"] = {
	name = "Insert (array)",
	inputs = { "Array" , "A" },
	inputtypes = { "ARRAY" , "ARRAY" },
	outputtypes = { "ARRAY" },
	output = function(gate, A, B)
		if A and B then table.insert(A, B) end
		return A
	end,
	label = function(Out, A, B)
		return string.format("insert(%s, %s)", A, B)
	end
}

-- Index
GateActions["array_index"] = {
	name = "Index",
	inputs = { "A" , "Index" },
	inputtypes = { "ARRAY" , "NORMAL" },
	outputtypes = { "NORMAL" },
	output = function(gate, A, B)
		if !A or !B or B > #A then return 0 end
		return A[B]
	end,
	label = function(Out, A, B)
		return string.format("index(%s, %s) = %d", A, B, Out)
	end
}

GateActions["array_index_string"] = {
	name = "Index (string)",
	inputs = { "A" , "Index" },
	inputtypes = { "ARRAY" , "NORMAL" },
	outputtypes = { "STRING" },
	output = function(gate, A, B)
		if !A or !B or B > #A then return "" end
		return A[B]
	end,
	label = function(Out, A, B)
		return string.format("index(%s, %s) = %d", A, B, Out)
	end
}

GateActions["array_index_vector"] = {
	name = "Index (vector)",
	inputs = { "A" , "Index" },
	inputtypes = { "ARRAY" , "NORMAL" },
	outputtypes = { "VECTOR" },
	output = function(gate, A, B)
		if !A or !B or B > #A then return Vector(0, 0, 0) end
		return A[B]
	end,
	label = function(Out, A, B)
		return string.format("index(%s, %s) = (%d,%d,%d)", A, B, Out.x, Out.y, Out.z)
	end
}

GateActions["array_index_angle"] = {
	name = "Index (angle)",
	inputs = { "A" , "Index" },
	inputtypes = { "ARRAY" , "NORMAL" },
	outputtypes = { "ANGLE" },
	output = function(gate, A, B)
		if !A or !B or B > #A then return Angle(0, 0, 0) end
		return A[B]
	end,
	label = function(Out, A, B)
		return string.format("index(%s, %s) = (%d,%d,%d)", A, B, Out.p, Out.y, Out.r)
	end
}

GateActions["array_index_entity"] = {
	name = "Index (entity)",
	inputs = { "A" , "Index" },
	inputtypes = { "ARRAY" , "ENTITY" },
	outputtypes = { "NORMAL" },
	output = function(gate, A, B)
		if !A or !B or B > #A then return NULL end
		return A[B]
	end,
	label = function(Out, A, B)
		return string.format("index(%s, %s) = %d", A, B, Out)
	end
}

GateActions["array_index_ranger"] = {
	name = "Index (ranger)",
	inputs = { "A" , "Index" },
	inputtypes = { "ARRAY" , "NORMAL" },
	outputtypes = { "RANGER" },
	output = function(gate, A, B)
		if !A or !B or B > #A then return NULL end
		return A[B]
	end,
	label = function(Out, A, B)
		return string.format("index(%s, %s) = %s", A, B, tostring(Out))
	end
}

GateActions["array_index_array"] = {
	name = "Index (array)",
	inputs = { "A" , "Index" },
	inputtypes = { "ARRAY" , "NORMAL" },
	outputtypes = { "ARRAY" },
	output = function(gate, A, B)
		if !A or !B or B > #A then return {} end
		return A[B]
	end,
	label = function(Out, A, B)
		return string.format("index(%s, %s) = %s", A, B, tostring(Out))
	end
}

GateActions()