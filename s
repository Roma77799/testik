--[[ Arena Autofarm GUI — вставь целиком в эксплойт ]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local ARENAS = { "Arena1", "Arena2", "Arena3", "Arena4", "Arena5", "Arena6" }
local SIDES = { "Left", "Right" }
local SLOT_IDS = { "1", "2", "3", "4" }
local DIE_COUNT = 5
local POLL = 0.35

local running = false
local showArenaNames = false
local farmerName = ""
local farmerSpot = nil -- { arena, farmerSide, ourSide, slot }
local arenaBillboards = {}
local arenasChildAddedConn = nil
local setStatus = function() end
local getReadyHull

local RegisterDied = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Replicator"):WaitForChild("RegisterDied")
local ArenaReady = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Arena"):WaitForChild("Ready")

local function log(...)
	local n = select("#", ...)
	local parts = {}
	for i = 1, n do
		parts[i] = tostring(select(i, ...))
	end
	local msg = table.concat(parts, " ")
	warn("[ArenaFarm] " .. msg)
	print("[ArenaFarm] " .. msg)
end

local function trimName(s)
	return (s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function isBombName(name)
	name = string.lower(name or "")
	return name == "bomb" or string.find(name, "bomb", 1, true) ~= nil
end

local function getFarmer()
	local query = trimName(farmerName)
	if query == "" then
		return nil
	end
	local exact = Players:FindFirstChild(query)
	if exact then
		return exact
	end
	local q = string.lower(query)
	for _, plr in ipairs(Players:GetPlayers()) do
		if string.lower(plr.Name) == q or string.lower(plr.DisplayName) == q then
			return plr
		end
	end
	return nil
end

local function containerHasBomb(container)
	if not container then
		return false
	end
	for _, d in ipairs(container:GetDescendants()) do
		if isBombName(d.Name) then
			return true
		end
	end
	return false
end

local function playerHasBomb(plr)
	if not plr then
		return false
	end
	if containerHasBomb(plr.Character) then
		return true
	end
	if containerHasBomb(plr.Backpack) then
		return true
	end
	if containerHasBomb(plr:FindFirstChildOfClass("PlayerGui")) then
		return true
	end
	return false
end

local function anyoneHasBomb()
	if playerHasBomb(LocalPlayer) then
		return true, "у тебя"
	end
	local farmer = getFarmer()
	if farmer and playerHasBomb(farmer) then
		return true, "у " .. farmer.Name
	end
	return false, nil
end

local function fireRegisterDied()
	if RegisterDied:IsA("RemoteEvent") then
		RegisterDied:FireServer()
	elseif RegisterDied:IsA("RemoteFunction") then
		RegisterDied:InvokeServer()
	else
		error("RegisterDied: неизвестный тип " .. RegisterDied.ClassName)
	end
end

local function guiText(obj)
	if not obj then
		return nil
	end
	if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
		local t = trimName(obj.Text)
		if t ~= "" then
			return t
		end
	end
	return nil
end

-- Формат в игре: (@ник) — скобки и @ обязательны в UI
local function extractNickFromLabel(text)
	text = trimName(text)
	if text == "" then
		return ""
	end

	local fromParens = text:match("%(@([^%)]+)%)")
	if fromParens then
		return string.lower(trimName(fromParens))
	end

	text = text:gsub("%(", ""):gsub("%)", "")
	text = trimName(text):gsub("^@", "")
	return string.lower(text)
end

local function getSlotUsernameText(slotFolder)
	local statsboard = slotFolder:FindFirstChild("Statsboard")
	if not statsboard then
		return nil
	end

	local uiFront = statsboard:FindFirstChild("UI_Front")
	local main = uiFront and uiFront:FindFirstChild("Main")
	local holder = main and main:FindFirstChild("StatsHolder")
	local pinfo = holder and holder:FindFirstChild("PlayerInfo")
	local names = pinfo and pinfo:FindFirstChild("Names")
	local username = names and names:FindFirstChild("Username")

	local t = guiText(username)
	if t then
		return t
	end

	if names then
		for _, d in ipairs(names:GetDescendants()) do
			local dt = guiText(d)
			if dt and (string.find(dt, "@", 1, true) or string.find(dt, "(", 1, true)) then
				return dt
			end
		end
	end

	for _, d in ipairs(statsboard:GetDescendants()) do
		if d.Name == "Username" then
			local dt = guiText(d)
			if dt then
				return dt
			end
		end
	end

	return nil
end

local function getFarmerSearchNames(farmer)
	local list = {}
	local function add(s)
		s = string.lower(trimName(s))
		if s ~= "" then
			for _, existing in ipairs(list) do
				if existing == s then
					return
				end
			end
			table.insert(list, s)
		end
	end
	if farmer then
		add(farmer.Name)
		add(farmer.DisplayName)
	end
	add(farmerName)
	return list
end

local function labelMatchesFarmer(labelText, farmer)
	if not labelText or not farmer then
		return false
	end

	local norm = extractNickFromLabel(labelText)
	if norm == "" or norm == "..." or norm == "…" then
		return false
	end

	for _, target in ipairs(getFarmerSearchNames(farmer)) do
		if norm == target then
			return true
		end
	end

	local rawLower = string.lower(labelText)
	for _, target in ipairs(getFarmerSearchNames(farmer)) do
		if string.find(rawLower, target, 1, true) then
			return true
		end
	end

	return false
end

local function debugScanUsernames()
	log("--- все Username на аренах ---")
	local arenasFolder = workspace:FindFirstChild("Arenas")
	if not arenasFolder then
		return
	end
	for _, arenaName in ipairs(ARENAS) do
		local arena = arenasFolder:FindFirstChild(arenaName)
		local slots = arena and arena:FindFirstChild("Slots")
		if slots then
			for _, sideName in ipairs(SIDES) do
				local sideFolder = slots:FindFirstChild(sideName)
				if sideFolder then
					for _, slotId in ipairs(SLOT_IDS) do
						local slot = sideFolder:FindFirstChild(slotId)
						if slot then
							local userText = getSlotUsernameText(slot)
							if userText and userText ~= "" then
								log(arenaName, sideName, slotId, "raw:", userText, "nick:", extractNickFromLabel(userText))
							end
						end
					end
				end
			end
		end
	end
	local farmer = getFarmer()
	if farmer then
		log("Ищем:", table.concat(getFarmerSearchNames(farmer), ", "))
	end
end

local function oppositeSide(side)
	if side == "Left" then
		return "Right"
	end
	return "Left"
end

local function scanFarmerSpot()
	local farmer = getFarmer()
	if not farmer then
		return nil
	end
	local arenasFolder = workspace:FindFirstChild("Arenas")
	if not arenasFolder then
		return nil
	end

	for _, arenaName in ipairs(ARENAS) do
		local arena = arenasFolder:FindFirstChild(arenaName)
		local slots = arena and arena:FindFirstChild("Slots")
		if slots then
			for _, sideName in ipairs(SIDES) do
				local sideFolder = slots:FindFirstChild(sideName)
				if sideFolder then
					for _, slotId in ipairs(SLOT_IDS) do
						local slot = sideFolder:FindFirstChild(slotId)
						if slot then
							local userText = getSlotUsernameText(slot)
							if userText and labelMatchesFarmer(userText, farmer) then
								return {
									arena = arenaName,
									farmerSide = sideName,
									ourSide = oppositeSide(sideName),
									slot = slotId,
									labelText = userText,
								}
							end
						end
					end
				end
			end
		end
	end
	return nil
end

local function refreshFarmerSpot()
	farmerSpot = scanFarmerSpot()
	return farmerSpot
end

getReadyHull = function()
	if not farmerSpot then
		refreshFarmerSpot()
	end
	if not farmerSpot then
		return nil
	end
	local arenas = workspace:FindFirstChild("Arenas")
	local arena = arenas and arenas:FindFirstChild(farmerSpot.arena)
	local slots = arena and arena:FindFirstChild("Slots")
	local side = slots and slots:FindFirstChild(farmerSpot.ourSide)
	local slot = side and side:FindFirstChild("1")
	local hull = slot and slot:FindFirstChild("Hull")
	if hull and hull:IsA("BasePart") then
		return hull
	end
	return nil
end

local function debugBombState()
	local farmer = getFarmer()
	local has, who = anyoneHasBomb()
	log("--- диагностика ---")
	log("Автофарм:", running and "ВКЛ" or "ВЫКЛ")
	log("Фармер:", farmer and farmer.Name or "НЕ НАЙДЕН", "| ввод:", farmerName)
	if farmerSpot then
		log(
			"Слот фармера:",
			farmerSpot.arena,
			farmerSpot.farmerSide,
			farmerSpot.slot,
			"| Ready:",
			farmerSpot.ourSide,
			"1"
		)
	else
		log("На аренах не найден (Statsboard Username)")
	end
	log("Бомба у тебя:", playerHasBomb(LocalPlayer) and "ДА" or "нет")
	log("Бомба у фармера:", farmer and (playerHasBomb(farmer) and "ДА" or "нет") or "—")
	log("Итог:", has and ("бомба " .. who) or "бомбы нет — ЖДЁМ")
	log("Hull:", getReadyHull() and "найден" or "НЕТ")
end

local function waitForFullCharacter(plr, timeout)
	plr = plr or LocalPlayer
	timeout = timeout or 25
	local deadline = tick() + timeout
	if not plr.Character then
		local ok = pcall(function()
			plr.CharacterAdded:Wait()
		end)
		if not ok and tick() > deadline then
			return false
		end
	end
	while tick() < deadline do
		local char = plr.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if hum and hrp and hum.Health > 0 then
				task.wait(0.25)
				return true
			end
		end
		task.wait(0.1)
	end
	log("Таймаут респавна")
	return false
end

local function waitForBomb()
	local heartbeat = 0
	setStatus("Жду бомбу (ты или фармер)...")
	while running do
		local has, who = anyoneHasBomb()
		if has then
			setStatus("Бомба " .. who)
			return true
		end
		if tick() - heartbeat >= 4 then
			heartbeat = tick()
			refreshFarmerSpot()
			if farmerSpot then
				setStatus("Жду бомбу | " .. farmerSpot.arena .. " " .. farmerSpot.farmerSide)
			else
				setStatus("Жду бомбу | фармер не на арене")
			end
			debugBombState()
		end
		task.wait(POLL)
	end
	return false
end

local function touchReadyButton()
	refreshFarmerSpot()
	if not firetouchinterest then
		log("Нет firetouchinterest")
		return false
	end

	local char = LocalPlayer.Character
	if not char then
		return false
	end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return false
	end

	local hull = getReadyHull()
	if not hull then
		if farmerSpot then
			log("Hull не найден:", farmerSpot.arena, farmerSpot.ourSide, "1")
		else
			log("Фармер не найден на Statsboard — Ready невозможен")
		end
		return false
	end
	log("Ready Hull:", hull:GetFullName())

	hrp.CFrame = hull.CFrame + Vector3.new(0, 3, 0)
	task.wait(0.15)

	local function touchPair(a, b)
		firetouchinterest(a, b, 0)
		task.wait(0.05)
		firetouchinterest(a, b, 1)
	end

	pcall(function()
		touchPair(hull, hrp)
	end)
	task.wait(0.1)
	pcall(function()
		touchPair(hrp, hull)
	end)
	task.wait(0.15)

	local ok, err = pcall(function()
		ArenaReady:FireServer(true)
	end)
	if not ok then
		log("Ready: " .. tostring(err))
		return false
	end
	return true
end

local function doFiveDeaths()
	for i = 1, DIE_COUNT do
		if not running then
			return
		end
		if not waitForBomb() then
			return
		end

		setStatus("Смерть " .. i .. "/" .. DIE_COUNT)
		log("Смерть " .. i .. "/" .. DIE_COUNT)
		local ok, err = pcall(fireRegisterDied)
		if not ok then
			log("RegisterDied ошибка:", err)
		end
		waitForFullCharacter(LocalPlayer, 25)
		task.wait(0.2)
	end
end

local function farmLoop()
	log("Цикл автофарма запущен")
	local spot = refreshFarmerSpot()
	if not spot then
		setStatus("Фармер не на арене (Statsboard)")
		log("Фармер не найден ни на одной из 6 арен")
	else
		setStatus(spot.arena .. " " .. spot.farmerSide .. " → Ready " .. spot.ourSide)
		log("Найден:", spot.labelText, "|", spot.arena, spot.farmerSide, spot.slot)
	end
	debugBombState()

	while running do
		if not waitForBomb() then
			break
		end

		log("Бомба найдена — " .. DIE_COUNT .. " смертей")
		doFiveDeaths()
		if not running then
			break
		end

		refreshFarmerSpot()
		local readyLabel = farmerSpot
			and (farmerSpot.arena .. " Ready " .. farmerSpot.ourSide .. ".1")
			or "?"
		setStatus("Ready: " .. readyLabel)
		log("Ready:", readyLabel)
		local readyOk = touchReadyButton()
		if not readyOk then
			setStatus("Ошибка Ready / Hull")
		end
		task.wait(0.5)
	end
	setStatus("Автофарм выключен")
	log("Автофарм выключен")
end

local function getArenaAnchor(arenaModel)
	if arenaModel:IsA("BasePart") then
		return arenaModel
	end
	if arenaModel.PrimaryPart then
		return arenaModel.PrimaryPart
	end
	for _, d in ipairs(arenaModel:GetDescendants()) do
		if d:IsA("BasePart") then
			return d
		end
	end
	return nil
end

local function destroyArenaBillboards()
	for _, gui in ipairs(arenaBillboards) do
		if gui and gui.Parent then
			gui:Destroy()
		end
	end
	table.clear(arenaBillboards)
	if arenasChildAddedConn then
		arenasChildAddedConn:Disconnect()
		arenasChildAddedConn = nil
	end
end

local function createArenaBillboard(arenaModel)
	local anchor = getArenaAnchor(arenaModel)
	if not anchor then
		return
	end
	for _, gui in ipairs(arenaBillboards) do
		if gui.Adornee == anchor and gui:GetAttribute("ArenaName") == arenaModel.Name then
			return
		end
	end

	local bb = Instance.new("BillboardGui")
	bb.Name = "ArenaFarm_NameTag"
	bb.Adornee = anchor
	bb.AlwaysOnTop = true
	bb.LightInfluence = 0
	bb.MaxDistance = 500
	bb.Size = UDim2.new(0, 140, 0, 44)
	bb.StudsOffset = Vector3.new(0, 14, 0)
	bb:SetAttribute("ArenaName", arenaModel.Name)
	bb.Parent = anchor

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
	label.BackgroundTransparency = 0.25
	label.BorderSizePixel = 0
	label.Font = Enum.Font.GothamBold
	label.TextSize = 18
	label.TextColor3 = Color3.fromRGB(255, 220, 100)
	label.TextStrokeTransparency = 0.5
	label.Text = arenaModel.Name
	label.Parent = bb

	local lc = Instance.new("UICorner")
	lc.CornerRadius = UDim.new(0, 6)
	lc.Parent = label

	table.insert(arenaBillboards, bb)
end

local function refreshArenaBillboards()
	local arenasFolder = workspace:FindFirstChild("Arenas")
	if not arenasFolder then
		log("Нет Workspace.Arenas")
		return
	end
	for _, child in ipairs(arenasFolder:GetChildren()) do
		createArenaBillboard(child)
	end
end

local function setArenaNamesVisible(on)
	showArenaNames = on
	if not on then
		destroyArenaBillboards()
		return
	end
	destroyArenaBillboards()
	refreshArenaBillboards()
	local arenasFolder = workspace:WaitForChild("Arenas", 10)
	if not arenasFolder then
		return
	end
	arenasChildAddedConn = arenasFolder.ChildAdded:Connect(function(child)
		if showArenaNames then
			task.defer(function()
				createArenaBillboard(child)
			end)
		end
	end)
	log("Имена арен: ВКЛ (" .. #arenaBillboards .. " подписей)")
end

-- GUI
local guiParent = (gethui and gethui()) or game:GetService("CoreGui")
local old = guiParent:FindFirstChild("ArenaAutofarmGui")
if old then
	old:Destroy()
end
destroyArenaBillboards()

local sg = Instance.new("ScreenGui")
sg.Name = "ArenaAutofarmGui"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = guiParent

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 220, 0, 218)
main.Position = UDim2.new(0, 12, 0.5, -109)
main.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
main.BorderSizePixel = 0
main.Parent = sg

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -12, 0, 28)
title.Position = UDim2.new(0, 6, 0, 6)
title.BackgroundTransparency = 1
title.Text = "Arena Autofarm"
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextColor3 = Color3.fromRGB(240, 240, 245)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local farmLabel = Instance.new("TextLabel")
farmLabel.Size = UDim2.new(1, -12, 0, 18)
farmLabel.Position = UDim2.new(0, 6, 0, 36)
farmLabel.BackgroundTransparency = 1
farmLabel.Text = "Имя фармящего:"
farmLabel.Font = Enum.Font.Gotham
farmLabel.TextSize = 12
farmLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
farmLabel.TextXAlignment = Enum.TextXAlignment.Left
farmLabel.Parent = main

local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(1, -12, 0, 30)
nameBox.Position = UDim2.new(0, 6, 0, 56)
nameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
nameBox.Text = ""
nameBox.PlaceholderText = "ник в Players"
nameBox.Font = Enum.Font.Gotham
nameBox.TextSize = 13
nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
nameBox.ClearTextOnFocus = false
nameBox.Parent = main
local nbc = Instance.new("UICorner")
nbc.CornerRadius = UDim.new(0, 6)
nbc.Parent = nameBox

local function syncFarmerName()
	farmerName = trimName(nameBox.Text)
end

nameBox:GetPropertyChangedSignal("Text"):Connect(syncFarmerName)
nameBox.FocusLost:Connect(syncFarmerName)

local namesToggleBtn = Instance.new("TextButton")
namesToggleBtn.Size = UDim2.new(1, -12, 0, 32)
namesToggleBtn.Position = UDim2.new(0, 6, 0, 94)
namesToggleBtn.Text = "Имена арен: ВЫКЛ"
namesToggleBtn.Font = Enum.Font.GothamSemibold
namesToggleBtn.TextSize = 13
namesToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
namesToggleBtn.BackgroundColor3 = Color3.fromRGB(90, 70, 120)
namesToggleBtn.AutoButtonColor = false
namesToggleBtn.BorderSizePixel = 0
namesToggleBtn.Parent = main
local ntbc = Instance.new("UICorner")
ntbc.CornerRadius = UDim.new(0, 6)
ntbc.Parent = namesToggleBtn

namesToggleBtn.MouseButton1Click:Connect(function()
	showArenaNames = not showArenaNames
	if showArenaNames then
		setArenaNamesVisible(true)
		namesToggleBtn.Text = "Имена арен: ВКЛ"
		namesToggleBtn.BackgroundColor3 = Color3.fromRGB(120, 90, 160)
	else
		setArenaNamesVisible(false)
		namesToggleBtn.Text = "Имена арен: ВЫКЛ"
		namesToggleBtn.BackgroundColor3 = Color3.fromRGB(90, 70, 120)
	end
end)

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, -12, 0, 36)
toggleBtn.Position = UDim2.new(0, 6, 0, 132)
toggleBtn.Text = "Автофарм: ВЫКЛ"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
toggleBtn.AutoButtonColor = false
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = main
local tbc = Instance.new("UICorner")
tbc.CornerRadius = UDim.new(0, 6)
tbc.Parent = toggleBtn

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -12, 0, 36)
status.Position = UDim2.new(0, 6, 0, 174)
status.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
status.BackgroundTransparency = 0.2
status.BorderSizePixel = 0
status.Font = Enum.Font.Gotham
status.TextSize = 10
status.TextColor3 = Color3.fromRGB(200, 210, 220)
status.TextWrapped = true
status.Text = "Статус: выкл"
status.Parent = main
local sbc = Instance.new("UICorner")
sbc.CornerRadius = UDim.new(0, 6)
sbc.Parent = status

setStatus = function(text)
	status.Text = "Статус: " .. tostring(text)
	log(text)
end

toggleBtn.MouseButton1Click:Connect(function()
	syncFarmerName()
	running = not running
	if running then
		if farmerName == "" then
			setStatus("Впиши имя фармящего")
			running = false
			return
		end
		local farmer = getFarmer()
		if not farmer then
			setStatus("Игрок не найден: " .. farmerName)
			log("Игрок не в игре. Players:")
			for _, p in ipairs(Players:GetPlayers()) do
				log(" -", p.Name, "/", p.DisplayName)
			end
			running = false
			return
		end
		if not firetouchinterest then
			setStatus("Нет firetouchinterest")
			running = false
			return
		end
		local spot = refreshFarmerSpot()
		if not spot then
			setStatus("Фармер не на арене — зайди в слот")
			log("Нет на Statsboard. Формат в игре: (@ник)")
			debugScanUsernames()
			running = false
			return
		end
		if not getReadyHull() then
			setStatus("Нет Hull " .. spot.ourSide .. ".1")
			running = false
			return
		end
		toggleBtn.Text = "Автофарм: ВКЛ"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 140, 80)
		setStatus(spot.arena .. " → Ready " .. spot.ourSide .. ".1")
		task.spawn(farmLoop)
	else
		toggleBtn.Text = "Автофарм: ВЫКЛ"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
		setStatus("Выключен")
	end
end)

log("GUI готова. Арена определяется по фармеру на Statsboard.")
