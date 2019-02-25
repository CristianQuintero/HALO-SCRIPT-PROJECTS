--[[
--=====================================================================================================--
Script Name: Base Game Settings, for SAPP (PC & CE)
Description: An all-in-one package that combines many of my scripts into one place.

             Nearly every aspect of the combined scripts have been heavily refined and improved in this version,
             with the addition of many new features not found in the standalone versions.
             This mod is heavy on said features and highly customizable, but also user friendly.


Combined Scripts:
    - Admin Chat            Chat IDs            Message Board
    - Chat Logging          Command Spy         Custom Weapons
    - Anti Impersonator     Console Logo        Player List
    - Alias System          Respawn Time        Teleport Manager
    - Get Coords            Spawn From Sky      Admin Join Messages
    - Color Reservation     Item Spawner        What cute things did you do today? (request by Shoo)
    - Lurker                Infinity Ammo       Portal Gun (request by Shoo)
    - Suggestions Box (request by Cyser@)       Enter Vehicle

    BGS Commands:
    /plugins, /enable [id], /disable [id]
    /mute [id] <time dif>, /unmute [id]
    /clear (clears chat)
    /clean

    "/plugins" shows you a list of all mods and tells you which ones are enabled or disabled.
    You can enable or disable any mod in game at any time with /enable [id], /disable [id].
   
    /clean (command syntax info) for Enter Vehicle & Item Spawner:
    
        ~ Valid [id] inputs: [number range 1-16, me or *] 
        * /clean [id] 1 (cleans up "Enter Vehicle" objects)
        * /clean [id] 2 (cleans up "Item Spawner" objects)
        * /clean [id] * (cleans up "everything")
        Also, to clear up any confusion should there be any, /clean * * is valid - This will clean everything for everybody.
    --

    To enable update checking, this script requires that the following plugin is installed:
    https://opencarnage.net/index.php?/topic/5998-sapp-http-client/
    Credits to Kavawuvi (002) for HTTP client functionality.
        
Copyright (c) 2016-2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]] --

api_version = "1.12.0.0"
local settings = {}
local function GameSettings()
    -- CONFIGURAITON [begins] >> ------------------------------------------------------------
    settings = {
        mod = {
            -- # This feature allows admins to communicate in a "private chat channel".
            ["Admin Chat"] = {
                enabled = true, -- Enabled = true, Disabled = false
                base_command = "achat",
                permission_level = 1, -- Minimum level required to execute /achat [on / off]
                prefix = "[ADMIN CHAT]",
                restore_previous_state = true,
                environment = "rcon", -- Valid environments: "rcon", "chat".
                message_format = { "%prefix% %sender_name% [%index%] %message%" }
            },
            ["Chat IDs"] = {
                --[[
                    This feature modifies player chat messages.
                    --> Adds a Player Index ID in front of their name in square [] brackets.
                
                    Example: 
                    Team output: [Chalwk] [1]: This is a test message
                    Global output: Chalwk [1]: This is a test message
                --]]
                enabled = true,
                global_format = { "%sender_name% [%index%]: %message%" },
                team_format = { "[%sender_name%] [%index%]: %message%" },
                use_admin_prefixes = false, -- Set to TRUE to enable the below bonus feature.
                -- Ability to have separate chat formats on a per-admin-level basis...
                trial_moderator = {
                    "[T-MOD] %sender_name% [%index%]: %message%", -- global
                    "[T-MOD] [%sender_name%] [%index%]: %message%" -- team
                },
                moderator = {
                    "[MOD] %sender_name% [%index%]: %message%", -- global
                    "[MOD] [%sender_name%] [%index%]: %message%" -- team
                },
                admin = {
                    "[ADMIN] %sender_name% [%index%]: %message%", -- global
                    "[ADMIN] [%sender_name%] [%index%]: %message%" -- team
                },
                senior_admin = {
                    "[S-ADMIN] %sender_name% [%index%]: %message%", -- global
                    "[S-ADMIN] [%sender_name%] [%index%]: %message%" -- team
                },
                ignore_list = {
                    "skip",
                    "rtv"
                }
            },
            -- # Custom (separate) join messages for staff on a per-level basis
            ["Admin Join Messages"] = {
                enabled = true,
                messages = {
                    -- [prefix] [message] (note: the joining player's name is automatically inserted between [prefix] and [message])
                    [1] = { "[TRIAL-MOD] ", " joined the server. Everybody hide!" },
                    [2] = { "[MODERATOR] ", " just showed up. Hold my beer!" },
                    [3] = { "[ADMIN] ", " just joined. Hide your bananas!" },
                    [4] = { "[SENIOR-ADMIN] ", " joined the server." }
                }
            },
            -- # This is a spectator-like feature.
            ["Lurker"] = {
                -- To enable a feature, set 'false' to 'true'
                enabled = true,
                base_command = "lurker",
                permission_level = 1,
                announcer = true, -- If this is enabled then all players will be alerted when someone goes into lurker mode.
                speed = true,
                god = true,
                camouflage = true,
                running_speed = 2, -- Speed boost applied (default running speed is 1)
                default_running_speed = 1, -- Speed the player returns to when they exit out of Lurker Mode.

                -- If the player picks up the oddball or flag, they receive a warning and are asked to drop the objective.
                -- If they do not drop the objective before the timer reaches 0, they are killed automatically.
                -- Warnings are given immediately upon picking up the objective.
                -- If the player has no warnings left their Lurker will be disabled (however, not revoked).
                -- ...
                time_until_death = 10, -- Time (in seconds) until the player is killed after picking up the objective.
                warnings = 4,
            },
            ["Infinity Ammo"] = {
                enabled = true,
                server_override = true, -- If this is enabled, all players will have Infinity (perma-ammo) by default.
                base_command = "infammo",
                announcer = true, -- If this is enabled then all players will be alerted when someone goes into Infinity Ammo mode.
                permission_level = 1,
                multiplier_min = 0.001, -- minimum damage multiplier
                multiplier_max = 10, -- maximum damage multiplier
            },
            ["Suggestions Box"] = {
                -- Players can suggest features or maps using /suggest {message}. Suggestions are saved to suggestions.txt
                enabled = false,
                base_command = "suggestion", -- Command Syntax: /suggestion {message}
                permission_level = -1, -- Minimum privilege level required to execute /suggestion (-1 for all players, 1-4 for admins)
                dir = "sapp\\suggestions.txt", -- file directory
                file_format = "[%time_stamp%] %player_name%: %message%", -- Message format saved to suggestions.txt
                response = "Thank you for your suggestion, %player_name%" -- Message omitted to the player when they execute /suggest
            },
            ["Portal Gun"] = {
                enabled = true,
                base_command = "portalgun",
                announcer = true, -- If this is enabled then all players will be alerted when someone goes into Portal Gun mode.
                permission_level = 1,
            },
            ["Message Board"] = {
                -- Welcome messages | OnPlayerJoin()
                enabled = false,
                duration = 10, -- How long should the message be displayed on screen for? (in seconds)
                alignment = "l", -- Left = l, Right = r, Center = c, Tab: t
                -- Use %server_name% variable to output the server name.
                -- Use %player_name% variable to output the joining player's name.
                messages = {
                    "Welcome to %server_name%, %player_name%",
                    "line 2",
                    "line 3",
                    "line 4",
                    "line 5"
                    -- repeat the structure to add more entries
                }
            },
            ["Color Reservation"] = {
                enabled = true, -- Enabled = true, Disabled = false
                color_table = {
                    [1] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- white
                    [2] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- black
                    [3] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- red
                    [4] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- blue
                    [5] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- gray
                    [6] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- yellow
                    [7] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- green
                    [8] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- pink
                    [9] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- purple
                    [10] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- cyan
                    [11] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- cobalt
                    [12] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- orange
                    [13] = { "abd5c96cd22517b4e2f358598147c606" }, -- teal (Shoo)
                    [14] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- sage
                    [15] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- brown
                    [16] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- tan
                    [17] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, -- maroon
                    [18] = { "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" } -- salmon
                }
            },
            -- # Logs chat, commands and quit-join events.
            ["Chat Logging"] = {
                enabled = true, -- Enabled = true, Disabled = false
                dir = "sapp\\Server Chat.txt"
            },
            ["Command Spy"] = {
                enabled = true,
                permission_level = 1,
                prefix = "[SPY]",
                hide_commands = true,
                commands_to_hide = {
                    "/accept",
                    "/deny",
                    -- "/afk",
                    -- "/lead",
                    -- "/stfu",
                    -- "/unstfu",
                    -- "/skip"
                }
            },
            ["Custom Weapons"] = {
                enabled = true, -- Enabled = true, Disabled = false
                assign_weapons = false,
                assign_custom_frags = false,
                assign_custom_plasmas = false,
                weapons = {
                    -- Weap slot 1, Weap slot 2, Weap slot 3, Weap slot 4, frags, plasmas. Set to 'nil' if not used (weapon slots only)
                    ["beavercreek"] = { sniper, pistol, rocket_launcher, shotgun, 4, 2 },
                    ["bloodgulch"] = { pistol, sniper, nil, nil, 2, 2 },
                    ["boardingaction"] = { plasma_cannon, rocket_launcher, flamethrower, nil, 1, 3 },
                    ["carousel"] = { nil, nil, pistol, needler, 3, 3 },
                    ["dangercanyon"] = { nil, plasma_rifle, nil, pistol, 4, 4 },
                    ["deathisland"] = { assault_rifle, nil, plasma_cannon, sniper, 1, 1 },
                    ["gephyrophobia"] = { nil, nil, nil, shotgun, 3, 3 },
                    ["icefields"] = { plasma_rifle, nil, plasma_rifle, nil, 2, 3 },
                    ["infinity"] = { assault_rifle, nil, nil, nil, 2, 4 },
                    ["sidewinder"] = { nil, rocket_launcher, nil, assault_rifle, 3, 2 },
                    ["timberland"] = { nil, nil, nil, pistol, 2, 4 },
                    ["hangemhigh"] = { flamethrower, nil, flamethrower, nil, 3, 3 },
                    ["ratrace"] = { nil, nil, nil, nil, 3, 2 },
                    ["damnation"] = { plasma_rifle, nil, nil, plasma_rifle, 1, 3 },
                    ["putput"] = { nil, rocket_launcher, assault_rifle, pistol, 4, 1 },
                    ["prisoner"] = { nil, nil, pistol, plasma_rifle, 2, 1 },
                    ["wizard"] = { rocket_launcher, nil, shotgun, nil, 1, 2 },
                    ["room_final"] = { rocket_launcher, nil, nil, nil, 1, 1 },
                    ["dead_end"] = { pistol, assault_rifle, nil, nil, 1, 1 },
                    ["gruntground"] = { needler, nil, nil, nil, 1, 1 },
                    ["feelgoodinc"] = { rocket_launcher, nil, nil, nil, 1, 1 },
                    ["lolcano"] = { rocket_launcher, nil, nil, nil, 1, 1 },
                    ["camden_place"] = { pistol, nil, nil, nil, 1, 1 },
                    ["alice_gulch"] = { pistol, nil, nil, nil, 1, 1 }
                },
            },
            ["Enter Vehicle"] = {
                enabled = true,
                base_command = "enter",
                permission_level = 1,
                multi_control = true,
                -- Destroy objects spawned:
                garbage_collection = {
                    on_death = true,
                    on_disconnect = true,
                },
            },
            ["Item Spawner"] = {
                enabled = true,
                base_command = "spawn",
                permission_level = 1,
                -- Destroy objects spawned:
                garbage_collection = {
                    on_death = true,
                    on_disconnect = true,
                },
                list = "itemlist",
                distance_from_playerX = 2.5,
                distance_from_playerY = 2.5,
                objects = {
                    -- To spawn an object, type /spawn [item name]
                    -- "Item Name", "tag type", "tag name"
                    [1] = { "cyborg", "bipd", "characters\\cyborg_mp\\cyborg_mp" },

                    -- Equipment
                    [2] = { "camo", "eqip", "powerups\\active camouflage" },
                    [3] = { "health", "eqip", "powerups\\health pack" },
                    [4] = { "overshield", "eqip", "powerups\\over shield" },
                    [5] = { "frag", "eqip", "weapons\\frag grenade\\frag grenade" },
                    [6] = { "plasma", "eqip", "weapons\\plasma grenade\\plasma grenade" },

                    -- Vehicles
                    [7] = { "banshee", "vehi", "vehicles\\banshee\\banshee_mp" },
                    [8] = { "turret", "vehi", "vehicles\\c gun turret\\c gun turret_mp" },
                    [9] = { "ghost", "vehi", "vehicles\\ghost\\ghost_mp" },
                    [10] = { "tank", "vehi", "vehicles\\scorpion\\scorpion_mp" },
                    [11] = { "rhog", "vehi", "vehicles\\rwarthog\\rwarthog" },
                    [12] = { "hog", "vehi", "vehicles\\warthog\\mp_warthog" },

                    -- Weapons
                    [13] = { "rifle", "weap", "weapons\\assault rifle\\assault rifle" },
                    [14] = { "ball", "weap", "weapons\\ball\\ball" },
                    [15] = { "flag", "weap", "weapons\\flag\\flag" },
                    [16] = { "flamethrower", "weap", "weapons\\flamethrower\\flamethrower" },
                    [17] = { "needler", "weap", "weapons\\needler\\mp_needler" },
                    [18] = { "pistol", "weap", "weapons\\pistol\\pistol" },
                    [19] = { "ppistol", "weap", "weapons\\plasma pistol\\plasma pistol" },
                    [20] = { "prifle", "weap", "weapons\\plasma rifle\\plasma rifle" },
                    [21] = { "frg", "weap", "weapons\\plasma_cannon\\plasma_cannon" },
                    [22] = { "rocket", "weap", "weapons\\rocket launcher\\rocket launcher" },
                    [23] = { "shotgun", "weap", "weapons\\shotgun\\shotgun" },
                    [24] = { "sniper", "weap", "weapons\\sniper rifle\\sniper rifle" },

                    -- Projectiles
                    [25] = { "sheebolt", "proj", "vehicles\\banshee\\banshee bolt" },
                    [26] = { "sheerod", "proj", "vehicles\\banshee\\mp_banshee fuel rod" },
                    [27] = { "turretbolt", "proj", "vehicles\\c gun turret\\mp gun turret" },
                    [28] = { "ghostbolt", "proj", "vehicles\\ghost\\ghost bolt" },
                    [29] = { "tankbullet", "proj", "vehicles\\scorpion\\bullet" },
                    [30] = { "tankshell", "proj", "vehicles\\scorpion\\tank shell" },
                    [31] = { "hogbullet", "proj", "vehicles\\warthog\\bullet" },
                    [32] = { "riflebullet", "proj", "weapons\\assault rifle\\bullet" },
                    [33] = { "flame", "proj", "weapons\\flamethrower\\flame" },
                    [34] = { "needle", "proj", "weapons\\needler\\mp_needle" },
                    [35] = { "pistolbullet", "proj", "weapons\\pistol\\bullet" },
                    [36] = { "ppistolbolt", "proj", "weapons\\plasma pistol\\bolt" },
                    [37] = { "priflebolt", "proj", "weapons\\plasma rifle\\bolt" },
                    [38] = { "priflecbolt", "proj", "weapons\\plasma rifle\\charged bolt" },
                    [39] = { "rocketproj", "proj", "weapons\\rocket launcher\\rocket" },
                    [40] = { "shottyshot", "proj", "weapons\\shotgun\\pellet" },
                    [41] = { "snipershot", "proj", "weapons\\sniper rifle\\sniper bullet" },
                    [42] = { "fuelrodshot", "proj", "weapons\\plasma_cannon\\plasma_cannon" },

                    -- Custom Vehicles [ Bitch Slap ]
                    [43] = { "slap1", "vehi", "deathstar\\1\\vehicle\\tag_2830" }, -- Chain Gun Hog
                    [44] = { "slap2", "vehi", "deathstar\\1\\vehicle\\tag_3215" }, -- Quad Bike
                    [45] = { "wraith", "vehi", "vehicles\\wraith\\wraith" },
                    [46] = { "pelican", "vehi", "vehicles\\pelican\\pelican" },
                    -- Custom Weapons ...
                }
            },
            ["Anti Impersonator"] = {
                enabled = true,
                action = "kick", -- Valid actions, "kick", "ban"
                reason = "impersonating",
                bantime = 10, -- (In Minutes) -- Set to zero to ban permanently
                users = {
                    {["Chalwk"] = {"6c8f0bc306e0108b4904812110185edd", "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"}},
                    {["Ro@dhog"] = {"0ca756f62f9ecb677dc94238dcbc6c75", "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"}},
                    {["§hoo"] = {"abd5c96cd22517b4e2f358598147c606", "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"}},
                    -- repeat the structure to add more hash entries (assuming you own multiple copies of halo)
                    {["NAME"] = {"hash1", "hash2", "hash3", "etc..."}},
                },
            },
            ["Console Logo"] = {
                enabled = true
            },
            -- # An alternative player list mod. Overrides SAPP's built in /pl command.
            ["Player List"] = {
                enabled = true,
                permission_level = 1,
                alignment = "l", -- Left = l, Right = r, Center = c, Tab: t
                command_aliases = {
                    "pl",
                    "players",
                    "playerlist",
                    "playerslist"
                }
            },
            -- # Query a player's hash to check what aliases have been used with it.
            ["Alias System"] = {
                enabled = true,
                base_command = "alias",
                dir = "sapp\\alias.lua",
                permission_level = 1,
                alignment = "l", -- Left = l, Right = r, Center = c, Tab: t
                duration = 5 -- How long should the alias results be displayed for? (in seconds)
            },
            ["Respawn Time"] = {
                enabled = true,
                maps = {
                    -- CTF, SLAYER, TEAM-S, KOTH, TEAM-KOTH, ODDBALL, TEAM-ODDBALL, RACE, TEAM-RACE
                    ["beavercreek"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["bloodgulch"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["boardingaction"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["carousel"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["dangercanyon"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["deathisland"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["gephyrophobia"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["icefields"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["infinity"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["sidewinder"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["timberland"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["hangemhigh"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["ratrace"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["damnation"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["putput"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["prisoner"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["wizard"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["tactics"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["gruntground"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["lolcano"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["homestead"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["camden_place"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["olympus_mons"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["chaosgulchv2"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["enigma"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["extinction"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["coldsnap"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["mario64"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["dead-end"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["destinycanyon"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["immure"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["sneak"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["windfall_island"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["feelgoodinc"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["battlegulch_v2_chaos"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["ragnarok"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["celebration_island"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["doom_wa_view"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["garden_ce"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["sciophobiav2"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["portent"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["pitfall"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["quagmire"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 },
                    ["medical block"] = { 3, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5 }
                }
            },
            ["Teleport Manager"] = {
                enabled = true,
                dir = "sapp\\teleports.txt",
                permission_level = {
                    setwarp = 1,
                    warp = -1,
                    back = -1,
                    warplist = -1,
                    warplistall = -1,
                    delwarp = 1
                },
                commands = {
                    "setwarp", -- set command
                    "warp", -- go to command
                    "back", -- go back command
                    "warplist", --list command
                    "warplistall", -- list all command
                    "delwarp" -- delete command
                }
            },
            ["Get Coords"] = {
                enabled = false,
                base_command = "coords",
                permission_level = 1,
                environment = "console"
            },
            ["wctdydt"] = {
                -- # What cute things did you do today? (requested by Shoo)
                enabled = true,
                base_command = "cute",

                -- Use %executors_name% (optional) variable to output the executor's name.
                -- Use %target_name% (optional) variable to output the target's name.

                messages = {
                    -- Target sees this message
                    "%target_name%, what cute things did you do today?",
                    -- Command response (to executor)
                    "[you] -> %target_name%, what cute things did you do today?",
                },
                permission_level = 1,
                environment = "chat" -- Valid environments: "rcon", "chat".
            },
            ["Spawn From Sky"] = {
                enabled = false,
                maps = {
                    ["bloodgulch"] = {
                        height = 35,
                        invulnerability = 9,
                        { 95.687797546387, -159.44900512695, -0.10000000149012 },
                        { 40.240600585938, -79.123199462891, -0.10000000149012 }
                    },
                    ["deathisland"] = {
                        height = 35,
                        invulnerability = 9,
                        { -26.576030731201, -6.9761986732483, 9.6631727218628 },
                        { 29.843469619751, 15.971487045288, 8.2952880859375 }
                    },
                    ["icefields"] = {
                        height = 35,
                        invulnerability = 9,
                        { 24.85000038147, -22.110000610352, 2.1110000610352 },
                        { -77.860000610352, 86.550003051758, 2.1110000610352 }
                    },
                    ["infinity"] = {
                        height = 35,
                        invulnerability = 9,
                        { 0.67973816394806, -164.56719970703, 15.039022445679 },
                        { -1.8581243753433, 47.779975891113, 11.791272163391 }
                    },
                    ["sidewinder"] = {
                        height = 35,
                        invulnerability = 9,
                        { -32.038200378418, -42.066699981689, -3.7000000476837 },
                        { 30.351499557495, -46.108001708984, -3.7000000476837 }
                    },
                    ["timberland"] = {
                        height = 25,
                        invulnerability = 5,
                        { 17.322099685669, -52.365001678467, -17.751399993896 },
                        { -16.329900741577, 52.360000610352, -17.741399765015 }
                    },
                    ["dangercanyon"] = {
                        height = 25,
                        invulnerability = 5,
                        { -12.104507446289, -3.4351840019226, -2.2419033050537 },
                        { 12.007399559021, -3.4513700008392, -2.2418999671936 }
                    },
                    ["beavercreek"] = {
                        height = 25,
                        invulnerability = 5,
                        { 29.055599212646, 13.732000350952, -0.10000000149012 },
                        { -0.86037802696228, 13.764800071716, -0.0099999997764826 }
                    },
                    ["boardingaction"] = {
                        height = 4,
                        invulnerability = 3,
                        { 1.723109960556, 0.4781160056591, 0.60000002384186 },
                        { 18.204000473022, -0.53684097528458, 0.60000002384186 }
                    },
                    ["carousel"] = {
                        height = 3,
                        invulnerability = 2,
                        { 5.6063799858093, -13.548299789429, -3.2000000476837 },
                        { -5.7499198913574, 13.886699676514, -3.2000000476837 }
                    },
                    ["chillout"] = {
                        height = 2,
                        invulnerability = 1,
                        { 7.4876899719238, -4.49059009552, 2.5 },
                        { -7.5086002349854, 9.750340461731, 0.10000000149012 }
                    },
                    ["damnation"] = {
                        height = 3,
                        invulnerability = 2,
                        { 9.6933002471924, -13.340399742126, 6.8000001907349 },
                        { -12.17884349823, 14.982703208923, -0.20000000298023 }
                    },
                    ["gephyrophobia"] = {
                        height = 5,
                        invulnerability = 4,
                        { 26.884338378906, -144.71551513672, -16.049139022827 },
                        { 26.727857589722, 0.16621616482735, -16.048349380493 }
                    },
                    ["hangemhigh"] = {
                        height = 5,
                        invulnerability = 4,
                        { 13.047902107239, 9.0331249237061, -3.3619771003723 },
                        { 32.655700683594, -16.497299194336, -1.7000000476837 }
                    },
                    ["longest"] = {
                        height = 2,
                        invulnerability = 1,
                        { -12.791899681091, -21.6422996521, -0.40000000596046 },
                        { 11.034700393677, -7.5875601768494, -0.40000000596046 }
                    },
                    ["prisoner"] = {
                        height = 2,
                        invulnerability = 1,
                        { -9.3684597015381, -4.9481601715088, 5.6999998092651 },
                        { 9.3676500320435, 5.1193399429321, 5.6999998092651 }
                    },
                    ["putput"] = {
                        height = 3,
                        invulnerability = 2,
                        { -18.89049911499, -20.186100006104, 1.1000000238419 },
                        { 34.865299224854, -28.194700241089, 0.10000000149012 }
                    },
                    ["ratrace"] = {
                        height = 3,
                        invulnerability = 2,
                        { -4.2277698516846, -0.85564690828323, -0.40000000596046 },
                        { 18.613000869751, -22.652599334717, -3.4000000953674 }
                    },
                    ["wizard"] = {
                        height = 3,
                        invulnerability = 2,
                        { -9.2459697723389, 9.3335800170898, -2.5999999046326 },
                        { 9.1828498840332, -9.1805400848389, -2.5999999046326 }
                    }
                }
            }
        },
        -- GLOBAL SETTINGS
        global = {
            server_prefix = "**SERVER** ",
            handlemutes = true,
            mute_dir = "sapp\\mutes.txt",
            default_mute_time = 525600,
            can_mute_admins = false, -- True = yes, false = no
            beepOnLoad = false,
            beepOnJoin = true,
            script_version = 1.7,
            check_for_updates = false,
            plugin_commands = {
                enable = "enable",
                disable = "disable",
                list = "plugins",
                mute = "mute",
                unmute = "unmute",
                mutelist = "mutelist",
                clearchat = "clear",
                garbage_collection = "clean",
            },
            permission_level = {
                trial_moderator = 1,
                moderator = 2,
                admin = 3,
                senior_admin = 4
            },
            player_data = {
                "Player: %name%",
                "CD Hash: %hash%",
                "IP Address: %ip_address%",
                "Index ID: %index_id%",
                "Privilege Level: %level%",
            },
        }
    }
    -- CONFIGURAITON [ends] << ------------------------------------------------------------
end

-- Tables used Globally
local players = {}
local player_info = {}
local mapname = ""
local ce
local empty_file
local console_address_patch = nil

-- Mute Handler
local mute_duration = {}
local time_diff = {}
local muted = {}
local mute_timer = {}
local init_mute_timer = {}

-- #Message Board
local welcome_timer = {}

-- #Admin Chat
local data = {}
local stored_data = {}
local game_over

-- #Custom Weapons
local weapon = {}

-- #Alias System
local trigger = {}
local alias_bool = {}
local target_hash

-- #Teleport Manager
local canset = {}
local wait_for_response = {}
local previous_location = {}
for i = 1, 16 do
    previous_location[i] = {}
end

-- #Spawn From Sky
local init_timer = {}
local first_join = {}

-- #Color Reservation
local colorres_bool = {}
local can_use_colorres

-- #Item Spawner
local temp_objects_table = {}

-- #Lurker
local lurker = {}
local lurker_warn = {}
local object_picked_up = {}
local has_objective = {}
local lurker_warnings = {}

-- #Infinity Ammo
local infammo = {}
local frag_check = {}
local modify_damage = {}
local damage_multiplier = {}

-- #Portal Gun
local weapon_status = {}
local portalgun_mode = {}

-- #Enter Vehicle
local ev = {}
local ev_Status = {}
local ev_NewVehicle = {}
local ev_OldVehicle = {}

-- drones
local EV_drone_table = {}
local IS_drone_table = {}
local item_objects = {}

local sub, gsub, find, lower, format, match = string.sub, string.gsub, string.find, string.lower, string.format, string.match
local floor = math.floor
local concat = table.concat

local function getServerName()
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    local servername = read_widestring(network_struct + 0x8, 0x42)
    return servername
end

local function TagInfo(obj_type, obj_name)
    local tag = lookup_tag(obj_type, obj_name)
    return tag ~= 0 and read_dword(tag + 0xC) or nil
end

local function adjust_ammo(PlayerIndex)
    for i = 1, 4 do
        execute_command("ammo " .. tonumber(PlayerIndex) .. " 999 " .. i)
        execute_command("mag " .. tonumber(PlayerIndex) .. " 100 " .. i)
        execute_command("battery " .. tonumber(PlayerIndex) .. " 100 " .. i)
    end
end

local function DisableInfAmmo(TargetID)
    infammo[TargetID] = false
    frag_check[TargetID] = false
    modify_damage[TargetID] = false
    damage_multiplier[TargetID] = 0
end

local function getPlayerInfo(PlayerIndex, id)
    if player_present(PlayerIndex) then
        if player_info[PlayerIndex] ~= nil or player_info[PlayerIndex] ~= {} then
            for key, _ in ipairs(player_info[PlayerIndex]) do
                return player_info[PlayerIndex][key][id]
            end
        end
    end
end

local function enterVehicle(PlayerIndex, Vehicle)
    enter_vehicle(Vehicle, PlayerIndex, 0)
    ev[PlayerIndex] = true
end

local function announce(PlayerIndex, message)
    for i = 1, 16 do
        if (player_present(i) and i ~= PlayerIndex) then
            say(i, message)
        end
    end
end

function OnScriptLoad()
    loadWeaponTags()
    GameSettings()
    printEnabled()
    if (settings.global.check_for_updates) then
        getCurrentVersion(true)
    else
        cprint("[BGS] Current Version: " .. settings.global.script_version, 2 + 8)
    end
    register_callback(cb['EVENT_TICK'], "OnTick")

    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")

    register_callback(cb['EVENT_PREJOIN'], "OnPlayerPrejoin")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")

    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
    register_callback(cb['EVENT_PRESPAWN'], "OnPlayerPrespawn")

    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")

    register_callback(cb['EVENT_DIE'], "OnPlayerKill")

    register_callback(cb['EVENT_DAMAGE_APPLICATION'], "OnDamageApplication")

    register_callback(cb['EVENT_WEAPON_PICKUP'], "OnWeaponPickup")
    register_callback(cb['EVENT_WEAPON_DROP'], "OnWeaponDrop")

    register_callback(cb['EVENT_OBJECT_SPAWN'], "OnObjectSpawn")

    for i = 1, 16 do
        if player_present(i) then

            local p_table = get_var(i, "$name") .. ", " .. get_var(i, "$hash")
            players[p_table] = {}

            -- #Message Board
            if (settings.mod["Message Board"].enabled) then
                players[p_table].message_board_timer = 0
            end

            -- #Alias System
            if (settings.mod["Alias System"].enabled) then
                players[p_table].alias_timer = 0
            end

            -- #Admin Chat
            if (settings.mod["Admin Chat"].enabled) then
                if not (game_over) and tonumber(get_var(i, "$lvl")) >= getPermLevel("Admin Chat", nil, nil) then
                    players[get_var(i, "$name") .. ", " .. get_var(i, "$hash")].adminchat = nil
                    players[get_var(i, "$name") .. ", " .. get_var(i, "$hash")].boolean = nil
                end
            end

            -- #Lurker
            if (settings.mod["Lurker"].enabled) then
                resetLurker(i)
            end
        end
    end

    if halo_type == "PC" then
        ce = 0x0
    else
        ce = 0x40
    end

    -- #Custom Weapons
    if (settings.mod["Custom Weapons"].enabled) then
        if not (game_over) then
            if get_var(0, "$gt") ~= "n/a" then
                mapname = get_var(0, "$map")
            end
        end
    end
    if (settings.global.beepOnLoad) then
        execute_command_sequence("beep 1200 200; beep 1200 200; beep 1200 200")
    end

    if settings.mod["Alias System"].enabled then
        local f1 = settings.mod["Alias System"].dir
        checkFile(f1)
    end

    if settings.global.handlemutes then
        local f2 = settings.global.mute_dir
        checkFile(f2)
    end

    if settings.mod["Teleport Manager"].enabled then
        local f3 = settings.mod["Teleport Manager"].dir
        checkFile(f3)
    end

    -- #Console Logo
    if (settings.mod["Console Logo"].enabled) then
        --noinspection GlobalCreationOutsideO
        function consoleLogo()
            -- Logo: ascii: 'kban'
            cprint("================================================================================", 2 + 8)
            cprint(os.date("%A, %d %B %Y - %X"), 6)
            cprint("")
            cprint("     '||'  '||'     |     '||'       ..|''||           ..|'''.| '||''''|  ", 4 + 8)
            cprint("      ||    ||     |||     ||       .|'    ||        .|'     '   ||  .    ", 4 + 8)
            cprint("      ||''''||    |  ||    ||       ||      ||       ||          ||''|    ", 4 + 8)
            cprint("      ||    ||   .''''|.   ||       '|.     ||       '|.      .  ||       ", 4 + 8)
            cprint("     .||.  .||. .|.  .||. .||.....|  ''|...|'         ''|....'  .||.....| ", 4 + 8)
            cprint("               ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-")
            cprint("                      " .. getServerName())
            cprint("               ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-")
            cprint("")
            cprint("================================================================================", 2 + 8)
        end

        timer(50, "consoleLogo")
    end
    local rcon = sig_scan("B8????????E8??000000A1????????55")
    if (rcon ~= 0) then
        console_address_patch = read_dword(rcon + 1)
        safe_write(true)
        write_byte(console_address_patch, 0)
        safe_write(false)
    end

    if checkFile("sapp\\bgs_changelog.txt") then
        RecordChanges()
    end
end

function OnScriptUnload()
    for i = 1, 16 do
        if player_present(i) then
            local p_table = get_var(i, "$name") .. ", " .. get_var(i, "$hash")

            -- #Admin Chat
            if (settings.mod["Admin Chat"].enabled) then
                if tonumber(get_var(i, "$lvl")) >= getPermLevel("Admin Chat", nil, nil) then
                    players[p_table].adminchat = false
                    players[p_table].boolean = false
                end
            end
        end
    end
    if console_address_patch ~= nil then
        safe_write(true)
        write_byte(console_address_patch, 0x72)
        safe_write(false)
    end
end

function OnNewGame()
    -- Used Globally
    game_over = false
    mapname = get_var(0, "$map")

    for i = 1, 16 do
        if player_present(i) then
            local p_table = get_var(i, "$name") .. ", " .. get_var(i, "$hash")

            -- #Message Board
            if (settings.mod["Message Board"].enabled) then
                players[p_table].message_board_timer = 0
            end

            -- #Alias System
            if (settings.mod["Alias System"].enabled) then
                alias_bool[i] = false
                trigger[i] = false
                players[p_table].alias_timer = 0
            end

            -- #Lurker
            if (settings.mod["Lurker"].enabled) then
                resetLurker(i)
            end

            -- #Admin Chat
            if (settings.mod["Admin Chat"].enabled) then
                if tonumber(get_var(i, "$lvl")) >= getPermLevel("Admin Chat", nil, nil) then
                    players[get_var(i, "$name") .. ", " .. get_var(i, "$hash")].adminchat = false
                    players[get_var(i, "$name") .. ", " .. get_var(i, "$hash")].boolean = false
                end
            end
        end
    end

    -- #Color Reservation
    if (settings.mod["Color Reservation"].enabled) then
        if (getTeamPlay()) then
            can_use_colorres = false
        else
            can_use_colorres = true
        end
    end

    -- #Chat Logging
    if (settings.mod["Chat Logging"].enabled) then
        local dir = settings.mod["Chat Logging"].dir
        local file = io.open(dir, "a+")
        if file ~= nil then
            local map = get_var(0, "$map")
            local gt = get_var(0, "$mode")
            local n1 = "\n"
            local t1 = os.date("[%A %d %B %Y] - %X - A new game has started on " .. tostring(map) .. ", Mode: " .. tostring(gt))
            local n2 = "\n---------------------------------------------------------------------------------------------\n"
            file:write(n1, t1, n2)
            file:close()
        end
    end

    -- #Teleport Manager
    if (settings.mod["Teleport Manager"].enabled) then
        check_file_status(PlayerIndex)
    end

    -- #Item Spawner
    if (settings.mod["Item Spawner"].enabled) then
        local objects_table = settings.mod["Item Spawner"].objects
        for i = 1, #objects_table do
            temp_objects_table[#temp_objects_table + 1] = objects_table[i][1]
        end
    end
end

function OnGameEnd()
    -- Used Globally
    -- Prevents displaying chat ids when the game is over.
    -- Otherwise map voting breaks.
    game_over = true

    for i = 1, 16 do
        if player_present(i) then
            local p_table = get_var(i, "$name") .. ", " .. get_var(i, "$hash")
            -- #Weapon Settings
            if (settings.mod["Custom Weapons"].enabled and settings.mod["Custom Weapons"].assign_weapons) then
                weapon[i] = false
            end

            -- #Alias System
            if (settings.mod["Alias System"].enabled) then
                alias_bool[i] = false
                trigger[i] = false
                players[p_table].alias_timer = 0
            end

            -- #Lurker
            if (settings.mod["Lurker"].enabled) then
                resetLurker(i)
            end

            -- #Message Board
            if (settings.mod["Message Board"].enabled) then
                welcome_timer[i] = false
                players[p_table].message_board_timer = 0
            end

            -- #Admin Chat
            if (settings.mod["Admin Chat"].enabled) then
                if tonumber(get_var(i, "$lvl")) >= getPermLevel("Admin Chat", nil, nil) then
                    if (Restore_Previous_State) then
                        local bool
                        if players[get_var(i, "$name") .. ", " .. get_var(i, "$hash")].adminchat == true then
                            bool = "true"
                        else
                            bool = "false"
                        end
                        data[i] = get_var(i, "$name") .. ":" .. bool
                        stored_data[data] = stored_data[data] or {}
                        table.insert(stored_data[data], tostring(data[i]))
                    else
                        players[get_var(i, "$name") .. ", " .. get_var(i, "$hash")].adminchat = false
                        players[get_var(i, "$name") .. ", " .. get_var(i, "$hash")].boolean = false
                    end
                end
            end

            -- SAPP | Mute Handler
            if (settings.global.handlemutes == true) then
                if (muted[tonumber(i)] == true) then
                    local name, hash = get_var(i, "$name"), get_var(i, "$hash")
                    local ip = getPlayerInfo(i, "ip"):match("(%d+.%d+.%d+.%d+:%d+)")
                    local file_name = settings.global.mute_dir
                    checkFile(file_name)
                    local file = io.open(file_name, "r")
                    file:close()
                    local lines = lines_from(file_name)
                    for k, v in pairs(lines) do
                        if k ~= nil then
                            if v:match(ip) and v:match(hash) then
                                local updated_entry = ip .. ", " .. hash .. ", " .. name .. ", ;" .. time_diff[tonumber(i)]
                                local f1 = io.open(file_name, "r")
                                local content = f1:read("*all")
                                f1:close()
                                content = gsub(content, v, updated_entry)
                                local f2 = io.open(file_name, "w")
                                f2:write(content)
                                f2:close()
                            end
                        end
                    end
                end
            end
        end
    end
    -- #Chat Logging
    if (settings.mod["Chat Logging"].enabled) then
        local dir = settings.mod["Chat Logging"].dir
        local file = io.open(dir, "a+")
        if file ~= nil then
            local data = os.date("[%A %d %B %Y] - %X - The game is ending - ")
            file:write(data)
            file:close()
        end
    end
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) then
            local p_table = get_var(i, "$name") .. ", " .. get_var(i, "$hash")

            -- SAPP | Mute Handler
            if (settings.global.handlemutes == true) then
                if init_mute_timer[tonumber(i)] == true then

                    local hash = get_var(i, "$hash")
                    local ip = getPlayerInfo(i, "ip"):match("(%d+.%d+.%d+.%d+:%d+)")
                    local entry = ip .. ", " .. hash

                    mute_timer[entry].timer = mute_timer[entry].timer + 0.030

                    local minutes = secondsToTime(mute_timer[entry].timer, 4)
                    local mute_time = (mute_duration[tonumber(i)]) - floor(minutes)
                    time_diff[tonumber(i)] = mute_time

                    if (mute_time <= 0) then
                        time_diff[tonumber(i)] = 0
                        muted[tonumber(i)] = false
                        init_mute_timer[tonumber(i)] = false
                        removeEntry(ip, hash, i)
                        rprint(i, "Your mute time has expired.")
                    end
                end
            end

            -- #Message Board
            if (settings.mod["Message Board"].enabled) then
                if (welcome_timer[i] == true) then
                    players[p_table].message_board_timer = players[p_table].message_board_timer + 0.030
                    cls(i)
                    local message_board = settings.mod["Message Board"].messages
                    for k, _ in pairs(message_board) do
                        local StringFormat = (gsub(gsub(message_board[k], "%%server_name%%", getServerName()), "%%player_name%%", get_var(i, "$name")))
                        rprint(i, "|" .. settings.mod["Message Board"].alignment .. " " .. StringFormat)
                    end
                    if players[p_table].message_board_timer >= floor(settings.mod["Message Board"].duration) then
                        welcome_timer[i] = false
                        players[p_table].message_board_timer = 0
                    end
                end
            end

            -- #Portal Gun
            if (settings.mod["Portal Gun"].enabled) then
                if (player_present(i) and player_alive(i)) then
                    if (portalgun_mode[i] == true) then
                        local player_object = get_dynamic_player(i)
                        local playerX, playerY, playerZ = read_float(player_object + 0x230), read_float(player_object + 0x234), read_float(player_object + 0x238)
                        local shot_fired
                        local is_crouching
                        local couching = read_float(player_object + 0x50C)
                        local px, py, pz = read_vector3d(player_object + 0x5c)
                        if (couching == 0) then
                            pz = pz + 0.65
                            is_crouching = false
                        else
                            pz = pz + (0.35 * couching)
                            is_crouching = true
                        end
                        local ignore_player = read_dword(get_player(i) + 0x34)
                        local success, a, b, c, target = intersect(px, py, pz, playerX * 1000, playerY * 1000, playerZ * 1000, ignore_player)
                        if (success == true and target ~= nil) then
                            shot_fired = read_float(player_object + 0x490)
                            if (shot_fired ~= weapon_status[i] and shot_fired == 1 and is_crouching) then
                                execute_command("boost " .. i)
                            end
                            weapon_status[i] = shot_fired
                        end
                    end
                end
            end

            -- #Lurker
            if (settings.mod["Lurker"].enabled) then
                if (lurker[i] == true) then
                    if (settings.mod["Lurker"].speed == true) then
                        execute_command("s " .. tonumber(i) .. " " .. tonumber(settings.mod["Lurker"].running_speed))
                    end
                end
                if (lurker[i] == true) and (lurker_warn[i] == true) then

                    local id = get_var(i, "$name") .. ", " .. get_var(i, "$hash")
                    players[id].lurker_timer = players[id].lurker_timer + 0.030

                    if (getWarnings(i) <= 0) then
                        lurker_warn[i] = false
                        cls(i)
                        say(i, "Lurker mode was disabled!")
                        cls(i)
                        -- No warnings left: Turn off lurker and reset counters
                        setLurker(i, false)
                        write_dword(get_player(i) + 0x2C, 0 * 33)
                    end

                    cls(i)
                    local days, hours, minutes, seconds = secondsToTime(players[id].lurker_timer, 4)
                    rprint(i, "|cWarning! Drop the " .. object_picked_up[i])
                    rprint(i, "|cYou will be killed in " .. settings.mod["Lurker"].time_until_death - floor(seconds) .. " seconds")
                    rprint(i, "|c[ warnings left ] ")
                    rprint(i, "|c" .. lurker_warnings[i])
                    rprint(i, "|c ")
                    rprint(i, "|c ")
                    rprint(i, "|c ")

                    if (players[id].lurker_timer >= settings.mod["Lurker"].time_until_death) then
                        lurker_warn[i] = false
                        killSilently(i)
                        write_dword(get_player(i) + 0x2C, 0 * 33)
                        cls(i)
                        rprint(i, "|c=========================================================")
                        rprint(i, "|cYou were killed!")
                        rprint(i, "|c=========================================================")
                        rprint(i, "|c ")
                        rprint(i, "|c ")
                        rprint(i, "|c ")
                        rprint(i, "|c ")
                        object_picked_up[i] = ""
                    end
                end
            end

            -- #Infinity Ammo
            if (settings.mod["Infinity Ammo"].enabled and infammo[i]) then
                if (frag_check[i] == true) and getFrags(i) == true then
                    execute_command("nades " .. tonumber(i) .. " 7")
                end
            end

            -- #Enter Vehicle
            if (settings.mod["Enter Vehicle"].enabled) then
                if ev_Status[i] == true then
                    if not PlayerInVehicle(i) then
                        enter_vehicle(ev_NewVehicle[i], i, 0)
                        local old_vehicle = get_object_memory(ev_OldVehicle[i])
                        write_vector3d(old_vehicle + 0x5C, 0, 0, 0)
                        timer(500, "DestroyObject", ev_OldVehicle[i])
                        ev_Status[i] = false
                    end
                end
            end

            -- #Custom Weapons
            if (settings.mod["Custom Weapons"].enabled and settings.mod["Custom Weapons"].assign_weapons) then
                if settings.mod["Custom Weapons"].weapons[mapname] ~= nil then
                    if (player_alive(i)) then
                        if (weapon[i] == true) then
                            execute_command("wdel " .. i)
                            local player = get_dynamic_player(i)
                            local x, y, z = read_vector3d(player + 0x5C)
                            local primary, secondary, tertiary, quaternary, Slot = select(1, determineWeapon())

                            if (primary) then
                                assign_weapon(spawn_object("weap", primary, x, y, z), i)
                            end

                            if (secondary) then
                                assign_weapon(spawn_object("weap", secondary, x, y, z), i)
                            end

                            if (Slot == 3 or Slot == 4) then
                                timer(100, "delayAssignMore", player, x, y, z)
                            end

                            --noinspection GlobalCreationOutsideO
                            function delayAssignMore(player, x, y, z)
                                if (tertiary) then
                                    assign_weapon(spawn_object("weap", tertiary, x, y, z), i)
                                end

                                if (quaternary) then
                                    assign_weapon(spawn_object("weap", quaternary, x, y, z), i)
                                end
                            end
                        end
                        weapon[i] = false
                    end
                end
            end

            -- #Alias System
            -- To Do: Organize aliases into 'pages' (n results per page)
            if (settings.mod["Alias System"].enabled) then
                if (trigger[i] == true) then
                    players[p_table].alias_timer = players[p_table].alias_timer + 0.030
                    cls(i)
                    concatAliases(i, 1, 6)
                    concatAliases(i, 7, 12)
                    concatAliases(i, 13, 18)
                    concatAliases(i, 19, 24)
                    concatAliases(i, 25, 30)
                    concatAliases(i, 31, 36)
                    concatAliases(i, 37, 42)
                    concatAliases(i, 43, 48)
                    concatAliases(i, 49, 55)
                    concatAliases(i, 56, 61)
                    concatAliases(i, 62, 67)
                    concatAliases(i, 68, 73)
                    concatAliases(i, 74, 79)
                    concatAliases(i, 80, 85)
                    concatAliases(i, 86, 91)
                    concatAliases(i, 92, 97)
                    concatAliases(i, 98, 100)
                    if (alias_bool[i] == true) then
                        local alignment = settings.mod["Alias System"].alignment
                        rprint(i, "|" .. alignment .. " " .. 'Showing aliases for: "' .. target_hash .. '"')
                    end
                    local duration = settings.mod["Alias System"].duration
                    if players[p_table].alias_timer >= floor(duration) then
                        trigger[i] = false
                        alias_bool[i] = false
                        players[p_table].alias_timer = 0
                    end
                end
            end
            -- #Spawn From Sky
            if (settings.mod["Spawn From Sky"].enabled) then
                if (init_timer[i] == true) then
                    timeUntilRestore(i)
                end
            end
        end
    end
end

function determineWeapon()
    local primary, secondary, tertiary, quaternary, Slot
    for i = 1, 4 do
        local weapon = settings.mod["Custom Weapons"].weapons[mapname][i]
        if (weapon ~= nil) then
            if (i == 1 and settings.mod["Custom Weapons"].weapons[mapname][1] ~= nil) then
                primary = settings.mod["Custom Weapons"].weapons[mapname][1]
                Slot = 1
            end
            if (i == 2 and settings.mod["Custom Weapons"].weapons[mapname][2] ~= nil) then
                secondary = settings.mod["Custom Weapons"].weapons[mapname][2]
                Slot = 2
            end
            if (i == 3 and settings.mod["Custom Weapons"].weapons[mapname][3] ~= nil) then
                tertiary = settings.mod["Custom Weapons"].weapons[mapname][3]
                Slot = 3
            end
            if (i == 4 and settings.mod["Custom Weapons"].weapons[mapname][4] ~= nil) then
                quaternary = settings.mod["Custom Weapons"].weapons[mapname][4]
                Slot = 4
            end
        end
    end
    return primary, secondary, tertiary, quaternary, Slot
end

function OnPlayerPrejoin(PlayerIndex)
    if (settings.global.beepOnJoin == true) then
        os.execute("echo \7")
    end
    player_info[PlayerIndex] = {}
    cprint("________________________________________________________________________________", 2 + 8)
    cprint("Player attempting to connect to the server...", 5 + 8)
    -- #CONSOLE OUTPUT
    local ns = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    local cns = ns + 0x1AA + ce + to_real_index(PlayerIndex) * 0x20
    local name, hash = read_widestring(cns, 12), get_var(PlayerIndex, "$hash")
    local ip, id, level = get_var(PlayerIndex, "$ip"), get_var(PlayerIndex, "$n"), tonumber(get_var(PlayerIndex, "$lvl"))

    -- Matching and replacing in case the OP decides to reorder the player_data table
    local a, b, c, d, e
    local tab = settings.global.player_data
    for i = 1, #tab do
        if tab[i]:match("%%name%%") then
            a = gsub(tab[i], "%%name%%", name)
        elseif tab[i]:match("%%hash%%") then
            b = gsub(tab[i], "%%hash%%", hash)
        elseif tab[i]:match("%%index_id%%") then
            d = gsub(tab[i], "%%index_id%%", id)
        elseif tab[i]:match("%%ip_address%%") then
            c = gsub(tab[i], "%%ip_address%%", ip)
        elseif tab[i]:match("%%level%%") then
            e = gsub(tab[i], "%%level%%", level)
        end
    end
    table.insert(player_info[PlayerIndex], { ["name"] = a, ["hash"] = b, ["ip"] = c, ["id"] = d, ["level"] = e })

    cprint(getPlayerInfo(PlayerIndex, "name"), 2 + 8)
    cprint(getPlayerInfo(PlayerIndex, "hash"), 2 + 8)
    cprint(getPlayerInfo(PlayerIndex, "ip"), 2 + 8)
    cprint(getPlayerInfo(PlayerIndex, "id"), 2 + 8)
    cprint(getPlayerInfo(PlayerIndex, "level"), 2 + 8)
end

function OnPlayerJoin(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local id = get_var(PlayerIndex, "$n")
    local ip = getPlayerInfo(PlayerIndex, "ip"):match("(%d+.%d+.%d+.%d+:%d+)")

    -- #CONSOLE OUTPUT
    if player_info[PlayerIndex] ~= nil or player_info[PlayerIndex] ~= {} then
        cprint("Join Time: " .. os.date("%A %d %B %Y - %X"), 2 + 8)
        cprint("Status: " .. name .. " connected successfully.", 5 + 8)
        cprint("________________________________________________________________________________", 2 + 8)
    end

    if (settings.global.check_for_updates) then
        if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel(nil, nil, "senior_admin") then
            if (getCurrentVersion(false) ~= settings.global.script_version) then
                rprint(PlayerIndex, "============================================================================")
                rprint(PlayerIndex, "[BGS] Version " .. getCurrentVersion(false) .. " is available for download.")
                rprint(PlayerIndex, "Current version: v" .. settings.global.script_version)
                rprint(PlayerIndex, "============================================================================")
            end
        end
    end

    -- SAPP | Mute Handler
    if (settings.global.handlemutes == false) then
        muted[tonumber(PlayerIndex)] = false or nil
    end

    if (settings.global.handlemutes == true) then
        local file_name = settings.global.mute_dir
        if checkFile(file_name) then
            local stringToMatch = ip .. ", " .. hash
            local lines = lines_from(file_name)
            for _, v in pairs(lines) do
                if v:match(stringToMatch) then
                    local timeFound = match(v, (";(.+)"))
                    local words = tokenizestring(timeFound, ", ")
                    mute_duration[tonumber(PlayerIndex)] = tonumber(words[1])
                    muted[tonumber(PlayerIndex)] = true
                    if (mute_duration[tonumber(PlayerIndex)] == settings.global.default_mute_time) then
                        rprint(PlayerIndex, "You are muted permanently.")
                    else
                        init_mute_timer[tonumber(PlayerIndex)] = true
                        rprint(PlayerIndex, "You were muted! Time remaining: " .. mute_duration[tonumber(PlayerIndex)] .. " minute(s)")
                    end
                else
                    mute_duration[tonumber(PlayerIndex)] = 0
                    muted[tonumber(PlayerIndex)] = false
                    init_mute_timer[tonumber(PlayerIndex)] = false
                end
            end
        end
    end

    -- #Color Reservation | WIP
    if (settings.mod["Color Reservation"].enabled) then
        if (can_use_colorres == true) then
            local ColorTable = settings.mod["Color Reservation"].color_table
            local player = getPlayer(PlayerIndex)
            local ran = math.random
            for k, _ in ipairs(ColorTable) do
                for i = 1, #ColorTable do
                    if ColorTable[k][i] ~= nil then
                        if find(ColorTable[k][i], hash) then
                            k = k - 1
                            write_byte(player + 0x60, tonumber(k))
                            colorres_bool[PlayerIndex] = true
                        else
                            -- Get all indices that contain valid hashes
                            if (ColorTable[k][i] ~= "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx") then
                                if (read_byte(getPlayer(PlayerIndex) + 0x60) == k) then
                                    local function selectRandomColor(exclude)
                                        math.randomseed(os.time())
                                        local num = ran(1, 18)
                                        if num == tonumber(exclude) then
                                            selectRandomColor(12)
                                        else
                                            return num
                                        end
                                    end
                                    write_byte(player + 0x60, tonumber(selectRandomColor(k)))
                                    colorres_bool[PlayerIndex] = true
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- Used Globally
    local p_table = name .. ", " .. hash
    players[p_table] = {}

    local entry = ip .. ", " .. hash
    mute_timer[entry] = {}
    mute_timer[entry].timer = 0

    -- #Spawn From Sky
    if (settings.mod["Spawn From Sky"].enabled) then
        players[p_table].sky_timer = 0
        init_timer[PlayerIndex] = true
        first_join[PlayerIndex] = true
    end

    -- #Lurker
    if (settings.mod["Lurker"].enabled) then
        lurker[PlayerIndex] = false
        has_objective[PlayerIndex] = false
        resetLurker(PlayerIndex)
        lurker_warnings[PlayerIndex] = settings.mod["Lurker"].warnings
    end

    -- #Infinity Ammo
    if (settings.mod["Infinity Ammo"].enabled) then
        damage_multiplier[PlayerIndex] = 0
        if not settings.mod["Infinity Ammo"].server_override then
            infammo[PlayerIndex] = false
            modify_damage[PlayerIndex] = false
            damage_multiplier[PlayerIndex] = 0
        else
            infammo[PlayerIndex] = true
        end
    end

    -- #Message Board
    if (settings.mod["Message Board"].enabled) then
        players[p_table].message_board_timer = 0
        welcome_timer[PlayerIndex] = true
    end

    -- #Alias System
    if (settings.mod["Alias System"].enabled) then
        addAlias(name, hash)
        players[p_table].alias_timer = 0
        welcome_timer[PlayerIndex] = true
    end

    -- #Enter Vehicle
    if (settings.mod["Enter Vehicle"].enabled) then
        ev[PlayerIndex] = false
        ev_Status[PlayerIndex] = false
        EV_drone_table[PlayerIndex] = nil
    end

    -- #Item Spawner
    if (settings.mod["Item Spawner"].enabled) then
        IS_drone_table[PlayerIndex] = nil
    end

    -- #Anti Impersonator
    if (settings.mod["Anti Impersonator"].enabled) then
        local tab = settings.mod["Anti Impersonator"].users
        local found
        for key, _ in ipairs(tab) do
            local userdata = tab[key][name]
            if (userdata ~= nil) then
                for i = 1,#userdata do
                    if string.find(userdata[i], hash) then
                        found = true
                        break
                    end
                end
                if not (found) then
                    local action = settings.mod["Anti Impersonator"].action
                    local reason = settings.mod["Anti Impersonator"].reason
                    if (action == "kick") then
                        execute_command("k" .. " " .. id .. " \"" .. reason .. "\"")
                        cprint(name .. " was kicked for " .. reason, 4 + 8)
                    elseif (action == "ban") then
                        local bantime = settings.mod["Anti Impersonator"].bantime
                        execute_command("b" .. " " .. id .. " " .. bantime .. " \"" .. reason .. "\"")
                        cprint(name .. " was banned for " .. bantime .. " minutes for " .. reason, 4 + 8)
                    end
                    break
                end
            end
        end
    end

    -- #Chat Logging
    if (settings.mod["Chat Logging"].enabled) then
        local dir = settings.mod["Chat Logging"].dir
        local file = io.open(dir, "a+")
        if file ~= nil then
            local timestamp = os.date("[%d/%m/%Y - %H:%M:%S]")
            file:write(timestamp .. "    [JOIN]    Name: " .. name .. "    ID: [" .. id .. "]    IP: [" .. ip .. "]    CD-Key Hash: [" .. hash .. "]\n")
            file:close()
        end
    end

    -- #Admin Chat
    if (settings.mod["Admin Chat"].enabled) then
        players[p_table].adminchat = nil
        players[p_table].boolean = nil
        if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Admin Chat", nil, nil) then
            if (settings.mod["Admin Chat"].restore_previous_state == true) then
                local t = tokenizestring(tostring(data[PlayerIndex]), ":")
                if (t[2] ~= nil) then
                    if (t[2] == "true") then
                        rprint(PlayerIndex, "[reminder] Your admin chat is on!")
                        players[p_table].adminchat = true
                        players[p_table].boolean = true
                    else
                        players[p_table].adminchat = false
                        players[p_table].boolean = false
                    end
                end
            else
                players[p_table].adminchat = false
                players[p_table].boolean = false
            end
        end
    end

    -- #Admin Join Messages
    if (settings.mod["Admin Join Messages"].enabled) then
        local level = tonumber(get_var(PlayerIndex, "$lvl"))
        local join_message
        if (level >= 1) then
            local prefix = settings.mod["Admin Join Messages"].messages[level][1]
            local suffix = settings.mod["Admin Join Messages"].messages[level][2]
            join_message = prefix .. name .. suffix
            local function announceJoin(join_message)
                for i = 1, 16 do
                    if player_present(i) then
                        rprint(i, join_message)
                    end
                end
            end

            announceJoin(join_message)
        end
    end
end

function OnPlayerLeave(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local id = get_var(PlayerIndex, "$n")
    local ip = getPlayerInfo(PlayerIndex, "ip"):match("(%d+.%d+.%d+.%d+:%d+)")
    local level = getPlayerInfo(PlayerIndex, "level"):match("%d+")

    -- #CONSOLE OUTPUT
    cprint("________________________________________________________________________________", 4 + 8)
    if player_info[PlayerIndex] ~= nil or player_info[PlayerIndex] ~= {} then
        cprint(getPlayerInfo(PlayerIndex, "name"), 4 + 8)
        cprint(getPlayerInfo(PlayerIndex, "hash"), 4 + 8)
        cprint(getPlayerInfo(PlayerIndex, "ip"), 4 + 8)
        cprint(getPlayerInfo(PlayerIndex, "id"), 4 + 8)
        cprint(getPlayerInfo(PlayerIndex, "level"), 4 + 8)
        player_info[PlayerIndex] = nil
    end
    cprint("________________________________________________________________________________", 4 + 8)

    -- Used Globally
    local p_table = name .. ", " .. hash

    -- #Spawn From Sky
    if (settings.mod["Spawn From Sky"].enabled) then
        if init_timer == true then
            init_timer[PlayerIndex] = false
        end
        if first_join == true then
            first_join[PlayerIndex] = false
        end
        players[p_table].sky_timer = 0
    end

    -- SAPP | Mute Handler
    if (settings.global.handlemutes == true) then
        if (muted[tonumber(PlayerIndex)] == true) then
            muted[tonumber(PlayerIndex)] = false
            local file_name = settings.global.mute_dir
            checkFile(file_name)
            local file = io.open(file_name, "r")
            file:close()
            local lines = lines_from(file_name)
            for k, v in pairs(lines) do
                if k ~= nil then
                    if v:match(ip) and v:match(hash) then
                        local updated_entry = ip .. ", " .. hash .. ", " .. name .. ", ;" .. time_diff[tonumber(PlayerIndex)]
                        local f1 = io.open(file_name, "r")
                        local content = f1:read("*all")
                        f1:close()
                        content = gsub(content, v, updated_entry)
                        local f2 = io.open(file_name, "w")
                        f2:write(content)
                        f2:close()
                    end
                end
            end
        end
    end

    -- #Lurker
    if (settings.mod["Lurker"].enabled) then
        has_objective[PlayerIndex] = false
        lurker[PlayerIndex] = false
        resetLurker(PlayerIndex)
    end

    -- #Infinity Ammo
    if (settings.mod["Infinity Ammo"].enabled and infammo[PlayerIndex]) then
        DisableInfAmmo(PlayerIndex)
    end

    -- #Alias System
    if (settings.mod["Alias System"].enabled) then
        alias_bool[PlayerIndex] = false
        trigger[PlayerIndex] = false
        players[p_table].alias_timer = 0
    end

    -- #Message Board
    if (settings.mod["Message Board"].enabled) then
        welcome_timer[PlayerIndex] = false
        players[p_table].message_board_timer = 0
    end

    -- #Enter Vehicle & Item Spawner
    if (settings.mod["Enter Vehicle"].enabled) or (settings.mod["Item Spawner"].enabled) then
        if (settings.mod["Enter Vehicle"].garbage_collection.on_disconnect) then
            if ev_NewVehicle[PlayerIndex] ~= nil then
                ev[PlayerIndex] = false
                ev_Status[PlayerIndex] = false
            end
            CleanUpDrones(PlayerIndex, 1)
        end
        if (settings.mod["Item Spawner"].garbage_collection.on_disconnect) then
            CleanUpDrones(PlayerIndex, 2)
        end
    end

    -- #Chat Logging
    if (settings.mod["Chat Logging"].enabled) then
        local dir = settings.mod["Chat Logging"].dir
        local file = io.open(dir, "a+")
        if file ~= nil then
            local timestamp = os.date("[%d/%m/%Y - %H:%M:%S]")
            file:write(timestamp .. "    [QUIT]    Name: " .. name .. "    ID: [" .. id .. "]    IP: [" .. ip .. "]    CD-Key Hash: [" .. hash .. "]\n")
            file:close()
        end
    end

    -- #Admin Chat
    if (settings.mod["Admin Chat"].enabled) then
        if (tonumber(level) >= getPermLevel("Admin Chat", nil, nil)) then
            if (settings.mod["Admin Chat"].restore_previous_state) then
                local bool
                if players[p_table].adminchat == true then
                    bool = "true"
                else
                    bool = "false"
                end
                data[PlayerIndex] = get_var(PlayerIndex, "$name") .. ":" .. bool
                stored_data[data] = stored_data[data] or {}
                table.insert(stored_data[data], tostring(data[PlayerIndex]))
            else
                players[p_table].adminchat = false
                players[p_table].boolean = false
            end
        end
    end

    -- #Teleport Manager
    if (settings.mod["Teleport Manager"].enabled) then
        wait_for_response[PlayerIndex] = false
        for i = 1, 3 do
            previous_location[PlayerIndex][i] = nil
        end
    end
end

function OnPlayerPrespawn(PlayerIndex)
    -- #Spawn From Sky
    if (settings.mod["Spawn From Sky"].enabled) then
        if (first_join[PlayerIndex] == true) then
            first_join[PlayerIndex] = false
            local team = get_var(PlayerIndex, "$team")
            local function Teleport(PlayerIndex, id)
                local height = settings.mod["Spawn From Sky"].maps[mapname].height
                write_vector3d(get_dynamic_player(PlayerIndex) + 0x5C,
                        settings.mod["Spawn From Sky"].maps[mapname][id][1],
                        settings.mod["Spawn From Sky"].maps[mapname][id][2],
                        settings.mod["Spawn From Sky"].maps[mapname][id][3] + floor(height))
                execute_command("god " .. tonumber(PlayerIndex))
            end

            if (team == "red") then
                Teleport(PlayerIndex, 1)
            elseif (team == "blue") then
                Teleport(PlayerIndex, 2)
            end
        end
    end
end

function OnPlayerSpawn(PlayerIndex)
    -- #Custom Weapons
    if (settings.mod["Custom Weapons"].enabled) then
        weapon[PlayerIndex] = true
        if player_alive(PlayerIndex) then
            local player_object = get_dynamic_player(PlayerIndex)
            if (player_object ~= 0) then
                if (settings.mod["Custom Weapons"].assign_custom_frags == true) then
                    local frags = settings.mod["Custom Weapons"].weapons[mapname][5]
                    write_word(player_object + 0x31E, tonumber(frags))
                end
                if (settings.mod["Custom Weapons"].assign_custom_plasmas == true) then
                    local plasmas = settings.mod["Custom Weapons"].weapons[mapname][6]
                    write_word(player_object + 0x31F, tonumber(plasmas))
                end
            end
        end
    end

    -- #Color Reservation | WIP
    if (settings.mod["Color Reservation"].enabled) then
        if (can_use_colorres == true) then
            if (colorres_bool[PlayerIndex]) then
                colorres_bool[PlayerIndex] = false
                local player_object = read_dword(get_player(PlayerIndex) + 0x34)
                DestroyObject(player_object)
            end
        end
    end

    -- #Portal Gun
    if (settings.mod["Portal Gun"].enabled) then
        weapon_status[PlayerIndex] = 0
    end

    -- #Lurker
    if (settings.mod["Lurker"].enabled) then
        if (lurker[PlayerIndex] == true) then
            has_objective[PlayerIndex] = false
            resetLurker(PlayerIndex)
            setLurker(PlayerIndex, true)
        end
    end

    -- #Infinity Ammo
    if (settings.mod["Infinity Ammo"].enabled and infammo[PlayerIndex]) then
        frag_check[PlayerIndex] = true
        adjust_ammo(PlayerIndex)
    end
end

function OnPlayerKill(PlayerIndex)

    -- #Enter Vehicle & Item Spawner
    if (settings.mod["Enter Vehicle"].enabled) or (settings.mod["Item Spawner"].enabled) then
        if (settings.mod["Enter Vehicle"].garbage_collection.on_death) then
            CleanUpDrones(PlayerIndex, 1)
        end
        if (settings.mod["Item Spawner"].garbage_collection.on_death) then
            CleanUpDrones(PlayerIndex, 2)
        end
    end

    -- #Respawn Time
    if (settings.mod["Respawn Time"].enabled) then
        local function getSpawnTime()
            local spawntime
            if (get_var(1, "$gt") == "ctf") then
                spawntime = settings.mod["Respawn Time"].maps[mapname][1]
            elseif (get_var(1, "$gt") == "slayer") then
                if not getTeamPlay() then
                    spawntime = settings.mod["Respawn Time"].maps[mapname][2]
                else
                    spawntime = settings.mod["Respawn Time"].maps[mapname][3]
                end
            elseif (get_var(1, "$gt") == "koth") then
                if not getTeamPlay() then
                    spawntime = settings.mod["Respawn Time"].maps[mapname][4]
                else
                    spawntime = settings.mod["Respawn Time"].maps[mapname][5]
                end
            elseif (get_var(1, "$gt") == "oddball") then
                if not getTeamPlay() then
                    spawntime = settings.mod["Respawn Time"].maps[mapname][6]
                else
                    spawntime = settings.mod["Respawn Time"].maps[mapname][7]
                end
            elseif (get_var(1, "$gt") == "race") then
                if not getTeamPlay() then
                    spawntime = settings.mod["Respawn Time"].maps[mapname][8]
                else
                    spawntime = settings.mod["Respawn Time"].maps[mapname][9]
                end
            end
            return spawntime
        end
        if settings.mod["Respawn Time"].maps[mapname] ~= nil then
            local player = get_player(PlayerIndex)
            write_dword(player + 0x2C, tonumber(getSpawnTime()) * 33)
        end
    end
    -- #Lurker
    if (settings.mod["Lurker"].enabled == true) then
        has_objective[PlayerIndex] = false
        resetLurker(PlayerIndex)
    end
    -- #Infinity Ammo
    if (settings.mod["Infinity Ammo"].enabled and infammo[PlayerIndex]) then
        frag_check[PlayerIndex] = false
    end
end

function OnPlayerChat(PlayerIndex, Message, type)

    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local id = get_var(PlayerIndex, "$n")
    local response

    -- Used Globally
    local p_table = name .. ", " .. hash
    local privilege_level = tonumber(get_var(PlayerIndex, "$lvl"))

    -- Used throughout OnPlayerChat()
    local message = tokenizestring(Message)
    if (#message == 0) then
        return nil
    end

    -- #Chat IDs & Admin Chat
    local keyword
    if (settings.mod["Chat IDs"].enabled) or (settings.mod["Admin Chat"].enabled) then
        local keywords_to_ignore = settings.mod["Chat IDs"].ignore_list
        if (table.match(keywords_to_ignore, message[1])) then
            keyword = true
        else
            keyword = false
        end
    end

    -- #Command Spy & Chat Logging
    local command
    local iscommand
    local cmd_prefix
    if (settings.mod["Command Spy"].enabled) or (settings.mod["Chat Logging"].enabled) then
        local content = tokenizestring(Message)
        if (#content == 0) then
            return nil
        end
        if sub(content[1], 1, 1) == "/" or sub(content[1], 1, 1) == "\\" then
            command = content[1]:gsub("\\", "/")
            iscommand = true
            cmd_prefix = "[COMMAND] "
        else
            iscommand = false
        end
    end

    -- #Command Spy
    if (settings.mod["Command Spy"].enabled) then
        local hidden_messages = settings.mod["Command Spy"].commands_to_hide
        local hidden
        for k, _ in pairs(hidden_messages) do
            if (command == k) then
                hidden = true
            end
            break
        end
        if (tonumber(get_var(PlayerIndex, "$lvl")) == -1) and (iscommand) then
            local hide_commands = settings.mod["Command Spy"].hide_commands
            if (hide_commands and hidden) then
                response = false
            elseif (hide_commands and not hidden) or (hide_commands == false) then
                CommandSpy(settings.mod["Command Spy"].prefix .. " " .. name .. ":    \"" .. Message .. "\"")
                response = true
            end
        end
    end

    -- #Chat Logging
    if (settings.mod["Chat Logging"].enabled) then
        local chat_type

        if type == 0 then
            chat_type = "[GLOBAL]  "
        elseif type == 1 then
            chat_type = "[TEAM]    "
        elseif type == 2 then
            chat_type = "[VEHICLE] "
        end

        if (player_present(PlayerIndex) ~= nil) then
            local dir = settings.mod["Chat Logging"].dir
            local function LogChat(dir, value)
                local timestamp = os.date("[%d/%m/%Y - %H:%M:%S]")
                local file = io.open(dir, "a+")
                if file ~= nil then
                    local chatValue = string.format("%s\t%s\n", timestamp, tostring(value))
                    file:write(chatValue)
                    file:close()
                end
            end

            if iscommand then
                LogChat(dir, "   " .. cmd_prefix .. "     " .. name .. " [" .. id .. "]: " .. Message)
                cprint(cmd_prefix .. " " .. name .. " [" .. id .. "]: " .. Message, 3 + 8)
            else
                LogChat(dir, "   " .. chat_type .. "     " .. name .. " [" .. id .. "]: " .. Message)
                cprint(chat_type .. " " .. name .. " [" .. id .. "]: " .. Message, 3 + 8)
            end
        end
    end

    -- SAPP | Mute Handler
    if (settings.global.handlemutes == true) then
        if (muted[tonumber(PlayerIndex)] == true) then
            if (mute_duration[tonumber(PlayerIndex)] == settings.global.default_mute_time) then
                rprint(PlayerIndex, "You are muted permanently.")
            else
                rprint(PlayerIndex, "You are muted! Time remaining: " .. mute_duration[tonumber(PlayerIndex)] .. " minute(s)")
            end
            return false
        end
    end

    -- #Chat IDs
    if (settings.mod["Chat IDs"].enabled) then
        if not (game_over) and not (muted[tonumber(PlayerIndex)]) then

            -- GLOBAL FORMAT
            local GlobalDefault = settings.mod["Chat IDs"].global_format[1]
            local Global_TModFormat = settings.mod["Chat IDs"].trial_moderator[1]
            local Global_ModFormat = settings.mod["Chat IDs"].moderator[1]
            local Global_AdminFormat = settings.mod["Chat IDs"].admin[1]
            local Global_SAdminFormat = settings.mod["Chat IDs"].senior_admin[1]

            --TEAM FORMAT
            local TeamDefault = settings.mod["Chat IDs"].team_format[1]
            local Team_TModFormat = settings.mod["Chat IDs"].trial_moderator[2]
            local Team_ModFormat = settings.mod["Chat IDs"].moderator[2]
            local Team_AdminFormat = settings.mod["Chat IDs"].admin[2]
            local Team_SAdminFormat = settings.mod["Chat IDs"].senior_admin[2]

            if not (keyword) or (keyword == nil) then
                local function ChatHandler(PlayerIndex, Message)
                    local function SendToTeam(Message, PlayerIndex, Global, Tmod, Mod, Admin, sAdmin)
                        for i = 1, 16 do
                            if player_present(i) and (get_var(i, "$team") == get_var(PlayerIndex, "$team")) then
                                local formattedString = ""
                                execute_command("msg_prefix \"\"")
                                if (Global == true) then
                                    formattedString = (gsub(gsub(gsub(TeamDefault, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                                elseif (Tmod == true) then
                                    formattedString = (gsub(gsub(gsub(Team_TModFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                                elseif (Mod == true) then
                                    formattedString = (gsub(gsub(gsub(Team_ModFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                                elseif (Admin == true) then
                                    formattedString = (gsub(gsub(gsub(Team_AdminFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                                elseif (sAdmin == true) then
                                    formattedString = (gsub(gsub(gsub(Team_SAdminFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                                end
                                say(i, formattedString)
                                execute_command("msg_prefix \" " .. settings.global.server_prefix .. "\"")
                                response = false
                            end
                        end
                    end

                    local function SendToAll(Message, Global, Tmod, Mod, Admin, sAdmin)
                        local formattedString = ""
                        execute_command("msg_prefix \"\"")
                        if (Global == true) then
                            formattedString = (gsub(gsub(gsub(GlobalDefault, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                        elseif (Tmod == true) then
                            formattedString = (gsub(gsub(gsub(Global_TModFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                        elseif (Mod == true) then
                            formattedString = (gsub(gsub(gsub(Global_ModFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                        elseif (Admin == true) then
                            formattedString = (gsub(gsub(gsub(Global_AdminFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                        elseif (sAdmin == true) then
                            formattedString = (gsub(gsub(gsub(Global_SAdminFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                        end
                        say_all(formattedString)
                        execute_command("msg_prefix \" " .. settings.global.server_prefix .. "\"")
                        response = false
                    end

                    for b = 0, #message do
                        if message[b] then
                            if not (sub(message[1], 1, 1) == "/" or sub(message[1], 1, 1) == "\\") then
                                if (getTeamPlay()) then
                                    if (type == 0 or type == 2) then
                                        if (settings.mod["Chat IDs"].use_admin_prefixes == true) then
                                            if (privilege_level) == getPermLevel(nil, nil, "trial_moderator") then
                                                SendToAll(Message, nil, true, nil, nil, nil)
                                            elseif (privilege_level) == getPermLevel(nil, nil, "moderator") then
                                                SendToAll(Message, nil, nil, true, nil, nil)
                                            elseif (privilege_level) == getPermLevel(nil, nil, "admin") then
                                                SendToAll(Message, nil, nil, nil, true, nil)
                                            elseif (privilege_level) == getPermLevel(nil, nil, "senior_admin") then
                                                SendToAll(Message, nil, nil, nil, nil, true)
                                            else
                                                SendToAll(Message, true, nil, nil, nil, nil)
                                            end
                                        else
                                            SendToAll(Message, true, nil, nil, nil, nil)
                                        end
                                    elseif (type == 1) then
                                        if (settings.mod["Chat IDs"].use_admin_prefixes == true) then
                                            if (privilege_level) == getPermLevel(nil, nil, "trial_moderator") then
                                                SendToTeam(Message, PlayerIndex, nil, true, nil, nil, nil)
                                            elseif (privilege_level) == getPermLevel(nil, nil, "moderator") then
                                                SendToTeam(Message, PlayerIndex, nil, nil, true, nil, nil)
                                            elseif (privilege_level) == getPermLevel(nil, nil, "admin") then
                                                SendToTeam(Message, PlayerIndex, nil, nil, nil, true, nil)
                                            elseif (privilege_level) == getPermLevel(nil, nil, "senior_admin") then
                                                SendToTeam(Message, PlayerIndex, nil, nil, nil, nil, true)
                                            else
                                                SendToTeam(Message, PlayerIndex, true, nil, nil, nil, nil)
                                            end
                                        else
                                            SendToTeam(Message, PlayerIndex, true, nil, nil, nil, nil)
                                        end
                                    end
                                else
                                    if (settings.mod["Chat IDs"].use_admin_prefixes == true) then
                                        if (privilege_level) == getPermLevel(nil, nil, "trial_moderator") then
                                            SendToAll(Message, nil, true, nil, nil, nil)
                                        elseif (privilege_level) == getPermLevel(nil, nil, "moderator") then
                                            SendToAll(Message, nil, nil, true, nil, nil)
                                        elseif (privilege_level) == getPermLevel(nil, nil, "admin") then
                                            SendToAll(Message, nil, nil, nil, true, nil)
                                        elseif (privilege_level) == getPermLevel(nil, nil, "senior_admin") then
                                            SendToAll(Message, nil, nil, nil, nil, true)
                                        else
                                            SendToAll(Message, true, nil, nil, nil, nil)
                                        end
                                    else
                                        SendToAll(Message, true, nil, nil, nil, nil)
                                    end
                                end
                            else
                                response = true
                            end
                            break
                        end
                    end
                end

                if (settings.mod["Admin Chat"].enabled) then
                    if (players[p_table].adminchat ~= true) then
                        ChatHandler(PlayerIndex, Message)
                    end
                else
                    ChatHandler(PlayerIndex, Message)
                end
            end
        end
    end

    -- #Admin Chat
    if (settings.mod["Admin Chat"].enabled) then
        local function AdminChat(Message)
            for i = 1, 16 do
                if player_present(i) and tonumber(get_var(i, "$lvl")) >= getPermLevel("Admin Chat", nil, nil) then
                    if (settings.mod["Admin Chat"].environment == "rcon") then
                        rprint(i, "|l" .. Message)
                    elseif (settings.mod["Admin Chat"].environment == "chat") then
                        execute_command("msg_prefix \"\"")
                        say(i, Message)
                        execute_command("msg_prefix \" *  * SERVER *  * \"")
                    end
                end
            end
        end

        if players[p_table].adminchat == true then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Admin Chat", nil, nil) then
                for c = 0, #message do
                    if message[c] then
                        if not (keyword) or (keyword == nil) then
                            if sub(message[1], 1, 1) == "/" or sub(message[1], 1, 1) == "\\" then
                                response = true
                            else
                                local AdminMessageFormat = settings.mod["Admin Chat"].message_format[1]
                                local prefix = settings.mod["Admin Chat"].prefix
                                local Format = (gsub(gsub(gsub(gsub(AdminMessageFormat,
                                        "%%prefix%%", prefix), "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                                AdminChat(Format)
                                response = false
                            end
                        end
                        break
                    end
                end
            end
        end
    end

    -- #Teleport Manager
    if (settings.mod["Teleport Manager"].enabled) then
        if wait_for_response[PlayerIndex] then
            if Message == ("yes") then
                local file_name = settings.mod["Teleport Manager"].dir
                local warp_num = tonumber(getWarp())
                delete_from_file(file_name, warp_num, 1, PlayerIndex)
                rprint(PlayerIndex, "Successfully deleted teleport id #" .. warp_num)
                wait_for_response[PlayerIndex] = false
            elseif Message == ("no") then
                rprint(PlayerIndex, "Process Cancelled")
                wait_for_response[PlayerIndex] = false
            end
            if Message ~= "yes" or Message ~= "no" then
                rprint(PlayerIndex, "That is not a valid response, please try again. Type yes|no")
            end
            response = false
        end
    end
    return response
end

-- SAPP | Saves mute entry to txt file
function saveMuteEntry(PlayerIndex, offender_ip, offender_id, offender_hash, mute_time)
    local file_name = settings.global.mute_dir
    if checkFile(file_name) then
        local file = io.open(file_name, "r")
        local content = file:read("*a")
        file:close()
        local offender_name = get_var(offender_id, "$name")

        if not (match(content, offender_ip)
                and match(content, offender_id)
                and match(content, offender_hash)) then

            if (tonumber(mute_time) ~= settings.global.default_mute_time) then
                rprint(PlayerIndex, offender_name .. " has been muted for " .. mute_time .. " minute(s)")
                rprint(offender_id, "You have been muted for " .. mute_time .. " minute(s)")
            else
                rprint(PlayerIndex, offender_name .. " has been muted permanently")
                rprint(offender_id, "You were muted permanently")
            end

            local new_entry = offender_ip .. ", " .. offender_hash .. ", " .. offender_name .. ", ;" .. mute_time
            local file = assert(io.open(file_name, "a+"))
            file:write(new_entry .. "\n")
            file:close()
        else
            rprint(PlayerIndex, offender_name .. " is already muted!")
        end
    end
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)

    -- Used Globally
    local t = tokenizestring(Command)
    if t[1] == nil then
        return nil
    end
    local command = t[1]:gsub("\\", "/")
    local privilege_level = tonumber(get_var(PlayerIndex, "$lvl"))

    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local p_table = name .. ", " .. hash

    if (settings.global.check_for_updates) then
        if (lower(Command) == "bgs") then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel(nil, nil, "senior_admin") then
                if (getCurrentVersion(false) ~= settings.global.script_version) then
                    rprint(PlayerIndex, "============================================================================")
                    rprint(PlayerIndex, "[BGS] Version " .. getCurrentVersion(false) .. " is available for download.")
                    rprint(PlayerIndex, "Current version: v" .. settings.global.script_version)
                    rprint(PlayerIndex, "============================================================================")
                else
                    rprint(PlayerIndex, "BGS Version " .. settings.global.script_version)
                end
            else
                rprint(PlayerIndex, "Insufficient Permission")
            end
            return false
        end
    end

    -- #Clear Chat
    if (command == settings.global.plugin_commands.clearchat) then
        if (privilege_level) >= getPermLevel(nil, nil, "trial_moderator") then
            for _ = 1, 20 do
                execute_command("msg_prefix \"\"")
                say_all(" ")
                execute_command("msg_prefix \" " .. settings.global.server_prefix .. "\"")
            end
            rprint(PlayerIndex, "Chat was cleared!")
        else
            rprint(PlayerIndex, "Insufficient Permission")
        end
        return false
    end

    if (command == settings.global.plugin_commands.list) then
        if (privilege_level) >= getPermLevel(nil, nil, "senior_admin") then
            --rprint(PlayerIndex, "\n----- [ BASE GAME SETTINGS ] -----")
            local t = {}
            for k, _ in pairs(settings.mod) do
                t[#t + 1] = k
            end
            for k, v in pairs(t) do
                if v then
                    if (settings.mod[v].enabled) then
                        rprint(PlayerIndex, "[" .. k .. "] " .. v .. " is enabled")
                    else
                        rprint(PlayerIndex, "[" .. k .. "] " .. v .. " is disabled")
                    end
                end
            end
            --rprint(PlayerIndex, "-----------------------------------------------------\n")
            for _ in pairs(t) do
                t[_] = nil
            end
        else
            rprint(PlayerIndex, "Insufficient Permission")
        end
        return false
    elseif (command == settings.global.plugin_commands.enable) then
        if (t[2] ~= nil and t[2]:match("%d+")) then
            if (privilege_level) >= getPermLevel(nil, nil, "senior_admin") then
                local id = t[2]
                local t = {}
                for k, _ in pairs(settings.mod) do
                    t[#t + 1] = k
                end
                for k, v in pairs(t) do
                    if v then
                        if (tonumber(id) == tonumber(k)) then
                            if not (settings.mod[v].enabled) then
                                settings.mod[v].enabled = true
                                rprint(PlayerIndex, "[" .. k .. "] " .. v .. " is enabled")
                            else
                                rprint(PlayerIndex, v .. " is already enabled!")
                            end
                        end
                    end
                end
                for _ in pairs(t) do
                    t[_] = nil
                end
            else
                rprint(PlayerIndex, "Insufficient Permission")
            end
        else
            rprint(PlayerIndex, "Invalid Syntax")
        end
        return false
    elseif (command == settings.global.plugin_commands.disable) then
        if (t[2] ~= nil and t[2]:match("%d+")) then
            if (privilege_level) >= getPermLevel(nil, nil, "senior_admin") then
                local id = t[2]
                local t = {}
                for k, _ in pairs(settings.mod) do
                    t[#t + 1] = k
                end
                for k, v in pairs(t) do
                    if v then
                        if (tonumber(id) == tonumber(k)) then
                            if (settings.mod[v].enabled) then
                                settings.mod[v].enabled = false
                                rprint(PlayerIndex, "[" .. k .. "] " .. v .. " is disabled")
                            else
                                rprint(PlayerIndex, v .. " is already enabled!")
                            end
                        end
                    end
                end
                for _ in pairs(t) do
                    t[_] = nil
                end
            else
                rprint(PlayerIndex, "Insufficient Permission")
            end
        else
            rprint(PlayerIndex, "Invalid Syntax")
        end
        return false
    end

    -- SAPP | Mute command listener
    if (settings.global.handlemutes == true) then
        if (command == settings.global.plugin_commands.mute) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= 1 then
                if (t[2] ~= nil and t[2]:match("%d+")) then
                    local offender_id = get_var(tonumber(t[2]), "$n")
                    if offender_id ~= get_var(PlayerIndex, "$n") then
                        if player_present(offender_id) then
                            local proceed
                            local valid

                            if (settings.global.can_mute_admins == true) then
                                proceed = true
                            elseif tonumber(get_var(offender_id, "$lvl")) >= getPermLevel(nil, nil, "trial_moderator") then
                                proceed = false
                                rprint(PlayerIndex, "You cannot mute admins.")
                            else
                                proceed = true
                            end
                            local offender_ip = get_var(offender_id, "$ip")
                            local offender_hash = get_var(offender_id, "$hash")
                            mute_duration[tonumber(offender_id)] = 0
                            if (t[3] == nil) then
                                time_diff[tonumber(offender_id)] = tonumber(settings.global.default_mute_time)
                                mute_duration[tonumber(offender_id)] = tonumber(settings.global.default_mute_time)
                                valid = true
                            elseif match(t[3], "%d+") then
                                time_diff[tonumber(offender_id)] = tonumber(t[3])
                                mute_duration[tonumber(offender_id)] = tonumber(t[3])
                                init_mute_timer[tonumber(offender_id)] = true
                                valid = true
                            else
                                valid = false
                                rprint(PlayerIndex, "Invalid syntax. Usage: /" .. settings.global.plugin_commands.mute .. " [id] <time dif>")
                            end
                            if (proceed) and (valid) then
                                muted[tonumber(offender_id)] = true
                                saveMuteEntry(PlayerIndex, offender_ip, offender_id, offender_hash, mute_duration[tonumber(offender_id)])
                            end
                        else
                            rprint(PlayerIndex, "Player not present")
                        end
                    else
                        rprint(PlayerIndex, "Error. You cannot mute or unmute yourself.")
                    end
                else
                    rprint(PlayerIndex, "Invalid player. Usage: /" .. settings.global.plugin_commands.mute .. " [id] <time dif>")
                end
            else
                rprint(PlayerIndex, "Insufficient Permission.")
            end
            return false
        elseif (command == settings.global.plugin_commands.unmute) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= 1 then
                if (t[2] ~= nil and t[2]:match("%d+")) then
                    local offender_id = get_var(tonumber(t[2]), "$n")
                    if offender_id ~= get_var(PlayerIndex, "$n") then
                        if player_present(offender_id) then
                            local offender_name = get_var(offender_id, "$name")
                            local offender_ip = get_var(offender_id, "$ip")
                            local offender_hash = get_var(offender_id, "$hash")
                            if (muted[tonumber(offender_id)] == true) then

                                muted[tonumber(offender_id)] = false
                                init_mute_timer[tonumber(offender_id)] = false
                                time_diff[tonumber(PlayerIndex)] = 0

                                removeEntry(tostring(offender_ip), tostring(offender_hash), tonumber(offender_id))

                                rprint(PlayerIndex, offender_name .. " has been unmuted")
                                rprint(offender_id, "You have been  unmuted")
                            else
                                rprint(PlayerIndex, offender_name .. " it not muted")
                            end
                        else
                            rprint(PlayerIndex, "Player not present")
                        end
                    else
                        rprint(PlayerIndex, "Error. You cannot mute or unmute yourself.")
                    end
                else
                    rprint(PlayerIndex, "Invalid player. Usage: /" .. settings.global.plugin_commands.unmute .. " [id]")
                end
            else
                rprint(PlayerIndex, "Insufficient Permission")
            end
            return false
        elseif (command == settings.global.plugin_commands.mutelist) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= 1 then
                local file_name = settings.global.mute_dir
                if (t[2] == nil) then
                    rprint(PlayerIndex, "----------- IP - HASH - NAME - TIME REMAINING (in minutes) ----------- ")
                else
                    rprint(PlayerIndex, "----------- NAME - TIME REMAINING (in minutes) ----------- ")
                end
                local lines = lines_from(file_name)
                for k, v in pairs(lines) do
                    if k ~= nil then
                        if (t[2] == nil) then
                            rprint(PlayerIndex, gsub(v, "(;)", "(") .. "m)")
                        elseif t[2] == "-o" then
                            for i = 1, 16 do
                                if player_present(i) and v:match(get_var(i, "$ip")) and v:match(get_var(i, "$hash")) then
                                    local name = get_var(i, "$name")
                                    local id = get_var(i, "$n")
                                    local time = time_diff[tonumber(i)]
                                    rprint(PlayerIndex, name .. " [" .. id .. "]: " .. time .. " minutes left")
                                end
                            end
                        else
                            rprint(PlayerIndex, "Invalid Syntax")
                            break
                        end
                    end
                end
            else
                rprint(PlayerIndex, "Insufficient Permission")
            end
            return false
        end
    end

    -- #Suggestions Box (requested by Cyser@)
    if (command == settings.mod["Suggestions Box"].base_command) then
        if (settings.mod["Suggestions Box"].enabled) then
            if (t[2] ~= nil) then
                local name = get_var(PlayerIndex, "$name")
                local t = {}
                local dir = settings.mod["Suggestions Box"].dir
                local txt_format = settings.mod["Suggestions Box"].file_format
                local content = gsub(Command, settings.mod["Suggestions Box"].base_command, "")

                t[#t + 1] = content
                if (t) then
                    local file = io.open(dir, "a+")
                    if (file) then
                        for _, v in pairs(t) do
                            text = v
                        end
                        local tstamp = os.date("%d/%m/%Y - %H:%M:%S")
                        local str = gsub(gsub(gsub(txt_format, "%%time_stamp%%", tstamp), "%%player_name%%", name), "%%message%%", text .. "\n")
                        file:write(str)
                        file:close()
                        rprint(PlayerIndex, gsub(settings.mod["Suggestions Box"].response, "%%player_name%%", name))
                        rprint(PlayerIndex, "------------ [ MESSAGE ] ------------------------------------------------")
                        rprint(PlayerIndex, text)
                        rprint(PlayerIndex, "-------------------------------------------------------------------------------------------------------------")
                    end
                end
            else
                rprint(PlayerIndex, "Invalid Syntax: Usage: /" .. settings.mod["Suggestions Box"].base_command .. " {message}")
            end
            for _ in pairs(t) do
                _ = nil
            end
            return false
        else
            rprint(PlayerIndex, "Failed to execute. Suggestions Box is disabled.")
            return false
        end
    end

    -- #Enter Vehicle
    if (command == settings.mod["Enter Vehicle"].base_command) then
        if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Enter Vehicle", nil, nil) then
            if (settings.mod["Enter Vehicle"].enabled) then
                if settings.mod["Item Spawner"].enabled then
                    if player_alive(PlayerIndex) then
                        local object_to_spawn
                        if (t[2] ~= nil) then
                            local distance, height
                            if t[3] ~= nil then
                                if t[3]:match("%d+") then
                                    distance = tonumber(t[3])
                                else
                                    rprint(PlayerIndex, "Command failed. Invalid distance parameter")
                                end
                            else
                                distance = 2
                            end

                            if t[4] ~= nil then
                                if t[4]:match("%d+") then
                                    height = tonumber(t[3])
                                else
                                    rprint(PlayerIndex, "Command failed. Invalid height parameter")
                                end
                            else
                                height = 0.3
                            end

                            local x, y, z, is_valid, is_error, no_match
                            local objects_table = settings.mod["Item Spawner"].objects
                            local player_object = get_dynamic_player(PlayerIndex)
                            for i = 1, #objects_table do
                                if t[2]:match(objects_table[i][1]) and (objects_table[i][2] == "vehi") then
                                    if TagInfo(objects_table[i][2], objects_table[i][3]) then

                                        if PlayerInVehicle(PlayerIndex) then
                                            local VehicleID = read_dword(player_object + 0x11C)
                                            if (VehicleID == 0xFFFFFFFF) then
                                                return false
                                            end
                                            local vehicle = get_object_memory(VehicleID)
                                            x, y, z = read_vector3d(vehicle + 0x5c)
                                            ev_OldVehicle[PlayerIndex] = VehicleID
                                        else
                                            x, y, z = read_vector3d(player_object + 0x5c)
                                        end

                                        local camera_x = read_float(player_object + 0x230)
                                        local camera_y = read_float(player_object + 0x234)
                                        x = x + camera_x * distance
                                        y = y + camera_y * distance
                                        z = z + height

                                        ev_NewVehicle[PlayerIndex] = spawn_object("vehi", objects_table[i][3], x, y, z)

                                        local multi_control = settings.mod["Enter Vehicle"].multi_control

                                        -- Multi Control - NOT in vehicle
                                        if multi_control and not PlayerInVehicle(PlayerIndex) then
                                            enterVehicle(PlayerIndex, ev_NewVehicle[PlayerIndex])

                                            -- Multi Control - IN vehicle
                                        elseif multi_control and PlayerInVehicle(PlayerIndex) then
                                            enterVehicle(PlayerIndex, ev_NewVehicle[PlayerIndex])

                                            -- NO Multi Control - NOT in vehicle
                                        elseif not multi_control and not PlayerInVehicle(PlayerIndex) then
                                            enterVehicle(PlayerIndex, ev_NewVehicle[PlayerIndex])

                                            -- NO Multi Control - IN vehicle
                                        elseif not multi_control and PlayerInVehicle(PlayerIndex) then
                                            exit_vehicle(PlayerIndex)
                                            ev_Status[PlayerIndex] = true
                                        end

                                        if ev_NewVehicle[PlayerIndex] ~= nil then
                                            EV_drone_table[PlayerIndex] = EV_drone_table[PlayerIndex] or {}
                                            table.insert(EV_drone_table[PlayerIndex], ev_NewVehicle[PlayerIndex])
                                        end

                                        ev[PlayerIndex] = true
                                        is_valid = true
                                    else
                                        is_error = true
                                    end
                                else
                                    no_match = true
                                end
                            end

                            if (is_valid) then
                                rprint(PlayerIndex, "Entering vehicle")
                            end

                            if not (is_valid) and (no_match) and not (is_error) then
                                rprint(PlayerIndex, "Failed to spawn object. [unknown object name]")

                            elseif (is_valid == nil or is_valid == false) and (is_error) and (no_match) then
                                rprint(PlayerIndex, "Failed to spawn object. [missing tag id]")
                            end
                        else
                            rprint(PlayerIndex, "Invalid Syntax: Usage: /" .. settings.mod["Enter Vehicle"].base_command .. " {vehicle nickname}")
                        end
                    else
                        rprint(PlayerIndex, "Command failed. You are dead. [wait until you respawn]")
                    end
                else
                    rprint(PlayerIndex, "Error. Plugin: 'Item Spawner' needs to be enabled for this to work.")
                end
            else
                rprint(PlayerIndex, "Failed to execute. Enter Vehicle is disabled.")
            end
        else
            rprint(PlayerIndex, "Insufficient Permission")
        end
        return false
    end

    if (command == settings.global.plugin_commands.garbage_collection) then
        if (settings.mod["Enter Vehicle"].enabled) or (settings.mod["Item Spawner"].enabled) then
            local TargetID, TableID, continue, is_all

            if (t[2] ~= nil) then
                if (t[2] == "me") then
                    TargetID = tonumber(PlayerIndex)
                elseif (t[2]:match("%d+")) then
                    TargetID = tonumber(t[2])
                elseif (tostring(t[2]) == "*") then
                    is_all = true
                end
            else
                rprint(PlayerIndex, "Invalid Syntax")
            end

            local identifier
            if (t[3] ~= nil) then
                if t[3]:match("%d+") then
                    if tonumber(t[3]) > 0 and tonumber(t[3]) < 3 then
                        TableID = tonumber(t[3]);
                        continue = true
                        if TableID == 1 then
                            identifier = "vehicle"
                        else
                            identifier = "item"
                        end
                        if not (is_all) then
                            if (ev_NewVehicle[TargetID] ~= nil) or (item_objects[TargetID] ~= nil) then
                                if TargetID == tonumber(PlayerIndex) then
                                    rprint(PlayerIndex, "Cleaning up " .. identifier .. " objects")
                                else
                                    rprint(PlayerIndex, "Cleaning up " .. get_var(TargetID, "$name") .. "'s " .. identifier .. " objects")
                                end
                            else
                                rprint(PlayerIndex, "Nothing to clean up!")
                            end
                        end
                    else
                        rprint(PlayerIndex, "Invalid table id!")
                    end
                elseif tostring(t[3]) == "*" then
                    TableID = "all";
                    continue = true
                    if not (is_all) then
                        if TargetID == tonumber(PlayerIndex) then
                            if (ev_NewVehicle[TargetID] ~= nil) or (item_objects[TargetID] ~= nil) then
                                rprint(PlayerIndex, "Cleaning up everything you spawned")
                            else
                                rprint(PlayerIndex, "Nothing to clean up!")
                            end
                        else
                            rprint(PlayerIndex, "Cleaning up everything " .. get_var(TargetID, "$name") .. " has spawned")
                        end
                    end
                end
            end

            if (continue) and not (is_all) then
                if player_present(TargetID) then
                    CleanUpDrones(TargetID, TableID)
                else
                    rprint(PlayerIndex, "Player not present!")
                end
            elseif (continue) and (is_all) then
                for i = 1, 16 do
                    if player_present(i) then
                        if (ev_NewVehicle[i] ~= nil) or (item_objects[i] ~= nil) then
                            CleanUpDrones(tonumber(i), TableID)
                            if identifier == nil then
                                identifier = ""
                            end
                            rprint(PlayerIndex, "Cleaning up " .. get_var(tonumber(i), "$name") .. "'s " .. identifier .. " spawned objects")
                        else
                            rprint(PlayerIndex, get_var(tonumber(i), "$name") .. " has nothing to clean up")
                        end
                    end
                end
            end
        end
        return false
    end

    -- #Lurker
    if (command == settings.mod["Lurker"].base_command) then
        if (settings.mod["Lurker"].enabled) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Lurker", nil, nil) then
                if (lurker[PlayerIndex] == false or lurker[PlayerIndex] == nil) then
                    if not (modify_damage[PlayerIndex]) then
                        setLurker(PlayerIndex, true)
                        rprint(PlayerIndex, "Lurker mode enabled!")
                    else
                        rprint(PlayerIndex, "Unable to set Lurker Mode while you have damage multipliers applied")
                    end
                else
                    setLurker(PlayerIndex, false)
                    rprint(PlayerIndex, "Lurker mode disabled!")
                end
            else
                rprint(PlayerIndex, "Insufficient Permission")
            end
            return false
        else
            rprint(PlayerIndex, "Failed to execute. Lurker is disabled.")
            return false
        end
    end

    -- #Infinity Ammo
    if (command == settings.mod["Infinity Ammo"].base_command) then
        if (settings.mod["Infinity Ammo"].enabled) then
            if not (settings.mod["Infinity Ammo"].server_override) then
                if PlayerIndex ~= -1 and PlayerIndex >= 1 and PlayerIndex < 16 then
                    if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Infinity Ammo", nil, nil) then

                        local _min = settings.mod["Infinity Ammo"].multiplier_min
                        local _max = settings.mod["Infinity Ammo"].multiplier_max

                        local function EnableInfAmmo(TargetID, specified, multiplier)
                            infammo[TargetID] = true
                            frag_check[TargetID] = true
                            adjust_ammo(TargetID)
                            if specified then
                                if not (lurker[TargetID]) then
                                    local mult = tonumber(multiplier)
                                    modify_damage[TargetID] = true
                                    damage_multiplier[TargetID] = mult
                                    rprint(TargetID, "[cheat] Infinity Ammo enabled!")
                                    rprint(TargetID, damage_multiplier[TargetID] .. "% damage multiplier applied")
                                else
                                    rprint(PlayerIndex, "Unable to set damage multipliers while in Lurker Mode")
                                end
                            else
                                rprint(TargetID, "[cheat] Infinity Ammo enabled!")
                                if (settings.mod["Infinity Ammo"].announcer) then
                                    announce(PlayerIndex, get_var(PlayerIndex, "$name") .. " is now in Infinity Ammo mode.")
                                end
                            end
                        end

                        local function validate(T3)
                            if tonumber(T3) >= tonumber(_min) and tonumber(T3) < tonumber(_max) + 1 then
                                return true
                            else
                                rprint(PlayerIndex, "Invalid multiplier. Choose a number between 0.001-10")
                            end
                            return false
                        end

                        if t[2] ~= nil then
                            if t[2] == "me" then
                                if t[3] == nil then
                                    EnableInfAmmo(PlayerIndex, false, 0)
                                elseif t[3]:match("%d+") then
                                    if validate(tonumber(t[3])) then
                                        EnableInfAmmo(PlayerIndex, true, tonumber(t[3]))
                                        rprint(PlayerIndex, "[cheat] Enabled infammo for " .. get_var(tonumber(t[3]), "$name"))
                                    end
                                else
                                    rprint(PlayerIndex, "Invalid Syntax: Type /" .. settings.mod["Infinity Ammo"].base_command .. " [id] {multiplier}")
                                end
                            elseif t[2]:match("%d+") then
                                if t[3] == nil then
                                    if player_present(tonumber(t[2])) then
                                        EnableInfAmmo(tonumber(t[2]), false, 0)
                                        rprint(PlayerIndex, "[cheat] Enabled infammo for " .. get_var(tonumber(t[2]), "$name"))
                                    else
                                        rprint(PlayerIndex, "Player not present")
                                    end
                                elseif t[3]:match("%d+") then
                                    if player_present(tonumber(t[2])) then
                                        if validate(tonumber(t[3])) then
                                            EnableInfAmmo(tonumber(t[2]), true, tonumber(t[3]))
                                            rprint(PlayerIndex, "[cheat] Enabled infammo for " .. get_var(tonumber(t[3]), "$name"))
                                        end
                                    else
                                        rprint(PlayerIndex, "Player not present")
                                    end
                                end
                            elseif t[2] == "off" then
                                if t[3] == nil or t[3] == "me" then
                                    DisableInfAmmo(PlayerIndex)
                                    rprint(PlayerIndex, "[cheat] Disabled infammo")
                                    if (settings.mod["Infinity Ammo"].announcer) then
                                        announce(PlayerIndex, get_var(PlayerIndex, "$name") .. " is no longer in Infinity Ammo Mode")
                                    end
                                elseif t[3]:match("%d+") then
                                    if player_present(tonumber(t[3])) then
                                        DisableInfAmmo(tonumber(t[3]))
                                        rprint(PlayerIndex, "[cheat] Disabled infammo for " .. get_var(tonumber(t[3]), "$name"))
                                    else
                                        rprint(PlayerIndex, "Player not present")
                                    end
                                end
                            else
                                rprint(PlayerIndex, "Invalid Syntax: Usage: /" .. settings.mod["Infinity Ammo"].base_command .. " [id] {multiplier}")
                            end
                        else
                            rprint(PlayerIndex, "Invalid Syntax: Usage: /" .. settings.mod["Infinity Ammo"].base_command .. " [id] {multiplier}")
                        end
                    else
                        rprint(PlayerIndex, "Insufficient Permission")
                    end
                else
                    cprint("The Server cannot execute this command!", 4 + 8)
                end
            else
                rprint(PlayerIndex, "Failed to execute.")
                rprint(PlayerIndex, "Ammo cannot be adjusted while the server is in Ammo-Override mode.")
            end
            return false
        else
            rprint(PlayerIndex, "Failed to execute. Infinity Ammo is disabled.")
            return false
        end
    end

    -- #Player List
    if (settings.mod["Player List"].enabled) then
        local commands = settings.mod["Player List"].command_aliases
        local count = #t
        for _, v in pairs(commands) do
            local cmds = tokenizestring(v, ",")
            for i = 1, #cmds do
                if (t[1] == cmds[i]) then
                    if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Player List", nil, nil) then
                        listPlayers(PlayerIndex, count)
                    else
                        rprint(PlayerIndex, "Insufficient Permission")
                    end
                    return false
                end
            end
        end
    end

    -- #Portal Gun
    if (command == settings.mod["Portal Gun"].base_command) then
        if (settings.mod["Portal Gun"].enabled) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Portal Gun", nil, nil) then
                if t[2] ~= nil then
                    if t[2] == "on" or t[2] == "1" or t[2] == "true" then
                        if portalgun_mode[PlayerIndex] == true then
                            rprint(PlayerIndex, "Portal Gun mode is already on!")
                        else
                            portalgun_mode[PlayerIndex] = true
                            rprint(PlayerIndex, "Portalgun Mode enabled.")
                            if (settings.mod["Portal Gun"].announcer) then
                                announce(PlayerIndex, get_var(PlayerIndex, "$name") .. " is now in Portal Gun mode!")
                            end
                        end
                    elseif t[2] == "off" or t[2] == "0" or t[2] == "false" then
                        if portalgun_mode[PlayerIndex] == false then
                            rprint(PlayerIndex, "Portal Gun mode is already off!")
                        else
                            portalgun_mode[PlayerIndex] = false
                            rprint(PlayerIndex, "Portalgun Mode disabled.")
                            if (settings.mod["Portal Gun"].announcer) then
                                announce(PlayerIndex, get_var(PlayerIndex, "$name") .. " is no longer in Portal Gun Mode")
                            end
                        end
                    end
                else
                    rprint(PlayerIndex, "Invalid Syntax. Usage: /" .. settings.mod["Portal Gun"].base_command .. " on|off")
                end
            else
                rprint(PlayerIndex, "You do not have permission to execute that command!")
            end
            return false
        else
            rprint(PlayerIndex, "Failed to execute. Portal Gun is disabled.")
            return false
        end
    end

    -- #What cute things did you do today
    if (command == settings.mod["wctdydt"].base_command) then
        if (settings.mod["wctdydt"].enabled) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= settings.mod["wctdydt"].permission_level then
                if (t[2] ~= nil and t[2]:match("%d+")) then
                    local target_id = tonumber(t[2])
                    if target_id ~= tonumber(PlayerIndex) then
                        if target_id ~= nil and target_id > 0 and target_id < 17 then
                            if player_present(target_id) then

                                local toTargetFormat = settings.mod["wctdydt"].messages[1]
                                local toExecutorFormat = settings.mod["wctdydt"].messages[2]

                                local TargetResponse = (gsub(gsub(toTargetFormat,
                                        "%%executors_name%%", get_var(PlayerIndex, "$name")), "%%target_name%%", get_var(target_id, "$name")))

                                if (settings.mod["wctdydt"].environment == "chat") then
                                    execute_command("msg_prefix \"\"")
                                    say(target_id, TargetResponse)
                                    execute_command("msg_prefix \" " .. settings.global.server_prefix .. "\"")
                                else
                                    rprint(target_id, TargetResponse)
                                end

                                local ExecutorResponse = (gsub(gsub(toExecutorFormat,
                                        "%%executors_name%%", get_var(PlayerIndex, "$name")), "%%target_name%%", get_var(target_id, "$name")))

                                execute_command("msg_prefix \"\"")
                                say(PlayerIndex, ExecutorResponse)
                                execute_command("msg_prefix \" " .. settings.global.server_prefix .. "\"")
                            else
                                rprint(PlayerIndex, "Invalid Player Index")
                            end
                        else
                            rprint(PlayerIndex, "Invalid player!")
                        end
                    else
                        rprint(PlayerIndex, "You cannot execute this on yourself!")
                    end
                else
                    rprint(PlayerIndex, "Invalid player!")
                end
            else
                rprint(PlayerIndex, "Insufficient Permission")
            end
            return false
        else
            rprint(PlayerIndex, "Failed to execute. wctdydt is disabled.")
            return false
        end
    end

    -- #Item Spawner
    if (command == settings.mod["Item Spawner"].base_command) then
        if (settings.mod["Item Spawner"].enabled) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Item Spawner", nil, nil) then
                if t[2] ~= nil then
                    if player_alive(PlayerIndex) then
                        local objects_table = settings.mod["Item Spawner"].objects
                        local is_valid, is_error
                        local sin = math.sin
                        for i = 1, #objects_table do
                            if t[2]:match(objects_table[i][1]) then
                                local tag_type = objects_table[i][2]
                                local tag_name = objects_table[i][3]
                                if TagInfo(tag_type, tag_name) then
                                    local function SpawnObject(PlayerIndex, tag_type, tag_name)
                                        local player_object = get_dynamic_player(PlayerIndex)
                                        if player_object ~= 0 then
                                            local x_aim = read_float(player_object + 0x230)
                                            local y_aim = read_float(player_object + 0x234)
                                            local z_aim = read_float(player_object + 0x238)
                                            local x = read_float(player_object + 0x5C)
                                            local y = read_float(player_object + 0x60)
                                            local z = read_float(player_object + 0x64)
                                            local obj_x = x + settings.mod["Item Spawner"].distance_from_playerX * sin(x_aim)
                                            local obj_y = y + settings.mod["Item Spawner"].distance_from_playerY * sin(y_aim)
                                            local obj_z = z + 0.3 * sin(z_aim) + 0.5
                                            item_objects[PlayerIndex] = spawn_object(tag_type, tag_name, obj_x, obj_y, obj_z)
                                            rprint(PlayerIndex, "Spawned " .. objects_table[i][1])
                                            is_valid = true

                                            if (item_objects[PlayerIndex]) ~= nil then
                                                IS_drone_table[PlayerIndex] = IS_drone_table[PlayerIndex] or {}
                                                table.insert(IS_drone_table[PlayerIndex], item_objects[PlayerIndex])
                                            end
                                        end
                                    end

                                    SpawnObject(PlayerIndex, tag_type, tag_name)
                                else
                                    is_error = true
                                    rprint(PlayerIndex, "[Base Game Settings]")
                                    rprint(PlayerIndex, "Error: Missing tag id for '" .. t[2] .. "' in 'objects' table.")
                                end
                                break
                            end
                        end
                        if not (is_valid) and not (is_error) then
                            rprint(PlayerIndex, "[Base Game Settings]")
                            rprint(PlayerIndex, "'" .. t[2] .. "' is not a valid object or it is missing in the 'objects' table.")
                        end
                    else
                        rprint(PlayerIndex, "[dead] - Failed to execute. Wait until you respawn.")
                    end
                else
                    rprint(PlayerIndex, "Invalid Syntax")
                end
            else
                rprint(PlayerIndex, "Insufficient Permission")
            end
            return false
        else
            rprint(PlayerIndex, "Failed to execute. Item Spawner is disabled.")
            return false
        end
    elseif (command == settings.mod["Item Spawner"].list) then
        if (settings.mod["Item Spawner"].enabled) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Item Spawner", nil, nil) then
                local function concatTableObjects(PlayerIndex, start_index, end_index)
                    local t = {}
                    local row
                    for j = tonumber(start_index), tonumber(end_index) do
                        if temp_objects_table[j] ~= nil then
                            t[#t + 1] = temp_objects_table[j]
                            row = concat(t, ",    ")
                        end
                    end
                    if row ~= nil then
                        rprint(PlayerIndex, row)
                    end
                    for _ in pairs(t) do
                        t[_] = nil
                    end
                end

                rprint(PlayerIndex, "------------------------ [ ITEMS ] ------------------------")
                concatTableObjects(PlayerIndex, 1, 5)
                concatTableObjects(PlayerIndex, 6, 10)
                concatTableObjects(PlayerIndex, 11, 15)
                concatTableObjects(PlayerIndex, 16, 20)
                concatTableObjects(PlayerIndex, 21, 25)
                concatTableObjects(PlayerIndex, 26, 30)
                concatTableObjects(PlayerIndex, 31, 35)
                concatTableObjects(PlayerIndex, 36, 40)
                concatTableObjects(PlayerIndex, 41, 45)
                concatTableObjects(PlayerIndex, 46, 50)
                concatTableObjects(PlayerIndex, 46, 50)
                rprint(PlayerIndex, "-----------------------------------------------------------")
            else
                rprint(PlayerIndex, "Insufficient Permission")
            end
            return false
        else
            rprint(PlayerIndex, "Failed to execute. Item Spawner is disabled.")
            return false
        end
    end

    -- #Get Coords
    if (command == settings.mod["Get Coords"].base_command) then
        if (settings.mod["Get Coords"].enabled) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Get Coords", nil, nil) then
                local player_object = get_dynamic_player(PlayerIndex)
                if player_object ~= 0 then
                    local x, y, z = read_vector3d(player_object + 0x5C)
                    if settings.mod["Get Coords"].environment == "console" then
                        cprint(x .. ", " .. y .. ", " .. z)
                    elseif settings.mod["Get Coords"].environment == "rcon" then
                        rprint(PlayerIndex, x .. ", " .. y .. ", " .. z)
                    elseif settings.mod["Get Coords"].environment == "both" then
                        rprint(PlayerIndex, x .. ", " .. y .. ", " .. z)
                        cprint(x .. ", " .. y .. ", " .. z)
                    end
                    kill(PlayerIndex)
                    local player = get_player(PlayerIndex)
                    write_dword(player + 0x2C, 0 * 33)
                    return false
                end
            end
        else
            rprint(PlayerIndex, "Failed to execute. Get Coords is disabled.")
            return false
        end
    end

    -- #Admin Chat
    if (command == settings.mod["Admin Chat"].base_command) then
        if (settings.mod["Admin Chat"].enabled) then
            if PlayerIndex ~= -1 and PlayerIndex >= 1 and PlayerIndex < 16 then
                if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Admin Chat", nil, nil) then
                    if t[2] == "on" or t[2] == "1" or t[2] == "true" or t[2] == '"1"' or t[2] == '"on"' or t[2] == '"true"' then
                        if players[p_table].boolean ~= true then
                            players[p_table].adminchat = true
                            players[p_table].boolean = true
                            rprint(PlayerIndex, "Admin Chat enabled.")
                            return false
                        else
                            rprint(PlayerIndex, "Admin Chat is already enabled.")
                            return false
                        end
                    elseif t[2] == "off" or t[2] == "0" or t[2] == "false" or t[2] == '"off"' or t[2] == '"0"' or t[2] == '"false"' then
                        if players[p_table].boolean ~= false then
                            players[p_table].adminchat = false
                            players[p_table].boolean = false
                            rprint(PlayerIndex, "Admin Chat disabled.")
                            return false
                        else
                            rprint(PlayerIndex, "Admin Chat is already disabled.")
                            return false
                        end
                    else
                        rprint(PlayerIndex, "Invalid Syntax: Type /" .. settings.mod["Admin Chat"].base_command .. " on|off")
                        return false
                    end
                else
                    rprint(PlayerIndex, "Insufficient Permission")
                    return false
                end
            else
                cprint("The Server cannot execute this command!", 4 + 8)
            end
        else
            rprint(PlayerIndex, "Failed to execute. Admin Chat is disabled.")
            return false
        end
    end

    -- #Alias System
    if (command == settings.mod["Alias System"].base_command) then
        if (settings.mod["Alias System"].enabled) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Alias System", nil, nil) then
                if t[2] ~= nil then
                    if t[2] == match(t[2], "^%d+$") and t[3] == nil then
                        if player_present(tonumber(t[2])) then
                            local index = tonumber(t[2])
                            target_hash = tostring(get_var(index, "$hash"))
                            if trigger[PlayerIndex] == true then
                                -- aliases already showing (clear console then show again)
                                cls(PlayerIndex)
                                players[p_table].alias_timer = 0
                                trigger[PlayerIndex] = true
                                alias_bool[PlayerIndex] = true
                            else
                                -- show aliases (first time)
                                trigger[PlayerIndex] = true
                                alias_bool[PlayerIndex] = true
                            end
                        else
                            players[p_table].alias_timer = 0
                            trigger[PlayerIndex] = false
                            cls(PlayerIndex)
                            rprint(PlayerIndex, "Player not present")
                        end
                    else
                        players[p_table].alias_timer = 0
                        trigger[PlayerIndex] = false
                        cls(PlayerIndex)
                        rprint(PlayerIndex, "Invalid player id")
                    end
                    return false
                else
                    rprint(PlayerIndex, "Invalid syntax. Use /" .. settings.mod["Alias System"].base_command .. " [id]")
                    return false
                end
            else
                rprint(PlayerIndex, "Insufficient Permission")
            end
        else
            rprint(PlayerIndex, "Failed to execute. Alias System is disabled.")
            return false
        end
    end

    -- #Teleport Manager
    if (settings.mod["Teleport Manager"].enabled) then
        local file_name = settings.mod["Teleport Manager"].dir
        if t[1] ~= nil then
            if (command == settings.mod["Teleport Manager"].commands[1]) then
                if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Teleport Manager", true, "setwarp") then
                    if t[2] ~= nil then
                        check_file_status(PlayerIndex)
                        if not empty_file then
                            local lines = lines_from(file_name)
                            for _, v in pairs(lines) do
                                if t[2] == v:match("[%a%d+_]*") then
                                    rprint(PlayerIndex, "That portal name already exists!")
                                    canset[PlayerIndex] = false
                                    break
                                else
                                    canset[PlayerIndex] = true
                                end
                            end
                        else
                            canset[PlayerIndex] = true
                        end
                        if t[2]:match(mapname) then
                            rprint(PlayerIndex, "Teleport name cannot be the same as the current map name!")
                            canset[PlayerIndex] = false
                        end
                        if canset[PlayerIndex] == true then
                            if PlayerInVehicle(PlayerIndex) then
                                x1, y1, z1 = read_vector3d(get_object_memory(read_dword(get_dynamic_player(PlayerIndex) + 0x11C)) + 0x5c)
                            else
                                x1, y1, z1 = read_vector3d(get_dynamic_player(PlayerIndex) + 0x5C)
                            end
                            local file = io.open(file_name, "a+")
                            local line = t[2] .. " [Map: " .. mapname .. "] X " .. x1 .. ", Y " .. y1 .. ", Z " .. z1
                            file:write(line, "\n")
                            file:close()
                            rprint(PlayerIndex, "Teleport location set to: " .. x1 .. ", " .. y1 .. ", " .. z1)
                        end
                    else
                        rprint(PlayerIndex, "Invalid Syntax. Command Usage: /" .. settings.mod["Teleport Manager"].commands[1] .. " <teleport name>")
                    end
                else
                    rprint(PlayerIndex, "You're not allowed to execute /" .. settings.mod["Teleport Manager"].commands[1])
                end
                return false
            end
        end
        ---------------------------------------------------------
        -- GO TO COMMAND --
        if t[1] ~= nil then
            if (command == settings.mod["Teleport Manager"].commands[2]) then
                check_file_status(PlayerIndex)
                if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Teleport Manager", true, "warp") then
                    if t[2] ~= nil then
                        if not empty_file then
                            local found
                            local valid
                            local lines = lines_from(file_name)
                            for _, v in pairs(lines) do
                                if t[2] == v:match("[%a%d+_]*") then
                                    if (player_alive(PlayerIndex)) then
                                        if find(v, mapname) then
                                            found = true
                                            -- numbers without decimal points -----------------------------------------------------------------------------
                                            local x, y, z
                                            if match(v, ("X%s*%d+,%s*Y%s*%d+,%s*Z%s*%d+")) then
                                                valid = true -- 0
                                                x = gsub(match(v, "X%s*%d+"), "X%s*%d+", match(match(v, "X%s*%d+"), "%d+"))
                                                y = gsub(match(v, "Y%s*%d+"), "Y%s*%d+", match(match(v, "Y%s*%d+"), "%d+"))
                                                z = gsub(match(v, "Z%s*%d+"), "Z%s*%d+", match(match(v, "Z%s*%d+"), "%d+"))
                                            elseif match(v, ("X%s*-%d+,%s*Y%s*-%d+,%s*Z%s*-%d+")) then
                                                valid = true -- *
                                                x = gsub(match(v, "X%s*-%d+"), "X%s*-%d+", match(match(v, "X%s*-%d+"), "-%d+"))
                                                y = gsub(match(v, "Y%s*-%d+"), "Y%s*-%d+", match(match(v, "Y%s*-%d+"), "-%d+"))
                                                z = gsub(match(v, "Z%s*-%d+"), "Z%s*-%d+", match(match(v, "Z%s*-%d+"), "-%d+"))
                                            elseif match(v, ("X%s*-%d+,%s*Y%s*%d+,%s*Z%s*%d+")) then
                                                valid = true -- 1
                                                x = gsub(match(v, "X%s*-%d+"), "X%s*-%d+", match(match(v, "X%s*-%d+"), "-%d+"))
                                                y = gsub(match(v, "Y%s*%d+"), "Y%s*%d+", match(match(v, "Y%s*%d+"), "%d+"))
                                                z = gsub(match(v, "Z%s*%d+"), "Z%s*%d+", match(match(v, "Z%s*%d+"), "%d+"))
                                            elseif match(v, ("X%s*%d+,%s*Y%s*-%d+,%s*Z%s*%d+")) then
                                                valid = true -- 2
                                                x = gsub(match(v, "X%s*%d+"), "X%s*%d+", match(match(v, "X%s*%d+"), "%d+"))
                                                y = gsub(match(v, "Y%s*-%d+"), "Y%s*-%d+", match(match(v, "Y%s*-%d+"), "-%d+"))
                                                z = gsub(match(v, "Z%s*%d+"), "Z%s*%d+", match(match(v, "Z%s*%d+"), "%d+"))
                                            elseif match(v, ("X%s*%d+,%s*Y%s*%d+,%s*Z%s*-%d+")) then
                                                valid = true -- 3
                                                x = gsub(match(v, "X%s*%d+"), "X%s*%d+", match(match(v, "X%s*%d+"), "%d+"))
                                                y = gsub(match(v, "Y%s*%d+"), "Y%s*%d+", match(match(v, "Y%s*%d+"), "%d+"))
                                                z = gsub(match(v, "Z%s*-%d+"), "Z%s*-%d+", match(match(v, "Z%s*-%d+"), "-%d+"))
                                            elseif match(v, ("X%s*-%d+,%s*Y%s*-%d+,%s*Z%s*%d+")) then
                                                valid = true -- 1 & 2
                                                x = gsub(match(v, "X%s*-%d+"), "X%s*-%d+", match(match(v, "X%s*-%d+"), "-%d+"))
                                                y = gsub(match(v, "Y%s*-%d+"), "Y%s*-%d+", match(match(v, "Y%s*-%d+"), "-%d+"))
                                                z = gsub(match(v, "Z%s*%d+"), "Z%s*%d+", match(match(v, "Z%s*%d+"), "%d+"))
                                            elseif match(v, ("X%s*-%d+,%s*Y%s*%d+,%s*Z%s*-%d+")) then
                                                valid = true -- 1 & 3
                                                x = gsub(match(v, "X%s*-%d+"), "X%s*-%d+", match(match(v, "X%s*-%d+"), "-%d+"))
                                                y = gsub(match(v, "Y%s*%d+"), "Y%s*%d+", match(match(v, "Y%s*%d+"), "%d+"))
                                                z = gsub(match(v, "Z%s*-%d+"), "Z%s*-%d+", match(match(v, "Z%s*-%d+"), "-%d+"))
                                            elseif match(v, ("X%s*%d+,%s*Y%s*-%d+,%s*Z%s*-%d+")) then
                                                valid = true -- 2 & 3
                                                x = gsub(match(v, "X%s*%d+"), "X%s*%d+", match(match(v, "X%s*%d+"), "%d+"))
                                                y = gsub(match(v, "Y%s*-%d+"), "Y%s*-%d+", match(match(v, "Y%s*-%d+"), "-%d+"))
                                                z = gsub(match(v, "Z%s*-%d+"), "Z%s*-%d+", match(match(v, "Z%s*-%d+"), "-%d+"))
                                                -- numbers with decimal points -----------------------------------------------------------------------------
                                            elseif match(v, ("X%s*%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*%d+.%d+")) then
                                                valid = true -- 0
                                                x = gsub(match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", match(match(v, "X%s*%d+.%d+"), "%d+.%d+"))
                                                y = gsub(match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", match(match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
                                                z = gsub(match(v, "Z%s*%d+.%d+"), "Z%s*%d+.%d+", match(match(v, "Z%s*%d+.%d+"), "%d+.%d+"))
                                            elseif match(v, ("X%s*-%d+.%d+,%s*Y%s*-%d+.%d+,%s*Z%s*-%d+.%d+")) then
                                                valid = true -- *
                                                x = gsub(match(v, "X%s*-%d+.%d+"), "X%s*-%d+.%d+", match(match(v, "X%s*-%d+.%d+"), "-%d+.%d+"))
                                                y = gsub(match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", match(match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
                                                z = gsub(match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", match(match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))
                                            elseif match(v, ("X%s*-%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*%d+.%d+")) then
                                                valid = true -- 1
                                                x = gsub(match(v, "X%s*-%d+.%d+"), "X%s*-%d+.%d+", match(match(v, "X%s*-%d+.%d+"), "-%d+.%d+"))
                                                y = gsub(match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", match(match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
                                                z = gsub(match(v, "Z%s*%d+.%d+"), "Z%s*%d+.%d+", match(match(v, "Z%s*%d+.%d+"), "%d+.%d+"))
                                            elseif match(v, ("X%s*%d+.%d+,%s*Y%s*-%d+.%d+,%s*Z%s*%d+.%d+")) then
                                                valid = true -- 2
                                                x = gsub(match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", match(match(v, "X%s*%d+.%d+"), "%d+.%d+"))
                                                y = gsub(match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", match(match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
                                                z = gsub(match(v, "Z%s*%d+.%d+"), "Z%s*%d+.%d+", match(match(v, "Z%s*%d+.%d+"), "%d+.%d+"))
                                            elseif match(v, ("X%s*%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*-%d+.%d+")) then
                                                valid = true -- 3
                                                x = gsub(match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", match(match(v, "X%s*%d+.%d+"), "%d+.%d+"))
                                                y = gsub(match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", match(match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
                                                z = gsub(match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", match(match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))
                                            elseif match(v, ("X%s*-%d+.%d+,%s*Y%s*-%d+.%d+,%s*Z%s*%d+.%d+")) then
                                                valid = true -- 1 & 2
                                                x = gsub(match(v, "X%s*-%d+.%d+"), "X%s*-%d+.%d+", match(match(v, "X%s*-%d+.%d+"), "-%d+.%d+"))
                                                y = gsub(match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", match(match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
                                                z = gsub(match(v, "Z%s*%d+.%d+"), "Z%s*%d+.%d+", match(match(v, "Z%s*%d+.%d+"), "%d+.%d+"))
                                            elseif match(v, ("X%s*-%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*-%d+.%d+")) then
                                                valid = true -- 1 & 3
                                                x = gsub(match(v, "X%s*-%d+.%d+"), "X%s*-%d+.%d+", match(match(v, "X%s*-%d+.%d+"), "-%d+.%d+"))
                                                y = gsub(match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", match(match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
                                                z = gsub(match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", match(match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))
                                            elseif match(v, ("X%s*%d+.%d+,%s*Y%s*-%d+.%d+,%s*Z%s*-%d+.%d+")) then
                                                valid = true -- 2 & 3
                                                x = gsub(match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", match(match(v, "X%s*%d+.%d+"), "%d+.%d+"))
                                                y = gsub(match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", match(match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
                                                z = gsub(match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", match(match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))
                                            else
                                                rprint(PlayerIndex, "Script Error! Coordinates for that teleport do not match the regex expression!")
                                                cprint("Script Error! Coordinates for that teleport do not match the regex expression!", 4 + 8)
                                            end
                                            if (v ~= nil and valid) then
                                                if not PlayerInVehicle(PlayerIndex) then
                                                    local prevX, prevY, prevZ = read_vector3d(get_dynamic_player(PlayerIndex) + 0x5C)
                                                    previous_location[PlayerIndex][1] = prevX
                                                    previous_location[PlayerIndex][2] = prevY
                                                    previous_location[PlayerIndex][3] = prevZ
                                                    write_vector3d(get_dynamic_player(PlayerIndex) + 0x5C, tonumber(x), tonumber(y), tonumber(z))
                                                    rprint(PlayerIndex, "Teleporting to [" .. t[2] .. "] " .. floor(x) .. ", " .. floor(y) .. ", " .. floor(z))
                                                    valid = false
                                                else
                                                    TeleportPlayer(read_dword(get_dynamic_player(PlayerIndex) + 0x11C), tonumber(x), tonumber(y), tonumber(z) + 0.5)
                                                    rprint(PlayerIndex, "Teleporting to [" .. t[2] .. "] " .. floor(x) .. ", " .. floor(y) .. ", " .. floor(z))
                                                    valid = false
                                                end
                                            end
                                        else
                                            found = true
                                            rprint(PlayerIndex, "That warp is not linked to this map!")
                                        end
                                    else
                                        found = true
                                        rprint(PlayerIndex, "You cannot teleport when dead!")
                                    end
                                end
                            end
                            if not (found) then
                                rprint(PlayerIndex, "That teleport name is not valid!")
                            end
                        else
                            rprint(PlayerIndex, "The teleport list is empty!")
                        end
                    else
                        rprint(PlayerIndex, "Invalid Syntax. Command Usage: /" .. settings.mod["Teleport Manager"].commands[2] .. " <teleport name>")
                    end
                else
                    rprint(PlayerIndex, "You're not allowed to execute /" .. settings.mod["Teleport Manager"].commands[2])
                end
                return false
                ---------------------------------------------------------
                -- BACK COMMAND --
            elseif (command == settings.mod["Teleport Manager"].commands[3]) then
                if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Teleport Manager", true, "back") then
                    if not PlayerInVehicle(PlayerIndex) then
                        if previous_location[PlayerIndex][1] ~= nil then
                            write_vector3d(get_dynamic_player(PlayerIndex) + 0x5C, previous_location[PlayerIndex][1], previous_location[PlayerIndex][2], previous_location[PlayerIndex][3])
                            rprint(PlayerIndex, "Returning to previous location!")
                            for i = 1, 3 do
                                previous_location[PlayerIndex][i] = nil
                            end
                        else
                            rprint(PlayerIndex, "Unable to teleport back! You haven't been anywhere!")
                        end
                    end
                else
                    rprint(PlayerIndex, "You're not allowed to execute /" .. settings.mod["Teleport Manager"].commands[3])
                end
                return false
                ---------------------------------------------------------
                -- LIST COMMAND --
            elseif (command == settings.mod["Teleport Manager"].commands[4]) then
                local found = false
                if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Teleport Manager", true, "warplist") then
                    check_file_status(PlayerIndex)
                    if not empty_file then
                        local lines = lines_from(file_name)
                        for k, v in pairs(lines) do
                            if find(v, mapname) then
                                found = true
                                rprint(PlayerIndex, "[" .. k .. "] " .. v)
                            end
                        end
                        if not found then
                            rprint(PlayerIndex, "There are no warps for the current map.")
                        end
                    else
                        rprint(PlayerIndex, "The teleport list is empty!")
                    end
                else
                    rprint(PlayerIndex, "You're not allowed to execute /" .. settings.mod["Teleport Manager"].commands[4])
                end
                return false
                ---------------------------------------------------------
                -- LIST ALL COMMAND --
            elseif (command == settings.mod["Teleport Manager"].commands[5]) then
                if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Teleport Manager", true, "warplistall") then
                    check_file_status(PlayerIndex)
                    if not empty_file then
                        local lines = lines_from(file_name)
                        for k, v in pairs(lines) do
                            rprint(PlayerIndex, "[" .. k .. "] " .. v)
                        end
                    else
                        rprint(PlayerIndex, "The teleport list is empty!")
                    end
                else
                    rprint(PlayerIndex, "You're not allowed to execute /" .. settings.mod["Teleport Manager"].commands[5])
                end
                return false
                ---------------------------------------------------------
                -- DELETE COMMAND --
            elseif (command == settings.mod["Teleport Manager"].commands[6]) then
                if tonumber(get_var(PlayerIndex, "$lvl")) >= getPermLevel("Teleport Manager", true, "delwarp") then
                    if t[2] ~= nil then
                        check_file_status(PlayerIndex)
                        if not empty_file then
                            local lines = lines_from(file_name)
                            local found
                            for k, v in pairs(lines) do
                                if k ~= nil then
                                    if t[2] == v:match(k) then
                                        found = true
                                        if find(v, mapname) then
                                            delete_from_file(file_name, k, 1, PlayerIndex)
                                            rprint(PlayerIndex, "Successfully deleted teleport id #" .. k)
                                        else
                                            wait_for_response[PlayerIndex] = true
                                            rprint(PlayerIndex, "Warning: That teleport is not linked to this map.")
                                            rprint(PlayerIndex, "Type 'YES' to delete, type 'NO' to cancel.")
                                            --noinspection GlobalCreationOutsideO
                                            function getWarp()
                                                return tonumber(k)
                                            end
                                        end
                                    end
                                end
                            end
                            if not (found) then
                                rprint(PlayerIndex, "Teleport Index ID does not exist!")
                            end
                        else
                            rprint(PlayerIndex, "The teleport list is empty!")
                        end
                    else
                        rprint(PlayerIndex, "Invalid Syntax. Command Usage: /" .. settings.mod["Teleport Manager"].commands[6] .. " <index id>")
                    end
                else
                    rprint(PlayerIndex, "You're not allowed to execute /" .. settings.mod["Teleport Manager"].commands[6])
                end
                return false
            end
        end
    end
end

-- Used Globally
function OnDamageApplication(PlayerIndex, CauserIndex, MetaID, Damage, HitString, Backtap)
    -- #Lurker
    if (settings.mod["Lurker"].enabled) then
        if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex) then
            if (lurker[CauserIndex] == true) then
                return false
            end
        end
    end
    -- #Infinity Ammo
    if (settings.mod["Infinity Ammo"].enabled) then
        if (tonumber(CauserIndex) > 0 and PlayerIndex ~= CauserIndex) then
            if (modify_damage[CauserIndex] == true) then
                return true, Damage * tonumber(damage_multiplier[CauserIndex])
            end
        end
    end
end

function OnWeaponPickup(PlayerIndex, WeaponIndex, Type)
    -- #Lurker
    if (settings.mod["Lurker"].enabled) then
        if (lurker[PlayerIndex] == true) then
            if tonumber(Type) == 1 then
                local PlayerObj = get_dynamic_player(PlayerIndex)
                local WeaponObj = get_object_memory(read_dword(PlayerObj + 0x2F8 + (tonumber(WeaponIndex) - 1) * 4))
                local name = read_string(read_dword(read_word(WeaponObj) * 32 + 0x40440038))
                if (name == "weapons\\flag\\flag" or name == "weapons\\ball\\ball") then
                    if (name == "weapons\\flag\\flag") then
                        object_picked_up[PlayerIndex] = "flag"
                    elseif (name == "weapons\\ball\\ball") then
                        object_picked_up[PlayerIndex] = "oddball"
                    end
                    lurker_warnings[PlayerIndex] = lurker_warnings[PlayerIndex] - 1
                    lurker_warn[PlayerIndex] = true
                    has_objective[PlayerIndex] = true
                end
            end
        end
    end
    -- #Infinity Ammo
    if (settings.mod["Infinity Ammo"].enabled and infammo[PlayerIndex]) then
        adjust_ammo(PlayerIndex)
    end
end

function OnWeaponDrop(PlayerIndex)
    -- #Lurker
    if (settings.mod["Lurker"].enabled) then
        if (lurker[PlayerIndex] == true and has_objective[PlayerIndex] == true) then
            cls(PlayerIndex)
            has_objective[PlayerIndex] = false
            resetLurker(PlayerIndex)
        end
    end
end

function killSilently(PlayerIndex)
    local kill_message_addresss = sig_scan("8B42348A8C28D500000084C9") + 3
    local original = read_dword(kill_message_addresss)
    safe_write(true)
    write_dword(kill_message_addresss, 0x03EB01B1)
    safe_write(false)
    execute_command("kill " .. tonumber(PlayerIndex))
    safe_write(true)
    write_dword(kill_message_addresss, original)
    safe_write(false)

    -- Deduct one death
    local deaths = tonumber(get_var(PlayerIndex, "$deaths"))
    execute_command("deaths " .. tonumber(PlayerIndex) .. " " .. deaths - 1)
end

function setLurker(PlayerIndex, bool)
    if bool then
        lurker[PlayerIndex] = true
        if (settings.mod["Lurker"].god) then
            execute_command("god " .. tonumber(PlayerIndex))
        end
        if (settings.mod["Lurker"].camouflage) then
            execute_command("camo " .. tonumber(PlayerIndex))
        end
        if (settings.mod["Lurker"].announcer) then
            announce(PlayerIndex, get_var(PlayerIndex, "$name") .. " is now in lurker mode! [spectator]")
        end
    else
        lurker[PlayerIndex] = false
        if (settings.mod["Lurker"].speed) then
            execute_command("s " .. tonumber(PlayerIndex) .. " " .. tonumber(settings.mod["Lurker"].default_running_speed))
        end
        if (settings.mod["Lurker"].god == true) then
            execute_command("ungod " .. tonumber(PlayerIndex))
        end
        killSilently(PlayerIndex)
        resetLurker(PlayerIndex)
        cls(PlayerIndex)
        if (settings.mod["Lurker"].announcer) then
            announce(PlayerIndex, get_var(PlayerIndex, "$name") .. " is no longer in lurker mode! [spectator]")
        end
    end
end

function resetLurker(PlayerIndex)
    local p_table = get_var(PlayerIndex, "$name") .. ", " .. get_var(PlayerIndex, "$hash")
    lurker_warn[PlayerIndex] = false
    players[p_table].lurker_timer = 0
end

function getWarnings(PlayerIndex)
    return lurker_warnings[PlayerIndex]
end

-- #Player List
function listPlayers(PlayerIndex, count)
    if (count == 1) then
        local header, ffa

        if (getTeamPlay()) then
            header = "|" .. settings.mod["Player List"].alignment .. " [ ID.    -    Name.    -    Team.    -    IP. ]"
        else
            header = "|" .. settings.mod["Player List"].alignment .. " [ ID.    -    Name.    -    IP. ]"
        end
        rprint(PlayerIndex, header)

        for i = 1, 16 do
            if player_present(i) then
                local name, id, team, ip = get_var(i, "$name"), get_var(i, "$n"), get_var(i, "$team"), get_var(i, "$ip")
                if (getTeamPlay()) then
                    if team == "red" then
                        team = "Red"
                    elseif team == "blue" then
                        team = "Blue"
                    else
                        team = "Hidden"
                    end
                else
                    ffa = true
                end
                if not (ffa) then
                    rprint(PlayerIndex, "|" .. settings.mod["Player List"].alignment .. "     " .. id .. ".         " .. name .. "   |   " .. team .. "   |   " .. ip)
                else
                    rprint(PlayerIndex, "|" .. settings.mod["Player List"].alignment .. "     " .. id .. ".         " .. name .. "   |   " .. ip)
                end
            end
        end
    else
        rprint(PlayerIndex, "Invalid Syntax")
        return false
    end
end

-- #Command Spy
function CommandSpy(Message)
    for i = 1, 16 do
        if (tonumber(get_var(i, "$lvl"))) >= getPermLevel("Command Spy", nil, nil) then
            rprint(i, Message)
        end
    end
end

function OnObjectSpawn(PlayerIndex, MapID, ParentID, ObjectID)
    if PlayerIndex then
        -- #Infinity Ammo
        if (settings.mod["Infinity Ammo"].enabled and infammo[PlayerIndex]) then
            adjust_ammo(PlayerIndex)
        end
    end
end

-- Used Globally
function read_widestring(address, length)
    local count = 0
    local byte_table = {}
    for i = 1, length do
        if read_byte(address + count) ~= 0 then
            byte_table[i] = string.char(read_byte(address + count))
        end
        count = count + 2
    end
    return concat(byte_table)
end

-- Used Globally
function table.match(table, value)
    for k, v in pairs(table) do
        if v == value then
            return k
        end
    end
end

-- Clears the players console
function cls(PlayerIndex)
    for _ = 1, 25 do
        rprint(PlayerIndex, " ")
    end
end

-- Used Globally
function tokenizestring(inputString, Separator)
    if Separator == nil then
        Separator = "%s"
    end
    local t = {};
    local i = 1
    for str in string.gmatch(inputString, "([^" .. Separator .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

-- Used Globally
function getPermLevel(script, bool, args)
    local level = 0
    local trigger
    local permission_table

    -- getPermLevel("Script Name", nil, nil)
    if (script ~= nil and bool == nil and args == nil) then
        level = settings.mod[script].permission_level

        -- getPermLevel(nil, nil, "admin_type")
    elseif (script == nil and bool == nil and args ~= nil) then
        permission_table = settings.global.permission_level
        trigger = true

        -- [ getPermLevel("Script Name", true, "admin_type")
    elseif (script ~= nil and bool == true and args ~= nil) then
        trigger = true
        permission_table = settings.mod["Teleport Manager"].permission_level
    end

    if (trigger) and (permission_table ~= nil) then
        for k, v in pairs(permission_table) do
            local words = tokenizestring(v, ",")
            for i = 1, #words do
                if (tostring(k) == args) then
                    level = words[i]
                    break
                end
            end
        end
    end
    -- ]
    return tonumber(level)
end

-- Used Globally
function getTeamPlay()
    if get_var(0, "$ffa") == "0" then
        return true
    else
        return false
    end
end

-- Used Globally
function lines_from(file)
    local lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

-- Used Globally
function PlayerInVehicle(PlayerIndex)
    if (get_dynamic_player(PlayerIndex) ~= 0) then
        local VehicleID = read_dword(get_dynamic_player(PlayerIndex) + 0x11C)
        if VehicleID == 0xFFFFFFFF then
            return false
        else
            return true
        end
    else
        return false
    end
end

-- Used Globally
function TeleportPlayer(ObjectID, x, y, z)
    if get_object_memory(ObjectID) ~= 0 then
        local veh_obj = get_object_memory(read_dword(get_object_memory(ObjectID) + 0x11C))
        write_vector3d((veh_obj ~= 0 and veh_obj or get_object_memory(ObjectID)) + 0x5C, x, y, z)
    end
end

-- Prints enabled scripts | Called by OnScriptLoad()
function printEnabled()
    cprint("\n----- [ BASE GAME SETTINGS ] -----", 3 + 5)
    for k, _ in pairs(settings.mod) do
        if (settings.mod[k].enabled) then
            cprint(k .. " is enabled", 2 + 8)
        else
            cprint(k .. " is disabled", 4 + 8)
        end
    end
    cprint("----------------------------------\n", 3 + 5)
end

-- #Spawn From Sky
function timeUntilRestore(PlayerIndex)
    local p_table = get_var(PlayerIndex, "$name") .. ", " .. get_var(PlayerIndex, "$hash")
    players[p_table].sky_timer = players[p_table].sky_timer + 0.030
    if (players[p_table].sky_timer >= (settings.mod["Spawn From Sky"].maps[mapname].invulnerability)) then
        players[p_table].sky_timer = 0
        init_timer[tonumber(PlayerIndex)] = false
        execute_command("ungod " .. tonumber(PlayerIndex))
    end
end

-- #Infinity Ammo
function getFrags(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if player_object ~= 0 and player_present(PlayerIndex) then
        safe_read(true)
        local frags = read_byte(player_object + 0x31E)
        local plasmas = read_byte(player_object + 0x31F)
        safe_read(false)
        if tonumber(frags) <= 0 or tonumber(plasmas) <= 0 then
            return true
        end
    end
    return false
end

-- #Weapon Settings
function loadWeaponTags()
    pistol = "weapons\\pistol\\pistol"
    sniper = "weapons\\sniper rifle\\sniper rifle"
    plasma_cannon = "weapons\\plasma_cannon\\plasma_cannon"
    rocket_launcher = "weapons\\rocket launcher\\rocket launcher"
    plasma_pistol = "weapons\\plasma pistol\\plasma pistol"
    plasma_rifle = "weapons\\plasma rifle\\plasma rifle"
    assault_rifle = "weapons\\assault rifle\\assault rifle"
    flamethrower = "weapons\\flamethrower\\flamethrower"
    needler = "weapons\\needler\\mp_needler"
    shotgun = "weapons\\shotgun\\shotgun"
end

-- Returns the static memory address of the player table entry.
function getPlayer(PlayerIndex)
    if tonumber(PlayerIndex) then
        if tonumber(PlayerIndex) ~= 0 then
            local player = get_player(PlayerIndex)
            if player ~= 0 then
                return player
            end
        end
    end
    return nil
end

-- Returns player hash
function getHash(PlayerIndex)
    if PlayerIndex ~= nil and PlayerIndex ~= "-1" then
        local hash = get_var(PlayerIndex, "$hash")
        return hash
    end
    return nil
end

function table.val_to_str(v)
    if "string" == type(v) then
        v = gsub(v, "\n", "\\n")
        if match(gsub(v, "[^'\"]", ""), '^" + $') then
            return "'" .. v .. "'"
        end
        return '"' .. gsub(v, '"', '\\"') .. '"'
    else
        return "table" == type(v) and table.tostring(v) or tostring(v)
    end
end

function table.key_to_str(k)
    if "string" == type(k) and match(k, "^[_%a][_%a%d]*$") then
        return k
    else
        return "[" .. table.val_to_str(k) .. "]"
    end
end

function table.tostring(tbl)
    local result, done = {}, {}
    for k, v in ipairs(tbl) do
        table.insert(result, table.val_to_str(v))
        done[k] = true
    end
    for k, v in pairs(tbl) do
        if not done[k] then
            table.insert(result, table.key_to_str(k) .. "=" .. table.val_to_str(v))
        end
    end
    return "{" .. concat(result, ",") .. "}"
end

-- #Alias System
function addAlias(name, hash)
    local file_name = settings.mod["Alias System"].dir
    checkFile(file_name)
    local file = io.open(file_name, "r")
    local data = file:read("*a")
    file:close()
    if match(data, hash) then
        local lines = lines_from(file_name)
        for _, v in pairs(lines) do
            if match(v, hash) then
                if not v:match(name) then
                    local alias = v .. ", " .. name
                    local f1 = io.open(file_name, "r")
                    local content = f1:read("*all")
                    f1:close()
                    content = gsub(content, v, alias)
                    local f2 = io.open(file_name, "w")
                    f2:write(content)
                    f2:close()
                end
            end
        end
    else
        local file = assert(io.open(file_name, "a+"))
        file:write(hash .. ":" .. name .. "\n")
        file:close()
    end
end

-- Used Globally
function checkFile(dir)
    local file_name = dir
    local file = io.open(file_name, "rb")
    if file then
        file:close()
        return true
    else
        local file = io.open(file_name, "a+")
        if file then
            file:close()
            return true
        end
    end
end

-- #Alias System
function concatAliases(i, start_index, end_index)
    local t = {}
    local row, words, aliases
    local file_name = settings.mod["Alias System"].dir
    local lines = lines_from(file_name)
    for _, v in pairs(lines) do
        if v:match(target_hash) then
            aliases = v:match(":(.+)")
            words = tokenizestring(aliases, ",")
        end
    end
    for j = tonumber(start_index), tonumber(end_index) do
        t[#t + 1] = words[j]
        row = concat(t, ", ")
    end
    if row ~= nil then
        rprint(i, row)
    end
    for _ in pairs(t) do
        t[_] = nil
    end
end

-- #Teleport Manager
function check_file_status(PlayerIndex)
    local file_name = settings.mod["Teleport Manager"].dir
    local fileX = io.open(file_name, "rb")
    if fileX then
        fileX:close()
    else
        local fileY = io.open(file_name, "a+")
        if fileY then
            fileY:close()
        end
        if player_present(PlayerIndex) then
            rprint(PlayerIndex, file_name .. " doesn't exist. Creating...")
            cprint(file_name .. " doesn't exist. Creating...")
        end
    end
    local fileZ = io.open(file_name, "r")
    local line = fileZ:read()
    if line == nil then
        empty_file = true
    else
        empty_file = false
    end
    fileZ:close()
end

-- Used Globally
function delete_from_file(filename, starting_line, num_lines, PlayerIndex)

    local fp = io.open(filename, "r")
    if fp == nil then
        check_file_status(PlayerIndex)
    end
    local t = {}
    i = 1;
    for line in fp:lines() do
        if i < starting_line or i >= starting_line + num_lines then
            t[#t + 1] = line
        end
        i = i + 1
    end
    if i > starting_line and i < starting_line + num_lines then
        rprint(PlayerIndex, "Warning: End of File! No entries to delete.")
        cprint("Warning: End of File! No entries to delete.")
    end
    fp:close()
    fp = io.open(filename, "w+")
    for i = 1, #t do
        fp:write(string.format("%s\n", t[i]))
    end
    fp:close()
end

-- SAPP | Mute Handler
function removeEntry(ip, hash, PlayerIndex)
    local file_name = settings.global.mute_dir
    if checkFile(file_name) then
        local file = io.open(file_name, "r")
        file:close()
        local lines = lines_from(file_name)
        for k, v in pairs(lines) do
            if k ~= nil then
                if match(v, ip) and match(v, hash) then
                    delete_from_file(file_name, k, 1, PlayerIndex)
                end
            end
        end
    end
end

function CheckForFlag(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    for i = 0, 3 do
        local weapon_id = read_dword(player_object + 0x2F8 + 0x4 * i)
        if (weapon_id ~= 0xFFFFFFFF) then
            local weap_object = get_object_memory(weapon_id)
            if (weap_object ~= 0) then
                local tag_address = read_word(weap_object)
                local tagdata = read_dword(read_dword(0x40440000) + tag_address * 0x20 + 0x14)
                if (read_bit(tagdata + 0x308, 3) == 1) then
                    return true
                end
            end
        end
    end
    return false
end

function DestroyObject(object)
    if object then
        destroy_object(object)
    end
end

function CleanUpDrones(TargetID, TableID)
    -- Enter Vehicle
    local function CleanVehicles(TargetID)
        if EV_drone_table[TargetID] ~= nil then
            for k, v in pairs(EV_drone_table[TargetID]) do
                if EV_drone_table[TargetID][k] > 0 then
                    if v then
                        destroy_object(v)
                        EV_drone_table[TargetID][k] = nil
                    end
                end
            end
            EV_drone_table[TargetID] = nil
            ev_NewVehicle[TargetID] = nil
        end
    end

    -- Item Spawner
    local function CleanItems(TargetID)
        if IS_drone_table[TargetID] ~= nil then
            for k, v in pairs(IS_drone_table[TargetID]) do
                if IS_drone_table[TargetID][k] > 0 then
                    if v then
                        destroy_object(v)
                        IS_drone_table[TargetID][k] = nil
                    end
                end
            end
            IS_drone_table[TargetID] = nil
            item_objects[TargetID] = nil
        end
    end

    if (TableID == 1) then
        CleanVehicles(TargetID)
    elseif (TableID == 2) then
        CleanItems(TargetID)
    elseif (TableID == "all") then
        CleanVehicles(TargetID)
        CleanItems(TargetID)
    end
end

function secondsToTime(seconds, places)

    local years = floor(seconds / (60 * 60 * 24 * 365))
    seconds = seconds % (60 * 60 * 24 * 365)
    local weeks = floor(seconds / (60 * 60 * 24 * 7))
    seconds = seconds % (60 * 60 * 24 * 7)
    local days = floor(seconds / (60 * 60 * 24))
    seconds = seconds % (60 * 60 * 24)
    local hours = floor(seconds / (60 * 60))
    seconds = seconds % (60 * 60)
    local minutes = floor(seconds / 60)
    seconds = seconds % 60

    if places == 6 then
        return string.format("%02d:%02d:%02d:%02d:%02d:%02d", years, weeks, days, hours, minutes, seconds)
    elseif places == 5 then
        return string.format("%02d:%02d:%02d:%02d:%02d", weeks, days, hours, minutes, seconds)
    elseif not places or places == 4 then
        return days, hours, minutes, seconds
    elseif places == 3 then
        return string.format("%02d:%02d:%02d", hours, minutes, seconds)
    elseif places == 2 then
        return string.format("%02d:%02d", minutes, seconds)
    elseif places == 1 then
        return string.format("%02", seconds)
    end
end

function getCurrentVersion(bool)
    local http_client
    local ffi = require("ffi")
    ffi.cdef [[
        typedef void http_response;
        http_response *http_get(const char *url, bool async);
        void http_destroy_response(http_response *);
        void http_wait_async(const http_response *);
        bool http_response_is_null(const http_response *);
        bool http_response_received(const http_response *);
        const char *http_read_response(const http_response *);
        uint32_t http_response_length(const http_response *);
    ]]
    http_client = ffi.load("lua_http_client")

    local function GetPage(URL)
        local response = http_client.http_get(URL, false)
        local returning = nil
        if http_client.http_response_is_null(response) ~= true then
            local response_text_ptr = http_client.http_read_response(response)
            returning = ffi.string(response_text_ptr)
        end
        http_client.http_destroy_response(response)
        return returning
    end

    local url = 'http://raw.githubusercontent.com/Chalwk77/HALO-SCRIPT-PROJECTS/master/INDEV/Base%20Game%20Settings.lua'
    local version = GetPage(url):match("script_version = (%d+.%d+)")

    if (bool == true) then
        if (tonumber(version) ~= settings.global.script_version) then
            cprint("============================================================================", 5 + 8)
            cprint("[BGS] Version " .. tostring(version) .. " is available for download.")
            cprint("Current version: v" .. settings.global.script_version, 5 + 8)
            cprint("============================================================================", 5 + 8)
        else
            cprint("[BGS] Version " .. settings.global.script_version, 2 + 8)
        end
    end
    return tonumber(version)
end

function report()
    cprint("--------------------------------------------------------", 5 + 8)
    cprint("Please report this error on github:", 7 + 8)
    cprint("https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues", 7 + 8)
    cprint("--------------------------------------------------------", 5 + 8)
end

function OnError()
    cprint(debug.traceback(), 4 + 8)
    timer(50, "report")
end

function RecordChanges()
    local file = io.open("sapp\\bgs_changelog.txt", "w")
    local cl = {}

    cl[#cl + 1] = "[2/22/19]"
    cl[#cl + 1] = "I have made some heavy tweaks the /clean command (which was previously exclusive to the 'Enter Vehicle' mod)"
    cl[#cl + 1] = "in order to accommodate a new system that tracks objects spawned with both Enter vehicle and Item Spawner."
    cl[#cl + 1] = ""
    cl[#cl + 1] = "The base command is the same. However, the command arguments have changed:"
    cl[#cl + 1] = ""
    cl[#cl + 1] = "Valid [id] inputs: [number range 1-16, me or *]"
    cl[#cl + 1] = "/clean [id] 1 (cleans up 'Enter Vehicle' objects)"
    cl[#cl + 1] = "/clean [id] 2 (cleans up 'Item Spawner' objects)"
    cl[#cl + 1] = "/clean [id] * (cleans up 'everything')"
    cl[#cl + 1] = ""
    cl[#cl + 1] = "Also, to clear up any confusion should there be any, /clean * * is valid - This will clean everything for everybody."
    cl[#cl + 1] = "Additionally, you can toggle on|off garbage collection (on death, on disconnect) in the config sections of the respective mods."
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[2/23/19]"
    cl[#cl + 1] = "You can now use Lurker mode while Infinity Ammo is enabled,"
    cl[#cl + 1] = "but you cannot manipulate damage multipliers."
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""
    cl[#cl + 1] = ""
    cl[#cl + 1] = "[2/24/19]"
    cl[#cl + 1] = "Fixed a map check error relating to Respawn Time"
    cl[#cl + 1] = "-------------------------------------------------------------------------------------------------------------------------------"
    cl[#cl + 1] = ""

    file:write(concat(cl, "\n"))
    file:close()
    cprint("[BGS] Writing changelog... ", 2 + 8)
    for _ in pairs(cl) do
        cl[_] = nil
    end
end