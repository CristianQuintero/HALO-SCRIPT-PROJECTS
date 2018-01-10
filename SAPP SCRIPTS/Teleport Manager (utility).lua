--[[
--=====================================================================================================--
Script Name: Teleport Manager (utility), for SAPP (PC & CE)
Description: Allows the user to create custom teleports and warp to them on demand.

Warning: This script implements a heavy use of pattern matching (regex) and is extremely complicated. 
         Modify only if you know what you're doing!

Use this command to set a new teleport location
/setportal [teleport name]

Use this command to teleport to the desired teleport location
/tpo [teleport name]

Use this command to list all custom portals
/tplist


                -- do to:
                -- check if "portal name" already exists when creating
             
Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]-- 

-- configuration starts --

set_command = "setportal"
goto_command = "tpo"
list_command = "tplist"
delete_command = "tpdelete"
sapp_dir = "sapp\\teleports.txt"
permission_level = -1
-- configuration ends  --

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
end

function OnScriptUnload() end

function OnServerCommand(PlayerIndex, Command, Environment)
    local UnknownCMD = nil
    local t = tokenizestring(Command)
    ---------------------------------------------------------
    -- SET COMMAND --
    if t[1] ~= nil then
        if t[1] == string.lower(set_command) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= permission_level then
                if t[2] ~= nil then
                    if PlayerInVehicle(PlayerIndex) then
                        x1, y1, z1 = read_vector3d(get_object_memory(read_dword(get_dynamic_player(PlayerIndex) + 0x11C)) + 0x5c)
                    else
                        x1, y1, z1 = read_vector3d(get_dynamic_player(PlayerIndex) + 0x5C)
                    end
                    local file = io.open(sapp_dir, "a+")
                    local line = t[2] .. ": X " .. x1 .. ", Y " .. y1 .. ", Z " .. z1
                    file:write(line, "\n")
                    file:close()
                    say(PlayerIndex, "Teleport location set to: " .. x1 .. ", " .. y1 .. ", " .. z1)
                else
                    say(PlayerIndex, "Invalid Syntax. Command Usage: /" .. set_command .. " <teleport name>")
                end
            else
                say(PlayerIndex, "You're not allowed to execute /" .. set_command)
            end
            UnknownCMD = false
        end
    end
    ---------------------------------------------------------
    -- GO TO COMMAND --
    if t[1] ~= nil then
        if t[1] == string.lower(goto_command) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= permission_level then
                if t[2] ~= nil then
                    local file = sapp_dir
                    local lines = lines_from(file)
                    for k, v in pairs(lines) do
                        local teleport_name = v:match("[%a%d+_]*")
                        local valid = nil
                        if t[2] == teleport_name then
                            -- numbers without decimal points -----------------------------------------------------------------------------
                            if string.match(v, ("X%s*%d+,%s*Y%s*%d+,%s*Z%s*%d+")) then
                                cprint("Match", 2+8)
                                valid = true -- 0
                                x = string.gsub(string.match(v, "X%s*%d+"), "X%s*%d+", string.match(string.match(v, "X%s*%d+"), "%d+"))
                                y = string.gsub(string.match(v, "Y%s*%d+"), "Y%s*%d+", string.match(string.match(v, "Y%s*%d+"), "%d+"))
                                z = string.gsub(string.match(v, "Z%s*%d+"), "Z%s*%d+", string.match(string.match(v, "Z%s*%d+"), "%d+"))
                            elseif string.match(v, ("X%s*-%d+,%s*Y%s*-%d+,%s*Z%s*-%d+")) then 
                                valid = true -- *
                            x = string.gsub(string.match(v, "X%s*-%d+"), "X%s*-%d+", string.match(string.match(v, "X%s*-%d+"), "-%d+"))
                                y = string.gsub(string.match(v, "Y%s*-%d+"), "Y%s*-%d+", string.match(string.match(v, "Y%s*-%d+"), "-%d+"))
                                z = string.gsub(string.match(v, "Z%s*-%d+"), "Z%s*-%d+", string.match(string.match(v, "Z%s*-%d+"), "-%d+"))
                            elseif string.match(v, ("X%s*-%d+,%s*Y%s*%d+,%s*Z%s*%d+")) then  
                                valid = true -- 1
                                x = string.gsub(string.match(v, "X%s*-%d+"), "X%s*-%d+", string.match(string.match(v, "X%s*-%d+"), "-%d+"))
                                y = string.gsub(string.match(v, "Y%s*%d+"), "Y%s*%d+", string.match(string.match(v, "Y%s*%d+"), "%d+"))
                                z = string.gsub(string.match(v, "Z%s*%d+"), "Z%s*%d+", string.match(string.match(v, "Z%s*%d+"), "%d+"))
                            elseif string.match(v, ("X%s*%d+,%s*Y%s*-%d+,%s*Z%s*%d+")) then  
                                valid = true -- 2
                                x = string.gsub(string.match(v, "X%s*%d+"), "X%s*%d+", string.match(string.match(v, "X%s*%d+"), "%d+"))
                                y = string.gsub(string.match(v, "Y%s*-%d+"), "Y%s*-%d+", string.match(string.match(v, "Y%s*-%d+"), "-%d+"))
                                z = string.gsub(string.match(v, "Z%s*%d+"), "Z%s*%d+", string.match(string.match(v, "Z%s*%d+"), "%d+"))
                            elseif string.match(v, ("X%s*%d+,%s*Y%s*%d+,%s*Z%s*-%d+")) then  
                                valid = true -- 3
                                x = string.gsub(string.match(v, "X%s*%d+"), "X%s*%d+", string.match(string.match(v, "X%s*%d+"), "%d+"))
                                y = string.gsub(string.match(v, "Y%s*%d+"), "Y%s*%d+", string.match(string.match(v, "Y%s*%d+"), "%d+"))
                                z = string.gsub(string.match(v, "Z%s*-%d+"), "Z%s*-%d+", string.match(string.match(v, "Z%s*-%d+"), "-%d+"))
                            elseif string.match(v, ("X%s*-%d+,%s*Y%s*-%d+,%s*Z%s*%d+")) then 
                                valid = true -- 1 & 2
                                x = string.gsub(string.match(v, "X%s*-%d+"), "X%s*-%d+", string.match(string.match(v, "X%s*-%d+"), "-%d+"))
                                y = string.gsub(string.match(v, "Y%s*-%d+"), "Y%s*-%d+", string.match(string.match(v, "Y%s*-%d+"), "-%d+"))
                                z = string.gsub(string.match(v, "Z%s*%d+"), "Z%s*%d+", string.match(string.match(v, "Z%s*%d+"), "%d+"))
                            elseif string.match(v, ("X%s*-%d+,%s*Y%s*%d+,%s*Z%s*-%d+")) then 
                                valid = true -- 1 & 3
                                x = string.gsub(string.match(v, "X%s*-%d+"), "X%s*-%d+", string.match(string.match(v, "X%s*-%d+"), "-%d+"))
                                y = string.gsub(string.match(v, "Y%s*%d+"), "Y%s*%d+", string.match(string.match(v, "Y%s*%d+"), "%d+"))
                                z = string.gsub(string.match(v, "Z%s*-%d+"), "Z%s*-%d+", string.match(string.match(v, "Z%s*-%d+"), "-%d+"))
                            elseif string.match(v, ("X%s*%d+,%s*Y%s*-%d+,%s*Z%s*-%d+")) then 
                                valid = true -- 2 & 3
                                x = string.gsub(string.match(v, "X%s*%d+"), "X%s*%d+", string.match(string.match(v, "X%s*%d+"), "%d+"))
                                y = string.gsub(string.match(v, "Y%s*-%d+"), "Y%s*-%d+", string.match(string.match(v, "Y%s*-%d+"), "-%d+"))
                                z = string.gsub(string.match(v, "Z%s*-%d+"), "Z%s*-%d+", string.match(string.match(v, "Z%s*-%d+"), "-%d+")) 
                            -- numbers with decimal points -----------------------------------------------------------------------------
                            elseif string.match(v, ("X%s*%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*%d+.%d+")) then
                                valid = true -- 0
                                x = string.gsub(string.match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", string.match(string.match(v, "X%s*%d+.%d+"), "%d+.%d+"))
                                y = string.gsub(string.match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", string.match(string.match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
                                z = string.gsub(string.match(v, "Z%s*%d+.%d+"), "Z%s*%d+.%d+", string.match(string.match(v, "Z%s*%d+.%d+"), "%d+.%d+"))
                            elseif string.match(v, ("X%s*-%d+.%d+,%s*Y%s*-%d+.%d+,%s*Z%s*-%d+.%d+")) then
                                valid = true -- *
                                x = string.gsub(string.match(v, "X%s*-%d+.%d+"), "X%s*-%d+.%d+", string.match(string.match(v, "X%s*-%d+.%d+"), "-%d+.%d+"))
                                y = string.gsub(string.match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", string.match(string.match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
                                z = string.gsub(string.match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", string.match(string.match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))
                            elseif string.match(v, ("X%s*-%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*%d+.%d+")) then
                                valid = true -- 1
                                x = string.gsub(string.match(v, "X%s*-%d+.%d+"), "X%s*-%d+.%d+", string.match(string.match(v, "X%s*-%d+.%d+"), "-%d+.%d+"))
                                y = string.gsub(string.match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", string.match(string.match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
                                z = string.gsub(string.match(v, "Z%s*%d+.%d+"), "Z%s*%d+.%d+", string.match(string.match(v, "Z%s*%d+.%d+"), "%d+.%d+"))
                            elseif string.match(v, ("X%s*%d+.%d+,%s*Y%s*-%d+.%d+,%s*Z%s*%d+.%d+")) then
                                valid = true -- 2
                                x = string.gsub(string.match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", string.match(string.match(v, "X%s*%d+.%d+"), "%d+.%d+"))
                                y = string.gsub(string.match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", string.match(string.match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
                                z = string.gsub(string.match(v, "Z%s*%d+.%d+"), "Z%s*%d+.%d+", string.match(string.match(v, "Z%s*%d+.%d+"), "%d+.%d+"))
                            elseif string.match(v, ("X%s*%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*-%d+.%d+")) then
                                valid = true -- 3
                                x = string.gsub(string.match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", string.match(string.match(v, "X%s*%d+.%d+"), "%d+.%d+"))
                                y = string.gsub(string.match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", string.match(string.match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
                                z = string.gsub(string.match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", string.match(string.match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))
                            elseif string.match(v, ("X%s*-%d+.%d+,%s*Y%s*-%d+.%d+,%s*Z%s*%d+.%d+")) then
                                valid = true -- 1 & 2
                                x = string.gsub(string.match(v, "X%s*-%d+.%d+"), "X%s*-%d+.%d+", string.match(string.match(v, "X%s*-%d+.%d+"), "-%d+.%d+"))
                                y = string.gsub(string.match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", string.match(string.match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
                                z = string.gsub(string.match(v, "Z%s*%d+.%d+"), "Z%s*%d+.%d+", string.match(string.match(v, "Z%s*%d+.%d+"), "%d+.%d+"))
                            elseif string.match(v, ("X%s*-%d+.%d+,%s*Y%s*%d+.%d+,%s*Z%s*-%d+.%d+")) then
                                valid = true -- 1 & 3
                                x = string.gsub(string.match(v, "X%s*-%d+.%d+"), "X%s*-%d+.%d+", string.match(string.match(v, "X%s*-%d+.%d+"), "-%d+.%d+"))
                                y = string.gsub(string.match(v, "Y%s*%d+.%d+"), "Y%s*%d+.%d+", string.match(string.match(v, "Y%s*%d+.%d+"), "%d+.%d+"))
                                z = string.gsub(string.match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", string.match(string.match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))
                            elseif string.match(v, ("X%s*%d+.%d+,%s*Y%s*-%d+.%d+,%s*Z%s*-%d+.%d+")) then
                                valid = true  -- 2 & 3
                                x = string.gsub(string.match(v, "X%s*%d+.%d+"), "X%s*%d+.%d+", string.match(string.match(v, "X%s*%d+.%d+"), "%d+.%d+"))
                                y = string.gsub(string.match(v, "Y%s*-%d+.%d+"), "Y%s*-%d+.%d+", string.match(string.match(v, "Y%s*-%d+.%d+"), "-%d+.%d+"))
                                z = string.gsub(string.match(v, "Z%s*-%d+.%d+"), "Z%s*-%d+.%d+", string.match(string.match(v, "Z%s*-%d+.%d+"), "-%d+.%d+"))
                            else
                                rprint(PlayerIndex, "Script Error! Coordinates for that teleport do not match the regex expression!")
                                cprint("Script Error! Coordinates for that teleport do not match the regex expression!", 4+8)
                            end
                            if (v ~= nil and valid == true) then
                                if not PlayerInVehicle(PlayerIndex) then
                                    write_vector3d(get_dynamic_player(PlayerIndex) + 0x5C, tonumber(x), tonumber(y), tonumber(z))
                                    rprint(PlayerIndex, "Teleporting to X: " .. x .. " Y: " .. y .. " Z: " .. z)
                                    valid = false
                                else
                                    local player_object = get_dynamic_player(PlayerIndex)
                                    if (player_object ~= 0) then
                                        local vehicleId = read_dword(player_object + 0x11C)
                                        TeleportPlayer(vehicleId, tonumber(x), tonumber(y), tonumber(z) + 0.5)
                                        valid = false
                                    end
                                end
                            else
                                cprint("That teleport name is not valid!", 4+8)
                                rprint(PlayerIndex, "That teleport name is not valid!")
                            end
                        end
                    end
                    UnknownCMD = false
                else
                    say(PlayerIndex, "Invalid Syntax. Command Usage: /" .. goto_command .. " <teleport name>")
                end
            else
                say(PlayerIndex, "You're not allowed to execute /" .. goto_command)
            end
            UnknownCMD = false
        end
    end
    ---------------------------------------------------------
    -- LIST COMMAND --
    if t[1] ~= nil then
        if t[1] == string.lower(list_command) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= permission_level then
                local file = sapp_dir
                local lines = lines_from(file)
                for k,v in pairs(lines) do
                    rprint(PlayerIndex, "["..k.."] " .. v)
                end
            else
                say(PlayerIndex, "You're not allowed to execute /" .. list_command)
            end
            UnknownCMD = false
        end
    end
    ---------------------------------------------------------
    -- DELETE COMMAND --
    if t[1] ~= nil then
        if t[1] == string.lower(delete_command) then
            if tonumber(get_var(PlayerIndex, "$lvl")) >= permission_level then
                if t[2] ~= nil then
                    local file = sapp_dir
                    local lines = lines_from(file)
                    for k, v in pairs(lines) do
                        if k ~= nil then
                            if t[2] == v:match(k) then
                                delete_from_file( file, k, 1 , PlayerIndex)
                                say(PlayerIndex, "Successfully deleted teleport id #" ..k)
                            end
                        else
                            say(PlayerIndex, "Index ID does not exist!")
                        end
                    end
                end
            else
                say(PlayerIndex, "You're not allowed to execute /" .. delete_command)
            end
            UnknownCMD = false
        end
    end
    return UnknownCMD
end

function file_exists(file)
    local File = io.open(file, "rb")
    if File then 
        File:close() 
    end
    return File ~= nil
end

function lines_from(file)
    if not file_exists(file) then 
        return {} 
    end
    lines = {}
    for line in io.lines(file) do 
        lines[#lines + 1] = line
    end
    return lines
end

function tokenizestring(inputString, separator)
    if separator == nil then
        separator = "%s"
    end
    local t = { }; i = 1
    for str in string.gmatch(inputString, "([^" .. separator .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function delete_from_file(filename, starting_line, num_lines, player)
    local fp = io.open(filename, "r")
    if fp == nil then 
        return nil 
    end
    content = {}
    i = 1;
    for line in fp:lines() do
        if i < starting_line or i >= starting_line + num_lines then
            content[#content+1] = line
        end
        i = i + 1
    end
    if i > starting_line and i < starting_line + num_lines then
        say(player, "Warning: End of File! No entries to delete.")
        cprint("Warning: End of File! No entries to delete.")
    end
    fp:close()
    fp = io.open( filename, "w+")
    for i = 1, #content do
        fp:write(string.format("%s\n", content[i]))
    end
    fp:close()
end

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

function TeleportPlayer(ObjectID, x, y, z)
    if get_object_memory(ObjectID) ~= 0 then
        local veh_obj = get_object_memory(read_dword(get_object_memory(ObjectID) + 0x11C))
        write_vector3d((veh_obj ~= 0 and veh_obj or get_object_memory(ObjectID)) + 0x5C, x, y, z)
    end
end