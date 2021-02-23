include ("shared.lua")
include ("config/sv_playermodels.lua")
include ("round/sv_round_controller.lua")


AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("round/cl_round_controller.lua")

-- addons with resource folders to be downloaded 

resource.AddWorkshop(1761820193) -- Pickup History
resource.AddWorkshop(1758584347) -- HEV MK V

-- Variable init --

nbply = RecipientFilter() -- Count the number of players

function GM:PlayerConnect(name , ip)

	print ("Player "..name.." connected with IP ("..ip..")")
	
end

function GM:PlayerInitialSpawn(ply)

	print("Player "..ply:Name().." has spawned.")

end

function GM:PlayerSpawn(ply)

	ply:SetupHands()
	ply:SetRunSpeed(290)
	ply:SetWalkSpeed(160)
	ply:Give("weapon_ar2")
	nbply:AddAllPlayers()

end

function GM:Disconnect(ply)

	nbply:AddAllPlayers()

end

-- Return the amount of players connected

function getNbPly()

	print(nbply:GetCount())

end

-- For dev purpose, to be removed later



--------------------------------
-- NPCS auto target the player--
--------------------------------

local function SetRandomPlayerTargetForNPC(npc)
	if (npc:IsNPC()) then
		if (!IsValid(npc:GetEnemy())) then
			local allPlayers	= player.GetAll()
			local winnerPlNr	= math.random(1, #allPlayers)

			timer.Simple(0.15, function()
			local TargetPlayer = allPlayers[winnerPlNr]

				--- Set the enemy for the NPC, so it does not just stand there doing nothing
				if (!npc:IsValid() or !TargetPlayer:IsValid()) then return end
			npc:SetEnemy(TargetPlayer)
			npc:UpdateEnemyMemory(TargetPlayer, TargetPlayer:GetPos())
			npc:SetSchedule(SCHED_SHOOT_ENEMY_COVER)
			npc:SetSchedule(SCHED_FORCED_GO)
			npc:CapabilitiesAdd(CAP_OPEN_DOORS)

				end)
		end
	end
end



local t = 0
local interval = 0.15

-- Refresh player pos for npcs

hook.Add( "Think", "NPCAutoSeekPlayer", function()

	if t < CurTime() then

		t = CurTime() + interval

		for i, ent in ipairs( ents.GetAll('npc_*') ) do
			if ent:IsValid() then SetRandomPlayerTargetForNPC(ent) end
		end

	end


end)

--------------------------------
-- Player default playermodel --
--------------------------------

