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
            Duration = duration or 5
        })
    end)
    print("[" .. tostring(title) .. "] " .. tostring(text))
end

notify("toxicity hub", "Downloading menu...", 3)

local payloadUrl = "https://raw.githubusercontent.com/steeveen333/steven7z/main/payload.lua?nocache=" .. tostring(math.floor(tick()))
local payloadCode = nil

local loadOk, loadErr = pcall(function()
    payloadCode = game:HttpGet(payloadUrl)
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
    notify("toxicity hub", "Download error: Check internet or GitHub status.", 6)
    return
end

local executeFn, syntaxErr = loadstring(payloadCode, "toxicity.payload")
if not executeFn then
    notify("toxicity hub", "Compile error: " .. tostring(syntaxErr), 7)
    return
end

local runOk, runErr = pcall(executeFn)
if not runOk then
    notify("toxicity hub", "Runtime error: " .. tostring(runErr), 7)
end
