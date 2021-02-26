-----------------------
------Networking-------
-----------------------

util.AddNetworkString("UpdateGameStatus")
util.AddNetworkString("UpdateRoundNumber")
util.AddNetworkString("UpdateWaitingForPlayers")
util.AddNetworkString("UpdateGameStartTime")

--------------------------
--Round information variables
--------------------------

game_status = 0 --0 = end 1 = active
nextWaveWaiting = false

local activeRound = 1
local waitingforplayers = true

--------------------------
-----Round variables------
--------------------------
local gamestarting = false -- a variable used to avoid repetition when a player spawn at the gamestarttime hook
local gamelost = false

local secondinterval = 1
local timerInit = 0
local round_time = 0
local round_timer_enabled = false

--------------------------------
---Zombie spawning parameters---
--------------------------------

local t = 0

--what is the interval of spawn
local interval = 2

-- number of zombie spawned in a wave

local setMaxZombieCount = 1

-- dont touch this
local zombieCount = 0

-- is it spawning zombie?
local isSpawning = false

--------------------------------
-- Serverside Update functions
--------------------------------

function updateClientGameStatus()

	net.Start("UpdateGameStatus")
		net.WriteInt(game_status, 4)
	net.Broadcast()
	
end

function updateClientRoundNumber()

	net.Start("UpdateRoundNumber")
		net.WriteInt(activeRound, 4)
	net.Broadcast()

end

function updateClientWaitingForPlayers()
	net.Start("UpdateWaitingForPlayers")
		net.WriteBool(waitingForPlayers)
	net.Broadcast()
end

function updateClientGameStartTime()
	net.Start("UpdateGameStartTime")
		net.WriteInt(timer.RepsLeft("gamestarttime"), 16)
	net.Broadcast()
end

--------------------------------
-- Serverside Utility functions
--------------------------------

-- Called when there is enough player, the game will automatically start

function GameStart()

	if waitingforplayers == false and game_status == 0 and gamestarting == false and gamelost == false then

		gamestarting = true

		updateClientWaitingForPlayers()
		print("Game is about to begin")

		timer.Create("gamestarttime", 1, 10, function()

			print( string.ToMinutesSeconds((timer.RepsLeft("gamestarttime"))) )
			updateClientGameStartTime()

		end)

		timer.Simple(11, function()

			beginGame()

		end)

	end

end

function GameLost()

if gamelost == false and game_status == 1 and waitingforplayers == false then
 
 		gamelost = true

		print("Game lost, restarting the game")
		timer.Create("gamerestarttime", 1, 10, function()

			print( string.ToMinutesSeconds((timer.RepsLeft("gamerestarttime"))) )

--			We will need an update for clients for the new timer

		end)

		timer.Simple(11, function()

			game.CleanUpMap()
			endGame()

		end)

end

end

function beginGame()

	game_status = 1
	updateClientGameStatus()

	gamelost = false
	gamestarting = false

	zombieCount = setMaxZombieCount
	isSpawning = true

	round_timer_enabled = true

end


function endGame()

	updateClientGameStatus()

	game_status = 0
	gamestarting = false
	gamelost = false
	restartgame = false

	round_timer_enabled = false
	activeRound = activeRound - activeRound
	
end

-----------------------------------------
--Functions returning usefull variables--
-----------------------------------------

function getGameStatus()

	return game_status
	
end

function getRoundNumber()

	return activeRound
	
end

function getRoundTime()

	return string.ToMinutesSeconds(round_time)

end

function getRoundTimerEnabled()

	return round_timer_enabled

end

function getWaitingForPlayers()

	return waitingforplayers

end

function getGameStartTime()
	return (string.ToMinutesSeconds(timer.RepsLeft("gamestarttime")))
end

function getNextWaveWaiting()

	return nextWaveWaiting

end

function getGameStarting()

	return gamestarting

end

--------------------------------
----------Spawn system----------
--------------------------------

-- where should the zombie spawn
-- you can show the pos by typing cl_showpos 1 in console

--Vector pos from gm construct
local spawnPos = Vector(-38.879505, 2448.411133, 64.254677)

--		
--		function getBestSpawn()
--		
--				local bestSpawn = Vector(0,0,0)
--				local closestDistance = 0
--		
--				for k , v in pairs(spawnPos) do
--		
--					local closestZombieDistance = 100000
--		
--					for a , b in pairs(ents.FindByClass("npc_zombie")) do
--		
--						if b:GetPos():Distance(v) < closestZombieDistance then
--		
--							closestZombieDistance = b:GetPos():Distance(v)
--		
--						end
--		
--					end
--		
--					if closestZombieDistance > closestDistance then
--		
--						closestDistance = closestZombieDistance
--						bestSpawn = v
--					end
--				end
--		
--			print(bestSpawn)
--		end

--------------------------------
---------- Wave system ---------
--------------------------------

hook.Add("Think", "WaveThink", function()

	-- Wait for a certain amount of players to join before calling the starting game function

	if table.Count(player.GetAll()) >= 2 and gamestarting == false then

		waitingforplayers = false
		GameStart()


	elseif table.Count(player.GetAll()) <= 1 then

		waitingforplayers = true
		updateClientWaitingForPlayers()

	end

	--Variable that count the time of the current round--

	if round_timer_enabled == true then

		if timerInit < CurTime() then

			timerInit = CurTime() + secondinterval
			round_time = round_time + 1

		end
	end

	-- When every players are dead
	-- the gamelost variable is used so when the function is called it is set to true and it avoids the GameLost() to get spammed every frame

	if ( table.Count(deadplayernumbers) == table.Count(player.GetAll()) and game_status == 1 and nextWaveWaiting == false and gamelost == false ) then
		
		GameLost()

	end

	---------------------------------------------------

-- When the game is active and zombie spawning then
--Zombie spawning with interval and stop when it reached the maximum set

	if game_status == 1  and isSpawning == true then
		
		nextWaveWaiting = false


		if t < CurTime() then

			t = CurTime() + interval

			local temp = ents.Create("npc_zombie")
			temp:SetPos(spawnPos)
			temp:Spawn()

			zombieCount = zombieCount - 1
			print(zombieCount)

			if zombieCount <= 0 then

				isSpawning = false 				

			end
			
		end

	end
	
	-- When the game is active and there is no more zombies spawning after they all died then we call a break of 30 seconds
	-- Stop spawning zombies when it reach the maximum from the variable

	if game_status == 1 and isSpawning == false and table.Count(ents.FindByClass("npc_*")) == 0 and nextWaveWaiting == false then

		activeRound = activeRound + 1
		nextWaveWaiting = true

		round_time = round_time - round_time
		round_timer_enabled = false

	-- Set a break of 30 seconds before the next round
		timer.Simple(30,function()
			zombieCount = 5 * activeRound
			isSpawning = true
			round_timer_enabled = true
		end)
	end

end)

