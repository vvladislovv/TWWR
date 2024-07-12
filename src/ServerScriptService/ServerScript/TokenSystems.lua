local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Remotes = ReplicatedStorage:WaitForChild('Remotes')

local Data = require(ServerScriptService.ServerScript.Data)
local ModuleTable = require(ReplicatedStorage.Modules.ModuleTable)
local Utils = require(ReplicatedStorage.Libary.Utils)
local NofficalGame = require(ReplicatedStorage.Libary.NofficalGame)
local TweenModule = require(ReplicatedStorage.Libary.TweenModule)

local TableNofi = {}

local TokenSystems = {}

function TokenSystems:SpawnToken(Info)
        local v1 = true
        local vv1 = false
        local v2 = false
        local v3 = 0
        local v1Dop = true
        local TokenModule = ModuleTable.TokenTables.TokenDrop[Info.Token.Item]
        local Token = ReplicatedStorage.Assert.Token:Clone()
        Token.Type.Value = Info.Token.Type
        Token.Tokenimage.Color = TokenModule.ColorToken
        Token.PrimaryPart.Position = Vector3.new(Info.Position.X,-100,Info.Position.Z) 
        Token.Amount.Value = Info.Token.Amount
        Token.Item.Value = Info.Token.Item
        Token.Resourse.Value = Info.Resourse
        Token.Parent = workspace.Map.GameSettings.GameOnline.TokenFolder
        if Info.Token.Item == "Coin" then
            Token.Tokenimage.Decal1.Texture = TokenModule.Image
            Token.Tokenimage.Decal2.Texture = TokenModule.Image
        end
    
        Remotes.TokenClient:FireAllClients(Token,Info)
    
        local function TouchedToken(hit)
            if game.Players:FindFirstChild(hit.Parent.Name) then
                local Player = game.Players:FindFirstChild(hit.Parent.Name)
                Token.DownColor.CanTouch = false
                if Player then
                    task.spawn(function()
                        --Remotes.TokenClient2:FireAllClients(Token,Info)
                        task.wait(TokenModule.Coouldown-5)
                        v1 = true
                        v1Dop = true
                    end)
                    coroutine.wrap(function()
                        repeat 
                            if Token.PrimaryPart == nil and _G.PData.BaseFakeSettings.FieldVars ~= "" then return end
                        until Token.PrimaryPart.Position ~= nil
    
                        if vv1 == false and not v2 and hit.Parent == Player.Character and v3 == 0 then
                            v2 = true
                            vv1 = true
                            v3 = 1
                            -- Придумать как сделать
                            TweenModule:OrientationToken(Token)
                            TweenModule:TrasnparionToken(Token)
    
                            task.wait(1)
                            if Token.PrimaryPart ~= nil then
                                TweenService:Create(Token.PrimaryPart,TweenInfo.new(1.5,Enum.EasingStyle.Elastic,Enum.EasingDirection.Out), {Position = Token.PrimaryPart.Position + Vector3.new(0,-15,0)}):Play()
                                TweenService:Create(Token.Tokenimage,TweenInfo.new(1.5,Enum.EasingStyle.Elastic,Enum.EasingDirection.Out), {Position = Token.Tokenimage.Position + Vector3.new(0,-15,0)}):Play()
                                TweenService:Create(Token.DownColor,TweenInfo.new(1.5,Enum.EasingStyle.Elastic,Enum.EasingDirection.Out), {Position = Token.DownColor.Position + Vector3.new(0,-15,0)}):Play()
                                Token:Destroy()
                                vv1 = false
                                v3 = 0
                            end
                            vv1 = false
                            v3 = 0
                        end
                    end)()

                    task.spawn(function() -- тут смотреть 
                        local PData = Data:Get(Player)
                        if Token:FindFirstChild('Type').Value == "Drop" then
                            if Token:FindFirstChild('Item').Value == "Coin" then
                                if v1Dop then
                                    v1Dop = false
                                    local AmountOfHoney = math.round(((Token.Amount.Value + math.random(10,25)) * PData.Boost.PlayerBoost["Honey From Tokens"] / 100))

                                    coroutine.wrap(function()
                                        if TableNofi[Info.Token.Item] ~= nil then
                                            TableNofi[Info.Token.Item] += AmountOfHoney
                                        else
                                            TableNofi[Info.Token.Item] = AmountOfHoney
                                        end
                                        Remotes.Notify:FireClient(Player,"Orange","+"..TableNofi[Info.Token.Item].." "..Info.Token.Item,true,Info.Token.Item)
                                    end)()

                                    PData.IStats.Coin += AmountOfHoney
                                    --print(AmountOfHoney)
                                    PData.TotalItems.CoinTotal += AmountOfHoney
                                    PData.IStats.DailyHoney += AmountOfHoney
                                    PData:Update('IStats', PData.IStats)
                                    PData:Update('TotalItems', PData.TotalItems)
                                end
                                -- NofficalGame:NofficalCreate()
                            else
                                if v1 then
                                    v1 = false
                                    coroutine.wrap(function()
                                        if TableNofi[Info.Token.Item] ~= nil then
                                            TableNofi[Info.Token.Item] += Info.Token.Amount
                                        else
                                            TableNofi[Info.Token.Item] = Info.Token.Amount
                                        end
                                        Remotes.Notify:FireClient(Player,"Blue","+"..TableNofi[Info.Token.Item].." "..Info.Token.Item,true,Info.Token.Item)
                                    end)()
                                    if PData.Inventory[Token.Item.Value] == nil then
                                        PData.Inventory[Token.Item.Value] = Token.Amount.Value
                                    else
                                        PData.Inventory[Token.Item.Value] += Token.Amount.Value
                                    end
                                    PData:Update('Inventory', PData.Inventory)
                                end
                            end
    
                        elseif Token.Type.Value == "Boost" then
                            -- Fire in Boost
                        end
                        task.delay(15,function()
                            TableNofi = {}
                        end)
                    end)
    
                end
            end
        end
    
    
        Token.DownColor.Touched:Connect(TouchedToken)
end


return TokenSystems