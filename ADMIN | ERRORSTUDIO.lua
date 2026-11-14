If getgenv().TwoK then pcall(getgenv().TwoK.Stop) end
Local Players = game:GetService("Players")
Local ProximityPromptService = game:GetService("ProximityPromptService")
Local LocalPlayer = Players.LocalPlayer
Local Hub = {Running = true, Flags = {Farm = false}, Conns = {}, Busy = {}}
getgenv().TwoK = Hub
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/NeverWinnow/ERROR-STUDIO/refs/heads/main/Lodging"))()
Hub.UI = UI
function Hub.Stop()
    Hub.Running = false
    Hub.Flags.Farm = false
    For _, c in ipairs(Hub.Conns) do pcall(function() c:Disconnect() end) end
    pcall(function() UI:Destroy() end)
end
UI:SetTitle("ADMIN | ERROR STUDIO")
local Tab = UI:Tab("TEST")
local S = Tab:Section("เก็บงานก่อสร้าง")

-- เพิ่มการแจ้งเตือนใน Callback ของ Toggle
S:Toggle({
    Name = "ฟาร์มอัตโนมัติในระยะ", 
    Desc = "ทำงานเฉพาะพรอมป์ที่อยู่ในระยะที่เกมกำหนด", 
    Default = false, 
    Callback = function(v) 
        Hub.Flags.Farm = v 
        
        -- โค้ดสำหรับแสดงข้อความแจ้งเตือน (Notification)
        UI:Notify({
            Title = "ระบบฟาร์ม",
            Text = v and "เปิดใช้งานฟาร์มอัตโนมัติแล้ว" or "ปิดการใช้งานฟาร์มอัตโนมัติแล้ว",
            Duration = 3,
        })
    end
})

-- (โค้ดส่วนลูปการทำงานเดิมของคุณ)
task.spawn(function()
    while Hub.Running do
        If Hub.Flags.Farm then
            Pcall(function()
                Local folder = workspace:FindFirstChild("ก่อสร้าง")
                Local char = LocalPlayer.Character
                Local root = char and char:FindFirstChild("HumanoidRootPart")
                If not folder or not root then return end
                For _, obj in ipairs(folder:GetDescendants()) do
                    If not Hub.Running or not Hub.Flags.Farm then break end
                    If obj:IsA("ProximityPrompt") and obj.Enabled and not Hub.Busy[obj] then
                        Local parent = obj.Parent
                        Local part = parent and (parent:IsA("BasePart") and parent or parent:FindFirstChildWhichIsA("BasePart", true))
                        If part and (root.Position - part.Position).Magnitude <= obj.MaxActivationDistance then
                            Hub.Busy[obj] = true
                            Pcall(function()
                                Obj:InputHoldBegin()
                                Task.wait(math.max(obj.HoldDuration, 0.1) + 0.08)
                                Obj:InputHoldEnd()
                            end)
                            Task.wait(0.15)
                            Hub.Busy[obj] = nil
                        End
                    End
                end
            end)
        End
        Task.wait(0.2)
    end
end)

UI:AddSettingsTab()
UI:Toggle(true)
