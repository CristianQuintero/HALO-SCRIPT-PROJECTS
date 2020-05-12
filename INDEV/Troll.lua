--[[
--=====================================================================================================--
Script Name: Server Fun Plus (remake), for SAPP (PC & CE)

Credits to Kavawuvi and Devieth for functions at bottom of script.

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--


api_version = "1.12.0.0"

-- Configuration [STARTS] ------------------------------------------------------
local Troll = {

    -- Randomly prevent bullets from dealing damage:
    ["No Weapon Damage"] = {
        enabled = true,
        ignore_admins = true,
        -- Admins AT or BELOW this level will be effected (unless "affect_all_players" is true)
        ignore_admin_level = 1,
    },

    -- Jumble 1-2 characters in some sentences:
    ["Chat Text Randomizer"] = {
        enabled = true,
        ignore_admins = true,
        ignore_admin_level = 1,
        min_chances = 1, -- 1 in 6 chance of your messages being randomized every time you chat.
        max_chances = 6,
        format = {

            --[[ Custom Variables:

                %name% - will output the players name
                %msg% - will output message
                "%id% - will output the Player Index ID

            --]]

            global = "%name%: %msg%",
            team = "[%name%]: %msg%",
            vehicle = "[%name%]: %msg%"
        }
    },

    -- Inexplicable Deaths (no death message):
    ["Silent Kill"] = {
        enabled = true,
        ignore_admins = true,
        ignore_admin_level = 1,

        -- When a player spawns, the interval until they are killed is randomized.
        -- The interval itself is an amount of seconds between "min" and "max".
        min = 1, -- in seconds
        max = 300, -- in seconds
    },

    -- Randomly set Z axis to -0.5/WU:
    ["Teleport Under Map"] = {
        enabled = true,
        ignore_admins = true,
        ignore_admin_level = 1,

        -- Players will be teleported a random number of world units under the map.
        -- The value of W/Units is a random number between minZ, maxZ
        minZ = 0.3, -- in world units
        maxZ = 0.7, -- in world units

        -- Players will be teleported under the map at a random time between min/max seconds.
        min = 60, -- in seconds
        max = 300, -- in seconds
    },

    -- Randomly force player to drop flag:
    ["Flag Dropper"] = {
        enabled = true,
        ignore_admins = true,
        ignore_admin_level = 1,

        -- When a player pick up the flag, the interval until they drop it is randomized.
        -- The interval itself is an amount of seconds between "min" and "max".
        min = 1, -- in seconds
        max = 120, -- in seconds
    },

    -- Randomly eject player from vehicle:
    ["Vehicle Exit"] = {
        enabled = true,
        ignore_admins = true,
        ignore_admin_level = 1,

        -- When a player enters a vehicle, the interval until they are forced to exit is randomized.
        -- The interval itself is an amount of seconds between "min" and "max".
        min = 5, -- in seconds
        max = 120, -- in seconds
    },

    -- Change name on join to something random
    ["Name Changer"] = {
        enabled = true,
        ignore_admins = true,
        ignore_admin_level = 1,

        -- When a player joins, their new name will be randomly selected from this list.
        names = { -- Max 11 Characters only!
            { "iLoveAG" },
            { "iLoveV3" },
            { "loser4Eva" },
            { "iLoveChalwk" },
            { "iLoveSe7en" },
            { "iLoveAussie" },
            { "benDover" },
            { "clitEruss" },
            { "tinyDick" },
            { "cumShot" },
            { "PonyGirl" },
            { "iAmGroot" },
            { "twi$t3d" },
            { "maiBahd" },
            { "frown" },
            { "Laugh@me" },
            { "imaDick" },
            { "facePuncher" },
            { "TEN" },
            { "whatElse" },

            -- Repeat the structure to add more entries!
        }
    },

    -- Randomly change weapon ammo/battery:
    ["Ammo Changer"] = {
        enabled = true,
        ignore_admins = true,
        ignore_admin_level = 1,
        ammo = 0,
        mag = 0,
        battery = 0,
    },

    -- Forced Disconnect:
    ["Silent Kick"] = {
        enabled = true,
        ignore_admins = true,
        ignore_admin_level = 1,

        announcements = {
            enabled = false,
            msg = "%name% was silently disconnected from the server!"
        },

        -- When a player joins, the interval until they are kicked is randomized.
        -- The interval itself is an amount of seconds between "min" and "max".
        min = 60, -- in seconds
        max = 300, -- in seconds
    },

    -- Random Color Change:
    ["Random Color Change"] = {
        enabled = true,
        ignore_admins = true,
        ignore_admin_level = 1,

        -- COLOR ID, Enabled/Disabled
        colors = {
            { 0, true }, --white
            { 1, true }, --black
            { 2, true }, --red
            { 3, true }, --blue
            { 4, true }, --gray
            { 5, true }, --yellow
            { 6, true }, --green
            { 7, true }, --pink
            { 8, true }, --purple
            { 9, true }, --cyan
            { 10, true }, --cobalt
            { 11, true }, --orange
            { 12, true }, --teal
            { 13, true }, --sage
            { 14, true }, --brown
            { 15, true }, --tan
            { 16, true }, --maroon
            { 17, true } --salmon
        }
    },
}

local server_prefix = "**SAPP**"

-- [!] WARNING: If this is true, "affected_users_only" MUST be false.
local affect_all_players = true

local affected_users_only = false
local affected_users = {
    "127.0.0.1", -- Local Host
    "108.5.107.145" -- DeathBringR
}

-- Configuration [ENDS] ------------------------------------------------------

local players = { }
local gsub, sub, gmatch = string.gsub, string.sub, string.gmatch
local floor = math.floor
local time_scale = 1 / 30

local flag, globals, ls = { }, nil
local network_struct

function OnScriptLoad()

    -- Register needed event callbacks:
    register_callback(cb["EVENT_TICK"], "OnTick")

    register_callback(cb['EVENT_PREJOIN'], "OnPlayerPreJoin")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")

    register_callback(cb["EVENT_CHAT"], "OnPlayerChat")

    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_VEHICLE_ENTER"], "OnVehicleEntry")

    register_callback(cb["EVENT_PRESPAWN"], "OnPreSpawn")

    local gp = sig_scan("8B3C85????????3BF9741FE8????????8B8E2C0200008B4610") + 3
    if (gp == 3) then
        return
    end
    globals = read_dword(gp)

    LSS(true)

    network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)

    if (get_var(0, "$gt") ~= "n/a") then
        players = { }
        for i = 1, 16 do
            if player_present(i) then
                InitPlayer(i, false)
            end
        end
    end
end

function OnScriptUnload()
    LSS(false)
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        players = { }
        flag = { read_word(globals + 0x8), read_word(globals + 0xc) }
        local names = Troll["Name Changer"].names
        for i = 1, #names do
            names[i].used = false
        end
    end
end

function OnGameEnd()

end

function OnTick()
    for player, v in pairs(players) do
        if (player) and player_present(player) then

            local DynamicPlayer = get_dynamic_player(player)
            math.randomseed(os.time())

            if player_alive(player) then
                local silentkill = Troll["Silent Kill"]
                if (silentkill.enabled) and TrollPlayer(player, silentkill) then

                    v[3].timer = v[3].timer + time_scale
                    if (v[3].timer >= v[3].time_until_kill) then
                        KillSilently(player)
                    end
                end

                local tpundermap = Troll["Teleport Under Map"]
                if (tpundermap.enabled) and TrollPlayer(player, tpundermap) then
                    if (not InVehicle(DynamicPlayer)) then
                        v[4].timer = v[4].timer + time_scale
                        if (math.floor(v[4].timer) >= v[4].time_until_tp) then
                            v[4].timer = 0
                            v[4].time_until_tp = math.random(tpundermap.min, tpundermap.max)
                            local x, y, z = read_vector3d(DynamicPlayer + 0x5c)
                            write_vector3d(DynamicPlayer + 0x5c, x, y, z - v[4].zaxis)
                        end
                    end
                end

                local flagdropper = Troll["Flag Dropper"]
                if (flagdropper.enabled) and TrollPlayer(player, flagdropper) then
                    if (not InVehicle(DynamicPlayer)) then
                        if holdingFlag(DynamicPlayer) then
                            v[5].hasflag = true
                            v[5].timer = v[5].timer + time_scale
                            if (math.floor(v[5].timer) >= v[5].time_until_drop) then
                                drop_weapon(player)
                            end
                        elseif (v[5].hasflag) then
                            v[5].hasflag = false
                            v[5].time_until_drop = math.random(flagdropper.min, flagdropper.max)
                            v[5].timer = 0
                        else
                            v[5].timer = 0
                        end
                    end
                end

                local vehicleexit = Troll["Vehicle Exit"]
                if (vehicleexit.enabled) and TrollPlayer(player, vehicleexit) then
                    if InVehicle(DynamicPlayer) then
                        v[6].timer = v[6].timer + time_scale
                        if (v[6].timer >= v[6].time_until_exit) then
                            exit_vehicle(player)
                        end
                    end
                end
            end

            -- Player does not need to be alive to execute blocks of code below this line:
            local silentkick = Troll["Silent Kick"]
            if (silentkick.enabled) and TrollPlayer(player, silentkick) then
                v[9].timer = v[9].timer + time_scale
                if (v[9].timer >= v[9].time_until_kick) then
                    SilentKick(player)
                end
            end
        end
    end
end

function OnPlayerPreJoin(P)
    InitPlayer(P, false)
end

function OnPlayerDisconnect(P)
    InitPlayer(P, true)
end

function OnPreSpawn(P)

    local t = players[P]
    math.randomseed(os.time())

    if (t ~= nil) then

        local colorchange = Troll["Random Color Change"]
        if (colorchange.enabled) and TrollPlayer(P, colorchange) then
            local player = get_player(P)
            if (player ~= 0) then
                local id = tonumber(t[10].color())
                write_byte(player + 0x60, id)
            end
        end

        local silentkill = Troll["Silent Kill"]
        if (silentkill.enabled) and TrollPlayer(P, silentkill) then
            t[3].timer = 0
            t[3].time_until_kill = math.random(Troll["Silent Kill"].min, Troll["Silent Kill"].max)
        end

        local tpundermap = Troll["Teleport Under Map"]
        if (tpundermap.enabled) and TrollPlayer(P, tpundermap) then
            t[4].zaxis = math.random(Troll["Teleport Under Map"].minZ, Troll["Teleport Under Map"].maxZ)
            t[4].time_until_tp = math.random(Troll["Teleport Under Map"].min, Troll["Teleport Under Map"].max)
        end
    end
end

function OnPlayerChat(P, Message, Type)
    if (Type ~= 6) then
        local p = players[P]
        if (p ~= nil) then
            local t = Troll["Chat Text Randomizer"]
            if (t.enabled) and TrollPlayer(P, t) then

                local Msg = StrSplit(Message)
                if (Msg == nil or Msg == "") then
                    return
                elseif (not isChatCmd(Msg)) then

                    if (p[2].chance() == 1) then

                        local new_message = ShuffleWords(Message)
                        local formatMsg = function(Msg)
                            local patterns = {
                                { "%%name%%", p.name },
                                { "%%msg%%", new_message },
                                { "%%id%%", P }
                            }
                            for i = 1, #patterns do
                                Msg = (gsub(Msg, patterns[i][1], patterns[i][2]))
                            end
                            return Msg
                        end

                        execute_command("msg_prefix \"\"")
                        if (Type == 0) then
                            say_all(formatMsg(t.format.global))
                        elseif (Type == 1) then
                            SayTeam(P, formatMsg(t.format.team))
                        elseif (Type == 2) then
                            SayTeam(P, formatMsg(t.format.vehicle))
                        end
                        execute_command("msg_prefix \" " .. server_prefix .. "\"")
                        return false
                    end
                end
            end
        end
    end
end

function OnVehicleEntry(P, _)
    if (players[P] ~= nil) then
        local t = Troll["Vehicle Exit"]
        if (t.enabled) and TrollPlayer(P, t) then
            players[P][6].timer = 0
            players[P][6].time_until_exit = math.random(t.min, t.max)
        end
    end
end

function ChangeName(P)
    if (players[P] ~= nil) then
        local nc = Troll["Name Changer"]
        if (nc.enabled) and TrollPlayer(P, nc) then
            local client_network_struct = network_struct + 0x1AA + 0x40 + to_real_index(P) * 0x20
            write_widestring(client_network_struct, string.sub(GetRandomName(P), 1, 11), 12)
        end
    end
end

function SayTeam(P, Message)
    for i = 1, 16 do
        if player_present(i) then
            if get_var(i, "$team") == get_var(P, "$team") then
                say(i, Message)
            end
        end
    end
end

function InitPlayer(P, Reset)
    if (Reset) then

        local nc = Troll["Name Changer"]
        if (nc.enabled) and TrollPlayer(P, nc) then
            local id = players[P][7].name_id
            if (nc.names[id] ~= nil) then
                nc.names[id].used = false
            end
        end

        players[P] = nil

    else

        local Case = function()
            local ip = get_var(P, "$ip"):match("%d+.%d+.%d+.%d+")
            for i = 1, #affected_users do
                if (ip == affected_users[i] or (not affected_users_only) or affect_all_players) then
                    return true
                end
            end
            return false
        end

        if (Case) then

            math.randomseed(os.time())
            players[P] = {
                name = get_var(P, "$name"),
                [1] = { -- No Weapon Damage

                },
                [2] = { -- Chat Text Randomizer
                    chance = function()
                        return math.random(Troll["Chat Text Randomizer"].min_chances, Troll["Chat Text Randomizer"].max_chances)
                    end
                },
                [3] = { -- Silent Kill
                    timer = 0,
                    time_until_kill = math.random(Troll["Silent Kill"].min, Troll["Silent Kill"].max)
                },
                [4] = { -- Teleport Under Map
                    timer = 0,
                    zaxis = math.random(Troll["Teleport Under Map"].minZ, Troll["Teleport Under Map"].maxZ),
                    time_until_tp = math.random(Troll["Teleport Under Map"].min, Troll["Teleport Under Map"].max)
                },
                [5] = { -- Flag Dropper
                    timer = 0,
                    hasflag = false,
                    time_until_drop = math.random(Troll["Flag Dropper"].min, Troll["Flag Dropper"].max)
                },
                [6] = { -- Vehicle Exit
                    timer = 0,
                    time_until_exit = math.random(Troll["Vehicle Exit"].min, Troll["Vehicle Exit"].max)
                },
                [7] = { -- Name Changer
                    name_id = 0,
                },
                [8] = { -- Ammo Changer

                },
                [9] = { -- Silent Kick
                    timer = 0,
                    broadcast = true,
                    time_until_kick = math.random(Troll["Silent Kick"].min, Troll["Silent Kick"].max)
                },
                [10] = { -- Random Color Change
                    color = function()

                        local temp = { }
                        local colors = Troll["Random Color Change"].colors
                        for i = 1, #colors do
                            if (colors[i][2]) then
                                temp[#temp + 1] = colors[i][1]
                            end
                        end

                        if (#temp > 0) then
                            return math.random(#temp)
                        end

                        return 0
                    end
                }
            }

            ChangeName(P)
        end
    end
end

function SilentKick(P)

    for _ = 1, 9999 do
        rprint(P, " ")
    end

    local sk = Troll["Silent Kick"]
    if (sk.announcements.enabled) then
        if (players[P][9].broadcast) then
            players[P][9].broadcast = false
            for i = 1, 6 do
                if player_present(i) and (i ~= P) then
                    say(i, gsub(sk.announcements.msg, "%%name%%", players[P].name))
                end
            end
        end
    end
end

function HasFlag(DP)
    for j = 0, 3 do
        local weapon = read_dword(DP + 0x2F8 + 4 * j)
        for i = 1, #flag do
            if (weapon == flag[i]) then
                return true
            end
        end
    end
end

function holdingFlag(DynamicPlayer)
    for i = 0, 3 do
        local WeaponID = read_dword(DynamicPlayer + 0x2F8 + 0x4 * i)
        if (WeaponID ~= 0xFFFFFFFF) then
            local Weapon = get_object_memory(WeaponID)
            if (Weapon ~= 0) then
                local tag_address = read_word(Weapon)
                local tag_data = read_dword(read_dword(0x40440000) + tag_address * 0x20 + 0x14)
                if (read_bit(tag_data + 0x308, 3) == 1) then
                    return true
                end
            end
        end
    end
    return false
end

function InVehicle(DynamicPlayer)
    if (DynamicPlayer ~= 0) then
        local VehicleID = read_dword(DynamicPlayer + 0x11C)
        if (VehicleID ~= 0xFFFFFFFF) then
            return true
        end
    end
    return false
end

function TrollPlayer(P, Feature)
    local lvl = tonumber(get_var(P, "$lvl"))
    if (affect_all_players) then
        return true
    else
        return (not Feature.ignore_admins) or (lvl <= Feature.ignore_admin_level)
    end
end

function KillSilently(P)
    local kma = sig_scan("8B42348A8C28D500000084C9") + 3
    local original = read_dword(kma)
    safe_write(true)
    write_dword(kma, 0x03EB01B1)
    safe_write(false)
    execute_command("kill " .. tonumber(P))
    safe_write(true)
    write_dword(kma, original)
    safe_write(false)
    write_dword(get_player(P) + 0x2C, 0 * 33)
    local deaths = tonumber(get_var(P, "$deaths"))
    execute_command("deaths " .. tonumber(P) .. " " .. deaths - 1)
end

function GetRandomName(P)
    local nc = Troll["Name Changer"]
    if (nc.enabled) then

        local t = { }
        for i = 1, #nc.names do
            if (string.len(nc.names[i][1]) < 12) then
                if (not nc.names[i].used) then
                    t[#t + 1] = { nc.names[i][1], i }
                else
                    cprint(nc.names[i][1] .. " was already taken (skipping)", 2 + 8)
                end
            end
        end

        if (#t > 0) then

            math.randomseed(os.time())

            local rand = math.random(#t)
            local name = t[rand][1]
            local n_id = t[rand][2]
            nc.names[n_id].used = true
            players[P][7].name_id = n_id

            return name
        end

        return "no name"
    end
end

function isChatCmd(Msg)
    if (sub(Msg[1], 1, 1) == "/" or sub(Msg[1], 1, 1) == "\\") then
        return true
    end
end

function StrSplit(Message)
    local Args, index = { }, 1
    for Params in gmatch(Message, "([^%s]+)") do
        Args[index] = Params
        index = index + 1
    end
    return Args
end

function ShuffleWords(String)
    math.randomseed(os.time())
    local letters = { }

    for letter in String:gmatch '.[\128-\191]*' do
        letters[#letters + 1] = { letter = letter, rnd = math.random() }
    end

    table.sort(letters, function(a, b)
        return a.rnd < b.rnd
    end)

    for i, v in ipairs(letters) do
        letters[i] = v.letter
    end
    return table.concat(letters)
end

-- Credits to Kavawuvi for this chunk of code:
function LSS(state)
    if (state) then
        ls = sig_scan("741F8B482085C9750C")
        if (ls == 0) then
            ls = sig_scan("EB1F8B482085C9750C")
        end
        safe_write(true)
        write_char(ls, 235)
        safe_write(false)
    else
        if (ls == 0) then
            return
        end
        safe_write(true)
        write_char(ls, 116)
        safe_write(false)
    end
end
-----------------------------------------------------------------------

-- Credits to Devieth for these functions:
function write_widestring(address, str, len)
    local Count = 0
    for _ = 1, len do
        write_byte(address + Count, 0)
        Count = Count + 2
    end
    local count = 0
    local length = string.len(str)
    for i = 1, length do
        local newbyte = string.byte(string.sub(str, i, i))
        write_byte(address + count, newbyte)
        count = count + 2
    end
end

function read_widestring(Address, Size)
    local str = ""
    for i = 0, Size - 1 do
        if read_byte(Address + i * 2) ~= 00 then
            str = str .. string.char(read_byte(Address + i * 2))
        end
    end
    if str ~= "" then
        return str
    end
    return nil
end
-----------------------------------------------------------------------
