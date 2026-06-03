--[[ Arena Autofarm GUI — вставь целиком в эксплойт ]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local ARENAS = { "Arena1", "Arena2", "Arena3", "Arena4", "Arena5", "Arena6" }
local DIE_COUNT = 5
local POLL = 0.35

local running = false
local showArenaNames = false
local selectedArena = "Arena2"
local farmerName = ""
local arenaBillboards = {}
local arenasChildAddedConn = nil

local RegisterDied = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Replicator"):WaitForChild("RegisterDied")
local ArenaReady = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Arena"):WaitForChild("Ready")

local function log(msg)
	warn("[ArenaFarm] " .. tostring(msg))
end

local function getFarmer()
	if farmerName == "" then
		return nil
	end
	return Players:FindFirstChild(farmerName)
end

local function containerHasBomb(container)
	if not container then
		return false
	end
	if container:FindFirstChild("Bomb", true) then
		return true
	end
	for _, d in ipairs(container:GetDescendants()) do
		if d.Name == "Bomb" then
			return true
		end
	end
	return false
end

local function playerHasBomb(plr)
	if not plr then
		return false
	end
	return containerHasBomb(plr.Character) or containerHasBomb(plr.Backpack)
end

local function anyoneHasBomb()
	if playerHasBomb(LocalPlayer) then
		return true, "local"
	end
	local farmer = getFarmer()
	if farmer and playerHasBomb(farmer) then
		return true, "farmer"
	end
	return false
end

local function waitForFullCharacter(plr)
	plr = plr or LocalPlayer
	if not plr.Character then
		plr.CharacterAdded:Wait()
	end
	local char = plr.Character
	char:WaitForChild("Humanoid", 20)
	char:WaitForChild("HumanoidRootPart", 20)
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
		repeat
			task.wait()
		until hum.Health > 0
	end
	task.wait(0.25)
end

local function getReadyHull()
	local arenas = workspace:FindFirstChild("Arenas")
	if not arenas then
		return nil
	end
	local arena = arenas:FindFirstChild(selectedArena)
	if not arena then
		return nil
	end
	local slots = arena:FindFirstChild("Slots")
	local left = slots and slots:FindFirstChild("Left")
	local slot1 = left and left:FindFirstChild("1")
	local hull = slot1 and slot1:FindFirstChild("Hull")
	if hull and hull:IsA("BasePart") then
		return hull
	end
	return nil
end

local function touchReadyButton()
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
		log("Hull не найден для " .. selectedArena)
		return false
	end

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

		if not anyoneHasBomb() then
			repeat
				task.wait(POLL)
			until anyoneHasBomb() or not running
		end
		if not running then
			return
		end

		log("Смерть " .. i .. "/" .. DIE_COUNT)
		pcall(function()
			RegisterDied:FireServer()
		end)
		waitForFullCharacter(LocalPlayer)
		task.wait(0.2)
	end
end

local function farmLoop()
	while running do
		if not anyoneHasBomb() then
			repeat
				task.wait(POLL)
			until anyoneHasBomb() or not running
		end
		if not running then
			break
		end

		log("Бомба найдена — цикл x" .. DIE_COUNT)
		doFiveDeaths()
		if not running then
			break
		end

		log("Ready: " .. selectedArena)
		touchReadyButton()
		task.wait(0.5)
	end
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
main.Size = UDim2.new(0, 220, 0, 312)
main.Position = UDim2.new(0, 12, 0.5, -156)
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

local arenaLabel = Instance.new("TextLabel")
arenaLabel.Size = UDim2.new(1, -12, 0, 18)
arenaLabel.Position = UDim2.new(0, 6, 0, 36)
arenaLabel.BackgroundTransparency = 1
arenaLabel.Text = "Арена (одна):"
arenaLabel.Font = Enum.Font.Gotham
arenaLabel.TextSize = 12
arenaLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
arenaLabel.TextXAlignment = Enum.TextXAlignment.Left
arenaLabel.Parent = main

local arenaBtns = {}
local arenaContainer = Instance.new("Frame")
arenaContainer.Size = UDim2.new(1, -12, 0, 108)
arenaContainer.Position = UDim2.new(0, 6, 0, 56)
arenaContainer.BackgroundTransparency = 1
arenaContainer.Parent = main

local grid = Instance.new("UIGridLayout")
grid.CellSize = UDim2.new(0.48, 0, 0, 30)
grid.CellPadding = UDim2.new(0.04, 0, 0, 6)
grid.Parent = arenaContainer

local function styleArenaBtn(btn, active)
	btn.BackgroundColor3 = active and Color3.fromRGB(70, 120, 200) or Color3.fromRGB(45, 45, 52)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
end

for _, arenaName in ipairs(ARENAS) do
	local btn = Instance.new("TextButton")
	btn.Name = arenaName
	btn.Text = arenaName
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 12
	btn.AutoButtonColor = false
	btn.BorderSizePixel = 0
	styleArenaBtn(btn, arenaName == selectedArena)
	local bc = Instance.new("UICorner")
	bc.CornerRadius = UDim.new(0, 6)
	bc.Parent = btn
	btn.Parent = arenaContainer
	arenaBtns[arenaName] = btn

	btn.MouseButton1Click:Connect(function()
		selectedArena = arenaName
		for n, b in pairs(arenaBtns) do
			styleArenaBtn(b, n == arenaName)
		end
	end)
end

local farmLabel = Instance.new("TextLabel")
farmLabel.Size = UDim2.new(1, -12, 0, 18)
farmLabel.Position = UDim2.new(0, 6, 0, 168)
farmLabel.BackgroundTransparency = 1
farmLabel.Text = "Имя фармящего:"
farmLabel.Font = Enum.Font.Gotham
farmLabel.TextSize = 12
farmLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
farmLabel.TextXAlignment = Enum.TextXAlignment.Left
farmLabel.Parent = main

local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(1, -12, 0, 30)
nameBox.Position = UDim2.new(0, 6, 0, 188)
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

nameBox.FocusLost:Connect(function()
	farmerName = nameBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
end)

local namesToggleBtn = Instance.new("TextButton")
namesToggleBtn.Size = UDim2.new(1, -12, 0, 32)
namesToggleBtn.Position = UDim2.new(0, 6, 0, 224)
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
toggleBtn.Position = UDim2.new(0, 6, 0, 262)
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
status.Size = UDim2.new(1, -12, 0, 0)
status.Visible = false
status.Parent = main

toggleBtn.MouseButton1Click:Connect(function()
	farmerName = nameBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
	running = not running
	if running then
		if farmerName == "" then
			log("Впиши имя фармящего")
			running = false
			return
		end
		if not getFarmer() then
			log("Игрок не в игре: " .. farmerName)
			running = false
			return
		end
		if not firetouchinterest then
			log("Нужен firetouchinterest")
			running = false
			return
		end
		toggleBtn.Text = "Автофарм: ВКЛ"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 140, 80)
		task.spawn(farmLoop)
	else
		toggleBtn.Text = "Автофарм: ВЫКЛ"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
	end
end)

log("GUI готова. Арена по умолчанию: " .. selectedArena)
