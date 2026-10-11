--[[
    ══════════════════════════════════════════════════════════════════════
    toxicity hub | Official Secure Loader
    Support: Survive the Killer V3 Premium
    
    Execute in Roblox:
    loadstring(game:HttpGet("https://raw.githubusercontent.com/steeveen333/steven7z/main/Loader.lua", true))()
    ══════════════════════════════════════════════════════════════════════
--]]

local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "toxicity hub",
            Text = text or "",
            Duration = duration or 5
        })
    end)
end

notify("toxicity hub", "Checking access permissions...", 3)

local function getWhitelist()
    local url = "https://raw.githubusercontent.com/steeveen333/steven7z/main/whitelist.json?nocache=" .. tostring(tick())
    local body = nil
    
    local ok = pcall(function()
        body = game:HttpGet(url, true)
    end)
    
    if not ok or not body or body == "" then
        pcall(function()
            local req = (syn and syn.request) or (http and http.request) or http_request or request
            if req then
                local res = req({Url = url, Method = "GET"})
                if res and res.Body then body = res.Body end
            end
        end)
    end
    
    if body and body ~= "" then
        local success, parsed = pcall(function()
            return HttpService:JSONDecode(body)
        end)
        if success and parsed and parsed.whitelisted then
            return parsed.whitelisted
        end
    end
    return nil
end

local list = getWhitelist()
if not list then
    notify("toxicity hub", "Failed to contact authorization server.", 5)
    return
end

local myUserId = tostring(LocalPlayer.UserId)
local myName = string.lower(LocalPlayer.Name)
local isWhitelisted = false

for _, entry in ipairs(list) do
    local strEntry = string.lower(tostring(entry))
    if strEntry == myUserId or strEntry == myName or strEntry == "*" or strEntry == "all" then
        isWhitelisted = true
        break
    end
end

if not isWhitelisted then
    pcall(function()
        if setclipboard then
            setclipboard(myUserId)
            notify("toxicity hub", "Unauthorized! UserId " .. myUserId .. " copied to clipboard. Send to owner.", 8)
        else
            notify("toxicity hub", "Unauthorized! UserId: " .. myUserId .. " is not whitelisted.", 8)
        end
    end)
    return
end

notify("toxicity hub", "Access Granted! Loading menu...", 3)

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
    notify("toxicity hub", "Error: Unable to fetch payload.", 5)
    return
end

local executeFn, syntaxErr = loadstring(payloadCode, "toxicity.payload")
if not executeFn then
    notify("toxicity hub", "Compilation error: " .. tostring(syntaxErr), 6)
    return
end

task.spawn(executeFn)
