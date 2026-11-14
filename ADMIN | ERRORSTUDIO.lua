if getgenv().TwoK then pcall(getgenv().TwoK.Stop) end
local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local LocalPlayer = Players.LocalPlayer
local Hub = {Running = true, Flags = {Farm = false}, Conns = {}, Busy = {}}
getgenv().TwoK = Hub
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/NeverWinnow/ERROR-STUDIO/refs/heads/main/Lodging"))()
Hub.UI = UI
function Hub.Stop()
    Hub.Running = false
    Hub.Flags.Farm = false
    for _, c in ipairs(Hub.Conns) do pcall(function() c:Disconnect() end) end
    pcall(function() UI:Destroy() end)
end
UI:SetTitle("ADMIN | ERROR STUDIO")
local Tab = UI:Tab("TEST")
local S = Tab:Section("เก็บงานก่อสร้าง")
S:Label("ไม่วาร์ป • เดินเข้าใกล้จุดงานแล้วระบบกดค้างตาม HoldDuration")
S:Toggle({Name = "ฟาร์มอัตโนมัติในระยะ", Desc = "ทำงานเฉพาะพรอมป์ที่อยู่ในระยะที่เกมกำหนด", Default = false, Callback = function(v) Hub.Flags.Farm = v end})
S:Button({Name = "ทำงานจุดใกล้ตัว 1 รอบ", Callback = function()
    task.spawn(function()
        local folder = workspace:FindFirstChild("ก่อสร้าง")
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not folder or not root then return end
        for _, obj in ipairs(folder:GetDescendants()) do
            if not Hub.Running then break end
            if obj:IsA("ProximityPrompt") and obj.Enabled and not Hub.Busy[obj] then
                local parent = obj.Parent
                local part = parent and (parent:IsA("BasePart") and parent or parent:FindFirstChildWhichIsA("BasePart", true))
                if part and (root.Position - part.Position).Magnitude <= obj.MaxActivationDistance then
                    Hub.Busy[obj] = true
                    pcall(function()
                        obj:InputHoldBegin()
                        task.wait(math.max(obj.HoldDuration, 0.1) + 0.08)
                        obj:InputHoldEnd()
                    end)
                    task.wait(0.15)
                    Hub.Busy[obj] = nil
                end
            end
        end
    end)
end})
UI:AddSettingsTab()
UI:Toggle(true)
task.spawn(function()
    while Hub.Running do
        if Hub.Flags.Farm then
            pcall(function()
                local folder = workspace:FindFirstChild("ก่อสร้าง")
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if not folder or not root then return end
                for _, obj in ipairs(folder:GetDescendants()) do
                    if not Hub.Running or not Hub.Flags.Farm then break end
                    if obj:IsA("ProximityPrompt") and obj.Enabled and not Hub.Busy[obj] then
                        local parent = obj.Parent
                        local part = parent and (parent:IsA("BasePart") and parent or parent:FindFirstChildWhichIsA("BasePart", true))
                        if part and (root.Position - part.Position).Magnitude <= obj.MaxActivationDistance then
                            Hub.Busy[obj] = true
                            pcall(function()
                                obj:InputHoldBegin()
                                task.wait(math.max(obj.HoldDuration, 0.1) + 0.08)
                                obj:InputHoldEnd()
                            end)
                            task.wait(0.15)
                            Hub.Busy[obj] = nil
                        end
                    end
                end
            end)
        end
        task.wait(0.2)
    end
end)
