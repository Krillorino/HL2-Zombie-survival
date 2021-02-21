include("shared.lua")

--Other scripts

local camera_swap = 0

function GM:PlayerBindPress(pl, bind, pressed)
    if pressed and string.find(bind, "+menu_context") then
        if camera_swap == 0 then
            RunConsoleCommand("thirdperson_ots")
            camera_swap = 1
        else
            RunConsoleCommand("thirdperson_ots_swap")
            camera_swap = 0
        end
    end
end


hook.Add( "PlayerSpawn", "SetFOV", function()

	RunConsoleCommand("viewmodel_fov 85")

end)

