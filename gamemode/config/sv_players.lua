canrespawn = true



-- No teamkill :)

hook.Add( "PlayerShouldTakeDamage", "AntiTeamkill", function( ply, attacker )

	if attacker:IsPlayer() then
		return false
	else
		return true
	end

end )


function GM:PlayerDeathThink(ply)

-- If game is active and the nextwave break is not here yet

	if game_status == 1 and nextWaveWaiting == false then

		canrespawn = false 

	end

	--When player should be able to respawn

	if (nextWaveWaiting == true and game_status == 1) or (game_status == 0) then

			canrespawn = true
			ply:UnSpectate()
			ply:Spawn()


	end

end

function GM:PlayerDeath(ply)

	print(ply:Nick().." is dead")

	timer.Simple(2, function()

		if canrespawn == false then

			ply:Spectate(5)

		end

	end)

end


function getCanRespawn()

	return canrespawn

end

function GM:PlayerSpawn(ply)

	if (game_status == 0) or (game_status == 1 and canrespawn == true and nextWaveWaiting == true) then

		ply:SetTeam(TEAM_UNASSIGNED)
		ply:SetupHands()
		ply:SetRunSpeed(290)
		ply:SetWalkSpeed(160)
		ply:Give("weapon_ar2")



	end

	if (game_status == 1 and nextWaveWaiting == false) or (canrespawn == false) then

		ply:Spectate(5)


	end

end


function RespawnEveryone()

	for i, v in ipairs( player.GetAll() ) do
   		v:SetTeam(TEAM_UNASSIGNED)
   		v:UnSpectate()	
		v:Spawn()
	end

end


function RespawnSpectators()

	for i, v in ipairs( player.GetAll() ) do

		if team.GetName(v:Team()) == "Spectator" then

   			v:SetTeam(TEAM_UNASSIGNED)
   			v:UnSpectate()
			v:Spawn()

		end

	end

end


-- Table of players alive and dead (spectators) --

function getSpecPlayers()

	specnb = 0
	specplayers = {}

	for specplayers, v in ipairs( player.GetAll() ) do


		if team.GetName(v:Team()) == "Spectator" then

			specnb = specnb +1

				-- Removing existing variables to reset the entire table by re-adding values
			table.remove(specplayers, specnb)
			table.insert(specplayers, specnb,"["..specnb.."]"..v:Nick())
		

			else end


		end

	specnb = specnb - specnb
	return specplayers

end


-- By Alive players I mean players that aren't in spectator mode because when you die you are spectating.

function getPlayerNumbers() 

	players = 0
	playernumbers = {}

    for aliveply, v in ipairs( player.GetAll() ) do


        if team.GetName(v:Team()) == "Unassigned" then

            players = players +1

                -- Removing existing variables to reset the entire table by re-adding values
            table.remove(playernumbers, players)
            table.insert(playernumbers, players,"Player ".."["..players.."]".."["..v:Nick().."]")

        	else 

        end


    end

    players = players - players
    return playernumbers

end

-- Get all players that are dead

-- Table keep players when they die even after they respawn, we need to remove them when they respawn

deadplayernumbers = {}

hook.Add("Think", "GetAllDeadPlayers", function()

	deadplayers = 0

    for aliveply, v in ipairs( player.GetAll() ) do


        if v:Health() <= 0 then

            deadplayers = deadplayers + 1

                -- Removing existing variables to reset the entire table by re-adding values
            table.remove(deadplayernumbers, deadplayers)
            table.insert(deadplayernumbers, deadplayers,"Player ".."["..deadplayers.."]".."["..v:Nick().."]")

        	else 

        end

    end

    if waitingforplayers == true or game_status == 0 then

    	table.Empty(deadplayernumbers)

    end

    deadplayers = deadplayers - deadplayers
    return deadplayernumbers

end)



--il faut faire une table avec tout les joueurs avec comme hp = 0
--si le nombre de keys dans cette table est = au nombre de keys dans la table player.GetAll alors tout les joueurs sont mort
--a mettre cette table de joueurs mort dans un hook think 
