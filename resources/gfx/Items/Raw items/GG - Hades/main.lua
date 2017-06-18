
local greekhades_mod = RegisterMod( "ghades", 1)
local greekhades_item = Isaac.GetItemIdByName( "Hades" )

local fearTearChancePer = 0
local heartTypeChance_hades = 0
local heartRequirement_hades = 256
local enemiesKilled_hades = 0
local isHeartDropped_hades = false
--local debug_text = enemiesKilled_hades

function greekhades_mod:TearDetection_hades()
    local entities = Isaac.GetRoomEntities()
    local player = Isaac.GetPlayer(0)

	if player:HasCollectible(greekhades_item) then
		for i=1, #entities do
			if (entities[i].Type == EntityType.ENTITY_TEAR
			or entities[i].Type == EntityType.ENTITY_LASER
			or entities[i].Type == EntityType.ENTITY_KNIFE)
			and entities[i].FrameCount == 1
			and entities[i].SpawnerType == EntityType.ENTITY_PLAYER then
				if player.Luck >= 14 or math.random(1, 15-player.Luck) == 1 then
					entities[i]:ToTear().TearFlags = entities[i]:ToTear().TearFlags + 1<<20
					entities[i]:SetColor(Color(.1,.1,.1,1,75,0,75),-1,1,false,false)
				end
			end
		end
	end
end

function greekhades_mod:heartRequirementChecker_hades()
	local player = Isaac.GetPlayer(0)
	if player:HasCollectible(greekhades_item) then
		if (heartRequirement_hades == 256) then
			if ((math.floor(player.Luck + 0.5)) <= 10) then
				heartRequirement_hades = math.random(20, (30 - math.floor(player.Luck + 0.5)))
			elseif ((math.floor(player.Luck + 0.5)) > 10) then
				heartRequirement_hades = 20
			end
		end
		if isHeartDropped_hades == true then
			if ((math.floor(player.Luck + 0.5)) <= 10) then
				heartRequirement_hades = math.random(20, (30 - math.floor(player.Luck + 0.5)))
			elseif ((math.floor(player.Luck + 0.5)) >= 11) then
				heartRequirement_hades = 20
			end
			isHeartDropped_hades = false
		end
	end
end

function greekhades_mod:EnemyDeathDetection_hades(entity_hades,damageAmount_hades,damageFlags_hades,damageSource_hades)
	local player = Isaac.GetPlayer(0)

	if player:HasCollectible(greekhades_item) then
		if ((entity_hades.HitPoints - damageAmount_hades) <= 0) and (entity_hades:IsActiveEnemy(false)) and (damageSource_hades.Entity.SpawnerType == EntityType.ENTITY_PLAYER) then
			if (entity_hades:IsBoss()) then
				enemiesKilled_hades = enemiesKilled_hades + 4
			else
				enemiesKilled_hades = enemiesKilled_hades + 1
			end
		end
	end
end

function greekhades_mod:heartDropper_hades()
	local player = Isaac.GetPlayer(0)

	if enemiesKilled_hades >= heartRequirement_hades then
		heartTypeChance_hades = math.random(1,10)
		if heartTypeChance_hades <= 7 then
			Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_HEART,HeartSubType.HEART_HALF_SOUL,player.Position,Vector(0,0),Isaac.GetPlayer(0))
		elseif (heartTypeChance_hades == 8 or heartTypeChance_hades == 9) then
			Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_HEART,HeartSubType.HEART_SOUL,player.Position,Vector(0,0),Isaac.GetPlayer(0))
		elseif heartTypeChance_hades == 10 then
			Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_HEART,HeartSubType.HEART_BLACK,player.Position,Vector(0,0),Isaac.GetPlayer(0))

			heartTypeChance_hades = 0
		end
		enemiesKilled_hades = 0
		isHeartDropped_hades = true
		--debug_text = enemiesKilled_hades
	end
end

function greekhades_mod:cacheUpdate_hades(player, cacheFlag)
	local player = Isaac.GetPlayer(0)

	if player:HasCollectible(greekhades_item) then
		if (cacheFlag == CacheFlag.CACHE_DAMAGE) then
			player.Damage = player.Damage + 0.7
		end
	end
end

--function greekhades_mod:debug_text()
	--Isaac.RenderText(debug_text,100,100,255,0,0,255)
--end

greekhades_mod:AddCallback(ModCallbacks.MC_POST_UPDATE, greekhades_mod.TearDetection_hades)
greekhades_mod:AddCallback(ModCallbacks.MC_POST_UPDATE, greekhades_mod.heartRequirementChecker_hades)
greekhades_mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, greekhades_mod.EnemyDeathDetection_hades)
greekhades_mod:AddCallback(ModCallbacks.MC_POST_UPDATE, greekhades_mod.heartDropper_hades)
greekhades_mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, greekhades_mod.cacheUpdate_hades)
--greekhades_mod:AddCallback(ModCallbacks.MC_POST_RENDER, greekhades_mod.debug_text)
