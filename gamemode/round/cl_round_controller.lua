-----------------------
------Networking-------
-----------------------

net.Receive("UpdateGameStatus", function(len)

	game_status = net.ReadInt(4)
	
end)

net.Receive("UpdateRoundNumber", function(len)

	activeRound = net.ReadInt(4)
	
end)

net.Receive("UpdateWaitingForPlayers", function(len)

	waitingForPlayers = net.ReadBool()
	
end)

net.Receive("UpdateGameStartTime", function(len)

	gamestarttime = net.ReadInt(16)
	
end)

--------------------------
--Round information variables
--------------------------

local game_status = 0
local gamestarttime = 0
local waitingforplayers = true


--------------------------------
-- Clientside Update functions
--------------------------------

-- Type sv_cheats 1 and sv_allowcslua 1 to return 
-- the variable from a function by typing
-- lua_run_cl print(functionname())


function getGameStatus()

	return game_status
	
end


function getRoundNumber()

	return activeRound
	
end

function getWaitingForPlayers()

	return waitingforplayers

end


function getGameStartTime()
	return (string.ToMinutesSeconds(gamestarttime))
end