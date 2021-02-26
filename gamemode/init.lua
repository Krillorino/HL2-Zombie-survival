include ("shared.lua")
include ("config/sv_playermodels.lua")
include ("round/sv_round_controller.lua")
include ("config/sv_players.lua")
include ("modules/teams.lua")
include ("config/sv_npcs.lua")


AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("round/cl_round_controller.lua")
AddCSLuaFile("modules/teams.lua")

-- addons with resource folders to be downloaded 

resource.AddWorkshop(1761820193) -- Pickup History
resource.AddWorkshop(1758584347) -- HEV MK V

-- Variable init --


function GM:PlayerConnect(name , ip)

	print ("Player "..name.." connected with IP ("..ip..")")
	
end

function GM:PlayerInitialSpawn(ply)

	print("Player "..ply:Name().." has spawned.")

end


function GM:Disconnect(ply)

	print("Player "..ply:Name().." has disconnected.")


end

