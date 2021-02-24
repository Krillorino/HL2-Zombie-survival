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
local activeRound = 1
nextWaveWaiting = false
local waitingforplayers = true

--------------------------
--Round timer variables--
--------------------------

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
local zombieCount = 5

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

function beginGame()

	game_status = 1
	isSpawning = true
	round_timer_enabled = true
	updateClientGameStatus()

end


function endGame()

	game_status = 0
	updateClientGameStatus()
	round_timer_enabled = false
	
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
--------------------------------
----------Spawn system----------
--------------------------------

-- where should the zombie spawn
-- you can show the pos by typing cl_showpos 1 in console

--Vector pos from gm construct
local spawnPos = Vector(744, -283, -50)

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

-- Refresh everytime a playerspawn if the game should begin

hook.Add("PlayerSpawn", "GameStartTime", function()

	if waitingforplayers == false and game_status == 0 then

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

end)



hook.Add("Think", "WaveThink", function()

	-- Wait for a certain amount of players to join before calling the starting game function

	if nbply:GetCount() >= 2 then

		waitingforplayers = false


	elseif nbply:GetCount() <= 1 then

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

	---------------------------------------------------

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
	
	-- Stop spawning zombies when it reach the maximum from the variable

	if game_status == 1 and isSpawning == false and table.Count(ents.FindByClass("npc_*")) == 0 and nextWaveWaiting == false then

		activeRound = activeRound + 1
		nextWaveWaiting = true

		round_time = round_time - round_time
		round_timer_enabled = false
		RespawnSpectators()

	-- Set a break of 10 seconds before the next round
		timer.Simple(30,function()
			zombieCount = 5 * activeRound
			isSpawning = true
			round_timer_enabled = true
		end)
	end
end)

