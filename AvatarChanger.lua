-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- ====== FORWARD DECLARE MAIN GUI ======
local function loadMainGui() end

-- ====== MAIN GUI FUNCTION ======
function loadMainGui()
    -- Load the UI framework
    local UI1 = loadstring(game:HttpGet("https://gist.githubusercontent.com/1ksScripts/9677b4adf372380252e8e840209094e0/raw/18a19028d2114df920421eba871e37fee43aa59f/1ksMakesScriptBestScriptUniversal"))()

    -- Main window (DISABLE CloseUIButton bawaan biar nggak ada tombol ganda)
    local Win1 = UI1:Window({
        Title = "BiG Hub",
        Desc = "Made By: Bilal Ganteng",
        Icon = 11041446595,
        Config = {Keybind = Enum.KeyCode.LeftControl, Size = UDim2.new(0,450,0,350)},
        CloseUIButton = {Enabled = false}  -- Disable bawaan!
    })

    local Me1 = Players.LocalPlayer

    -- Tunggu library buat ScreenGui-nya & find instance penting (Shadow_1 & Background_1 CanvasGroup)
    task.wait(0.5)
    local libraryGui
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui:FindFirstChild("Shadow_1", true) then
            libraryGui = gui
            break
        end
    end
    if not libraryGui then
        Win1:Notify({Title="Error", Desc="Library GUI not found", Time=5})
        return
    end
    local Shadow_1 = libraryGui:FindFirstChild("Shadow_1", true)
    local Background_1 = libraryGui:FindFirstChild("Background_1", true)  -- CanvasGroup utama
    local oSize = Background_1.Size  -- Simpan ukuran original

    -- Buat SATU tombol toggle custom (style MIRIP library default: dark gray, bukan pink!)
    local ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = "BiGToggleFixed"
    ToggleGui.ResetOnSpawn = false
    ToggleGui.Parent = CoreGui

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "ToggleBtnFixed"
    ToggleBtn.Size = UDim2.new(0, 80, 0, 35)
    ToggleBtn.Position = UDim2.new(0, 10, 0, 10)  -- Atas kiri, mirip library CloseUI
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)  -- Dark gray seperti library default
    ToggleBtn.TextColor3 = Color3.new(1, 1, 1)  -- White text
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 14
    ToggleBtn.Text = "Close"  -- Awal terbuka
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.Parent = ToggleGui

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = ToggleBtn

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(60, 60, 60)
    BtnStroke.Thickness = 1
    BtnStroke.Parent = ToggleBtn

    -- Fungsi toggle manual (copy logic library: tween GroupTransparency + Size + Shadow.Visible)
    local function toggleWindow()
        local trans = Background_1.GroupTransparency
        local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Linear)
        if trans < 0.5 then  -- Terbuka → tutup
            local shrinkTween = TweenService:Create(Background_1, tweenInfo, {
                GroupTransparency = 1,
                Size = Background_1.Size - UDim2.new(0, 5, 0, 5)
            })
            shrinkTween:Play()
            shrinkTween.Completed:Connect(function()
                Shadow_1.Visible = false
            end)
        else  -- Tertutup → buka
            Shadow_1.Visible = true
            local openTween = TweenService:Create(Background_1, tweenInfo, {
                GroupTransparency = 0,
                Size = oSize
            })
            openTween:Play()
        end
    end

    -- Click tombol → toggle
    ToggleBtn.MouseButton1Click:Connect(toggleWindow)

    -- Sync text real-time (cek transparency CanvasGroup)
    RunService.Heartbeat:Connect(function()
        local trans = Background_1.GroupTransparency
        ToggleBtn.Text = (trans < 0.5) and "Close" or "Open"
    end)

    -- === Avatar Changer Tab ===
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

    -- === Name Changer Tab ===
    local Tab2 = Win1:Tab({Title="Name Changer", Icon="user"})
    Tab2:Section({Title="Edit Names"})

    local FakeDisplay = Me1.DisplayName
    local FakeUser = Me1.Name

    local usernameInput = ""
    Tab2:Textbox({
        Title="Edit Username",
        Desc="Set a fake username",
        Placeholder="New Username",
        Value="",
        ClearTextOnFocus=false,
        Callback=function(txt) usernameInput = txt end
    })
    Tab2:Button({
        Title="Apply Username",
        Desc="Apply the new fake username",
        Callback=function()
            if usernameInput and usernameInput:match("%S") then
                FakeUser = usernameInput
            end
        end
    })

    local displaynameInput = ""
    Tab2:Textbox({
        Title="Edit DisplayName",
        Desc="Set a fake DisplayName",
        Placeholder="New DisplayName",
        Value="",
        ClearTextOnFocus=false,
        Callback=function(txt) displaynameInput = txt end
    })
    Tab2:Button({
        Title="Apply DisplayName",
        Desc="Apply the new fake display name",
        Callback=function()
            if displaynameInput and displaynameInput:match("%S") then
                FakeDisplay = displaynameInput
            end
        end
    })

    -- Name patch logic
    local function applyReplacements(text)
        if not text or text == "" then return nil end
        local origDisp, origUser = Me1.DisplayName, Me1.Name
        local changed = false

        if origDisp ~= "" and text:find(origDisp..":", 1, true) then
            text = text:gsub(origDisp, FakeDisplay)
            changed = true
        elseif text == origDisp then
            text = FakeDisplay
            changed = true
        end

        if origUser ~= "" and text:find("@"..origUser, 1, true) then
            text = text:gsub("@"..origUser, "@"..FakeUser)
            changed = true
        elseif text == "@"..origUser then
            text = "@"..FakeUser
            changed = true
        end

        return changed and text or nil
    end

    local function patchLabel(lbl)
        local newText = applyReplacements(lbl.Text)
        if newText then lbl.Text = newText end
    end

    local function watchGui(root)
        root.DescendantAdded:Connect(function(d)
            if d:IsA("TextLabel") or d:IsA("TextButton") then
                d:GetPropertyChangedSignal("Text"):Connect(function()
                    patchLabel(d)
                end)
                patchLabel(d)
            end
        end)
        for _,d in ipairs(root:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("TextButton") then
                d:GetPropertyChangedSignal("Text"):Connect(function()
                    patchLabel(d)
                end)
                patchLabel(d)
            end
        end
    end

    watchGui(CoreGui)
    RunService.RenderStepped:Connect(function()
        for _,lbl in ipairs(CoreGui:GetDescendants()) do
            if lbl:IsA("TextLabel") or lbl:IsA("TextButton") then
                patchLabel(lbl)
            end
        end
    end)

    -- === Discord Invite Tab ===
    local TabDiscord = Win1:Tab({Title = "Discord Invite", Icon = "link"})
    TabDiscord:Section({Title = "My Discord Invite"})
    TabDiscord:Label({Title = "https://discord.com/invite/kJdg4JJSE6"})
    TabDiscord:Button({
        Title = "Copy Discord Invite Link",
        Desc = "Copies the invite link to your clipboard",
        Callback = function()
            setclipboard("https://discord.com/invite/kJdg4JJSE6")
            Win1:Notify({Title="Copied!", Desc="Discord invite copied!", Time=3})
        end
    })

    -- === How To Use Tab ===
    local TabHowTo = Win1:Tab({Title = "How To Use", Icon = "info"})
    TabHowTo:Section({Title = "Instructions"})
    TabHowTo:Label({Title = [[
- If you play fighting games, especially The Strongest Battlegrounds,
  only keep Classic Shirt and Classic Pants on, or the avatar will stay with the new one.
- In other games, you can keep your full avatar.
- Some games may retain items; if they do, remove them manually.
- This helps avoid conflicts with pressed folders and preserves your previous items.
]]})

    -- === Permanent cartoony pink GUI (tetep ada) ===
    for _, Frame in pairs(Win1:GetDescendants()) do  -- GetDescendants biar semua frame kena
        if Frame:IsA("Frame") then
            Frame.BackgroundColor3 = Color3.fromRGB(255,182,193)
            local corner = Frame:FindFirstChild("UICorner")
            if corner then corner.CornerRadius = UDim.new(0,15) end
        end
    end
end

loadMainGui()
