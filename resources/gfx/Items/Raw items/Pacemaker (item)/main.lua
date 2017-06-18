local divination = RegisterMod("Divination", 1)
local pacemaker_item = Isaac.GetItemIdByName("Pacemaker")

function divination:pacemakerLogic(entity, dmgAmount, dmgFlag, source, dmgSB_countdownFrames)
	local player = Isaac.GetPlayer(0)
	local randomangle = math.random(1, 360)
	local lessangle1 = math.random(1, 360)
	local lessangle2 = math.random(1, 360)
	if player:HasCollectible(pacemaker_item) then
		local laser1 = EntityLaser.ShootAngle(2, player.Position, randomangle, 4, Vector(0,0), player)
		local laser2 = EntityLaser.ShootAngle(2, player.Position, randomangle - lessangle1, 4, Vector(0,0), player)
		local laser3 = EntityLaser.ShootAngle(2, player.Position, randomangle - lessangle2, 4, Vector(0,0), player)
		
		laser1:SetColor(Color(1,1,1,1,-30,188,255),-1,1,false,false)
		laser2:SetColor(Color(1,1,1,1,-30,188,255),-1,1,false,false)
		laser3:SetColor(Color(1,1,1,1,-30,188,255),-1,1,false,false)
		
		laser1.CollisionDamage = player.Damage
		laser2.CollisionDamage = player.Damage
		laser3.CollisionDamage = player.Damage
		
		laser1.TearFlags = laser1.TearFlags | TearFlags.TEAR_HOMING
		laser2.TearFlags = laser2.TearFlags | TearFlags.TEAR_HOMING
		laser3.TearFlags = laser3.TearFlags | TearFlags.TEAR_HOMING
	end
end

divination:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, divination.pacemakerLogic, EntityType.ENTITY_PLAYER)