--// MERGED QUANTUM POWER & MINI UI v3.0
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

-- Cleanup old UI
if player.PlayerGui:FindFirstChild("MergedQuantumUI") then
    player.PlayerGui.MergedQuantumUI:Destroy()
end

-- Main UI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MergedQuantumUI"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 220, 0, 360)
main.Position = UDim2.new(0.5, -110, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Title Bar (Handle for Dragging)
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 90, 0)
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "Quantum Panel v3.0"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BackgroundTransparency = 1

-- Unified Dragging Logic
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = i.Position
        startPos = main.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- --- SECTION 1: PLAYER TOOLS ---
local box = Instance.new("TextBox", main)
box.Size = UDim2.new(0.9, 0, 0, 35)
box.Position = UDim2.new(0.05, 0, 0, 50)
box.PlaceholderText = "Target Username"
box.Text = ""
box.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
box.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

local tpBtn = Instance.new("TextButton", main)
tpBtn.Size = UDim2.new(0.9, 0, 0, 35)
tpBtn.Position = UDim2.new(0.05, 0, 0, 95)
tpBtn.Text = "Teleport to Player"
tpBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
tpBtn.TextColor3 = Color3.new(1,1,1)
tpBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)

-- --- SECTION 2: AIMBOT CONTROLS ---
local line = Instance.new("Frame", main)
line.Size = UDim2.new(0.9, 0, 0, 2)
line.Position = UDim2.new(0.05, 0, 0, 145)
line.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
line.BorderSizePixel = 0

local toggleBtn = Instance.new("TextButton", main)
toggleBtn.Size = UDim2.new(0.9, 0, 0, 50)
toggleBtn.Position = UDim2.new(0.05, 0, 0, 160)
toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
toggleBtn.Text = "AIMBOT [OFF]"
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 18
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)

local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(0.9, 0, 0, 100)
status.Position = UDim2.new(0.05, 0, 0, 220)
status.Text = "Status: Idle\nReady for action"
status.TextColor3 = Color3.fromRGB(0, 255, 120)
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.BackgroundTransparency = 1
status.TextWrapped = true

-- Logic: Teleport
tpBtn.MouseButton1Click:Connect(function()
    local target = Players:FindFirstChild(box.Text)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        player.Character:SetPrimaryPartCFrame(target.Character.HumanoidRootPart.CFrame)
        status.Text = "Teleported to: " .. target.Name
    else
        status.Text = "Player not found!"
    end
end)

-- Logic: Aimbot
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
                    if d < minDist and d <= 500 then
                        minDist = d
                        closest = p
                    end
                end
            end

            if closest and closest.Character and closest.Character:FindFirstChild("Head") then
                local head = closest.Character.Head
                local predict = head.Position + head.Velocity * 0.1
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, predict)
                status.Text = "Aiming: " .. closest.Name
            end
        end)
    else
        if aimConn then aimConn:Disconnect() end
        status.Text = "Aimbot: Stopped"
    end
end)

print("✅ Merged UI Loaded: Teleport & Aimbot Active.")
