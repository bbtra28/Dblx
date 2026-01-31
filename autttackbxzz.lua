-- Tunggu game load
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Pastikan PRIVATE SERVER MILIK SENDIRI
if game.PrivateServerId == "" then return end
if game.PrivateServerOwnerId ~= LocalPlayer.UserId then return end

-- Loop ringan, cek jumlah player
RunService.Heartbeat:Connect(function()
    if #Players:GetPlayers() > 1 then
        LocalPlayer:Kick("Player lain masuk ke private server")
    end
end)
