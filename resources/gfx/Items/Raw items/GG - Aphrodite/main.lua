
local greekaphro_mod = RegisterMod( "gaphro", 1)
local greekaphro_item = Isaac.GetItemIdByName( "Aphrodite" )

local convertEnemyChance_aphro = 0
local friendlyEnts_aphro = {}

function greekaphro_mod:TearDetection_aphro()
    local entities = Isaac.GetRoomEntities()
    local player = Isaac.GetPlayer(0)

	if player:HasCollectible(greekaphro_item) then
		for i=1, #entities do
			if (entities[i].Type == EntityType.ENTITY_TEAR
			or entities[i].Type == EntityType.ENTITY_LASER
			or entities[i].Type == EntityType.ENTITY_KNIFE)
			and entities[i].FrameCount == 1
			and entities[i].SpawnerType == EntityType.ENTITY_PLAYER then
				if player.Luck >= 12 or math.random(1, 13-player.Luck) == 1 then
					local tear = entities[i]:ToTear()
					local CharmFlagPower = (math.log(TearFlags.TEAR_CHARM) / math.log(2))
					if (tear.TearFlags>>CharmFlagPower) % 2 == 0 then
						tear.TearFlags = tear.TearFlags + TearFlags.TEAR_CHARM
						entities[i]:SetColor(Color(.1,.1,.1,1,255,182,193),-1,1,false,false)
					end
				end
			end
		end
	end
end

function greekaphro_mod:cacheUpdate_aphro(player, cacheFlag)
	local player = Isaac.GetPlayer(0)

	if player:HasCollectible(greekaphro_item) then
		if (cacheFlag == CacheFlag.CACHE_LUCK) then
			player.Luck = player.Luck + 2
		end
	end
end

function greekaphro_mod:entityTakeDamage_aphro(entity_aphro,damageAmount_aphro,damageFlags_aphro,damageSource_aphro)
	local player = Isaac.GetPlayer(0)

	if player:HasCollectible(greekaphro_item) then
		if (entity_aphro.HitPoints - damageAmount_aphro) <= 0 and not(entity_aphro:IsBoss()) and entity_aphro:IsActiveEnemy(false) and (damageSource_aphro.Entity.SpawnerType == EntityType.ENTITY_PLAYER) then
			convertEnemyChance_aphro = math.random(1,10)
			if convertEnemyChance_aphro == 1 then
				local spawnedEntity = Isaac.Spawn(entity_aphro.Type,entity_aphro.Variant,entity_aphro.SubType,entity_aphro.Position,Vector(0,0),player)

				spawnedEntity :AddEntityFlags(EntityFlag.FLAG_CHARM)
				spawnedEntity :AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
				entity_aphro:Kill()
			end
		end
	end
end

function greekaphro_mod:keepingFriendlyEntities_aphro()
	local player = Isaac.GetPlayer(0)

	if Game():GetFrameCount() <= 2 then
		friendlyEnts_aphro = {}
	end

	if Game():GetRoom():GetFrameCount() == 1 then
		for i,ent in pairs(friendlyEnts_aphro) do
			local spawnedEntity = Isaac.Spawn(ent.Type,ent.Variant,ent.SubType,player.Position,Vector(0,0),player)
			spawnedEntity:AddEntityFlags(EntityFlag.FLAG_CHARM)
			spawnedEntity:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
			spawnedEntity.HitPoints = ent.HitPoints
		end
	end

	local entities = Isaac.GetRoomEntities()
	friendlyEnts_aphro = {}

	for i=1, #entities do
		if entities[i]:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
			table.insert(friendlyEnts_aphro, entities[i])
		end
	end
end



greekaphro_mod:AddCallback(ModCallbacks.MC_POST_UPDATE, greekaphro_mod.TearDetection_aphro)
greekaphro_mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, greekaphro_mod.cacheUpdate_aphro)
greekaphro_mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, greekaphro_mod.entityTakeDamage_aphro)
greekaphro_mod:AddCallback(ModCallbacks.MC_POST_UPDATE, greekaphro_mod.keepingFriendlyEntities_aphro)
