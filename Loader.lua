--[[
    ══════════════════════════════════════════════════════════════════════
    toxicity hub | Official Loader
    Support: Survive the Killer V3 Premium
    
    Execute in Roblox:
    loadstring(game:HttpGet("https://raw.githubusercontent.com/steeveen333/steven7z/main/Loader.lua", true))()
    ══════════════════════════════════════════════════════════════════════
--]]

local StarterGui = game:GetService("StarterGui")

local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "toxicity hub",
            Text = text or "",
            Duration = duration or 4
        })
    end)
end

notify("toxicity hub", "Loading Survive the Killer V3...", 3)

local payloadUrl = "https://raw.githubusercontent.com/steeveen333/steven7z/main/payload.lua?nocache=" .. tostring(tick())
local payloadCode = nil

local loadOk = pcall(function()
    payloadCode = game:HttpGet(payloadUrl, true)
end)

if not loadOk or not payloadCode or payloadCode == "" then
    pcall(function()
        local req = (syn and syn.request) or (http and http.request) or http_request or request
        if req then
            local res = req({Url = payloadUrl, Method = "GET"})
            if res and res.Body then payloadCode = res.Body end
        end
    end)
end

if not payloadCode or payloadCode == "" then
    notify("toxicity hub", "Error: Unable to fetch payload. Check connection.", 5)
    return
end

local executeFn, syntaxErr = loadstring(payloadCode, "toxicity.payload")
if not executeFn then
    notify("toxicity hub", "Compilation error: " .. tostring(syntaxErr), 6)
    return
end

task.spawn(executeFn)
