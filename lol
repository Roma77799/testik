repeat wait() until game:IsLoaded()

if Key == nil then
    getgenv().Key = "SNAPSANIX HUB"
end

local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()
local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()

function sendnotification(message, type)
    if type == false or type == nil then
        print("[ " .. Key .. " ]: " .. message)
    end
    if type == true or type == nil then
        Notification:Notify(
            {Title = Key, Description = message},
            {OutlineColor = Color3.fromRGB(80, 80, 80), Time = 7, Type = "default"}
        )
    end
end

if getgenv().r3thexecuted then 
    sendnotification("Script already executed", nil) 
    return 
end
getgenv().r3thexecuted = true

sendnotification("Loader executed.", false)

--------------------------------------------------------------------------------------DEFINE----------------------------------------------------------------------------------------
local UIS = game:GetService("UserInputService")
local Touchscreen = UIS.TouchEnabled

--------------------------------------------------------------------------------------LISTS----------------------------------------------------------------------------------------
local games = {
    [11379739543] = 'Timebomb',
    [142823291] = 'mm2',
}

--------------------------------------------------------------------------------------LINK VERIFICATION-------------------------------------------------------------------------------
local scriptUrl = 'https://raw.githubusercontent.com/Roman34296589/SnapSanixHUB/refs/heads/main/SnapSanixHUB.lua'

-- Check if the creator is not Roman34296589 or the link is incorrect
if not string.find(scriptUrl, 'Roman34296589') or scriptUrl ~= 'https://raw.githubusercontent.com/Roman34296589/SnapSanixHUB/refs/heads/main/SnapSanixHUB.lua' then
    print("You're using a fake link")
    return
else
    sendnotification("Verified link and creator ✅", false)
end

--------------------------------------------------------------------------------------DEVICE CHECK------------------------------------------------------------------------------------
getgenv().R3TH_Device = Touchscreen and "Mobile" or "PC"
sendnotification(R3TH_Device .. " detected.", false)

if getgenv().R3TH_Device == "Mobile" then
    sendnotification("Mobile devices are not supported, only PC", nil)
    return
end

sendnotification("Script loading, this may take a while depending on your PC.", nil)
wait(2)

--------------------------------------------------------------------------------------LOADER----------------------------------------------------------------------------------------
if games[game.PlaceId] then
    sendnotification("Game Supported ✅", nil)
    loadstring(game:HttpGet('https://raw.githubusercontent.com/snapsanix/snapsanix/refs/heads/main/Games/' .. games[game.PlaceId] .. '.lua'))()
else
    sendnotification("Game not Supported ❌", nil)
end
