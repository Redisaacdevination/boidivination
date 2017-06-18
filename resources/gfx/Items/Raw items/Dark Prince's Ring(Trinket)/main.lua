local divination = RegisterMod("Divination", 1)
local darkprince_trinket = Isaac.GetTrinketIdByName("Dark Prince's Ring")

function divination:darkprinceLogic()
	local player = Isaac.GetPlayer(0)
	local room = Game():GetRoom()
	local center = room:GetCenterPos()
	local entities = Isaac.GetRoomEntities()
	local spawnedSlot = false
	if player:HasTrinket(darkprince_trinket) then
		if room:GetType() == RoomType.ROOM_DEVIL then
			for i = 1, #entities do
				if entities[i].Type == EntityType.ENTITY_SLOT and entities[i].Variant == 10 then
				spawnedSlot = true
				end
			end
			if spawnedSlot == false then
				Isaac.Spawn(6, 10, 0, center, Vector(0,0), player)
			end			
		end
	end
end

divination:AddCallback(ModCallbacks.MC_POST_UPDATE, divination.darkprinceLogic);