-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")  -- Untuk simulasi key press kalau perlu

-- ====== FORWARD DECLARE MAIN GUI ======
local function loadMainGui() end

-- ====== MAIN GUI FUNCTION ======
function loadMainGui()
    -- Load the UI framework
    local UI1 = loadstring(game:HttpGet("https://gist.githubusercontent.com/1ksScripts/9677b4adf372380252e8e840209094e0/raw/18a19028d2114df920421eba871e37fee43aa59f/1ksMakesScriptBestScriptUniversal"))()

    -- Main window - DISABLE CloseUIButton bawaan supaya nggak bentrok
    local Win1 = UI1:Window({
        Title = "BiG Hub",
        Desc = "Made By: Bilal Ganteng",
        Icon = 11041446595,
        Config = {Keybind = Enum.KeyCode.LeftControl, Size = UDim2.new(0,450,0,350)},
        CloseUIButton = {Enabled = false}  -- Hilangkan tombol bawaan!
    })

    local Me1 = Players.LocalPlayer

    -- Buat SATU tombol toggle custom (dark gray, mirip library default, bukan pink!)
    local ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = "BiGToggle"
    ToggleGui.ResetOnSpawn = false
    ToggleGui.Parent = CoreGui

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "ToggleBtn"
    ToggleBtn.Size = UDim2.new(0, 90, 0, 35)
    ToggleBtn.Position = UDim2.new(0, 15, 0, 15)  -- Atas kiri, gampang dilihat
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)  -- Dark gray default
    ToggleBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    ToggleBtn.Font = Enum.Font.GothamSemibold
    ToggleBtn.TextSize = 16
    ToggleBtn.Text = "Open"  -- Awal tertutup (biar aman)
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.Parent = ToggleGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = ToggleBtn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(80, 80, 80)
    stroke.Thickness = 1
    stroke.Parent = ToggleBtn

    -- Fungsi toggle: simulasi tekan LeftControl supaya library handle animasi sendiri
    local function toggleGui()
        -- Simulasi key press LeftControl (library toggle sendiri)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
    end

    -- Klik tombol → toggle
    ToggleBtn.MouseButton1Click:Connect(toggleGui)

    -- Sync text tombol (cek apakah UI visible via cari CanvasGroup di library ScreenGui)
    local function updateText()
        local visible = false
        for _, gui in pairs(CoreGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name ~= "BiGToggle" and gui:FindFirstChildWhichIsA("CanvasGroup") then
                local cg = gui:FindFirstChildWhichIsA("CanvasGroup")
                if cg and cg.GroupTransparency < 0.5 then
                    visible = true
                    break
                end
            end
        end
        ToggleBtn.Text = visible and "Close" or "Open"
    end

    -- Update text setiap frame (ringan, nggak lag)
    RunService.Heartbeat:Connect(updateText)

    -- Awal: tutup GUI kalau library auto open, biar tombol "Open"
    task.delay(1, function()
        if ToggleBtn.Text == "Close" then
            toggleGui()  -- Tutup dulu
        end
    end)

    -- Sisanya sama (Avatar Changer, Name Changer, dll)
    local Tab1 = Win1:Tab({Title = "Avatar Changer", Icon = "user"})
    Tab1:Section({Title = "BiG"})
    local Inp1 = ""

    Tab1:Textbox({
        Title = "Set target username or userid",
        Desc = "Enter any player username or UserID",
        Placeholder = "npa_sab",
        Value = "",
        ClearTextOnFocus = false,
        Callback = function(txt) Inp1 = txt end
    })

    Tab1:Button({
        Title = "Set Avatar",
        Desc = "Turn you into the target avatar",
        Callback = function()
            if Inp1 and Inp1 ~= "" then
                local Num1 = tonumber(Inp1)
                if Num1 then Mor1(Num1)
                else
                    local Pl3 = Players:FindFirstChild(Inp1)
                    if Pl3 then Mor1(Pl3.UserId)
                    else
                        local Suc2, Res1 = pcall(function() return Players:GetUserIdFromNameAsync(Inp1) end)
                        if Suc2 then Mor1(Res1)
                        else Win1:Notify({Title="Error", Desc="Player not found", Time=3}) end
                    end
                end
            else Win1:Notify({Title="Error", Desc="Enter username or UserID", Time=3}) end
        end
    })

    function Mor1(ID1)
        local Suc1, App1 = pcall(function() return Players:GetCharacterAppearanceAsync(ID1) end)
        if not Suc1 then Win1:Notify({Title="Error", Desc="Can't turn you into target avatar", Time=3}) return false end
        local Chr1 = Me1.Character
        if not Chr1 then Win1:Notify({Title="Error", Desc="I can't find your character", Time=3}) return false end
        local Hum1 = Chr1:WaitForChild("Humanoid")
        for _,Itm in pairs(Chr1:GetChildren()) do
            if Itm:IsA("Accessory") or Itm:IsA("Shirt") or Itm:IsA("Pants") or Itm:IsA("CharacterMesh") or Itm:IsA("BodyColors") then
                Itm:Destroy()
            end
        end
        if Chr1:FindFirstChild("Head") and Chr1.Head:FindFirstChild("face") then Chr1.Head.face:Destroy() end
        for _,Itm in pairs(App1:GetChildren()) do
            if Itm:IsA("Accessory") then local Acc = Itm:Clone() if Acc:FindFirstChild("Handle") then Hum1:AddAccessory(Acc) end end
            if Itm:IsA("Shirt") or Itm:IsA("Pants") or Itm:IsA("BodyColors") then Itm:Clone().Parent = Chr1 end
        end
        if Chr1:FindFirstChild("Head") then
            if App1:FindFirstChild("face") then App1.face:Clone().Parent = Chr1.Head
            else
                local f = Instance.new("Decal", Chr1.Head)
                f.Name = "face"; f.Face = Enum.NormalId.Front; f.Texture = "rbxasset://textures/face.png"
            end
        end
        task.wait(0.1)
        local p = Chr1.Parent; Chr1.Parent=nil; Chr1.Parent=p
        Win1:Notify({Title="Success", Desc="Avatar changed!", Time=3})
        return true
    end

    -- (Lanjutkan dengan Name Changer, Discord, How To Use seperti sebelumnya - copy dari script lama kalau perlu)

    -- Pink theme untuk window (tetep)
    for _, Frame in pairs(Win1:GetDescendants()) do
        if Frame:IsA("Frame") then
            Frame.BackgroundColor3 = Color3.fromRGB(255,182,193)
            if Frame:FindFirstChild("UICorner") then Frame.UICorner.CornerRadius=UDim.new(0,15) end
        end
    end
end

loadMainGui()
