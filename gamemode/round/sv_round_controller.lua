local game_status = 0 --0 = end 1 = active
local activeRound = 1
local waitingforplayers = true

util.AddNetworkString("UpdateGameStatus")
util.AddNetworkString("UpdateRoundNumber")


--Round timer variables--

local secondinterval = 1
local timerInit = 0
local round_time = 0
local round_timer_enabled = false


------------------------

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
-- Update the round to clients -
--------------------------------
function updateClientGameStatus()

	net.Start("UpdateGameStatus")
		net.WriteInt(game_status, 4)
	net.Broadcast()
	
end

function updateRoundNumber()

	net.Start("UpdateRoundNumber")
		net.WriteInt(activeRound, 4)
	net.Broadcast()

end

--

function beginGame()

	game_status = 1
	isSpawning = true
	round_timer_enabled = true
	updateClientRoundStatus()

end

--

function endGame()

	game_status = 0
	updateClientRoundStatus()
	round_timer_enabled = false
	
end

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


local nextWaveWaiting = false

hook.Add("PlayerSpawn", "GameStart", function()

	if waitingforplayers == false and game_status == 0 then

		print("Game is about to begin")

		timer.Create("roundStart", 1, 10, function()

		print( string.ToMinutesSeconds((timer.RepsLeft("roundStart"))) )

		end)

		timer.Simple(11, function()
		beginRound()
		end)

	end

end)



hook.Add("Think", "WaveThink", function()

	if nbply:GetCount() >= 2 then

		waitingforplayers = false

	elseif nbply:GetCount() <= 1 then

		waitingforplayers = true

	end

	--Variable that count the time of the current round--

	if round_timer_enabled == true then

		if timerInit < CurTime() then

			timerInit = CurTime() + secondinterval
			round_time = round_time + 1

		end
	end

	---------------------------------------------------

	if game_status == 1  and isSpawning == true then
		
		nextWaveWaiting = false

	--Zombie spawning with interval and stop when it reached the maximum set

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
	
	if game_status == 1 and isSpawning == false and table.Count(ents.FindByClass("npc_*")) == 0 and nextWaveWaiting == false then

		activeRound = activeRound + 1
		nextWaveWaiting = true

		round_time = round_time - round_time
		round_timer_enabled = false

		timer.Simple(10,function()
			zombieCount = 5 * activeRound
			isSpawning = true
			round_timer_enabled = true
		end)
	end
end)

