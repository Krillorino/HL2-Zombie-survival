local round_status = 0 --0 = end 1 = active
local activeRound = 1

util.AddNetworkString("UpdateRoundStatus")

-- Update the round to clients

function updateClientRoundStatus()

	net.Start("UpdateRoundStatus")
		net.WriteInt(round_status, 4)
	net.Broadcast()
	
end

function beginRound()

	round_status = 1
	updateClientRoundStatus()

end


function endRound()

	round_status = 0
	updateClientRoundStatus()
	
end

function getRoundStatus()

	return round_status
	
end

--------------------------------
---Zombie spawning parameters---
--------------------------------

local t = 0

--what is the interval of spawn
local interval = 2

-- number of zombie spawned in that wave
local zombieCount = 5

-- is it spawning zombie?
local isSpawning = false

-- where should the zombie spawn
-- you can show the pos by typing cl_showpos 1 in console
local spawnPos = {

	Vector(-78, -118)

}

--------------------------------
----------Spawn system----------
--------------------------------

function getBestSpawn()

		local bestSpawn = Vector(0,0,0)
		local closestDistance = 0

		for k , v in pairs(spawnPos) do

			local closestZombieDistance = 100000

			for a , b in pairs(ents.FindByClass("npc_zombie")) do

				if b:GetPos():Distance(v) < closestZombieDistance then

					closestZombieDistance = b:GetPos():Distance(v)

				end

			end

			if closestZombieDistance > closestDistance then

				closestDistance = closestZombieDistance
				bestSpawn = v
			end
		end

	print(bestSpawn)
end

--------------------------------
---------- Wave system ---------
--------------------------------

local nextWaveWaiting = false

hook.Add("Think", "WaveThink", function()
	
	if round_status == 1 and isSpawning == true then

		nextWaveWaiting = false

	--Curtime = current time in s and ms since the server has been up, we've set an interval with it
		if t < CurTime() then

			t = CurTime() + interval

			local temp = ents.Create("npc_zombie")
			temp:SetPos(spawnPos)
			temp:Spawn()

			zombieCount = zombieCount - 1

			if zombieCount <= 0 then

				isSpawning = false 

			end
			
		end

	end
	
	if round_status == 1 and isSpawning == false and table.Count(ents.FindByClass("npc_zombie")) == 0 and nextWaveWaiting == false then

		activeRound = activeRound + 1
		nextWaveWaiting = true

		timer.Simple(10,function()
			zombieCount = 5 * activeRound
			isSpawning = true
		end)
	end
end)

