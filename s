local f = game:GetService("ReplicatedStorage")
function printTable(t, indent)
    indent = indent or 0
    for k, v in pairs(t) do
        local formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            printTable(v, indent + 1)
        else
            print(formatting .. tostring(v))
        end
    end
end
local getPlayerData = f:FindFirstChild("GetPlayerData", true)
if getPlayerData then
    while true do
        task.wait(0.1)
        local data = getPlayerData:InvokeServer()
        
        if type(data) == "table" then
            print("--- Начало данных ---")
            printTable(data)
            print("--- Конец данных ---")
        else
            print("Получены не табличные данные:", data)
        end
    end
end
