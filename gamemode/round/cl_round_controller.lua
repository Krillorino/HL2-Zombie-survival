local game_status = 0

net.Receive("UpdateGameStatus", function(len)

	game_status = net.ReadInt(4)
	
end)

net.Receive("UpdateRoundNumber", function(len)

	activeRound = net.ReadInt(4)
	
end)

function getGameStatus()

	return game_status()
	
end


function getRoundNumber()

	return activeRound()
	
end