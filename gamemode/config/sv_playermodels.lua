--------------------------------
-- Player default playermodel --
--------------------------------

local rebelplayermodel = {
"models/player/Group03/female_01.mdl",
"models/player/Group03/female_02.mdl",
"models/player/Group03/female_03.mdl",
"models/player/Group03/female_04.mdl",
"models/player/Group03/female_05.mdl",
"models/player/Group03/female_06.mdl",
"models/player/Group03/male_01.mdl",
"models/player/Group03/male_02.mdl",
"models/player/Group03/male_03.mdl",
"models/player/Group03/male_04.mdl",
"models/player/Group03/male_05.mdl",
"models/player/Group03/male_06.mdl",
"models/player/Group03/male_07.mdl",
"models/player/Group03/male_08.mdl",
"models/player/Group03/male_09.mdl"
}


local function SetPlayermodel( ply )
	ply:SetModel(table.Random(rebelplayermodel))
end

hook.Add( "PlayerSpawn", "SetPlayermodel", SetPlayermodel )


