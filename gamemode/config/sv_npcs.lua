--------------------------------
-- NPCS auto target the player--
--------------------------------

local allPlayers = player.GetAll()	

--We need to filter only the players in the team 1
--Se we need to create a table filtering each player from the table player.GetAll with Team()) == "Spectator"

local function _SetRandomPlayerTargetForNPC(npc)

	if (npc:IsNPC()) then

		if (!IsValid(npc:GetEnemy())) then

			local _allPlayers	= player.GetAll()
			local _winnerPlNr	= math.random(1, #_allPlayers)

			timer.Simple(0.15, function()

				local __Player = _allPlayers[_winnerPlNr]
				--
				-- Set the enemy for the NPC, so it does not just stand there doing nothing
				-- lika young lazy teen or something
				if (!npc:IsValid() or !__Player:IsValid()) then return end
				npc:SetEnemy(__Player)
				npc:UpdateEnemyMemory(__Player, __Player:GetPos())
				npc:SetSchedule(SCHED_SHOOT_ENEMY_COVER)
				npc:SetSchedule(SCHED_FORCED_GO)
				npc:CapabilitiesAdd(CAP_OPEN_DOORS)

			end)
		end
	end
end


local timernpc = 0
local intervaltimernpc = 1.50

hook.Add("Think", "NPCTARGET", function()

		if timernpc < CurTime() then

		timernpc = CurTime() + intervaltimernpc

			for i, ent in ipairs( ents.GetAll('npc_*') ) do
				if ent:IsValid() then _SetRandomPlayerTargetForNPC( ent ) end
			end

		end
end)
