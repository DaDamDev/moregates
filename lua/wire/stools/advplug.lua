WireToolSetup.setCategory( "Input, Output/Data Transfer" )
WireToolSetup.open( "advplug", "Adv Plug", "gmod_wire_advsocket", nil, "Plugs" )

if (SERVER) then

	CreateConVar("sbox_maxwire_advplugs",20)
	CreateConVar("sbox_maxwire_advsockets",20)

	//resource.AddFile("models/bull/various/usb_socket.mdl")
	//resource.AddFile("materials/bull/various/usb_socket.vtf")

	//resource.AddFile("models/bull/various/usb_stick.mdl")
	//resource.AddFile("materials/bull/various/usb_stick.vtf")

else
	language.Add( "Tool.wire_advplug.name", "Adv Plug & Socket Tool (Wire)" )
	language.Add( "Tool.wire_advplug.desc", "Spawns plugs and sockets for use with the wire system." )
	language.Add( "Tool.wire_plug.0", "Primary: Create/Update Socket, Secondary: Create/Update Plug" )
	language.Add( "sboxlimit_wire_advplugs", "You've hit the Wire Adv Plugs limit!" )
	language.Add( "sboxlimit_wire_advsockets", "You've hit the Wire Adv Sockets limit!" )
	language.Add( "undone_wireadvplug", "Undone Wire Adv Plug" )
	language.Add( "undone_wireadvsocket", "Undone Wire Adv Socket" )

	language.Add( "Tool_wire_advplug_freeze", "Freeze the socket." )
	language.Add( "Tool_wire_advplug_type", "Type:" )
	language.Add( "Tool_wire_advplug_weldforce", "Plug weld force:" )
	language.Add( "Tool_wire_advplug_attachrange", "Plug attachment detection range:" )
	language.Add( "Tool_wire_advplug_drawoutline", "Draw the white outline on plugs and sockets." )
	language.Add( "Tool_wire_advplug_drawoutline_tooltip", "Disabling this helps you see inside the USB plug model when you set its material to wireframe." )
end

TOOL.ClientConVar["model"] = "models/props_lab/tpplugholder_single.mdl"
TOOL.ClientConVar["freeze"] = 1
TOOL.ClientConVar["type"] = "NORMAL"
TOOL.ClientConVar["weldforce"] = 5000
TOOL.ClientConVar["attachrange"] = 5
TOOL.ClientConVar["drawoutline"] = 1

local SocketModels = {
	["models/props_lab/tpplugholder_single.mdl"] = "models/props_lab/tpplug.mdl",
	["models/bull/various/usb_socket.mdl"] = "models/bull/various/usb_stick.mdl",
	["models/hammy/pci_slot.mdl"] = "models/hammy/pci_card.mdl",
	["models/wingf0x/isasocket.mdl"] = "models/wingf0x/isaplug.mdl",
	["models/wingf0x/altisasocket.mdl"] = "models/wingf0x/isaplug.mdl",
	["models/wingf0x/ethernetsocket.mdl"] = "models/wingf0x/ethernetplug.mdl",
	["models/wingf0x/hdmisocket.mdl"] = "models/wingf0x/hdmiplug.mdl"
}

local AngleOffset = {
	["models/props_lab/tpplugholder_single.mdl"] = Angle(0,0,0),
	["models/props_lab/tpplug.mdl"] = Angle(0,0,0),
	["models/bull/various/usb_socket.mdl"] = Angle(0,0,0),
	["models/bull/various/usb_stick.mdl"] = Angle(0,0,0),
	["models/hammy/pci_slot.mdl"] = Angle(90,0,0),
	["models/hammy/pci_card.mdl"] = Angle(90,0,0),
	["models/wingf0x/isasocket.mdl"] = Angle(90,0,0),
	["models/wingf0x/isaplug.mdl"] = Angle(90,0,0),
	["models/wingf0x/altisasocket.mdl"] = Angle(90,00,0),
	["models/wingf0x/ethernetsocket.mdl"] = Angle(90,0,0),
	["models/wingf0x/ethernetplug.mdl"] = Angle(90,0,0),
	["models/wingf0x/hdmisocket.mdl"] = Angle(90,0,0),
	["models/wingf0x/hdmiplug.mdl"] = Angle(90,0,0)
}

cleanup.Register( "wire_advplugs" )

function TOOL:GetModel()
	local model = self:GetClientInfo( "model" )
	if (!util.IsValidModel( model ) or !util.IsValidProp( model ) or !SocketModels[ model ]) then return "models/props_lab/tpplugholder_single.mdl" end
	return model
end

function TOOL:GetAngle( trace )
	local Ang
	if math.abs(trace.HitNormal.x) < 0.001 and math.abs(trace.HitNormal.y) < 0.001 then 
		return Vector(0,0,trace.HitNormal.z):Angle() + (AngleOffset[self:GetModel()] or Angle(0,0,0))
	else
		return trace.HitNormal:Angle() + (AngleOffset[self:GetModel()] or Angle(0,0,0))
	end
end

if SERVER then
	function TOOL:GetConVars() 
		return self:GetClientInfo("type"), self:GetClientNumber("weldforce"), math.Clamp(self:GetClientNumber("attachrange"), 1, 100)
	end
	
	-- Socket creation handled by WireToolObj
end

-- Create Plug
function TOOL:RightClick( trace )
	if (!trace) then return false end
	if (trace.Entity) then
		if (trace.Entity:IsPlayer()) then return false end
		if (trace.Entity:GetClass() == "gmod_wire_advplug") then
			if (CLIENT) then return true end
			trace.Entity:Setup(self:GetClientInfo("type"))
			return true
		end
	end
	if (CLIENT) then return true end
	if not util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) then return false end

	local ply = self:GetOwner()
	local plugmodel = SocketModels[self:GetModel()]

	local plug = WireLib.MakeWireEnt(ply, {Class = "gmod_wire_advplug", Pos=trace.HitPos, Angle=self:GetAngle(trace), Model=plugmodel}, self:GetClientInfo("type"))
	if not IsValid(plug) then return false end

	plug:SetPos( trace.HitPos - trace.HitNormal * plug:OBBMins().x )

	undo.Create("wireadvplug")
		undo.AddEntity( plug )
		undo.SetPlayer( ply )
	undo.Finish()

	ply:AddCleanup( "wire_advplugs", plug )

	return true
end

function TOOL.BuildCPanel( panel )
	WireToolHelpers.MakePresetControl(panel, "wire_advplug")
	ModelPlug_AddToCPanel(panel, "Socket", "wire_advplug")
	panel:CheckBox("#Tool_wire_advplug_freeze", "wire_advplug_freeze")
	panel:CheckBox("#Tool_wire_advplug_drawoutline", "wire_advplug_drawoutline")
	panel:NumSlider("#Tool_wire_advplug_weldforce", "wire_advplug_weldforce", 0, 100000)
	panel:NumSlider("#Tool_wire_advplug_attachrange", "wire_advplug_attachrange", 1, 100)
	
	panel:AddControl("ComboBox", {
		Label = "#Tool_wire_advplug_type",
		Options = {
			["Number"] = { wire_advplug_type = "NORMAL" },
			["String"] = { wire_advplug_type = "STRING" },
			["Angle"] = { wire_advplug_type = "ANGLE" },
			["Vector"] = { wire_advplug_type = "VECTOR" },
			["2D Vector"] = { wire_advplug_type = "VECTOR2" },
			["4D Vector"] = { wire_advplug_type = "VECTOR4" },
			["Entity"] = { wire_advplug_type = "ENTITY" },
			["Array"] = { wire_advplug_type = "ARRAY" },
			["Wirelink"] = { wire_advplug_type = "WIRELINK" },
		}
	})
end
