-- Pastikan game sudah load
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- HANYA jalan di private server milik sendiri
if game.PrivateServerId == "" then return end
if game.PrivateServerOwnerId ~= LocalPlayer.UserId then return end

-- Loop sederhana & stabil
while task.wait(0.5) do
    if Players.NumPlayers > 1 then
        LocalPlayer:Kick("Player lain masuk ke private server")
        break
    end
end
