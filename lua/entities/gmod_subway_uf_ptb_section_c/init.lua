AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.BogeyDistance = 650 -- Needed for gm trainspawner

--------------------------------------------------------------------------------
-- переписал Lindy2017 
-- ориг скрипты - татра и томас 
--------------------------------------------------------------------------------

---------------------------------------------------
-- Defined train information                      
-- Types of wagon(for wagon limit system):
-- 0 = Head or intherim                           
-- 1 = Only head                                     
-- 2 = Only intherim                                
---------------------------------------------------
ENT.SubwayTrain = {
	Type = "Pt",
	Name = "Pt Section C",
	WagType = 0,
	Manufacturer = "Duewag",
}

function ENT:Initialize()

	-- Set model and initialize
	self:SetModel("models/lilly/uf/ptb/ptb_c.mdl")
	self.BaseClass.Initialize(self)
	self:SetPos(self:GetPos() + Vector(0,0,0))

	self.Bogeys = {}
	-- Create bogeys
	--self.FrontBogey = self:CreateBogey(Vector( 0,0,0),Angle(0,0,0),true,"u2")--103,0,-80
	--table.insert(self.Bogeys,self.FrontBogey)	
	--self.RearBogey  = self:CreateBogeyUF(Vector(-600,0,0),Angle(0,0,0),false,"ptb")
	
	
	self.ThrottleState = 0
	self.ReverserState = 0
	self.ChopperJump = 0
	
	self.RearCouple = self:CreateCoupleUF(Vector( -528,0,8),Angle(0,180,0),true,"dummy")	
    --self.FrontCouple = self:CreateCoupleUF(Vector( 0,0,23),Angle(0,180,0),true,"u2")	
	
    --self.RearBogey:SetRenderMode(RENDERMODE_TRANSALPHA)
    --self.RearBogey:SetColor(Color(0,0,0,0))		

	self.Timer = CurTime()	
	self.Timer2 = CurTime()
	self:SetNW2Entity("RearBogey",self.RearBogey)
	--self:SetNW2Entity("MiddleBogey",self.MiddleBogey)
	self:SetNW2Entity("FrontBogey",self.FrontBogey)
	undo.Create(self.ClassName)	
	undo.AddEntity(self)	
	undo.SetPlayer(self.Owner)
	undo.SetCustomUndoText("Undone a train")
	undo.Finish()
	
	--self.Wheels = self.RearBogey.Wheels
   
	self.Lights = {
		[111] = { "dynamiclight",        Vector( 0, 0, 100), Angle(0,0,0), Color(216,161,92), distance = 450, brightness = 2},
		[112] = { "dynamiclight",        Vector( 200, 0, 100), Angle(0,0,0), Color(216,161,92), distance = 450, brightness = 2},
		[113] = { "dynamiclight",        Vector( 100, 0, 100), Angle(0,0,0), Color(216,161,92), distance = 450, brightness = 2},
	}
	for k,v in pairs(self.Lights) do
		self:SetLightPower(k,false)
	end

	self.BrakePressure = 0	

	--self.ptbsectionb = self:CreateSectionB(Vector(0,0,0))

end



-- LOCAL FUNCTIONS FOR GETTING OUR OWN ENTITY SPAWNS


function ENT:CreateBogeyUF(pos,ang,forward,typ)
    -- Create bogey entity
    local bogey = ents.Create("gmod_train_uf_bogey")
    bogey:SetPos(self:LocalToWorld(pos))
    bogey:SetAngles(self:GetAngles() + ang)
    bogey.BogeyType = typ
    bogey.NoPhysics = self.NoPhysics
    bogey:Spawn()

    -- Assign ownership
    if CPPI and IsValid(self:CPPIGetOwner()) then bogeyUF:CPPISetOwner(self:CPPIGetOwner()) end

    -- Some shared general information about the bogey
    self.SquealSound = self.SquealSound or math.floor(4*math.random())
    self.SquealSensitivity = self.SquealSensitivity or math.random()
    bogey.SquealSensitivity = self.SquealSensitivity
    bogey:SetNW2Int("SquealSound",self.SquealSound)
    bogey:SetNW2Bool("IsForwardBogey", forward)
    bogey:SetNW2Entity("TrainEntity", self)
    bogey.SpawnPos = pos
    bogey.SpawnAng = ang
    local index=1
    for i,v in ipairs(self.JointPositions) do
        if v>pos.x then index=i+1 else break end
    end
    table.insert(self.JointPositions,index,pos.x+53.6)
    table.insert(self.JointPositions,index+1,pos.x-53.6)
    -- Constraint bogey to the train
    if self.NoPhysics then
        bogey:SetParent(self)
    else
        constraint.Axis(bogey,self,0,0,
            Vector(0,0,0),Vector(0,0,0),
            0,0,0,1,Vector(0,0,1),false)
        if forward and IsValid(self.FrontCouple) then
            constraint.NoCollide(bogey,self.FrontCouple,0,0)
        elseif not forward and IsValid(self.RearCouple) then
            constraint.NoCollide(bogey,self.RearCouple,0,0)
        end
    end
	    -- Add to cleanup list
    table.insert(self.TrainEntities,bogey)
    return bogey
end
	
	

	function ENT:CreateCoupleUF(pos,ang,forward,typ)
    -- Create bogey entity
    local coupler = ents.Create("gmod_train_uf_couple")
    coupler:SetPos(self:LocalToWorld(pos))
    coupler:SetAngles(self:GetAngles() + ang)
    coupler.CoupleType = typ
    coupler:Spawn()

    -- Assign ownership
    if CPPI and IsValid(self:CPPIGetOwner()) then coupler:CPPISetOwner(self:CPPIGetOwner()) end

    -- Some shared general information about the bogey
    coupler:SetNW2Bool("IsForwardCoupler", forward)
    coupler:SetNW2Entity("TrainEntity", self)
    coupler.SpawnPos = pos
    coupler.SpawnAng = ang
    local index=1
    local x = self:WorldToLocal(coupler:LocalToWorld(coupler.CouplingPointOffset)).x
    for i,v in ipairs(self.JointPositions) do
        if v>pos.x then index=i+1 else break end
    end
    table.insert(self.JointPositions,index,x)
    -- Constraint bogey to the train
    if self.NoPhysics then
        bogey:SetParent(coupler)
    else
        constraint.AdvBallsocket(
            self,
            coupler,
            0, --bone
            0, --bone
            pos,
            Vector(0,0,0),
            1, --forcelimit
            1, --torquelimit
            -2, --xmin
            -2, --ymin
            -15, --zmin
            2, --xmax
            2, --ymax
            15, --zmax
            0.1, --xfric
            0.1, --yfric
            1, --zfric
            0, --rotonly
            1 --nocollide
        )

        if forward and IsValid(self.FrontBogey) then
            constraint.NoCollide(self.FrontBogey,coupler,0,0)
        elseif not forward and IsValid(self.RearBogey) then
            constraint.NoCollide(self.RearBogey,coupler,0,0)
        end
        
        constraint.Axis(coupler,self,0,0,
            Vector(0,0,0),Vector(0,0,0),
            0,0,0,1,Vector(0,0,1),false)
    end

    -- Add to cleanup list
    table.insert(self.TrainEntities,coupler)
    return coupler
end	

function ENT:OnButtonPress(button,ply)
end


function ENT:OnButtonRelease(button,ply)
	

end


function ENT:Think()
	self.BaseClass.Think(self)
	self.Speed = math.abs(-self:GetVelocity():Dot(self:GetAngles():Forward()) * 0.06858)
	self:SetNW2Int("Speed",self.Speed*150)
	if self.Timer and CurTime()-self.Timer > 0.1 then
		--self.RearBogey.Wheels:SetRenderMode(RENDERMODE_TRANSALPHA)
		--self.RearBogey.Wheels:SetColor(Color(0,0,0,0))		
		
		if CurTime()-self.Timer > 1 then
			--self.FrontBogey:Remove()
			--self.RearCouple:Remove()		
			--self.FrontBogey.Wheels:GetPhysicsObject():SetMass(6000)
			self.Timer = nil
		end
	end
	
	
	
		
	
	
	
	if self.Timer2 and CurTime()-self.Timer2 < 1 then
		for k,v in pairs(self.Bogeys) do
			constraint.Weld(v,v.Wheels,0,0,0,1,0)
			constraint.NoCollide(v.Wheels,self,0,0)		
		end

	elseif self.Timer2 then	
		self.Timer2 = nil
	end
	self.Speed = math.abs(-self:GetVelocity():Dot(self:GetAngles():Forward()) * 0.06858)
	self:SetNW2Int("Speed",self.Speed*100)

	
	--self:SetLightPower(111,true)
	--self:SetLightPower(112,true)
	--self:SetLightPower(113,true)

    --self.RearBogey.MotorForce  = self.Duewag_U2.Traction --18000*N
	--self.RearBogey.MotorPower = 100--N *100 + (self.ChopperJump) --100 ----------- maximum kW of one bogey 36.67
	--self.RearBogey.Reversed = self.Duewag_U2.ReverserState < 0


    --self.RearBogey.PneumaticBrakeForce = (70000.0) 
    --self.RearBogey.BrakeCylinderPressure = self.Duewag_U2.BrakePressure
end


function ENT:CreateSectionB(pos)
	local ang = Angle(0,180,0)
	local ptbsectionb = ents.Create("gmod_subway_uf_ptb_section_b")
	-- self.ptbsectionb = u2b
	ptbsectionb:SetPos(self:LocalToWorld(Vector(-180,0,0)))
	ptbsectionb:SetAngles(self:GetAngles() + ang)
	ptbsectionb:Spawn()
	ptbsectionb:SetOwner(self:GetOwner())
	local xmin = 5
	local xmax = 5
	
	constraint.AdvBallsocket(
		ptbsectionb,
		self,
		0, --bone
		0, --bone
		Vector(0,0,0),
		Vector(0,0,0),
		0, --forcelimit
		0, --torquelimit
		xmin, --xmin
		0, --ymin
		-50, --zmin
		xmax, --xmax
		0, --ymax
		50, --zmax
		0, --xfric
		0, --yfric
		0, --zfric
		0, --rotonly
		1 --nocollide
	)
	
	
	-- Add to cleanup list
	table.insert(self.TrainEntities,ptbsectionb)
	return ptbsectionb
end