local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    -- Deteksi tap layar
    if input.UserInputType == Enum.UserInputType.Touch then
        local touchPos = input.Position
        local ray = camera:ViewportPointToRay(touchPos.X, touchPos.Y)

        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {player.Character}
        params.FilterType = Enum.RaycastFilterType.Blacklist

        local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)

        if result then
            print("Nama Part:", result.Instance.Name)
            print("Path:", result.Instance:GetFullName())
        else
            print("Tidak mengenai part")
        end
    end
end)
