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

    -- Main window
    local Win1 = UI1:Window({
        Title = "1ksMakesScripts",
        Desc = "Made By: 1ksMakesScript",
        Icon = 11041446595,
        Config = {Keybind = Enum.KeyCode.LeftControl, Size = UDim2.new(0,450,0,350)},
        CloseUIButton = {Enabled=true, Text="1ksCloseAndOpenMenu"}
    })

    local Me1 = Players.LocalPlayer

    -- === Avatar Changer Tab ===
    local Tab1 = Win1:Tab({Title = "Avatar Changer", Icon = "user"})
    Tab1:Section({Title = "1ks"})
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

    -- Fake name variables
    local FakeDisplay = Me1.DisplayName
    local FakeUser = Me1.Name

    -- Username input
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

    -- DisplayName input
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

    -- Background logic to replace names in all CoreGui labels/buttons
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

    -- === Permanent cartoony pink GUI ===
    for _, Frame in pairs(Win1:Children()) do
        if Frame:IsA("Frame") then
            Frame.BackgroundColor3 = Color3.fromRGB(255,182,193)
            if Frame:FindFirstChild("UICorner") then Frame.UICorner.CornerRadius=UDim.new(0,15) end
        end
    end
end

-- ====== FIX: CALL THE FUNCTION TO LOAD GUI! ======
loadMainGui()
