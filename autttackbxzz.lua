-- Tunggu game load
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Pastikan ini private server MILIK KITA
if game.PrivateServerId == "" then return end
if game.PrivateServerOwnerId ~= player.UserId then return end

-- Kalau sudah ada orang lain sejak awal → langsung kick
if #Players:GetPlayers() > 1 then
    player:Kick("Player lain terdeteksi di private server")
end

-- Deteksi player baru join
Players.PlayerAdded:Connect(function(plr)
    if plr ~= player then
        player:Kick("Player lain join private server")
    end
end)
