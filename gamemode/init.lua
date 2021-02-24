include ("shared.lua")
include ("config/sv_playermodels.lua")
include ("round/sv_round_controller.lua")
include ("config/sv_players.lua")
include ("modules/teams.lua")


AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("round/cl_round_controller.lua")
AddCSLuaFile("modules/teams.lua")

-- addons with resource folders to be downloaded 

resource.AddWorkshop(1761820193) -- Pickup History
resource.AddWorkshop(1758584347) -- HEV MK V

-- Variable init --

nbply = RecipientFilter() -- Filter only the number of players
local allPlayers = {}

function GM:PlayerConnect(name , ip)

	print ("Player "..name.." connected with IP ("..ip..")")
	
end

function GM:PlayerInitialSpawn(ply)

	print("Player "..ply:Name().." has spawned.")

end


function GM:PlayerSpawn(ply)

	if game_status == 0 or (game_status == 1 and nextWaveWaiting == true) then

		ply:SetTeam(0)
		ply:SetupHands()
		ply:SetRunSpeed(290)
		ply:SetWalkSpeed(160)
		ply:Give("weapon_ar2")

		nbply:AddAllPlayers()
		allPlayers = player.GetAll()

	elseif game_status == 1 and nextWaveWaiting == false then

		ply:SetTeam(TEAM_SPECTATOR) -- Zombies still target the player where he died
		ply:Spectate( OBS_MODE_CHASE )

		allPlayers = player.GetAll()
		nbply:AddAllPlayers()

		return

	end

end

function GM:PlayerDeath(ply)

	if game_status == 1 and nextWaveWaiting == false then

		ply:SetTeam(TEAM_SPECTATOR) -- Zombies still target the player where he died
		ply:Spectate( OBS_MODE_CHASE )

	end


end

function GM:Disconnect(ply)

	nbply:AddAllPlayers()
	allPlayers = player.GetAll()

end

-- Return the amount of players connected

function getNbPly()

	print(nbply:GetCount())

end

-- For dev purpose, to be removed later



--------------------------------
-- NPCS auto target the player--
--------------------------------

local allPlayers = player.GetAll()

local function SetRandomPlayerTargetForNPC(npc)
	if (npc:IsNPC()) then
		if (!IsValid(npc:GetEnemy())) then
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



