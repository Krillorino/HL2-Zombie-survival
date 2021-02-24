local ply = FindMetaTable("Player")

function RespawnEveryone()

	for i, v in ipairs( player.GetAll() ) do
   		v:SetTeam(0)
   		v:Spectate(0)	
		v:Spawn()
	end

end

function RespawnASpecificPlayer()

	for i, v in ipairs( player.GetAll() ) do

		if v:Nick()=="Kherty" then
   			v:SetTeam(0)
   			v:Spectate(0)	
			v:Spawn()
		end

	end

end

function RespawnSpectators()

	for i, v in ipairs( player.GetAll() ) do

		if team.GetName(v:Team()) == "Spectator" then

   			v:SetTeam(0)
   			v:Spectate(0)	
			v:Spawn()

		end

	end

end


if nextWaveWaiting == true and game_status == 1 then

	spectatorsRespawn()

end




