-- Finds which box type uses face image 108908582036844 (shows as "Face 108908582036844" in Desert/Dungeon)
local RepS = game:GetService("ReplicatedStorage")
local cfg = require(RepS.Shared.BoxConfig)
local out, id = {}, "108908582036844"
local function walk(t, path, d)
    if d > 4 or type(t) ~= "table" then return end
    for k, v in pairs(t) do
        local p = path .. "." .. tostring(k)
        if type(v) == "table" then walk(v, p, d + 1)
        elseif tostring(v):find(id, 1, true) then out[#out + 1] = p .. " = " .. tostring(v) end
    end
end
walk(cfg, "BoxConfig", 0)
local text = #out > 0 and table.concat(out, "\n") or "no match in BoxConfig"
if setclipboard then setclipboard(text) end
print(text)
