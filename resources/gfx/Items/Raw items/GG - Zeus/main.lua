
local greekzeus_mod = RegisterMod( "gZeus", 1)
local greekzeus_item = Isaac.GetItemIdByName( "Zeus" )

local frames_passed_Zeus = 0
local seconds_passed_Zeus = 0
local currRoom_Zeus

function greekzeus_mod:Countdown_Zeus()
	local currRoom_Zeus = Game():GetLevel():GetCurrentRoom()

	if currRoom_Zeus:IsClear() == false then
		frames_passed_Zeus = frames_passed_Zeus + 1
		if (frames_passed_Zeus == 25) then
			--seconds_passed_Zeus = seconds_passed_Zeus + 1
			frames_passed_Zeus = 0
		end
	end

	--if seconds_passed_Zeus == 1 and frames_passed_Zeus == 1 then
		--frames_passed_Zeus = 0
		--seconds_passed_Zeus = 0
	--end

	if ((currRoom_Zeus:IsClear() == true) or (currRoom_Zeus:GetFrameCount() == 1)) then
		frames_passed_Zeus = 0
		--seconds_passed_Zeus = 0
	end
end

function greekzeus_mod:lightningStrike_Zeus()
	local player = Isaac.GetPlayer(0)
	local randPos = Isaac.GetRandomPosition()
	local currRoom_Zeus = Game():GetLevel():GetCurrentRoom()
	local entities = Isaac.GetRoomEntities()

	if  ((currRoom_Zeus:IsClear() == false) and (frames_passed_Zeus == 24) and (player:HasCollectible(greekzeus_item))) then

		lightning = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.CRACK_THE_SKY,0,randPos,Vector (0,0),player)
		lightning.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

		for i = 1, #entities do
			if (entities[i]:IsVulnerableEnemy() and entities[i].Position:Distance(randPos) < 80) then
				entities[i]:TakeDamage(((3*player.Damage)+10),0,EntityRef(player),0)
			end
		end
	end
end

function greekzeus_mod:cacheUpdate_Zeus(player, cacheFlag)
	local player = Isaac.GetPlayer(0)

	if (player:HasCollectible(greekzeus_item)) then
		if (cacheFlag == CacheFlag.CACHE_DAMAGE) then
			player.Damage = player.Damage + 1.5
		end
	end
end

greekzeus_mod:AddCallback(ModCallbacks.MC_POST_UPDATE, greekzeus_mod.Countdown_Zeus)
greekzeus_mod:AddCallback(ModCallbacks.MC_POST_UPDATE, greekzeus_mod.lightningStrike_Zeus)
greekzeus_mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, greekzeus_mod.cacheUpdate_Zeus)
