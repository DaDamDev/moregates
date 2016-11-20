AddCSLuaFile()
DEFINE_BASECLASS( "base_wire_entity" )
ENT.PrintName       = "Wire Adv Plug"
ENT.Author          = "DaDamRival"
ENT.Purpose         = "Links with a adv socket"
ENT.Instructions    = "Move a adv plug close to a adv socket to link them, and data will be transferred through the link."
ENT.WireDebugName = "Adv Plug"

function ENT:GetClosestSocket()
	local sockets = ents.FindInSphere( self:GetPos(), 100 )

	local ClosestDist
	local Closest

	for k,v in pairs( sockets ) do
		if (v:GetClass() == "gmod_wire_advsocket" and !v:GetNWBool( "Linked", false )) then
			local pos, _ = v:GetLinkPos()
			local Dist = self:GetPos():Distance( pos )
			if (ClosestDist == nil or ClosestDist > Dist) then
				ClosestDist = Dist
				Closest = v
			end
		end
	end

	return Closest
end

if CLIENT then
	function ENT:DrawEntityOutline()
		if (GetConVar("wire_advplug_drawoutline"):GetBool()) then
			self.BaseClass.DrawEntityOutline( self )
		end
	end
	return -- No more client
end

------------------------------------------------------------
-- Helper functions & variables
------------------------------------------------------------
local LETTERS = { "A", "B", "C", "D", "E", "F", "G", "H" }
local LETTERS_INV = {}
for k,v in pairs( LETTERS ) do
	LETTERS_INV[v] = k
end

function ENT:Initialize()
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self:SetNWBool( "Linked", false )

	self.Memory = {}
end

function ENT:Setup( InputType )
	self.InputType = InputType or "NORMAL"

	if (!self.Inputs or !self.Outputs or self.InputType != old) then
		if InputType != "NORMAL" then
			self.Inputs = WireLib.CreateInputs( self, { "In ["..InputType.."]" } )
			self.Outputs = WireLib.CreateOutputs( self, { "Out ["..InputType.."]" } )
		else
			self.Inputs = WireLib.CreateInputs( self, LETTERS )
			self.Outputs = WireLib.CreateOutputs( self, LETTERS )
		end
	end

	self:ShowOutput()
end

function ENT:TriggerInput( name, value )
	if (self.Socket and self.Socket:IsValid()) then
		self.Socket:SetValue( name, value )
	end
	self:ShowOutput()
end

function ENT:SetValue( name, value )
	if (!self.Socket or !self.Socket:IsValid()) then return end
	if (name == "In") then
		if InputType != "NORMAL" then
			WireLib.TriggerOutput( self, "Out", value )
		else
			for i = 1, #LETTERS do
				local val = (value or {})[i]
				
				WireLib.TriggerOutput( self, LETTERS[i], val )
			end
		end
	else
		if value != nil then
			if InputType != "NORMAL" then
				local data = table.Copy( self.Outputs.Out.Value )
				data[LETTERS_INV[name]] = value
				WireLib.TriggerOutput( self, "Out", data )
			else
				WireLib.TriggerOutput( self, name, value )
			end
		end
	end
	self:ShowOutput()
end

------------------------------------------------------------
-- WriteCell
-- Hi-speed support
------------------------------------------------------------
function ENT:WriteCell( Address, Value, WriteToMe )
	if (WriteToMe) then
		self.Memory[Address or 1] = Value or 0
		return true
	else
		if (self.Socket and self.Socket:IsValid()) then
			self.Socket:WriteCell( Address, Value, true )
			return true
		else
			return false
		end
	end
end

------------------------------------------------------------
-- ReadCell
-- Hi-speed support
------------------------------------------------------------
function ENT:ReadCell( Address )
	return self.Memory[Address or 1] or 0
end

function ENT:Think()
	self.BaseClass.Think( self )
	self:SetNWBool( "PlayerHolding", self:IsPlayerHolding() )
end

function ENT:ResetValues()
	local value
	
	if self.InputType == "STRING" then
		value = ""
	elseif self.InputType == "VECTOR" then
		value = Vector(0, 0, 0)
	elseif self.InputType == "ANGLE" then
		value = Angle(0, 0, 0)
	elseif self.InputType == "ENTITY" then
		value = nil
	elseif self.InputType == "NORMAL" then
		value = 0
	else
		value = {}
	end
	
	for i = 1, #LETTERS do
		WireLib.TriggerOutput( self, LETTERS[i], value )
	end
	
	self.Memory = {}
	self:ShowOutput()
end

------------------------------------------------------------
-- ResendValues
-- Resends the values when plugging in
------------------------------------------------------------
function ENT:ResendValues()
	if (!self.Socket) then return end
	if InputType != "NORMAL" then
		self.Socket:SetValue( "In", self.Inputs.In.Value )
	else
		for i = 1, #LETTERS do
			self.Socket:SetValue( LETTERS[i], self.Inputs[LETTERS[i]].Value )
		end
	end
end

function ENT:ShowOutput()
	local OutText = "Plug [" .. self:EntIndex() .. "]\n"
	
	if self.InputType == "STRING" then
		OutText = OutText .. "String input/outputs."
	elseif self.InputType == "VECTOR" then
		OutText = OutText .. "Vector input/outputs."
	elseif self.InputType == "ANGLE" then
		OutText = OutText .. "Angle input/outputs."
	elseif self.InputType == "ENTITY" then
		OutText = OutText .. "Entity input/outputs."
	elseif self.InputType == "NORMAL" then
		OutText = OutText .. "Number input/outputs."
	elseif self.InputType == "WIRELINK" then
		OutText = OutText .. "Wirelink input/outputs."
	elseif self.InputType == "VECTOR2" then
		OutText = OutText .. "2D Vector input/outputs."
	elseif self.InputType == "VECTOR4" then
		OutText = OutText .. "4D Vector input/outputs."
	elseif self.InputType == "ARRAY" then
		OutText = OutText .. "Array input/outputs."
	end
	
	if (self.Socket and self.Socket:IsValid()) then
		OutText = OutText .. "\nLinked to socket [" .. self.Socket:EntIndex() .. "]"
	end
	self:SetOverlayText(OutText)
end

duplicator.RegisterEntityClass( "gmod_wire_advplug", WireLib.MakeWireEnt, "Data", "InputType" )

function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
	if (info.Plug ~= nil) then
		ent:Setup( info.Plug.InputType )
	end

	self.BaseClass.ApplyDupeInfo(self, ply, ent, info, GetEntByID)
end
