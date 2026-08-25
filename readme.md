# 👼 MalaikatUI Library

[ 🇮🇩 Bahasa Indonesia ](#-bahasa-indonesia) | [ 🇬🇧 English ](#-english) | [ 🇲🇾 Bahasa Melayu ](#-bahasa-melayu)

---

## 🇮🇩 Bahasa Indonesia

**MalaikatUI** adalah library antarmuka (UI) Roblox modern bertema *Frosted Glass* yang dirancang untuk performa tinggi dan estetika yang bersih.

### 🚀 Panduan Integrasi Skrip

```lua
local MalaikatLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/library.lua"))

local Window = MalaikatLib:CreateWindow({
    Title = "Malaikat HUB v2.0",
    KeySystem = true,
    Key = "Malaikat2026",
    KeyLink = "https://github.com/MalaikatHubOFFICIAL/MalaikatLIBRARY"
})

local MainTab = Window:CreateTab("Main Features")

MainTab:AddButton("Teleport Spawn", "Teleport", function()
    print("Teleported to spawn!")
end)

MainTab:AddToggle("Auto Farm Coins", false, function(Value)
    print("Auto Farm:", Value)
end)

MainTab:AddSlider("WalkSpeed Modifier", 16, 250, 16, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)
```

### 👁️ Preview UI

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/PREVIEW.lua"))
```

---

## 🇬🇧 English

**MalaikatUI** is a lightweight, modern Roblox UI Library powered by a custom frosted glass engine.

### 🚀 Integration Guide

```lua
local MalaikatLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/library.lua"))

local Window = MalaikatLib:CreateWindow({
    Title = "Malaikat HUB v2.0",
    KeySystem = true,
    Key = "Malaikat2026",
    KeyLink = "https://github.com/MalaikatHubOFFICIAL/MalaikatLIBRARY"
})

local MainTab = Window:CreateTab("Main Features")

MainTab:AddButton("Teleport Spawn", "Teleport", function()
    print("Teleported to spawn!")
end)

MainTab:AddToggle("Auto Farm Coins", false, function(Value)
    print("Auto Farm:", Value)
end)

MainTab:AddSlider("WalkSpeed Modifier", 16, 250, 16, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)
```

### 👁️ Preview Script

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/PREVIEW.lua"))
```

---

## 🇲🇾 Bahasa Melayu

**MalaikatUI** ialah library UI Roblox moden bertemakan *Frosted Glass* yang direka untuk kelancaran tinggi dan paparan yang bersih.

### 🚀 Panduan Penggunaan

```lua
local MalaikatLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/library.lua"))

local Window = MalaikatLib:CreateWindow({
    Title = "Malaikat HUB v2.0",
    KeySystem = true,
    Key = "Malaikat2026",
    KeyLink = "https://github.com/MalaikatHubOFFICIAL/MalaikatLIBRARY"
})

local MainTab = Window:CreateTab("Main Features")

MainTab:AddButton("Teleport Spawn", "Teleport", function()
    print("Teleported to spawn!")
end)

MainTab:AddToggle("Auto Farm Coins", false, function(Value)
    print("Auto Farm:", Value)
end)

MainTab:AddSlider("WalkSpeed Modifier", 16, 250, 16, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)
```

### 👁️ Pratonton (Preview)

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/PREVIEW.lua"))
```
