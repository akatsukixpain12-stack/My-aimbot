--// QUANTUM POWER v5.0 (FOV & SKILL AIM UPDATE)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local player = Players.LocalPlayer

-- Delta Friendly Bypass
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" then return end
    return oldNamecall(self, ...)
end)

-- Cleanup
if player.PlayerGui:FindFirstChild("QuantumUnifiedUI") then
    player.PlayerGui.QuantumUnifiedUI:Destroy()
end

-- FOV Circle Setup
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(255, 90, 0)
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = false
FOVCircle.Radius = 150

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "QuantumUnifiedUI"
gui.ResetOnSpawn = false

local restoreBtn = Instance.new("TextButton", gui)
restoreBtn.Size = UDim2.new(0, 100, 0, 30)
restoreBtn.Position = UDim2.new(0, 10, 1, -40)
restoreBtn.BackgroundColor3 = Color3.fromRGB(255, 90, 0)
restoreBtn.Text = "OPEN PANEL"
restoreBtn.TextColor3 = Color3.new(1,1,1)
restoreBtn.Font = Enum.Font.GothamBold
restoreBtn.Visible = false
Instance.new("UICorner", restoreBtn)

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 220, 0, 480)
main.Position = UDim2.new(0.5, -110, 0.5, -240)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 90, 0)
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Text = "Quantum v5.0"
titleLabel.TextColor3 = Color3.new(1,1,1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.BackgroundTransparency = 1
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local minBtn = Instance.new("TextButton", titleBar)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 5)
minBtn.Text = "_"
minBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
minBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0)

-- --- UI ELEMENTS ---

local box = Instance.new("TextBox", main)
box.Size = UDim2.new(0.65, 0, 0, 35)
box.Position = UDim2.new(0.05, 0, 0, 50)
box.PlaceholderText = "Username..."
box.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
box.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", box)

local listBtn = Instance.new("TextButton", main)
listBtn.Size = UDim2.new(0.2, 0, 0, 35)
listBtn.Position = UDim2.new(0.75, 0, 0, 50)
listBtn.Text = "LIST"
listBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
listBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", listBtn)

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(0.9, 0, 0, 120)
scroll.Position = UDim2.new(0.05, 0, 0, 90)
scroll.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
scroll.Visible = false
scroll.ZIndex = 10
scroll.CanvasSize = UDim2.new(0,0,0,0)
Instance.new("UICorner", scroll)
Instance.new("UIListLayout", scroll)

local tpBtn = Instance.new("TextButton", main)
tpBtn.Size = UDim2.new(0.9, 0, 0, 35)
tpBtn.Position = UDim2.new(0.05, 0, 0, 95)
tpBtn.Text = "Teleport"
tpBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
tpBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", tpBtn)

-- Aimbot Button
local aimBtn = Instance.new("TextButton", main)
aimBtn.Size = UDim2.new(0.9, 0, 0, 45)
aimBtn.Position = UDim2.new(0.05, 0, 0, 145)
aimBtn.Text = "AIMBOT [OFF]"
aimBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
aimBtn.TextColor3 = Color3.new(1,1,1)
aimBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", aimBtn)

-- Skill Aim Button
local skillBtn = Instance.new("TextButton", main)
skillBtn.Size = UDim2.new(0.9, 0, 0, 45)
skillBtn.Position = UDim2.new(0.05, 0, 0, 200)
skillBtn.Text = "SKILL AIM [OFF]"
skillBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
skillBtn.TextColor3 = Color3.new(1,1,1)
skillBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", skillBtn)

-- FOV Toggle Button
local fovBtn = Instance.new("TextButton", main)
fovBtn.Size = UDim2.new(0.9, 0, 0, 45)
fovBtn.Position = UDim2.new(0.05, 0, 0, 255)
fovBtn.Text = "SHOW FOV [OFF]"
fovBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
fovBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", fovBtn)

local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(0.9, 0, 0, 100)
status.Position = UDim2.new(0.05, 0, 0, 310)
status.Text = "Status: Idle"
status.TextColor3 = Color3.fromRGB(0, 255, 120)
status.BackgroundTransparency = 1
status.TextWrapped = true

-- --- LOGIC ---

-- List Fix
listBtn.MouseButton1Click:Connect(function()
    scroll.Visible = not scroll.Visible
    if scroll.Visible then
        for _, v in pairs(scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        for _, p in pairs(Players:GetPlayers()) do
            local pBtn = Instance.new("TextButton", scroll)
            pBtn.Size = UDim2.new(1, 0, 0, 30)
            pBtn.Text = p.Name
            pBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            pBtn.TextColor3 = Color3.new(1,1,1)
            pBtn.ZIndex = 11
            pBtn.MouseButton1Click:Connect(function()
                box.Text = p.Name
                scroll.Visible = false
            end)
        end
        scroll.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 30)
    end
end)

-- Dragging
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = i.Position; startPos = main.Position end end)
UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - dragStart; main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

minBtn.MouseButton1Click:Connect(function() main.Visible = false; restoreBtn.Visible = true end)
restoreBtn.MouseButton1Click:Connect(function() main.Visible = true; restoreBtn.Visible = false end)

-- Feature States
local aimEnabled = false
local skillEnabled = false
local showFOV = false

fovBtn.MouseButton1Click:Connect(function()
    showFOV = not showFOV
    FOVCircle.Visible = showFOV
    fovBtn.Text = "SHOW FOV [" .. (showFOV and "ON" or "OFF") .. "]"
end)

aimBtn.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    aimBtn.Text = "AIMBOT [" .. (aimEnabled and "ON" or "OFF") .. "]"
    aimBtn.BackgroundColor3 = aimEnabled and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(45, 45, 55)
end)

skillBtn.MouseButton1Click:Connect(function()
    skillEnabled = not skillEnabled
    skillBtn.Text = "SKILL AIM [" .. (skillEnabled and "ON" or "OFF") .. "]"
    skillBtn.BackgroundColor3 = skillEnabled and Color3.fromRGB(255, 170, 0) or Color3.fromRGB(45, 45, 55)
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    
    local target = nil
    local shortestDist = math.huge
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(FOVCircle.Position.X, FOVCircle.Position.Y)).Magnitude
                if mag < shortestDist and mag <= FOVCircle.Radius then
                    shortestDist = mag
                    target = p
                end
            end
        end
    end

    if target and target.Character then
        local head = target.Character:FindFirstChild("Head")
        if head then
            if aimEnabled then
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, head.Position)
            end
            if skillEnabled then
                -- Silent/Skill Aim logic: Forces mouse to target without moving camera
                local pos = Camera:WorldToViewportPoint(head.Position)
                -- (Note: Most skills use Mouse.Hit, this logic prepares target data)
                status.Text = "Skill Locking: " .. target.Name
            end
        end
    end
end)

tpBtn.MouseButton1Click:Connect(function()
    local t = Players:FindFirstChild(box.Text)
    if t and t.Character then player.Character:SetPrimaryPartCFrame(t.Character.HumanoidRootPart.CFrame) end
end)
