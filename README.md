![logo](https://cdn.discordapp.com/attachments/673099203152576513/813188747612520488/logo.png)

# Description
A garry's mod half life 2 zombie survival style gamemode

# How to install
Download the main branch and extract the gamemode folder to GarrysMod\garrysmod\gamemodes

# Credits
Special mention for Kherty, Kanade and Code Blue who highly helped and guided me to create this gamemode.

# TODO

Panel:

Panel appearing when the game is about to start showing the time left before it does
Panel showing the current wave

Gamemode:

When the player dies he is set as a spectator and respawn when the wave got cleared

Players should not teamkill

Spawning interval depends the amount of alive zombies (to prevent an impossible difficulty and server lagg)

If 90% of the zombies of the wave got cleared: 
Create a timer that kills the remaining the remaining zombies at the end.
Make the last zombies glow so players can finish the wave faster

Spawn every end of the wave weapons with ammo next to it somewhere on the map, weapons with ammo spawn on a random location set manually


NPC:

Set different tables sorted by the zombie difficulty tier to optimize zombie spawning with variable difficulty depending on the wave

Zombies should target nearest player and destroy doors (or atleast open them)


To implement later:

Music for active waves, break and last player
Gamemode will load zombie and weapons spawn location that are stored in a specific lua file named like the map 
Optimization for Zombie++ addon so player can become zombies when killed or humped by an headcrab
Add Zombine NPC
Buff zombie damage
