-- Dumps every field of the rare box configs so we can tell True/Golem/Lord/King/Divine apart
local cfg = require(game:GetService("ReplicatedStorage").Shared.BoxConfig)
local out = {}
local function ser(v, d)
    if typeof(v) == "table" then
        if d > 2 then return "{...}" end
        local p = {}
        for k, x in pairs(v) do p[#p + 1] = tostring(k) .. "=" .. ser(x, d + 1) end
        return "{" .. table.concat(p, ", ") .. "}"
    end
    return typeof(v) .. ":" .. tostring(v)
end
for _, id in ipairs({"true_box", "golem_box", "lord_box", "king_box", "divine_box", "happy_box", "winged_box", "prism_box"}) do
    out[#out + 1] = id .. " -> " .. (cfg.ById[id] and ser(cfg.ById[id], 0) or "missing")
end
-- live rare box in the world (any box whose face is 108908582036844)
local br = workspace:FindFirstChild("BoxRuntime")
if br then
    for _, m in ipairs(br:GetChildren()) do
        local f = m:FindFirstChild("Face", true)
        if f and f:IsA("ImageLabel") and tostring(f.Image):find("108908582036844") then
            out[#out + 1] = "LIVE " .. m:GetFullName()
            for k, v in pairs(m:GetAttributes()) do out[#out + 1] = "  @" .. k .. "=" .. tostring(v) end
            for _, c in ipairs(m:GetDescendants()) do
                local x = c.Name .. " (" .. c.ClassName .. ")"
                if c:IsA("BasePart") then x = x .. " color=" .. tostring(c.Color) .. " mat=" .. c.Material.Name end
                if c:IsA("TextLabel") then x = x .. ' text="' .. c.Text .. '"' end
                out[#out + 1] = "  - " .. x
            end
            break
        end
    end
end
local text = table.concat(out, "\n"):sub(1, 30000)
if setclipboard then setclipboard(text) end
print(text)
