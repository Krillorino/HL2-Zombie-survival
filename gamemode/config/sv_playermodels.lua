local rebelplayermodel = {
"models/player/Group03/Female_01.mdl",
"models/player/Group03/Female_02.mdl",
"models/player/Group03/Female_03.mdl",
"models/player/Group03/Female_04.mdl",
"models/player/Group03/Female_06.mdl",
"models/player/Group03/Female_07.mdl",
"models/player/Group03/Male_01.mdl",
"models/player/Group03/male_02.mdl",
"models/player/Group03/male_03.mdl",
"models/player/Group03/Male_04.mdl",
"models/player/Group03/Male_05.mdl",
"models/player/Group03/male_06.mdl",
"models/player/Group03/male_07.mdl",
"models/player/Group03/male_08.mdl",
"models/player/Group03/male_09.mdl"
}


local function SetPlayermodel( ply )
	ply:SetModel(table.Random(rebelplayermodel))
end

hook.Add( "PlayerSpawn", "SetPlayermodel", SetPlayermodel )


