--====================================
-- FIND THE HEADS | FINAL FULL SCRIPT
-- ESP PLAYER + ESP HEAD + TP + NOCLIP + GUI TOGGLE
--====================================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- CONFIG
local HEAD_FOLDER = "Collect"

-- STATES
local ESP_PLAYER = true
local ESP_HEAD = true
local AUTO_TP = false
local NOCLIP = false
local GUI_VISIBLE = true

-- ESP STORAGE
local PLAYER_ESP = {}
local HEAD_ESP = {}

--====================================
-- GUI
--====================================
local gui = Instance.new("ScreenGui")
gui.Name = "FindTheHeads_GUI"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

-- TOGGLE BUTTON
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,45,0,45)
toggleBtn.Position = UDim2.new(0,10,0.5,-22)
toggleBtn.Text = "☰"
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.BorderSizePixel = 0
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)

-- MAIN FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,340,0,300)
frame.Position = UDim2.new(0.05,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

toggleBtn.MouseButton1Click:Connect(function()
	GUI_VISIBLE = not GUI_VISIBLE
	frame.Visible = GUI_VISIBLE
end)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,45)
title.Text = "FIND THE HEADS | SCRIPT"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(35,35,35)
title.BorderSizePixel = 0
Instance.new("UICorner", title).CornerRadius = UDim.new(0,14)

-- TAB BUTTONS
local espBtn = Instance.new("TextButton", frame)
espBtn.Text = "ESP"
espBtn.Size = UDim2.new(0.5,0,0,35)
espBtn.Position = UDim2.new(0,0,0,45)

local tpBtn = Instance.new("TextButton", frame)
tpBtn.Text = "TP"
tpBtn.Size = UDim2.new(0.5,0,0,35)
tpBtn.Position = UDim2.new(0.5,0,0,45)

for _,b in ipairs({espBtn,tpBtn}) do
	b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	b.TextColor3 = Color3.new(1,1,1)
	b.BorderSizePixel = 0
	b.TextScaled = true
end

-- CONTENT FRAMES
local espFrame = Instance.new("Frame", frame)
espFrame.Size = UDim2.new(1,0,1,-85)
espFrame.Position = UDim2.new(0,0,0,85)
espFrame.BackgroundTransparency = 1

local tpFrame = espFrame:Clone()
tpFrame.Parent = frame
tpFrame.Visible = false

espBtn.MouseButton1Click:Connect(function()
	espFrame.Visible = true
	tpFrame.Visible = false
end)

tpBtn.MouseButton1Click:Connect(function()
	espFrame.Visible = false
	tpFrame.Visible = true
end)

--====================================
-- ESP BUTTONS
--====================================
local espPlayerBtn = Instance.new("TextButton", espFrame)
espPlayerBtn.Size = UDim2.new(0.9,0,0,45)
espPlayerBtn.Position = UDim2.new(0.05,0,0.1,0)
espPlayerBtn.Text = "ESP PLAYER : ON"
espPlayerBtn.TextScaled = true
espPlayerBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
espPlayerBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", espPlayerBtn)

local espHeadBtn = Instance.new("TextButton", espFrame)
espHeadBtn.Size = UDim2.new(0.9,0,0,45)
espHeadBtn.Position = UDim2.new(0.05,0,0.3,0)
espHeadBtn.Text = "ESP HEAD : ON"
espHeadBtn.TextScaled = true
espHeadBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
espHeadBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", espHeadBtn)

espPlayerBtn.MouseButton1Click:Connect(function()
	ESP_PLAYER = not ESP_PLAYER
	espPlayerBtn.Text = ESP_PLAYER and "ESP PLAYER : ON" or "ESP PLAYER : OFF"
end)

espHeadBtn.MouseButton1Click:Connect(function()
	ESP_HEAD = not ESP_HEAD
	espHeadBtn.Text = ESP_HEAD and "ESP HEAD : ON" or "ESP HEAD : OFF"
end)

--====================================
-- TP BUTTONS
--====================================
local tpOnce = Instance.new("TextButton", tpFrame)
tpOnce.Size = UDim2.new(0.9,0,0,45)
tpOnce.Position = UDim2.new(0.05,0,0.1,0)
tpOnce.Text = "TP TO NEXT HEAD"
tpOnce.TextScaled = true
tpOnce.BackgroundColor3 = Color3.fromRGB(60,60,60)
tpOnce.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", tpOnce)

local tpAuto = Instance.new("TextButton", tpFrame)
tpAuto.Size = UDim2.new(0.9,0,0,45)
tpAuto.Position = UDim2.new(0.05,0,0.32,0)
tpAuto.Text = "AUTO TP : OFF"
tpAuto.TextScaled = true
tpAuto.BackgroundColor3 = Color3.fromRGB(60,60,60)
tpAuto.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", tpAuto)

local noclipBtn = Instance.new("TextButton", tpFrame)
noclipBtn.Size = UDim2.new(0.9,0,0,45)
noclipBtn.Position = UDim2.new(0.05,0,0.54,0)
noclipBtn.Text = "NOCLIP : OFF"
noclipBtn.TextScaled = true
noclipBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
noclipBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", noclipBtn)

--====================================
-- UTIL
--====================================
local function getPos(model)
	for _,v in ipairs(model:GetDescendants()) do
		if v:IsA("BasePart") then
			return v.Position
		end
	end
end

local function newESP(color)
	local box = Drawing.new("Square")
	box.Color = color
	box.Thickness = 2
	box.Filled = false

	local text = Drawing.new("Text")
	text.Size = 14
	text.Center = true
	text.Outline = true

	return {Box = box, Text = text}
end

--====================================
-- LOAD HEAD ESP
--====================================
local function loadHeads()
	local folder = workspace:FindFirstChild(HEAD_FOLDER)
	if not folder then return end
	for _,h in ipairs(folder:GetChildren()) do
		if h:IsA("Model") and not HEAD_ESP[h] then
			HEAD_ESP[h] = newESP(Color3.fromRGB(0,170,255))
		end
	end
end
loadHeads()

--====================================
-- RENDER ESP
--====================================
RunService.RenderStepped:Connect(function()
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	-- PLAYER ESP
	for _,plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character then
			local esp = PLAYER_ESP[plr] or newESP(Color3.fromRGB(255,80,80))
			PLAYER_ESP[plr] = esp

			if not ESP_PLAYER then
				esp.Box.Visible = false
				esp.Text.Visible = false
				continue
			end

			local pos = getPos(plr.Character)
			if pos then
				local s,on = Camera:WorldToViewportPoint(pos)
				if on then
					esp.Box.Size = Vector2.new(40,40)
					esp.Box.Position = Vector2.new(s.X-20,s.Y-20)
					esp.Box.Visible = true
					esp.Text.Text = plr.Name
					esp.Text.Position = Vector2.new(s.X,s.Y-30)
					esp.Text.Visible = true
				end
			end
		end
	end

	-- HEAD ESP
	for model,esp in pairs(HEAD_ESP) do
		if not ESP_HEAD or not model.Parent then
			esp.Box.Visible = false
			esp.Text.Visible = false
			continue
		end

		local pos = getPos(model)
		if pos then
			local s,on = Camera:WorldToViewportPoint(pos)
			if on then
				local d = math.floor((hrp.Position-pos).Magnitude)
				esp.Box.Size = Vector2.new(40,40)
				esp.Box.Position = Vector2.new(s.X-20,s.Y-20)
				esp.Box.Visible = true
				esp.Text.Text = model.Name.." ["..d.."m]"
				esp.Text.Position = Vector2.new(s.X,s.Y-32)
				esp.Text.Visible = true
			end
		end
	end
end)

--====================================
-- TP + NOCLIP
--====================================
local index = 1

local function getHeads()
	local folder = workspace:FindFirstChild(HEAD_FOLDER)
	if not folder then return {} end
	return folder:GetChildren()
end

local function tpTo(model)
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if hrp then
		local pos = getPos(model)
		if pos then
			hrp.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
		end
	end
end

tpOnce.MouseButton1Click:Connect(function()
	local heads = getHeads()
	if heads[index] then
		tpTo(heads[index])
		index += 1
	end
end)

tpAuto.MouseButton1Click:Connect(function()
	AUTO_TP = not AUTO_TP
	tpAuto.Text = AUTO_TP and "AUTO TP : ON" or "AUTO TP : OFF"

	task.spawn(function()
		while AUTO_TP do
			for _,h in ipairs(getHeads()) do
				if not AUTO_TP then break end
				tpTo(h)
				task.wait(1)
			end
		end
	end)
end)

noclipBtn.MouseButton1Click:Connect(function()
	NOCLIP = not NOCLIP
	noclipBtn.Text = NOCLIP and "NOCLIP : ON" or "NOCLIP : OFF"
end)

RunService.Stepped:Connect(function()
	if NOCLIP then
		local char = LocalPlayer.Character
		if char then
			for _,v in ipairs(char:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end
	end
end)

print("✅ FIND THE HEADS | FULL FINAL SCRIPT LOADED")
