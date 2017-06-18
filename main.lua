local divination = RegisterMod("divination", 1);

require("itemScripts/characters.lua")
require("itemScripts/item_greek_ares.lua")
require("itemScripts/item_greek_demeter.lua")
require("itemScripts/item_greek_dionysus.lua")
require("itemScripts/item_greek_hades.lua")
require("itemScripts/item_greek_poseidon.lua")

function divination:u()
	local player = Isaac.GetPlayer(0);
	if (player:GetName() == "ruby") then
		if (firsttime) then
			firsttime = false;
			player.TearColor = Color(1, .11, .11, 1, 0, 0, 0);
		end
		local entities = Isaac.GetRoomEntities();
		for i = 1, #entities do
			if (entities[i].Type == EntityType.ENTITY_TEAR and entities[i].FrameCount == 0) then
				entities[i].Position = player.Position - Vector(0,.1);
			end
		end
		
	elseif (player:GetName() == "saph") then
		if (firsttime) then
			firsttime = false;
		end
		if (Game():GetLevel():GetAngelRoomChance() < 1) then
			Game():GetLevel():AddAngelRoomChance(1);
		end
		if (Game():GetLevel():GetCurrentRoom():GetDevilRoomChance() < 1) then
			player:GetEffects():AddCollectibleEffect(215, false);
		end
		if (player:GetBlackHearts()>0) then
			player:AddBlackHearts(-2);
			player:TakeDamage(1, DamageFlag.DAMAGE_INVINCIBLE, EntityRef(player), 0);
		end
	end
end

function divination:i()
	firsttime = true;
	local player = Isaac.GetPlayer(0);
	if (player:GetName() == "saph") then
	
	elseif (player:GetName() == "ruby") then

	end
end

function divination:c(player, flag)
	if (player:GetName() == "saph") then
	 if (cacheFlag == CacheFlag.CACHE_FIREDELAY) then
                effTears = player.MaxFireDelay - 5
                effTears = math.min(2, effTears) -- tears up vs. effTears
            player.MaxFireDelay = player.MaxFireDelay - effTears
		if (flag == CacheFlag.CACHE_RANGE) then
			player.TearHeight = player.TearHeight - 16.25;
		elseif (flag == CacheFlag.CACHE_SPEED) then
			player.MoveSpeed = player.MoveSpeed + .5;
		end
	elseif (player:GetName() == "ruby") then
		if (flag == CacheFlag.CACHE_DAMAGE) then
			player.Damage = player.Damage + 1;
		elseif (flag == CacheFlag.CACHE_RANGE) then
			player.TearHeight = player.TearHeight + 4.75;
		elseif (flag == CacheFlag.CACHE_SPEED) then
			player.MoveSpeed = player.MoveSpeed - .2;
		end
	end
end

divination:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, divination.i);
divination:AddCallback(ModCallbacks.MC_POST_UPDATE, divination.u);
divination:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, divination.c);