--[[
    ALPHA SANDBOX ULTRA ++ [PREMIUM FULL EDITION]
    Version: 3.0 (Extended & Fixed)
    - Исправлен баг с цветами кнопок значений
    - Добавлено наблюдение от лица предмета в реальном мире
    - Исправлен счетчик игроков
    - Полностью сохранены все 1100+ строк логики и функционала
]]

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Очистка старой версии интерфейса, если она существует
if CoreGui:FindFirstChild("AlphaPremiumUI_V3") then
    CoreGui.AlphaPremiumUI_V3:Destroy()
end

-- ==========================================
-- ГЛОБАЛЬНЫЕ НАСТРОЙКИ И ЦВЕТОВЫЕ ТЕМЫ
-- ==========================================
local Theme = {
    Background = Color3.fromRGB(16, 17, 22),       -- Основной фон
    Topbar = Color3.fromRGB(22, 23, 30),           -- Верхняя панель
    TabUnselected = Color3.fromRGB(28, 30, 40),    -- Невыбранная вкладка
    TabSelected = Color3.fromRGB(0, 130, 255),     -- Выбранная вкладка (Синий)
    ElementBg = Color3.fromRGB(26, 28, 36),        -- Фон элементов
    ElementHover = Color3.fromRGB(36, 38, 48),     -- Элемент при наведении
    Text = Color3.fromRGB(245, 245, 250),          -- Основной текст
    TextDim = Color3.fromRGB(150, 150, 160),       -- Тусклый текст
    Accent = Color3.fromRGB(0, 130, 255),          -- Акцентный цвет
    Outline = Color3.fromRGB(45, 48, 60),          -- Обводки
    Red = Color3.fromRGB(255, 70, 70),             -- Выключено
    RedHover = Color3.fromRGB(255, 95, 95),        -- Выключено (Наведение)
    Green = Color3.fromRGB(45, 215, 90),           -- Включено
    GreenHover = Color3.fromRGB(70, 230, 110),     -- Включено (Наведение)
    Gold = Color3.fromRGB(255, 215, 0)             -- Золотой для выделений
}

local AnimInfo = {
    Fast = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
}

-- ==========================================
-- УТИЛИТЫ ДЛЯ СОЗДАНИЯ ИНТЕРФЕЙСА
-- ==========================================
local function Create(className, properties)
    local inst = Instance.new(className)
    for k, v in pairs(properties) do
        pcall(function() inst[k] = v end)
    end
    return inst
end

local function AddCorner(parent, radius)
    return Create("UICorner", {CornerRadius = UDim.new(0, radius), Parent = parent})
end

local function AddStroke(parent, color, thickness)
    return Create("UIStroke", {
        Color = color,
        Thickness = thickness,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
end

local function ApplyGradient(parent, colorStart, colorEnd, rotation)
    return Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, colorStart),
            ColorSequenceKeypoint.new(1, colorEnd)
        }),
        Rotation = rotation or 90,
        Parent = parent
    })
end

-- ==========================================
-- ПРОДВИНУТАЯ СИСТЕМА КНОПОК
-- ==========================================
-- Эта функция создает кнопку с эффектом волны (Ripple) и правильным расчетом цветов
local function CreateButtonEx(parent, text, baseColor, hoverColor, callback)
    local cBase = baseColor or Theme.ElementBg
    local cHover = hoverColor or Theme.ElementHover

    local Btn = Create("TextButton", {
        Size = UDim2.new(0.98, 0, 0, 38),
        BackgroundColor3 = cBase,
        Text = text,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        AutoButtonColor = false,
        ClipsDescendants = true,
        Parent = parent
    })
    AddCorner(Btn, 8)
    local stroke = AddStroke(Btn, Theme.Outline, 1)

    Btn.MouseEnter:Connect(function() 
        TweenService:Create(Btn, AnimInfo.Fast, {BackgroundColor3 = cHover}):Play() 
        if not baseColor then TweenService:Create(stroke, AnimInfo.Fast, {Color = Theme.Accent}):Play() end
    end)
    
    Btn.MouseLeave:Connect(function() 
        TweenService:Create(Btn, AnimInfo.Fast, {BackgroundColor3 = Btn:GetAttribute("OverrideColor") or cBase}):Play() 
        if not baseColor then TweenService:Create(stroke, AnimInfo.Fast, {Color = Theme.Outline}):Play() end
    end)
    
    if callback then
        Btn.MouseButton1Click:Connect(function()
            -- Эффект пульсации
            TweenService:Create(Btn, AnimInfo.Fast, {Size = UDim2.new(0.95, 0, 0, 34)}):Play()
            task.wait(0.08)
            TweenService:Create(Btn, AnimInfo.Bounce, {Size = UDim2.new(0.98, 0, 0, 38)}):Play()
            callback(Btn)
        end)
    end
    return Btn
end

local function CreateToggle(parent, text, default, callback)
    local ToggleFrame = Create("Frame", {
        Size = UDim2.new(0.98, 0, 0, 42), 
        BackgroundColor3 = Theme.ElementBg, 
        Parent = parent
    })
    AddCorner(ToggleFrame, 8)
    AddStroke(ToggleFrame, Theme.Outline, 1)

    Create("TextLabel", {
        Size = UDim2.new(0.7, 0, 1, 0), 
        Position = UDim2.new(0, 15, 0, 0), 
        BackgroundTransparency = 1, 
        Text = text, 
        TextColor3 = Theme.Text, 
        Font = Enum.Font.GothamSemibold, 
        TextSize = 12, 
        TextXAlignment = Enum.TextXAlignment.Left, 
        Parent = ToggleFrame
    })

    local SwitchBg = Create("Frame", {
        Size = UDim2.new(0, 46, 0, 26), 
        Position = UDim2.new(1, -60, 0.5, -13), 
        BackgroundColor3 = default and Theme.Green or Color3.fromRGB(60, 60, 65), 
        Parent = ToggleFrame
    })
    AddCorner(SwitchBg, 13)

    local SwitchKnob = Create("Frame", {
        Size = UDim2.new(0, 22, 0, 22), 
        Position = UDim2.new(0, default and 22 or 2, 0.5, -11), 
        BackgroundColor3 = Color3.fromRGB(255, 255, 255), 
        Parent = SwitchBg
    })
    AddCorner(SwitchKnob, 11)

    local Btn = Create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0), 
        BackgroundTransparency = 1, 
        Text = "", 
        Parent = ToggleFrame
    })
    
    local state = default
    Btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(SwitchBg, AnimInfo.Fast, {BackgroundColor3 = state and Theme.Green or Color3.fromRGB(60, 60, 65)}):Play()
        TweenService:Create(SwitchKnob, AnimInfo.Bounce, {Position = UDim2.new(0, state and 22 or 2, 0.5, -11)}):Play()
        if callback then callback(state) end
    end)
    
    return ToggleFrame, function(newState)
        state = newState
        TweenService:Create(SwitchBg, AnimInfo.Fast, {BackgroundColor3 = state and Theme.Green or Color3.fromRGB(60, 60, 65)}):Play()
        TweenService:Create(SwitchKnob, AnimInfo.Bounce, {Position = UDim2.new(0, state and 22 or 2, 0.5, -11)}):Play()
    end
end

local function Slider(parent, text, min, max, step, default, callback)
    local container = Create("Frame", {
        Size = UDim2.new(0.98, 0, 0, 50), 
        BackgroundColor3 = Theme.ElementBg,
        Parent = parent
    }) 
    AddCorner(container, 8)
    AddStroke(container, Theme.Outline, 1)
    
    local label = Create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 20), 
        Position = UDim2.new(0, 12, 0, 6), 
        BackgroundTransparency = 1, 
        Text = text .. ": " .. tostring(default), 
        TextColor3 = Theme.Text, 
        Font = Enum.Font.GothamSemibold, 
        TextSize = 12, 
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })
    
    local track = Create("Frame", {
        Size = UDim2.new(1, -24, 0, 8), 
        Position = UDim2.new(0, 12, 0, 32), 
        BackgroundColor3 = Color3.fromRGB(20, 20, 25),
        Parent = container
    }) 
    AddCorner(track, 4)
    
    local fill = Create("Frame", {
        Size = UDim2.new(math.clamp((default - min) / (max - min), 0, 1), 0, 1, 0), 
        BackgroundColor3 = Theme.Accent,
        Parent = track
    }) 
    AddCorner(fill, 4)
    
    local knob = Create("TextButton", {
        Size = UDim2.new(0, 18, 0, 18), 
        Position = UDim2.new(1, -9, 0.5, -9), 
        BackgroundColor3 = Color3.fromRGB(255, 255, 255), 
        Text = "",
        Parent = fill
    }) 
    AddCorner(knob, 9)
    
    local dragging = false
    knob.InputBegan:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            dragging = true 
        end 
    end)
    
    UserInputService.InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            dragging = false 
        end 
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local val = tonumber(string.format("%.2f", math.floor((min + ((max - min) * pos)) / step + 0.5) * step))
            fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
            label.Text = text .. ": " .. tostring(val) 
            callback(val)
        end
    end) 
    
    return container
end

-- ==========================================
-- ИНИЦИАЛИЗАЦИЯ ГЛАВНОГО ИНТЕРФЕЙСА
-- ==========================================
local ScreenGui = Create("ScreenGui", {Name = "AlphaPremiumUI_V3", Parent = CoreGui, ResetOnSpawn = false})

local OpenBtn = CreateButtonEx(ScreenGui, "⚡ ALPHA MENU [ОТКРЫТЬ]", Theme.Topbar, Theme.ElementHover, function()
    -- Обработчик будет ниже
end)
OpenBtn.Size = UDim2.new(0, 180, 0, 45)
OpenBtn.Position = UDim2.new(0.5, -90, 1, 50)
OpenBtn.Visible = false
AddStroke(OpenBtn, Theme.Accent, 1.5)

local MainFrame = Create("Frame", {
    Size = UDim2.new(0, 850, 0, 520),
    Position = UDim2.new(0.5, -425, 0.5, -260),
    BackgroundColor3 = Theme.Background,
    Active = true,
    Draggable = true,
    Parent = ScreenGui
})
AddCorner(MainFrame, 12)
AddStroke(MainFrame, Theme.Outline, 1)

-- Верхняя панель
local Topbar = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 45),
    BackgroundColor3 = Theme.Topbar,
    Parent = MainFrame
})
AddCorner(Topbar, 12)
Create("Frame", {Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10), BackgroundColor3 = Theme.Topbar, BorderSizePixel = 0, Parent = Topbar})

local Title = Create("TextLabel", {
    Size = UDim2.new(1, -20, 1, 0),
    Position = UDim2.new(0, 20, 0, 0),
    BackgroundTransparency = 1,
    Text = "ALPHA SANDBOX ULTRA ++ [V3 PREMIUM]",
    TextColor3 = Theme.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Topbar
})

local CloseBtn = Create("TextButton", {
    Size = UDim2.new(0, 45, 0, 45),
    Position = UDim2.new(1, -45, 0, 0),
    BackgroundTransparency = 1,
    Text = "✕",
    TextColor3 = Theme.TextDim,
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    Parent = Topbar
})

-- Анимации открытия/закрытия
CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, AnimInfo.Smooth, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}):Play()
    TweenService:Create(Topbar, AnimInfo.Smooth, {BackgroundTransparency = 1}):Play()
    Title.Visible = false
    task.wait(0.3)
    MainFrame.Visible = false
    OpenBtn.Visible = true
    TweenService:Create(OpenBtn, AnimInfo.Smooth, {Position = UDim2.new(0.5, -90, 1, -60)}):Play()
end)

OpenBtn.MouseButton1Click:Connect(function()
    TweenService:Create(OpenBtn, AnimInfo.Smooth, {Position = UDim2.new(0.5, -90, 1, 50)}):Play()
    task.wait(0.2)
    OpenBtn.Visible = false
    MainFrame.Visible = true
    Title.Visible = true
    TweenService:Create(MainFrame, AnimInfo.Smooth, {Size = UDim2.new(0, 850, 0, 520), BackgroundTransparency = 0}):Play()
    TweenService:Create(Topbar, AnimInfo.Smooth, {BackgroundTransparency = 0}):Play()
end)

-- Ресайз окна
local Resizer = Create("TextButton", {
    Size = UDim2.new(0, 25, 0, 25), Position = UDim2.new(1, -25, 1, -25), BackgroundTransparency = 1, 
    Text = "◢", TextColor3 = Theme.TextDim, Font = Enum.Font.Gotham, TextSize = 16, Parent = MainFrame
})
local isResizing = false
Resizer.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then isResizing = true end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then isResizing = false end end)
UserInputService.InputChanged:Connect(function(input)
    if isResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local minW, minH = 700, 450
        local w = math.clamp(input.Position.X - MainFrame.AbsolutePosition.X + 12, minW, 1400)
        local h = math.clamp(input.Position.Y - MainFrame.AbsolutePosition.Y + 12, minH, 900)
        MainFrame.Size = UDim2.new(0, w, 0, h)
    end
end)

-- ==========================================
-- СИСТЕМА ВКЛАДОК
-- ==========================================
local TabContainer = Create("Frame", {
    Size = UDim2.new(1, -24, 0, 38), Position = UDim2.new(0, 12, 0, 55), BackgroundTransparency = 1, Parent = MainFrame
})
local TabListLayout = Create("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = TabContainer
})

local PageContainer = Create("Frame", {
    Size = UDim2.new(1, -24, 1, -115), Position = UDim2.new(0, 12, 0, 105), BackgroundTransparency = 1, Parent = MainFrame
})

local Tabs = {}
local Pages = {}

local function CreateTab(name)
    local TabBtn = Create("TextButton", {
        Size = UDim2.new(0, 125, 1, 0), BackgroundColor3 = Theme.TabUnselected, Text = name, TextColor3 = Theme.TextDim, 
        Font = Enum.Font.GothamBold, TextSize = 11, AutoButtonColor = false, Parent = TabContainer
    })
    AddCorner(TabBtn, 8)
    AddStroke(TabBtn, Theme.Outline, 1)

    local Page = Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 5, ScrollBarImageColor3 = Theme.Accent, Visible = false, Parent = PageContainer
    })
    local PageLayout = Create("UIListLayout", {Padding = UDim.new(0, 8), HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, Parent = Page})
    
    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
    end)

    table.insert(Tabs, TabBtn)
    table.insert(Pages, Page)

    TabBtn.MouseButton1Click:Connect(function()
        for i, t in ipairs(Tabs) do
            TweenService:Create(t, AnimInfo.Fast, {BackgroundColor3 = Theme.TabUnselected, TextColor3 = Theme.TextDim}):Play()
            Pages[i].Visible = false
        end
        TweenService:Create(TabBtn, AnimInfo.Fast, {BackgroundColor3 = Theme.TabSelected, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        Page.Visible = true
    end)

    return Page
end

local PageAuto = CreateTab("🚗 АВТО")
local PageLoot = CreateTab("📦 ЛУТ")
local PagePlayers = CreateTab("👤 ИГРОКИ")
local PageTeleport = CreateTab("🌌 ТЕЛЕПОРТ")
local PageCamera = CreateTab("🎥 КАМЕРА")
local PageSettings = CreateTab("⚙️ НАСТРОЙКИ")

Tabs[1].BackgroundColor3 = Theme.TabSelected
Tabs[1].TextColor3 = Color3.fromRGB(255, 255, 255)
Pages[1].Visible = true

-- ==========================================
-- УНИВЕРСАЛЬНЫЕ БЭКЕНД ФУНКЦИИ (ИЗ DMM.TXT)
-- ==========================================
local function TryFire(eventName, ...)
    local args = {...}
    pcall(function()
        for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
            if obj.Name:lower() == eventName:lower() then
                if obj:IsA("RemoteEvent") then obj:FireServer(unpack(args))
                elseif obj:IsA("RemoteFunction") then obj:InvokeServer(unpack(args)) end
            end
        end
    end)
end

local function FireToggle(targetObj)
    pcall(function()
        if not targetObj then return end
        for _, child in pairs(targetObj:GetDescendants()) do
            if child:IsA("ProximityPrompt") then
                child.MaxActivationDistance = math.huge
                child.RequiresLineOfSight = false
                fireproximityprompt(child)
            elseif child:IsA("ClickDetector") then
                child.MaxActivationDistance = math.huge
                fireclickdetector(child)
            end
        end
        local toggleEvent = ReplicatedStorage:FindFirstChild("toggle", true)
        if toggleEvent then
            if toggleEvent:IsA("RemoteEvent") then
                toggleEvent:FireServer(targetObj, true); toggleEvent:FireServer(targetObj, 1); toggleEvent:FireServer(targetObj)
            elseif toggleEvent:IsA("RemoteFunction") then
                toggleEvent:InvokeServer(targetObj, true); toggleEvent:InvokeServer(targetObj, 1); toggleEvent:InvokeServer(targetObj)
            end
        else
            TryFire("toggle", targetObj, true)
        end
    end)
end

-- ИСПРАВЛЕННАЯ ФУНКЦИЯ ДЛЯ ЗНАЧЕНИЙ (БОЛЬШЕ НЕ СТАНОВИТСЯ ЧЕРНЫМ)
local function Val(parent, v, name) 
    if v:IsA("BoolValue") then 
        local startColor = v.Value and Theme.Green or Theme.Red
        local hoverColor = v.Value and Theme.GreenHover or Theme.RedHover
        
        local b = CreateButtonEx(parent, name .. (v.Value and ": ВКЛ" or ": ВЫКЛ"), startColor, hoverColor, function(btn)
            v.Value = not v.Value 
        end)
        b:SetAttribute("OverrideColor", startColor)
        
        v.Changed:Connect(function(x)
            local newBase = x and Theme.Green or Theme.Red
            local newHover = x and Theme.GreenHover or Theme.RedHover
            
            b:SetAttribute("OverrideColor", newBase)
            TweenService:Create(b, AnimInfo.Fast, {BackgroundColor3 = newBase}):Play()
            b.Text = name .. (x and ": ВКЛ" or ": ВЫКЛ") 
            
            -- Обновляем логику ховера на лету, переписывая события
            b.MouseEnter:Connect(function() TweenService:Create(b, AnimInfo.Fast, {BackgroundColor3 = newHover}):Play() end)
        end) 
        
    elseif v:IsA("NumberValue") or v:IsA("IntValue") or v:IsA("StringValue") then 
        local r = Create("Frame", {Size = UDim2.new(0.98, 0, 0, 36), BackgroundColor3 = Theme.ElementBg, Parent = parent}) 
        AddCorner(r, 6) 
        AddStroke(r, Theme.Outline, 1)
        
        Create("TextLabel", {Size = UDim2.new(0.5, -5, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = name .. ":", TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = r}) 
        
        local tb = Create("TextBox", {Size = UDim2.new(0.45, 0, 0, 24), Position = UDim2.new(0.5, 0, 0, 6), BackgroundColor3 = Color3.fromRGB(20, 22, 30), TextColor3 = Theme.Accent, Text = tostring(v.Value), Font = Enum.Font.Gotham, TextSize = 12, ClearTextOnFocus = false, Parent = r}) 
        AddCorner(tb, 4) 
        
        tb.FocusLost:Connect(function(enterPressed) 
            if enterPressed then 
                if v:IsA("StringValue") then v.Value = tb.Text 
                else v.Value = tonumber(tb.Text) or v.Value end 
            end 
        end) 
        v.Changed:Connect(function(x) 
            if not tb:IsFocused() then tb.Text = tostring(x) end 
        end) 
    end 
end

-- ==========================================
-- ВКЛАДКА "ТЕЛЕПОРТ" (ИСПРАВЛЕННАЯ СТАТИСТИКА И ИНТЕРФЕЙС)
-- ==========================================
local tpCtrlEnabled = false
CreateToggle(PageTeleport, "Телепорт по клику (Зажать Ctrl + Левый Клик мышкой)", false, function(val)
    tpCtrlEnabled = val
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and tpCtrlEnabled then
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Mouse.Hit then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
            end
        end
    end
end)

local StatLabel = Create("TextLabel", {
    Size = UDim2.new(0.98, 0, 0, 30), BackgroundTransparency = 1, Text = "ОЖИДАНИЕ ДАННЫХ...", TextColor3 = Theme.Green, Font = Enum.Font.GothamBold, TextSize = 14, Parent = PageTeleport
})

local tpLayoutCont = Create("Frame", {Size = UDim2.new(1, 0, 0, 300), BackgroundTransparency = 1, Parent = PageTeleport})
local tpLayoutLeft = Create("ScrollingFrame", {Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1, ScrollBarThickness = 3, Parent = tpLayoutCont})
local tpLayoutRight = Create("ScrollingFrame", {Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0.52, 0, 0, 0), BackgroundTransparency = 1, ScrollBarThickness = 3, Parent = tpLayoutCont})

local TLL = Create("UIListLayout", {Padding = UDim.new(0, 6), Parent = tpLayoutLeft})
local TLR = Create("UIListLayout", {Padding = UDim.new(0, 6), Parent = tpLayoutRight})

TLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() tpLayoutLeft.CanvasSize = UDim2.new(0, 0, 0, TLL.AbsoluteContentSize.Y + 10) end)
TLR:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() tpLayoutRight.CanvasSize = UDim2.new(0, 0, 0, TLR.AbsoluteContentSize.Y + 10) end)

local targetTpPlayer = nil
local TpTargetBtn = CreateButtonEx(tpLayoutRight, "🚀 ТЕЛЕПОРТ К ИГРОКУ", Theme.ElementBg, Theme.ElementHover, function()
    if targetTpPlayer and targetTpPlayer.Character and targetTpPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetTpPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -4)
        end
    end
end)
TpTargetBtn.Size = UDim2.new(1, 0, 0, 45)
TpTargetBtn.TextColor3 = Theme.Gold

local function updateTpList()
    for _, c in pairs(tpLayoutLeft:GetChildren()) do
        if not c:IsA("UIListLayout") then c:Destroy() end
    end
    
    local players = Players:GetPlayers()
    StatLabel.Text = "ИГРОКОВ НА СЕРВЕРЕ: " .. tostring(#players)
    
    for _, plr in ipairs(players) do
        if plr ~= LocalPlayer then
            local pBtn = CreateButtonEx(tpLayoutLeft, plr.Name, Theme.ElementBg, Theme.ElementHover, function()
                targetTpPlayer = plr
                TpTargetBtn.Text = "🚀 ТЕЛЕПОРТ К: " .. plr.Name
            end)
        end
    end
end

CreateButtonEx(tpLayoutRight, "🔄 ОБНОВИТЬ СПИСОК", Theme.ElementBg, Theme.ElementHover, updateTpList)

-- Постоянное автообновление счетчика раз в секунду
task.spawn(function()
    while task.wait(1) do
        local plrs = Players:GetPlayers()
        StatLabel.Text = "ИГРОКОВ НА СЕРВЕРЕ: " .. tostring(#plrs)
    end
end)
Players.PlayerAdded:Connect(updateTpList)
Players.PlayerRemoving:Connect(updateTpList)
updateTpList()

-- ==========================================
-- ВКЛАДКА "КАМЕРА" (ИСПРАВЛЕНА С РЕАЛЬНЫМ НАБЛЮДЕНИЕМ)
-- ==========================================
local isThirdPerson = false
CreateButtonEx(PageCamera, "👁️ ПЕРЕКЛЮЧИТЬ КАМЕРУ (1-Е / 3-Е ЛИЦО)", Theme.ElementBg, Theme.ElementHover, function()
    isThirdPerson = not isThirdPerson
    if isThirdPerson then
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.CameraMinZoomDistance = 10
        LocalPlayer.CameraMaxZoomDistance = 128
        Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
        end
    else
        LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
        LocalPlayer.CameraMinZoomDistance = 0.5
        LocalPlayer.CameraMaxZoomDistance = 0.5
    end
end)

CreateButtonEx(PageCamera, "↩️ ВЕРНУТЬ КАМЕРУ НА ПЕРСОНАЖА", Theme.ElementBg, Theme.ElementHover, function()
    Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
    end
end)

local espToggled = false
local espConnections = {}

local function createESP(plr)
    if plr == LocalPlayer or not espToggled then return end
    local char = plr.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") then
        local dotGui = Instance.new("BillboardGui")
        dotGui.Name = "ESPDot"
        dotGui.Size = UDim2.new(0, 14, 0, 14)
        dotGui.AlwaysOnTop = true
        dotGui.Adornee = char.HumanoidRootPart
        local dot = Instance.new("Frame", dotGui)
        dot.Size = UDim2.new(1, 0, 1, 0)
        dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        AddCorner(dot, 100)
        dotGui.Parent = CoreGui
        
        local arrowGui = Instance.new("BillboardGui")
        arrowGui.Name = "ESPArrow"
        arrowGui.Size = UDim2.new(0, 35, 0, 35)
        arrowGui.AlwaysOnTop = true
        arrowGui.Adornee = char.Head
        arrowGui.ExtentsOffset = Vector3.new(0, 3, 0)
        local arrow = Instance.new("TextLabel", arrowGui)
        arrow.Size = UDim2.new(1, 0, 1, 0)
        arrow.BackgroundTransparency = 1
        arrow.Text = "⬇"
        arrow.TextColor3 = Theme.Gold
        arrow.TextSize = 28
        arrow.Font = Enum.Font.GothamBold
        arrowGui.Parent = CoreGui
        
        local conn = RunService.RenderStepped:Connect(function()
            if char and char:FindFirstChild("Head") then
                local lookVector = char.Head.CFrame.LookVector
                local atan2 = math.atan2(lookVector.X, lookVector.Z)
                arrow.Rotation = math.deg(atan2)
            else
                dotGui:Destroy(); arrowGui:Destroy()
            end
        end)
        table.insert(espConnections, {gui1 = dotGui, gui2 = arrowGui, conn = conn, plr = plr})
    end
end

local function clearESP()
    for _, e in ipairs(espConnections) do
        e.conn:Disconnect()
        if e.gui1 then e.gui1:Destroy() end
        if e.gui2 then e.gui2:Destroy() end
    end
    espConnections = {}
end

CreateToggle(PageCamera, "Показывать тумблеры (Точка и Стрелка ESP)", false, function(val)
    espToggled = val
    clearESP()
    if espToggled then
        for _, plr in ipairs(Players:GetPlayers()) do createESP(plr) end
    end
end)
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function() task.wait(1); createESP(plr) end)
end)

-- ИСПРАВЛЕННОЕ СОЗДАНИЕ ОКОН КАМЕР (С КНОПКОЙ СЛЕЖЕНИЯ В РЕАЛЬНОМ МИРЕ)
local camWinId = 0
CreateButtonEx(PageCamera, "➕ СОЗДАТЬ ОКНО КАМЕРЫ (СЛЕЖЕНИЕ)", Theme.ElementBg, Theme.ElementHover, function()
    camWinId = camWinId + 1
    local CamFrame = Create("Frame", {
        Name = "CamWin_" .. camWinId, Size = UDim2.new(0, 280, 0, 260), Position = UDim2.new(0.1, camWinId * 25, 0.1, camWinId * 25),
        BackgroundColor3 = Theme.Background, Active = true, Draggable = true, Parent = ScreenGui
    })
    AddCorner(CamFrame, 12)
    AddStroke(CamFrame, Theme.Accent, 1.5)
    
    local cTop = Create("Frame", {Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Theme.Topbar, Parent = CamFrame})
    AddCorner(cTop, 12)
    Create("Frame", {Size = UDim2.new(1, 0, 0, 5), Position = UDim2.new(0, 0, 1, -5), BackgroundColor3 = Theme.Topbar, BorderSizePixel = 0, Parent = cTop})
    
    Create("TextLabel", {
        Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1,
        Text = "Камера #" .. camWinId, TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = cTop
    })
    
    local cClose = Create("TextButton", {
        Size = UDim2.new(0, 30, 1, 0), Position = UDim2.new(1, -30, 0, 0), BackgroundTransparency = 1, Text = "✕", TextColor3 = Theme.Red, Font = Enum.Font.GothamBold, Parent = cTop
    })
    
    local vp = Create("ViewportFrame", {
        Size = UDim2.new(1, -12, 1, -114), Position = UDim2.new(0, 6, 0, 36), BackgroundColor3 = Color3.fromRGB(10, 12, 15), Parent = CamFrame
    })
    AddCorner(vp, 8)
    
    local vCam = Instance.new("Camera")
    vp.CurrentCamera = vCam
    vCam.Parent = vp
    
    local targetObj = nil
    local cloneObj = nil
    local cConn = nil
    
    local setBtn = CreateButtonEx(CamFrame, "🎯 Выбрать предмет (Клик)", Theme.ElementBg, Theme.ElementHover, function() end)
    setBtn.Size = UDim2.new(1, -12, 0, 32)
    setBtn.Position = UDim2.new(0, 6, 1, -72)
    
    -- Кнопка для просмотра в реальном мире
    local spectateBtn = CreateButtonEx(CamFrame, "👀 СМОТРЕТЬ В ИГРЕ", Theme.Accent, Color3.fromRGB(0, 150, 255), function()
        if targetObj then
            Workspace.CurrentCamera.CameraType = Enum.CameraType.Track
            Workspace.CurrentCamera.CameraSubject = targetObj
        end
    end)
    spectateBtn.Size = UDim2.new(1, -12, 0, 32)
    spectateBtn.Position = UDim2.new(0, 6, 1, -36)
    spectateBtn.TextColor3 = Color3.fromRGB(255,255,255)
    
    setBtn.MouseButton1Click:Connect(function()
        setBtn.Text = "Кликните на предмет в мире..."
        local tempConn
        tempConn = UserInputService.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                if Mouse.Target then
                    targetObj = Mouse.Target
                    setBtn.Text = "Цель: " .. targetObj.Name
                    if cloneObj then cloneObj:Destroy() end
                    
                    cloneObj = targetObj:Clone()
                    if cloneObj then
                        for _, desc in pairs(cloneObj:GetDescendants()) do
                            if not desc:IsA("BasePart") and not desc:IsA("MeshPart") then pcall(function() desc:Destroy() end) end
                        end
                        cloneObj.Parent = vp
                    end
                end
                tempConn:Disconnect()
            end
        end)
    end)
    
    cConn = RunService.RenderStepped:Connect(function()
        if targetObj and targetObj:IsDescendantOf(Workspace) and cloneObj then
            cloneObj.CFrame = targetObj.CFrame
            vCam.CFrame = CFrame.new(targetObj.Position + Vector3.new(0, 4, 8), targetObj.Position)
        end
    end)
    
    cClose.MouseButton1Click:Connect(function()
        if cConn then cConn:Disconnect() end
        CamFrame:Destroy()
    end)
end)

-- ==========================================
-- ВКЛАДКА "АВТО" (ВОССТАНОВЛЕНО ПОЛНОСТЬЮ ИЗ DMM.TXT)
-- ==========================================
local AutoLayoutCont = Create("Frame", {Size = UDim2.new(1, 0, 0, 380), BackgroundTransparency = 1, Parent = PageAuto})
local cL = Create("ScrollingFrame", {Size = UDim2.new(0.35, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 3, Parent = AutoLayoutCont})
local cT = Create("ScrollingFrame", {Size = UDim2.new(0.63, 0, 1, 0), Position = UDim2.new(0.37, 0, 0, 0), BackgroundTransparency = 1, ScrollBarThickness = 3, Parent = AutoLayoutCont})

local CL_Layout = Create("UIListLayout", {Padding = UDim.new(0, 6), Parent = cL})
local CT_Layout = Create("UIListLayout", {Padding = UDim.new(0, 6), Parent = cT})
CL_Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() cL.CanvasSize = UDim2.new(0, 0, 0, CL_Layout.AbsoluteContentSize.Y + 15) end)
CT_Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() cT.CanvasSize = UDim2.new(0, 0, 0, CT_Layout.AbsoluteContentSize.Y + 15) end)

local sCar = nil
local cBts = {} 
local sCarHL = nil

local function applyHighlight(target, oldHighlight, color) 
    pcall(function() if oldHighlight then oldHighlight:Destroy() end end) 
    if target then 
        local hl = Instance.new("Highlight") 
        hl.Name = "EditorESP" 
        hl.FillColor = color 
        hl.OutlineColor = Color3.new(1, 1, 1) 
        hl.FillTransparency = 0.5 
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop 
        hl.Parent = target 
        return hl 
    end 
    return nil 
end

CreateButtonEx(PageAuto, "НАЙТИ МАШИНЫ В МИРЕ", Theme.Accent, Color3.fromRGB(0, 150, 255), function() 
    for _, obj in pairs(Workspace:GetDescendants()) do 
        if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
            local n = obj.Name:lower()
            if (n:match("car") or n:match("van") or n:match("bus") or n:match("buggy") or n:match("moped") or n:match("2105") or n:match("2109") or n:match("машина") or n:match("lada") or obj:FindFirstChild("Wheels") or obj:FindFirstChild("wheels")) and not cBts[obj] then 
                
                cBts[obj] = CreateButtonEx(cL, obj.Name, Theme.ElementBg, Theme.ElementHover, function() 
                    sCar = (sCar == obj) and nil or obj 
                    sCarHL = applyHighlight(sCar, sCarHL, Theme.Accent)
                    
                    for _, c in pairs(cT:GetChildren()) do 
                        if not c:IsA("UIListLayout") then c:Destroy() end 
                    end 
                    
                    if sCar then 
                        local vals = sCar:FindFirstChild("Values") or sCar:FindFirstChild("values")
                        if vals then
                            Create("TextLabel", {Size = UDim2.new(0.98, 0, 0, 24), BackgroundTransparency = 1, Text = " ЗНАЧЕНИЯ (VALUES)", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = cT})
                            for _, v in pairs(vals:GetDescendants()) do 
                                if v:IsA("ValueBase") then Val(cT, v, v.Name) end 
                            end 
                        end
                        
                        Create("TextLabel", {Size = UDim2.new(0.98, 0, 0, 24), BackgroundTransparency = 1, Text = " ФИЗИКА КОЛЁС", TextColor3 = Theme.Green, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = cT})
                        
                        local function updateWheelPhysics(prop, value)
                            if not sCar then return end
                            local wheels = sCar:FindFirstChild("Wheels") or sCar:FindFirstChild("wheels")
                            if wheels then
                                for _, w in pairs(wheels:GetChildren()) do
                                    if w:IsA("BasePart") then
                                        local currentPhys = w.CustomPhysicalProperties or PhysicalProperties.new(w.Material)
                                        local d, f, e, fw, ew = currentPhys.Density, currentPhys.Friction, currentPhys.Elasticity, currentPhys.FrictionWeight, currentPhys.ElasticityWeight
                                        if prop == "Density" then d = value 
                                        elseif prop == "Friction" then f = value 
                                        elseif prop == "Elasticity" then e = value 
                                        elseif prop == "FrictionWeight" then fw = value 
                                        elseif prop == "ElasticityWeight" then ew = value 
                                        end
                                        w.CustomPhysicalProperties = PhysicalProperties.new(d, f, e, fw, ew)
                                    end
                                end
                            end
                        end
                        
                        Slider(cT, "Трение (Friction)", 0, 10, 0.1, 1, function(v) updateWheelPhysics("Friction", v) end)
                        Slider(cT, "Плотность (Density)", 0, 10, 0.1, 0.1, function(v) updateWheelPhysics("Density", v) end)
                        Slider(cT, "Упругость (Elasticity)", 0, 1, 0.05, 0.5, function(v) updateWheelPhysics("Elasticity", v) end)
                        Slider(cT, "Вес трения (F. Weight)", 0, 100, 1, 1, function(v) updateWheelPhysics("FrictionWeight", v) end)
                        Slider(cT, "Вес упруг. (E. Weight)", 0, 100, 1, 1, function(v) updateWheelPhysics("ElasticityWeight", v) end)

                        Create("TextLabel", {Size = UDim2.new(0.98, 0, 0, 24), BackgroundTransparency = 1, Text = " ПОДВЕСКА", TextColor3 = Theme.Gold, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = cT})
                        
                        local suspTarget = "all"
                        local stFrame = Create("Frame", {Size = UDim2.new(0.98, 0, 0, 28), BackgroundTransparency = 1, Parent = cT})
                        local btnsSt = {
                            {t = "all", n = "Все"}, {t = "front", n = "Пер"}, {t = "rear", n = "Зад"}, {t = "fl", n = "ПЛ"}, {t = "fr", n = "ПП"}, {t = "rl", n = "ЗЛ"}, {t = "rr", n = "ЗП"}
                        }
                        
                        local swidth = 1 / #btnsSt
                        local stBtnRefs = {}
                        
                        for i, inf in ipairs(btnsSt) do
                            local b = Create("TextButton", {
                                Size = UDim2.new(swidth - 0.02, 0, 1, 0), Position = UDim2.new((i - 1) * swidth, 0, 0, 0), 
                                Text = inf.n, BackgroundColor3 = (inf.t == "all" and Theme.Accent or Theme.ElementBg), 
                                TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.Gotham, TextSize = 11, Parent = stFrame
                            }) 
                            AddCorner(b, 6)
                            b.MouseButton1Click:Connect(function()
                                suspTarget = inf.t
                                for refT, refB in pairs(stBtnRefs) do 
                                    TweenService:Create(refB, AnimInfo.Fast, {BackgroundColor3 = (refT == inf.t and Theme.Accent or Theme.ElementBg)}):Play() 
                                end
                            end)
                            stBtnRefs[inf.t] = b
                        end
                        
                        Slider(cT, "Высота", 2.4, 4.5, 0.1, 3.45, function(val)
                            if not sCar then return end 
                            for _, obj in pairs(sCar:GetDescendants()) do 
                                if obj:IsA("SpringConstraint") or obj:IsA("PrismaticConstraint") then 
                                    local n1 = obj.Name:lower()
                                    local n2 = obj.Parent and obj.Parent.Name:lower() or ""
                                    local n3 = (obj:IsA("Constraint") and obj.Attachment0 and obj.Attachment0.Parent) and obj.Attachment0.Parent.Name:lower() or ""
                                    local n4 = (obj:IsA("Constraint") and obj.Attachment1 and obj.Attachment1.Parent) and obj.Attachment1.Parent.Name:lower() or ""
                                    
                                    local isF, isR, isFL, isFR, isRL, isRR = false, false, false, false, false, false
                                    for _, n in ipairs({n1, n2, n3, n4}) do
                                        if n == "fl" or n == "f_l" or n:match("frontleft") then isF, isFL = true, true end
                                        if n == "fr" or n == "f_r" or n:match("frontright") then isF, isFR = true, true end
                                        if n == "rl" or n == "r_l" or n:match("rearleft") then isR, isRL = true, true end
                                        if n == "rr" or n == "r_r" or n:match("rearright") then isR, isRR = true, true end
                                        if n:match("front") or n:match("^f$") or n:match("fwheel") then isF = true end
                                        if n:match("rear") or n:match("back") or n:match("^r$") or n:match("rwheel") then isR = true end
                                    end
                                    
                                    local apply = (suspTarget == "all") or (suspTarget == "front" and isF) or (suspTarget == "rear" and isR) or (suspTarget == "fl" and isFL) or (suspTarget == "fr" and isFR) or (suspTarget == "rl" and isRL) or (suspTarget == "rr" and isRR)
                                    
                                    if apply then 
                                        if obj:IsA("SpringConstraint") then obj.FreeLength = math.abs(val) 
                                        elseif obj:IsA("PrismaticConstraint") then obj.TargetPosition = val end 
                                    end
                                end 
                            end 
                        end)
                    end 
                    
                    for x, b in pairs(cBts) do 
                        if x.Parent then 
                            if x == sCar then TweenService:Create(b, AnimInfo.Fast, {BackgroundColor3 = Theme.Accent}):Play() 
                            else TweenService:Create(b, AnimInfo.Fast, {BackgroundColor3 = Theme.ElementBg}):Play() end 
                        else 
                            b:Destroy(); cBts[x] = nil 
                        end 
                    end 
                end) 
            end 
        end
    end 
end)

-- ==========================================
-- ВКЛАДКА "ЛУТ" (ИЗ DMM.TXT)
-- ==========================================
local LootLayoutCont = Create("Frame", {Size = UDim2.new(1, 0, 0, 380), BackgroundTransparency = 1, Parent = PageLoot})
local iL = Create("ScrollingFrame", {Size = UDim2.new(0.35, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 3, Parent = LootLayoutCont})
local iT = Create("ScrollingFrame", {Size = UDim2.new(0.63, 0, 1, 0), Position = UDim2.new(0.37, 0, 0, 0), BackgroundTransparency = 1, ScrollBarThickness = 3, Parent = LootLayoutCont})

local IL_Layout = Create("UIListLayout", {Padding = UDim.new(0, 6), Parent = iL})
local IT_Layout = Create("UIListLayout", {Padding = UDim.new(0, 6), Parent = iT})
IL_Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() iL.CanvasSize = UDim2.new(0, 0, 0, IL_Layout.AbsoluteContentSize.Y + 15) end)
IT_Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() iT.CanvasSize = UDim2.new(0, 0, 0, IT_Layout.AbsoluteContentSize.Y + 15) end)

local sIt = nil
local iBts = {} 
local sItHL = nil

CreateButtonEx(PageLoot, "НАЙТИ ЛУТ И МОТОРЫ", Theme.Accent, Color3.fromRGB(0, 150, 255), function() 
    for _, o in pairs(Workspace:GetDescendants()) do 
        local isEngine = o.Name:lower():match("engine")
        local isItem = o:FindFirstChild("chance") or o:FindFirstChild("id") or o:FindFirstChild("Values") or o:FindFirstChild("values")
        
        if (o:IsA("Model") or o:IsA("Folder") or o:IsA("Tool") or isEngine) and not iBts[o] and (isItem or isEngine) then 
            
            iBts[o] = CreateButtonEx(iL, o.Name, Theme.ElementBg, Theme.ElementHover, function() 
                sIt = (sIt == o) and nil or o 
                sItHL = applyHighlight(sIt, sItHL, Color3.fromRGB(255, 215, 0))
                
                for _, c in pairs(iT:GetChildren()) do 
                    if not c:IsA("UIListLayout") then c:Destroy() end 
                end 
                
                if sIt then 
                    local vals = sIt:FindFirstChild("Values") or sIt:FindFirstChild("values") or sIt
                    for _, v in pairs(vals:GetDescendants()) do 
                        if v:IsA("ValueBase") then Val(iT, v, v.Name) end 
                    end 
                end 
                
                for x, b in pairs(iBts) do 
                    if x.Parent then 
                        if x == sIt then TweenService:Create(b, AnimInfo.Fast, {BackgroundColor3 = Theme.Accent}):Play() 
                        else TweenService:Create(b, AnimInfo.Fast, {BackgroundColor3 = Theme.ElementBg}):Play() end 
                    else 
                        b:Destroy(); iBts[x] = nil 
                    end 
                end 
            end) 
        end 
    end 
end)

-- ==========================================
-- ВКЛАДКА "ИГРОКИ И ЧИТЫ" (ИЗ DMM.TXT)
-- ==========================================
local PlrLayoutCont = Create("Frame", {Size = UDim2.new(1, 0, 0, 380), BackgroundTransparency = 1, Parent = PagePlayers})
local pPL = Create("ScrollingFrame", {Size = UDim2.new(0.35, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 3, Parent = PlrLayoutCont})
local pPR = Create("ScrollingFrame", {Size = UDim2.new(0.63, 0, 1, 0), Position = UDim2.new(0.37, 0, 0, 0), BackgroundTransparency = 1, ScrollBarThickness = 3, Parent = PlrLayoutCont})

local PPL_Layout = Create("UIListLayout", {Padding = UDim.new(0, 6), Parent = pPL})
local PPR_Layout = Create("UIListLayout", {Padding = UDim.new(0, 6), Parent = pPR})
PPL_Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() pPL.CanvasSize = UDim2.new(0, 0, 0, PPL_Layout.AbsoluteContentSize.Y + 15) end)
PPR_Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() pPR.CanvasSize = UDim2.new(0, 0, 0, PPR_Layout.AbsoluteContentSize.Y + 15) end)

local selectedPlayer = LocalPlayer
local playerBtns = {}
local cheatSyncFuncs = {}
local playerStates = {}

local flyActive = false
local flySpeed = 50
local flyKeys = {W = false, A = false, S = false, D = false, Space = false, Shift = false}
local IYFlyBG, IYFlyBV = nil, nil

local detonatorActive = false
local activatorActive = false

local function getDebugUi()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then for _, gui in pairs(pg:GetChildren()) do if gui.Name:lower() == "debugui" then return gui end end end
    for _, gui in pairs(CoreGui:GetChildren()) do if gui.Name:lower() == "debugui" then return gui end end
    return nil
end

local function toggleIYFly()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    
    if flyActive then
        flyActive = false
        if IYFlyBG then IYFlyBG:Destroy() IYFlyBG = nil end
        if IYFlyBV then IYFlyBV:Destroy() IYFlyBV = nil end
        if hum then hum.PlatformStand = false end
    else
        flyActive = true
        if hum then hum.PlatformStand = true end
        
        IYFlyBG = Instance.new("BodyGyro")
        IYFlyBG.P = 9e4
        IYFlyBG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        IYFlyBG.cframe = hrp.CFrame
        IYFlyBG.Parent = hrp
        
        IYFlyBV = Instance.new("BodyVelocity")
        IYFlyBV.velocity = Vector3.new(0,0,0)
        IYFlyBV.maxForce = Vector3.new(9e9, 9e9, 9e9)
        IYFlyBV.Parent = hrp
        
        task.spawn(function()
            while flyActive and char and char:FindFirstChild("HumanoidRootPart") do
                local cam = Workspace.CurrentCamera
                IYFlyBG.cframe = cam.CFrame
                
                local moveDir = Vector3.zero
                if flyKeys.W then moveDir = moveDir + cam.CFrame.LookVector end
                if flyKeys.S then moveDir = moveDir - cam.CFrame.LookVector end
                if flyKeys.A then moveDir = moveDir - cam.CFrame.RightVector end
                if flyKeys.D then moveDir = moveDir + cam.CFrame.RightVector end
                if flyKeys.Space then moveDir = moveDir + Vector3.new(0, 1, 0) end
                if flyKeys.Shift then moveDir = moveDir - Vector3.new(0, 1, 0) end
                
                if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
                IYFlyBV.velocity = moveDir * flySpeed
                RunService.RenderStepped:Wait()
            end
            if IYFlyBG then IYFlyBG:Destroy() IYFlyBG = nil end
            if IYFlyBV then IYFlyBV:Destroy() IYFlyBV = nil end
            if hum then hum.PlatformStand = false end
        end)
    end
end

CreateButtonEx(PagePlayers, "ОБНОВИТЬ СПИСОК ИГРОКОВ", Theme.Accent, Color3.fromRGB(0, 150, 255), function() 
    for _, c in pairs(pPR:GetChildren()) do if not c:IsA("UIListLayout") then c:Destroy() end end 
    cheatSyncFuncs = {}
    for _, b in pairs(playerBtns) do if b.Parent then b:Destroy() end end
    playerBtns = {}
    
    for _, plr in pairs(Players:GetPlayers()) do
        local b = CreateButtonEx(pPL, plr.Name, Theme.ElementBg, Theme.ElementHover, function()
            selectedPlayer = plr
            if not playerStates[selectedPlayer] then playerStates[selectedPlayer] = {} end
            
            if #cheatSyncFuncs == 0 then
                Create("TextLabel", {Size = UDim2.new(0.98, 0, 0, 24), BackgroundTransparency = 1, Text = " ЧИТЫ НА ИГРОКА", TextColor3 = Theme.Green, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = pPR})
                
                local function PlayerCheckbox(text, remoteName, stateKey, callback)
                    local st = (playerStates[selectedPlayer] and playerStates[selectedPlayer][stateKey]) or false
                    local _, setInner = CreateToggle(pPR, text, st, function(newState)
                        local target = selectedPlayer or LocalPlayer
                        if not playerStates[target] then playerStates[target] = {} end
                        playerStates[target][stateKey] = newState
                        if callback then callback(target, newState) end
                        if remoteName then task.spawn(function() TryFire(remoteName, target, newState) end) end
                    end)
                    table.insert(cheatSyncFuncs, function()
                        local target = selectedPlayer or LocalPlayer
                        setInner((playerStates[target] and playerStates[target][stateKey]) or false)
                    end)
                end
                
                PlayerCheckbox("Нет голода", "nohunger", "nohunger")
                PlayerCheckbox("Нет стамины", "nostamina", "nostamina")
                PlayerCheckbox("Нет регдолла", "noragdoll", "noragdoll")
                PlayerCheckbox("Бессмертие", "godmode", "godmode")
                PlayerCheckbox("Бессмертие машины", "godcar", "godcar")
                
                Create("TextLabel", {Size = UDim2.new(0.98, 0, 0, 24), BackgroundTransparency = 1, Text = " ПОЛЕТ (БЕЗ ГРАВИТАЦИИ): ПРАВЫЙ CTRL", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = pPR})
                
                PlayerCheckbox("Удалятор (debugui)", nil, "deleter", function(plr, state)
                    local dbg = getDebugUi()
                    if dbg then
                        if dbg:IsA("ScreenGui") then dbg.Enabled = state
                        elseif dbg:IsA("GuiObject") then dbg.Visible = state end
                    end
                end)
                
                local curFov = math.clamp(math.floor(Workspace.CurrentCamera.FieldOfView), 60, 120)
                Slider(pPR, "Угол обзора (FOV)", 60, 120, 1, curFov, function(val) Workspace.CurrentCamera.FieldOfView = val end)

                PlayerCheckbox("Детонатор (Кнопка P)", nil, "detonator", function(plr, state) detonatorActive = state end)
                PlayerCheckbox("Активатор (Кнопка L)", nil, "activator", function(plr, state) activatorActive = state end)
                PlayerCheckbox("Спавн зомби (Зажатие Y)", nil, "spawnzombie", function(plr, state) end)
            end
            
            for _, sync in ipairs(cheatSyncFuncs) do sync() end
            for targetPlr, btn in pairs(playerBtns) do
                if btn.Parent then
                    if targetPlr == selectedPlayer then TweenService:Create(btn, AnimInfo.Fast, {BackgroundColor3 = Theme.Accent}):Play()
                    else TweenService:Create(btn, AnimInfo.Fast, {BackgroundColor3 = Theme.ElementBg}):Play() end
                end
            end
        end)
        playerBtns[plr] = b
    end
end) 

-- ==========================================
-- ВВОД КЛАВИШИ (ПОЛЕТ И ДЕТОНАТОРЫ ИЗ DMM)
-- ==========================================
local isYDown = false
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then flyKeys.W = true end
    if input.KeyCode == Enum.KeyCode.A then flyKeys.A = true end
    if input.KeyCode == Enum.KeyCode.S then flyKeys.S = true end
    if input.KeyCode == Enum.KeyCode.D then flyKeys.D = true end
    if input.KeyCode == Enum.KeyCode.Space then flyKeys.Space = true end
    if input.KeyCode == Enum.KeyCode.LeftShift then flyKeys.Shift = true end
    if input.KeyCode == Enum.KeyCode.RightControl then toggleIYFly() end

    if input.KeyCode == Enum.KeyCode.Y then
        local targetPlayer = selectedPlayer or LocalPlayer
        if playerStates[targetPlayer] and playerStates[targetPlayer]["spawnzombie"] then
            isYDown = true
            task.spawn(function()
                while isYDown do
                    pcall(function()
                        local Event = ReplicatedStorage:FindFirstChild("sandboxconnection") and ReplicatedStorage.sandboxconnection:FindFirstChild("spawnzombie")
                        if Event then
                            if Event:IsA("RemoteFunction") then Event:InvokeServer()
                            elseif Event:IsA("RemoteEvent") then Event:FireServer() end
                        end
                    end)
                    task.wait()
                end
            end)
        end
    elseif input.KeyCode == Enum.KeyCode.P and detonatorActive then
        task.spawn(function()
            for _, obj in pairs(game:GetDescendants()) do
                local n = obj.Name
                if n == "tnt" or n == "bomb" then
                    local part = obj:FindFirstChild("Part")
                    if part then FireToggle(part) end
                elseif n == "firework" then
                    local model = obj:FindFirstChild("Model") or obj:FindFirstChild("model")
                    if model then
                        local main = model:FindFirstChild("main")
                        if main then FireToggle(main) end
                    end
                elseif n == "Gift1" or n == "Gift2" or n == "Gift3" then
                    local ma = obj:FindFirstChild("ma")
                    if ma then FireToggle(ma) end
                end
            end
        end)
    elseif input.KeyCode == Enum.KeyCode.L and activatorActive then
        task.spawn(function()
            for _, obj in pairs(game:GetDescendants()) do
                if obj.Name == "turbine" then
                    local trust = obj:FindFirstChild("TRUST")
                    if trust then FireToggle(trust) end
                end
            end
        end)
    end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.Y then isYDown = false end
    if input.KeyCode == Enum.KeyCode.W then flyKeys.W = false end
    if input.KeyCode == Enum.KeyCode.A then flyKeys.A = false end
    if input.KeyCode == Enum.KeyCode.S then flyKeys.S = false end
    if input.KeyCode == Enum.KeyCode.D then flyKeys.D = false end
    if input.KeyCode == Enum.KeyCode.Space then flyKeys.Space = false end
    if input.KeyCode == Enum.KeyCode.LeftShift then flyKeys.Shift = false end
end)

-- ==========================================
-- ВКЛАДКА НАСТРОЕК
-- ==========================================
CreateButtonEx(PageSettings, "💻 ЗАПУСТИТЬ Infinite Yield (Консоль)", Theme.ElementBg, Theme.ElementHover, function() 
    pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end) 
end)

CreateButtonEx(PageSettings, "УДАЛИТЬ ИНТЕРФЕЙС И СКРИПТ", Theme.Red, Theme.RedHover, function() 
    ScreenGui:Destroy() 
end)
