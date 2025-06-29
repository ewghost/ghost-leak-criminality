local HttpService = game:GetService("HttpService")
local SERVER_URL  = "http://ghostapi.glitch.me"
local SCRIPT_NAME = "aks-keysystem"

local function GetRaw(url)
    if typeof(game.HttpGetAsync) == "function" then
        local ok, resp = pcall(function() return game:HttpGetAsync(url) end)
        if ok and type(resp) == "string" then return resp end
    end
    if type(http) == "table" and type(http.request) == "function" then
        local ok, resp = pcall(function() return http.request({Url=url,Method="GET"}).Body end)
        if ok and type(resp) == "string" then return resp end
    end
    local ok, resp = pcall(function() return HttpService:GetAsync(url, true) end)
    if ok and type(resp) == "string" then return resp end
    return nil
end

local function LoadMeta(name)
    for i = 1, 5 do
        local raw = GetRaw(SERVER_URL.."/load/"..name)
        if raw then
            local ok, data = pcall(function() return HttpService:JSONDecode(raw) end)
            if ok and type(data) == "table" and data.url then
                return data.url
            end
        end
        wait(1)
    end
    return nil
end

local function LoadRemoteScript(name)
    local url = LoadMeta(name)
    if not url then
        warn("Failed to fetch metadata for script:", name)
        return
    end
    for i = 1, 5 do
        local code = GetRaw(url)
        if code and type(code) == "string" then
            local fn, err = loadstring(code)
            if fn then
                local ok, runErr = pcall(fn)
                if not ok then warn("Error executing script:", runErr) end
                return
            else
                warn("Failed to compile script:", err)
            end
        end
        wait(1)
    end
    warn("Failed to download script code after multiple attempts:", name)
end

LoadRemoteScript(SCRIPT_NAME)
