local divination = RegisterMod("Divination", 1)
local isaacswill_trinket = Isaac.GetTrinketIdByName("Isaac's Will")

local AngelPool = {
	CollectibleType.COLLECTIBLE_BIBLE,
	CollectibleType.COLLECTIBLE_BREATH_OF_LIFE,
	CollectibleType.COLLECTIBLE_DEAD_SEA_SCROLLS,
	CollectibleType.COLLECTIBLE_DELIRIOUS,
	CollectibleType.COLLECTIBLE_EDENS_SOUL,
	CollectibleType.COLLECTIBLE_PRAYER_CARD,
	CollectibleType.COLLECTIBLE_VOID,
	CollectibleType.COLLECTIBLE_BODY,
	CollectibleType.COLLECTIBLE_CELTIC_CROSS,
	CollectibleType.COLLECTIBLE_CENSER,
	CollectibleType.COLLECTIBLE_CIRCLE_OF_PROTECTION,
	CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT,
	CollectibleType.COLLECTIBLE_DEAD_DOVE,
	CollectibleType.COLLECTIBLE_DUALITY,
	CollectibleType.COLLECTIBLE_EUCHARIST,
	CollectibleType.COLLECTIBLE_GLYPH_OF_BALANCE,
	CollectibleType.COLLECTIBLE_GODHEAD,
	CollectibleType.COLLECTIBLE_GUARDIAN_ANGEL,
	CollectibleType.COLLECTIBLE_HABIT,
	CollectibleType.COLLECTIBLE_HALO,
	CollectibleType.COLLECTIBLE_HOLY_GRAIL,
	CollectibleType.COLLECTIBLE_HOLY_LIGHT,
	CollectibleType.COLLECTIBLE_HOLY_MANTLE,
	CollectibleType.COLLECTIBLE_HOLY_WATER,
	CollectibleType.COLLECTIBLE_IMMACULATE_CONCEPTION,
	CollectibleType.COLLECTIBLE_MIND,
	CollectibleType.COLLECTIBLE_RELIC,
	CollectibleType.COLLECTIBLE_ROSARY,
	CollectibleType.COLLECTIBLE_SACRED_HEART,
	CollectibleType.COLLECTIBLE_SCAPULAR,
	CollectibleType.COLLECTIBLE_SERAPHIM,
	CollectibleType.COLLECTIBLE_SPEAR_OF_DESTINY,
	CollectibleType.COLLECTIBLE_SOUL,
	CollectibleType.COLLECTIBLE_SWORN_PROTECTOR,
	CollectibleType.COLLECTIBLE_TRINITY_SHIELD,
	CollectibleType.COLLECTIBLE_WAFER
	}
	
isaacswillEffect = true
function divination:isaacswillToTrue()
	local player = Isaac.GetPlayer(0)
	if player:HasTrinket(isaacswill_trinket) then
		isaacswillEffect = true
	end
end

function divination:isaacswillLogic()
	local player = Isaac.GetPlayer(0)
	local randomchance = math.random(1, 100)
	local randomitem = math.random(1,504)
	local randomval = math.random(1,#AngelPool)
	
	if player:IsDead() and isaacswillEffect == true then
		if randomval <= 80 then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, player.Position, Vector(0,0), player)
		else
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, AngelPool[randomval], player.Position, Vector(0,0), player)
		end
		isaacswillEffect = false
	end
end

divination:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, divination.isaacswillToTrue);
divination:AddCallback(ModCallbacks.MC_POST_UPDATE, divination.isaacswillLogic);