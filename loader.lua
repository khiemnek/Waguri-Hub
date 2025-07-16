-- Waguri Hub | Grow A Garden
-- Made for educational & testing purposes
-- Anti-detection + GUI + Egg Randomizer + Alt Acc Pet Trade

-- 👁️ ICON AVATAR: https://i.imgur.com/yv9rQ4a.png

-- 🌸 Anti-Detection Setup
local function WaguriProtect()
    math.randomseed(tick())

    -- Hook Kick
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNC = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        if getnamecallmethod() == "Kick" then
            warn("⚠️ Roblox is trying to kick you!")
            return nil
        end
        return oldNC(self, ...)
    end)
    setreadonly(mt, true)

    -- Safe wait
    function safeWait(min, max)
        local t = math.random(min * 100, max * 100) / 100
        task.wait(t)
    end
    print("✅ Waguri Protect Loaded")
end
WaguriProtect()

-- 🌸 Load Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
    Name = "🌸 Waguri Hub | Grow A Garden",
    LoadingTitle = "Waguri Hub Loading...",
    LoadingSubtitle = "with ❤️ by Khiêm",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "WaguriHub",
        FileName = "waguri_config"
    },
    Discord = { Enabled = false },
    KeySystem = false,
})

-- 🌸 Egg Randomizer Tab
local eggName = "Easter Egg"
local wantedPets = {}
local autoHatch = false

local EggTab = Window:CreateTab("🥚 Egg Tools", "https://i.imgur.com/yv9rQ4a.png")

EggTab:CreateInput({
    Name = "Egg Name",
    PlaceholderText = "E.g. Easter Egg",
    Callback = function(text) eggName = text end
})

EggTab:CreateInput({
    Name = "Wanted Pet(s)",
    PlaceholderText = "Comma-separated, e.g. Golden Bunny, Lava Pet",
    Callback = function(text)
        wantedPets = {}
        for pet in string.gmatch(text, '([^,]+)') do
            table.insert(wantedPets, pet:match("^%s*(.-)%s*$"))
        end
    end
})

EggTab:CreateToggle({
    Name = "Auto Hatch Egg",
    CurrentValue = false,
    Callback = function(value)
        autoHatch = value
    end
})

-- Pet ESP (basic)
game.Players.LocalPlayer:WaitForChild("Pets").ChildAdded:Connect(function(pet)
    if table.find(wantedPets, pet.Name) then
        Rayfield:Notify({
            Title = "🎉 Pet Found!",
            Content = pet.Name,
            Duration = 4
        })
    end
end)

-- Auto Hatch Thread
task.spawn(function()
    while task.wait(2) do
        if autoHatch and eggName ~= "" then
            pcall(function()
                local Remote = game:GetService("ReplicatedStorage").Remotes.HatchEgg
                Remote:FireServer(eggName)
            end)
        end
    end
end)

-- 🌸 Shop Tab
local ShopTab = Window:CreateTab("🛒 Shop Tools", "https://i.imgur.com/yv9rQ4a.png")
ShopTab:CreateButton({
    Name = "Buy Easter Egg",
    Callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.BuyItem:InvokeServer("Egg", "Easter Egg")
        end)
    end
})

ShopTab:CreateButton({
    Name = "Buy Shovel (Gear)",
    Callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.BuyItem:InvokeServer("Gear", "Shovel")
        end)
    end
})

-- 🌱 Seed Tab
local SeedTab = Window:CreateTab("🌱 Craft Tools", "https://i.imgur.com/yv9rQ4a.png")
SeedTab:CreateButton({
    Name = "Craft Reclaim Seed",
    Callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CraftSeed:InvokeServer("Reclaim")
        end)
    end
})

-- 🔄 Alt Account Tab
local altUsername = ""
local AltTab = Window:CreateTab("🔄 Alt Account", "https://i.imgur.com/yv9rQ4a.png")

AltTab:CreateInput({
    Name = "Alt Username",
    PlaceholderText = "e.g. MyAlt123",
    Callback = function(text) altUsername = text end
})

AltTab:CreateButton({
    Name = "Send Pet to Alt",
    Callback = function()
        local alt = game.Players:FindFirstChild(altUsername)
        if alt then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.Trade:InvokeServer(alt)
            end)
        else
            Rayfield:Notify({
                Title = "❌ Alt not found!",
                Content = "Make sure username is correct & alt is in same server",
                Duration = 5
            })
        end
    end
})

print("✅ Waguri Hub loaded!")