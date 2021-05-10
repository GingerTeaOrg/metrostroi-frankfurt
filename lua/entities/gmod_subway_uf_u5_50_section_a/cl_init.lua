include("shared.lua")

ENT.ClientSounds = {}
ENT.ClientProps = {}
ENT.ButtonMap = {}
--------------------------------------------------------------------------------
-- переписал Lindy2017 + немного скриптов томаса
--------------------------------------------------------------------------------

ENT.Lights = {
	-- Headlight glow
	[1] = { "headlight",		Vector(580,0,80), Angle(0,0,0), Color(216,161,92), hfov=80, vfov=80,farz=5144,brightness = 4}, --216,161,92
}












ENT.ClientProps["Dest"] = {
	model = "models/lilly/uf/u2/dest_a.mdl",
	pos = Vector(-9.7,0,-0.75),
	ang = Angle(0,0,0),
	scale = 1,
}





ENT.ButtonMap["Cab"] = {
    pos = Vector(450,0,42),
    ang = Angle(0,0,90),
    width = 642,
    height = 2000,
    scale = 1,
	
    buttons = {

    }
}

function ENT:Think()
	self.BaseClass.Think(self)
	self:SetSoundState("horn1",self:GetPackedBool("Bell",false) and 1 or 0,1)
	self:SetSoundState("horn2",self:GetPackedBool("Horn",false) and 1 or 0,1)
	self:SetSoundState("Bitte_Zuruecktreten",self:GetPackedBool("BitteZuruecktreten",false) and 1 or 0,1)
	self:SetSoundState("igbt7",self:GetPackedBool("igbt74",false) and 1 or 0,1)		
		self:SetLightPower(1,true,1)
	if IsValid(self.GlowingLights[1]) then
		self.GlowingLights[1]:SetEnableShadows(true)
		self.GlowingLights[1]:SetFarZ(5144)--5144
	end	
	

	local speed = self:GetNW2Int("Speed")/100
	local limit = 80
	local nxt = 35
	
	if IsValid(self.ClientEnts["speedo1"])then
		self.ClientEnts["speedo1"]:SetSkin(speed%10)
	end
	
	if IsValid(self.ClientEnts["speedo2"])then
		self.ClientEnts["speedo2"]:SetSkin(speed/10)
	end
	
	if speed ~= -1 then
		for i=1,5 do
			if IsValid(self.ClientEnts["speedfact"..i])then
				--self.ClientEnts["speeddop"..i]:SetSkin(math.Clamp(50-limit/2-(i-1)*10,0,10))
				self.ClientEnts["speedfact"..i]:SetSkin(math.Clamp(speed/2-(i-1)*10,0,10))
				--self.ClientEnts["speedrek"..i]:SetSkin(math.Clamp(50-nxt/2-(i-1)*10,0,10)) 
			end
			if IsValid(self.ClientEnts["speedrek"..i])then
				--self.ClientEnts["speeddop"..i]:SetSkin(math.Clamp(50-limit/2-(i-1)*10,0,10))
				--self.ClientEnts["speedfact"..i]:SetSkin(math.Clamp(speed/2-(i-1)*10,0,10))
				self.ClientEnts["speedrek"..i]:SetSkin(math.Clamp(50-nxt/2-(i-1)*10,0,10)) 
			end
			if IsValid(self.ClientEnts["speeddop"..i])then
				self.ClientEnts["speeddop"..i]:SetSkin(math.Clamp(50-limit/2-(i-1)*10,0,10))
			--	self.ClientEnts["speedfact"..i]:SetSkin(math.Clamp(speed/2-(i-1)*10,0,10))
			--	self.ClientEnts["speedrek"..i]:SetSkin(math.Clamp(50-nxt/2-(i-1)*10,0,10)) 
			end
	
		end
	end
	
	--door anim
	for i=0,3 do
		for k=0,1 do
			local n_l = "door"..i.."x"..k.."a"
			local n_r = "door"..i.."x"..k.."b"
			local rand = math.random(0.3,1.2)
		end
	end
	
    local rol10 = math.Clamp(speed/5,0,1)*(1-math.Clamp((speed-50)/8,0,1))
    local rol70 = math.Clamp((speed-50)/8,0,1)
    self:SetSoundState("rolling_10",rol10,1)
    self:SetSoundState("rolling_70",rol70,1)
	
	end
	
function ENT:Draw()
    self.BaseClass.Draw(self)
end



function ENT:Initialize()
	self.BaseClass.Initialize(self)
	for k,v in pairs(self.Lights) do
		self:SetLightPower(k,false)
	end
end