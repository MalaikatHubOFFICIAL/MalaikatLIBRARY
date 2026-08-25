# 👼 MalaikatUI Library

[ 🇮🇩 Bahasa Indonesia ](#-bahasa-indonesia) | [ 🇬🇧 English ](#-english) | [ 🇲🇾 Bahasa Melayu ](#-bahasa-melayu)

---

## 🇮🇩 Bahasa Indonesia

**MalaikatUI** adalah library antarmuka (UI) Roblox modern bertema *Frosted Glass Engine*. Dirancang khusus untuk memberikan tampilan premium, performa tinggi, animasi *spring physics* yang mulus, serta dilengkapi fitur *Key System* yang fleksibel.

### 📌 Fitur Utama
* **Frosted Glass Aesthetic:** Tampilan transparan yang elegan dan modern.
* **Ultra Smooth Physics:** Pergerakan UI dan efek tombol menggunakan algoritma *lerp spring*.
* **Dynamic Island Notifications:** Sistem antrean notifikasi melayang yang responsif.
* **Customizable Key System:** Pilihan verifikasi kunci yang mudah diaktifkan atau dimatikan.
* **Multi-Platform Support:** Kompatibel dan stabil digunakan di PC maupun Mobile Executor.

---

### 🚀 Panduan Inisialisasi

Untuk memulai, panggil skrip library menggunakan kode berikut:

```lua
local MalaikatLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/refs/heads/main/library.lua"))()

local Window = MalaikatLib:CreateWindow({
    Title = "Malaikat HUB v2.0",
    KeySystem = true,
    Key = "Malaikat2026",
    KeyLink = "https://github.com/MalaikatHubOFFICIAL/MalaikatLIBRARY"
})
```

#### ⚙️ Penjelasan Parameter Window:
* `Title` *(String)*: Judul utama yang tampil di header UI.
* `KeySystem` *(Boolean)*: Set `true` untuk mengaktifkan sistem kunci, atau `false` untuk langsung membuka UI.
* `Key` *(String)*: Kunci rahasia yang wajib dimasukkan pengguna.
* `KeyLink` *(String)*: URL/link untuk mengarahkan pengguna mengambil kunci akses (misal: Linkvertise/Discord).

---

### 🧩 Panduan Penggunaan Komponen UI

#### 1. Membuat Tab Navigasi
```lua
local MainTab = Window:CreateTab("Main Features")
local PlayerTab = Window:CreateTab("Player Settings")
```

#### 2. Tombol (Button)
```lua
MainTab:AddButton("Teleport Spawn", "Teleport", function()
    print("Teleported to spawn!")
end)
```

#### 3. Sakelar (Toggle)
```lua
MainTab:AddToggle("Auto Farm Coins", false, function(Value)
    print("Auto Farm status:", Value)
end)
```

#### 4. Penggeser Angka (Slider)
```lua
PlayerTab:AddSlider("WalkSpeed Modifier", 16, 250, 16, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)
```

---

### 👁️ Skrip Preview
Uji coba seluruh tampilan dan komponen antarmuka menggunakan skrip preview ini:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/refs/heads/main/PREVIEW.lua"))()
```

---

## 🇬🇧 English

**MalaikatUI** is a lightweight, modern Roblox UI Library powered by a custom Frosted Glass Engine. Designed to deliver smooth spring physics animations, fluid response times, and an adaptable Key System.

### 📌 Core Features
* **Frosted Glass Aesthetic:** Clean, modern transparent user interface.
* **Ultra Smooth Physics:** Powered by lerp spring mechanics for fluid transitions.
* **Dynamic Island Notifications:** Sleek floating notification queue system.
* **Flexible Key System:** Toggle key verification on or off seamlessly.
* **Cross-Platform Compatibility:** Optimized for both Desktop and Mobile Executors.

---

### 🚀 Initialization Guide

To initialize the library, include the following code in your script:

```lua
local MalaikatLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/refs/heads/main/library.lua"))()

local Window = MalaikatLib:CreateWindow({
    Title = "Malaikat HUB v2.0",
    KeySystem = true,
    Key = "Malaikat2026",
    KeyLink = "https://github.com/MalaikatHubOFFICIAL/MalaikatLIBRARY"
})
```

#### ⚙️ Window Parameters:
* `Title` *(String)*: Main title displayed on the UI header.
* `KeySystem` *(Boolean)*: Set `true` to enable key verification, or `false` to bypass.
* `Key` *(String)*: Access key required for authentication.
* `KeyLink` *(String)*: Direct URL where users can retrieve the key.

---

### 🧩 UI Component Guide

#### 1. Creating Navigation Tabs
```lua
local MainTab = Window:CreateTab("Main Features")
local PlayerTab = Window:CreateTab("Player Settings")
```

#### 2. Action Button
```lua
MainTab:AddButton("Teleport Spawn", "Teleport", function()
    print("Teleported to spawn!")
end)
```

#### 3. State Toggle
```lua
MainTab:AddToggle("Auto Farm Coins", false, function(Value)
    print("Auto Farm status:", Value)
end)
```

#### 4. Value Slider
```lua
PlayerTab:AddSlider("WalkSpeed Modifier", 16, 250, 16, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)
```

---

### 👁️ Preview Script
Test the complete UI layout and interactive elements using the preview script below:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/refs/heads/main/PREVIEW.lua"))()
```

---

## 🇲🇾 Bahasa Melayu

**MalaikatUI** ialah library UI Roblox moden berkuasakan *Frosted Glass Engine*. Direka khas untuk memberikan paparan premium, animasi *spring physics* yang lancar, serta dilengkapi dengan fitur *Key System* yang fleksibel.

### 📌 Ciri-Ciri Utama
* **Revolusi Frosted Glass:** Paparan lut sinar yang elegan dan kemas.
* **Animasi Ultra Lancar:** Menggunakan algoritma *lerp spring* untuk pergerakan elemen.
* **Dynamic Island Notifications:** Sistem notifikasi terapung yang responsif.
* **Sistem Kunci Boleh Disesuaikan:** Fungsi kunci akses yang mudah diaktifkan atau dimatikan.
* **Sokongan Pelbagai Peranti:** Stabil digunakan pada peranti PC dan Telefon Pintar.

---

### 🚀 Panduan Penggunaan

Panggil library ini dalam skrip anda dengan menggunakan kod berikut:

```lua
local MalaikatLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/refs/heads/main/library.lua"))()

local Window = MalaikatLib:CreateWindow({
    Title = "Malaikat HUB v2.0",
    KeySystem = true,
    Key = "Malaikat2026",
    KeyLink = "https://github.com/MalaikatHubOFFICIAL/MalaikatLIBRARY"
})
```

#### ⚙️ Penerangan Parameter Window:
* `Title` *(String)*: Tajuk utama pada bahagian header UI.
* `KeySystem` *(Boolean)*: Tetapkan `true` untuk menggunakan sistem kunci, atau `false` untuk buka terus.
* `Key` *(String)*: Kunci akses yang perlu dimasukkan oleh pengguna.
* `KeyLink` *(String)*: Pautan untuk pengguna mendapatkan kunci akses.

---

### 🧩 Panduan Komponen UI

#### 1. Cipta Tab Navigasi
```lua
local MainTab = Window:CreateTab("Main Features")
local PlayerTab = Window:CreateTab("Player Settings")
```

#### 2. Butang (Button)
```lua
MainTab:AddButton("Teleport Spawn", "Teleport", function()
    print("Teleported to spawn!")
end)
```

#### 3. Suis (Toggle)
```lua
MainTab:AddToggle("Auto Farm Coins", false, function(Value)
    print("Auto Farm status:", Value)
end)
```

#### 4. Pengelongsor (Slider)
```lua
PlayerTab:AddSlider("WalkSpeed Modifier", 16, 250, 16, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)
```

---

### 👁️ Skrip Pratonton (Preview)
Uji paparan antaramuka lengkap menggunakan skrip ini:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/refs/heads/main/PREVIEW.lua"))()
```
