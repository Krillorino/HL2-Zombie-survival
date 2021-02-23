include("shared.lua")
include("round/cl_round_controller.lua")

--Other scripts

local thirdperson_stage = 0

function GM:PlayerBindPress(pl, bind, pressed)
    if pressed and string.find(bind, "+menu_context") then
        if thirdperson_stage == 0 then
            RunConsoleCommand("thirdperson_ots")
            thirdperson_stage = 1
        elseif thirdperson_stage == 1 then
            RunConsoleCommand("thirdperson_ots_swap")
            thirdperson_stage = 2
        elseif thirdperson_stage == 2 then
            RunConsoleCommand("thirdperson_ots_swap")
            RunConsoleCommand("thirdperson_ots")
            thirdperson_stage = 0
        end
    end
end

