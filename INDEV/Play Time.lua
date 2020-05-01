-- Config Starts --
local path = "sapp\\playtime.json"
local playtime_command = "playtime"
local permission_level = 1

local messages = {
    [1] = "Your playtime is Days: %d%, Hours: %h%, Minutes: %m%, Seconds: %s%",
    [2] = "%name%'s playtime is Days: %d%, Hours: %h%, Minutes: %m%, Seconds: %s%",
    [3] = "Invalid Player ID. Usage: /%cmd% [number: 1-16] | */all | me",
    [4] = "You do not have permission to execute this command!",
}

-- Config Ends --

api_version = "1.12.0.0"

local players = { }
local json = (loadfile "json.lua")()
local gsub, gmatch, lower, upper = string.gsub, string.gmatch, string.lower, string.upper
local floor, format = string.floor, string.format

function OnScriptLoad()
    -- Register needed event callbacks:
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb['EVENT_GAME_START'], 'OnGameStart')
    register_callback(cb['EVENT_LEAVE'], 'OnPlayerDisconnect')
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")

    if (get_var(0, "$gt") ~= "n/a") then
        CheckFile()
    end
end

function OnTick()
    for i = 1,16 do
        if player_present(i) then
            if (players[i]) then
                players[i].time = os.clock()
            end
        end
    end
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        CheckFile()
    end
end

function OnServerCommand(Executor, Command, _, _)
    local Args = CmdSplit(Command)
    if (Args == nil) then
        return
    else
        Args[1] = (lower(Args[1]) or upper(Args[1]))
        if (Args[1] == playtime_command) then
            if HasAccess(Executor) then
                local pl = GetPlayers(Executor, Args)
                if (#pl > 0) then
                    for i = 1, #pl do

                        local msg
                        local TargetID = pl[i]
                        local name = get_var(TargetID, "$name")

                        local time = players[TargetID].time
                        local days, hours, minutes, seconds = secondsToTime(time, 4)
                        if (Executor == TargetID) then
                            msg = gsub(gsub(gsub(gsub(messages[1], "%%d%%", days), "%%h%%", hours), "%%m%%", minutes), "%%s%%", seconds)
                        else
                            msg = gsub(gsub(gsub(gsub(gsub(messages[2], "%%d%%", days), "%%h%%", hours), "%%m%%", minutes), "%%s%%", seconds), "%%name%%", name)
                        end
                        rprint(Executor, msg)
                    end
                end
            end
            return false
        end
    end
end

function GetPlayers(Executor, Args)
    local pl = { }
    if (Args[2] == nil or Args[2] == "me") then
        table.insert(pl, Executor)
    elseif (Args[2]:match("%d+") and player_present(Args[2])) then
        table.insert(pl, Args[2])
    elseif (Args[2] == "all" or Args[2] == "*") then
        for i = 1, 16 do
            if player_present(i) then
                table.insert(pl, i)
            end
        end
    else
        rprint(Executor, gsub(messages[3], "%%cmd%%", Args[1]))
    end
    return pl
end

function CmdSplit(Cmd)
    local t, i = {}, 1
    for Args in gmatch(Cmd, "([^%s]+)") do
        t[i] = Args
        i = i + 1
    end
    return t
end

function HasAccess(Executor)
    local lvl = tonumber(get_var(Executor, "$lvl"))
    if (lvl >= permission_level) then
        return true
    else
        rprint(Executor, messages[4])
    end
end

function OnPlayerConnect(PlayerIndex)
    InitPlayer(PlayerIndex, false)
end

function OnPlayerDisconnect(PlayerIndex)
    UpdateTime(PlayerIndex)
    InitPlayer(PlayerIndex, true)
end

function GetPlayTime(IP)
    local file = io.open(path, "r")
    if (file ~= nil) then
        local data = file:read("*all")
        local stats = json:decode(data)
        if (stats[IP]) then
            return stats[IP]
        end
        io.close(file)
    end
    return nil
end

function InitPlayer(PlayerIndex, Reset)
    if (Reset) then
        players[PlayerIndex] = { }
    else

        local ip = get_var(PlayerIndex, "$ip"):match('(%d+.%d+.%d+.%d+)')
        local playtime, record = GetPlayTime(ip)
        if (playtime) then
            playtime, record = playtime.time, true
        else
            playtime, record = 0, false
        end

        local name = get_var(PlayerIndex, "$name")
        players[PlayerIndex] = { ip = ip, time = playtime, name = name }

        if (not record) then
            local file, stats = io.open(path, "r")
            if (file ~= nil) then
                local data = file:read("*all")
                stats = json:decode(data)
                io.close(file)
            end

            local file = assert(io.open(path, "w"))
            if (file) then
                stats[ip] = players[PlayerIndex]
                file:write(json:encode_pretty(stats))
                io.close(file)
            end
        end
    end
end

function UpdateTime(PlayerIndex)

    -- todo: fix table index pointer:

    local stats = players[PlayerIndex]
    local records = GetPlayTime(stats.ip)

    records[stats.ip] = stats

    local file = assert(io.open(path, "w"))
    if (file) then
        file:write(json:encode_pretty(records))
        io.close(file)
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

    if (places == 6) then
        return format("%02d:%02d:%02d:%02d:%02d:%02d", years, weeks, days, hours, minutes, seconds)
    elseif (places == 5) then
        return format("%02d:%02d:%02d:%02d:%02d", weeks, days, hours, minutes, seconds)
    elseif (not places or places == 4) then
        return days, hours, minutes, seconds
    elseif (places == 3) then
        return format("%02d:%02d:%02d", hours, minutes, seconds)
    elseif (places == 2) then
        return format("%02d:%02d", minutes, seconds)
    elseif (places == 1) then
        return format("%02", seconds)
    end
end

function CheckFile()

    local file = io.open(path, "a")
    if (file ~= nil) then
        io.close(file)
    end

    local file, stats = io.open(path, "r")
    if (file ~= nil) then
        local data = file:read("*all")
        stats = json:decode(data)
        io.close(file)
    end

    if (not stats) then
        local file = assert(io.open(path, "w"))
        if (file) then
            file:write("{\n}")
            io.close(file)
        end
    end
end
