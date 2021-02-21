include ("shared.lua")
include ("config/sv_playermodels.lua")
include ("round/sv_round_controller.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("round/cl_round_controller.lua")

function GM:PlayerConnect(name , ip)

	print ("Player "..name.." connected with IP ("..ip..")")
	
end

function GM:PlayerInitialSpawn(ply)

	print("Player "..ply:Name().." has spawned.")

end

--------------------------------
-- NPCS auto target the player--
--------------------------------

hook.Add( "Think", "NPCAutoSeekPlayer", function()
	local npcs = ents.GetAll()
	local plys = player.GetAll()
	local plyCount = #plys

	-- No point trying to give NPCs a player when there are none
	if ( plyCount == 0 ) then
		return
	end

	-- Loop over all entities and check for NPCs
	for i = 1, #npcs do
		local npc = npcs[ i ]

		-- If this entity is an NPC without an enemy, give them one
		if ( npc:IsNPC() && !IsValid( npc:GetEnemy() ) ) then
			local curPly = nil			-- Closest player
			local curPlyPos = nil		-- Position of closest player
			local curDist = math.huge	-- Lowest distance between npc and player
			
			local npcPos = npc:GetPos()	-- Position of the NPC

			-- Loop over all players to check their distance from the NPC
			for i = 1, plyCount do
				local ply = plys[ i ]

				-- Only consider players that this NPC hates
				if ( npc:Disposition( ply ) == D_HT ) then
					-- TODO: You can optimise looking up each player's position (constant)
					-- for every NPC by generating a table of:
					--- key = player identifier (entity object, UserID, EntIndex, etc.)
					--- value = player's position vector
					-- for the first NPC that passes to this part of the code,
					-- then reuse it for other NPCs
					local plyPos = ply:GetPos()
					
					-- Use DistToSqr for distance comparisons since
					-- it's more efficient than Distance, and the
					-- non-squared distance isn't needed for anything
					local dist = npcPos:DistToSqr( plyPos )

					-- If the new distance is lower, update the player information
					if ( dist < curDist ) then
						curPly = ply
						curPlyPos = plyPos
						curDist = dist
					end
				end
			end

			-- curPly is guarenteed to be valid since this code
			-- will only run if there is at least one player
			npc:SetEnemy( curPly )
			npc:UpdateEnemyMemory( curPly, curPlyPos )
		end
	end
end )

--------------------------------
-- Player default playermodel --
--------------------------------

