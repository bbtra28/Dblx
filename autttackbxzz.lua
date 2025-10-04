for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("Model") and v:FindFirstChild("Humanoid") then
        print("Ditemukan model dengan Humanoid:", v.Name, "dalam folder:", v.Parent.Name)
    end
end
