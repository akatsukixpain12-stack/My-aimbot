--// QUANTUM POWER v4.5 (DROPDOWN UPDATE)
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

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "QuantumUnifiedUI"
gui.ResetOnSpawn = false

-- Restore Button
local restoreBtn = Instance.new("TextButton", gui)
restoreBtn.Size = UDim2.new(0, 100, 0, 30)
restoreBtn.Position = UDim2.new(0, 10, 1, -40)
restoreBtn.BackgroundColor3 = Color3.fromRGB(255, 90, 0)
restoreBtn.Text = "OPEN PANEL"
restoreBtn.TextColor3 = Color3.new(1,1,1)
restoreBtn.Font = Enum.Font.GothamBold
restoreBtn.Visible = false
Instance.new("UICorner", restoreBtn)

-- Main Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 220, 0, 380)
main.Position = UDim2.new(0.5, -110, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Title Bar
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 90, 0)
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Text = "Quantum v4.5"
titleLabel.TextColor3 = Color3.new(1,1,1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.BackgroundTransparency = 1
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize Button
local minBtn = Instance.new("TextButton", titleBar)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 5)
minBtn.Text = "_"
minBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
minBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0)

-- --- PLAYER SECTION ---

local box = Instance.new("TextBox", main)
box.Size = UDim2.new(0.65, 0, 0, 35)
box.Position = UDim2.new(0.05, 0, 0, 55)
box.PlaceholderText = "Username..."
box.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
box.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

local listBtn = Instance.new("TextButton", main)
listBtn.Size = UDim2.new(0.2, 0, 0, 35)
listBtn.Position = UDim2.new(0.75, 0, 0, 55)
listBtn.Text = "LIST"
listBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
listBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", listBtn)

-- Scrolling Dropdown (Hidden initially)
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(0.9, 0, 0, 150)
scroll.Position = UDim2.new(0.05, 0, 0, 95)
scroll.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
scroll.Visible = false
scroll.ZIndex = 5
Instance.new("UICorner", scroll)

local layout = Instance.new("UIListLayout", scroll)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local tpBtn = Instance.new("TextButton", main)
tpBtn.Size = UDim2.new(0.9, 0, 0, 35)
tpBtn.Position = UDim2.new(0.05, 0, 0, 100)
tpBtn.Text = "Teleport"
tpBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
tpBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", tpBtn)

-- --- COMBAT SECTION ---

local toggleBtn = Instance.new("TextButton", main)
toggleBtn.Size = UDim2.new(0.9, 0, 0, 50)
toggleBtn.Position = UDim2.new(0.05, 0, 0, 160)
toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
toggleBtn.Text = "AIMBOT [OFF]"
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", toggleBtn)

local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(0.9, 0, 0, 100)
status.Position = UDim2.new(0.05, 0, 0, 220)
status.Text = "Status: Idle"
status.TextColor3 = Color3.fromRGB(0, 255, 120)
status.BackgroundTransparency = 1
status.TextWrapped = true

-- --- LOGIC ---

-- Dragging
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = i.Position; startPos = main.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

-- Min/Restore
minBtn.MouseButton1Click:Connect(function() main.Visible = false; restoreBtn.Visible = true end)
restoreBtn.MouseButton1Click:Connect(function() main.Visible = true; restoreBtn.Visible = false end)

-- Player List Logic
listBtn.MouseButton1Click:Connect(function()
    scroll.Visible = not scroll.Visible
    if scroll.Visible then
        for _, v in pairs(scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player then
                local pBtn = Instance.new("TextButton", scroll)
                pBtn.Size = UDim2.new(1, 0, 0, 30)
                pBtn.Text = p.Name
                pBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                pBtn.TextColor3 = Color3.new(1,1,1)
                pBtn.MouseButton1Click:Connect(function()
                    box.Text = p.Name
                    scroll.Visible = false
                end)
            end
        end
        scroll.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 30)
    end
end)

-- Teleport Logic
tpBtn.MouseButton1Click:Connect(function()
    local target = Players:FindFirstChild(box.Text)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        player.Character:SetPrimaryPartCFrame(target.Character.HumanoidRootPart.CFrame)
        status.Text = "Teleported to: " .. target.Name
    else
        status.Text = "Player not found!"
    end
end)

-- Aimbot Logic
local aimEnabled = false
local aimConn
toggleBtn.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    toggleBtn.Text = "AIMBOT [" .. (aimEnabled and "ON ✅" or "OFF") .. "]"
    toggleBtn.BackgroundColor3 = aimEnabled and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(45, 45, 55)
    if aimEnabled then
        aimConn = RunService.RenderStepped:Connect(function()
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local closest, minDist = nil, math.huge
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                    local d = (root.Position - p.Character.Head.Position).Magnitude
                    if d < minDist and d <= 500 then minDist = d; closest = p end
                end
            end
            if closest and closest.Character and closest.Character:FindFirstChild("Head") then
                local head = closest.Character.Head
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, head.Position + head.Velocity * 0.1)
                status.Text = "Aiming: " .. closest.Name
            end
        end)
    else
        if aimConn then aimConn:Disconnect() end
        status.Text = "Aimbot: Stopped"
    end
end)

print("✅ Quantum v4.5 with Player List Loaded.")
