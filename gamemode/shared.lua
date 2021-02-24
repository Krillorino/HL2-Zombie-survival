GM.Name = "HL2 : Zombie survival"

function GM:Initialize()

	self.BaseClass.Initialize(self)

end

team.SetUp(0, Player, Color(0,0,250))

team.SetUp(1, Spectator, Color(0,0,0))