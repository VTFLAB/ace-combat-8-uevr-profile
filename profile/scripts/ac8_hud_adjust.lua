--[[
  ACE COMBAT 8 + UEVR : HUD element position adjuster

  Works together with ac8_ui_fix.lua, which pushes the flight HUD widgets
  into the viewport:
      WBP_HUD_Chronicle_MainFlight_000_C
      WBP_HUD_Chronicle_Parts_NoGlow_000_C

  - Dumps both widget trees (child names / classes / slot positions) to
      %APPDATA%\UnrealVRMod\AceCombat8\data\ac8_hud_adjust.txt
  - Lets you shift each root widget, or any child widget by name,
    with RenderTranslation (pixels). Layout is untouched.

  Settings UI: UEVR menu (Insert) -> LuaLoader -> Script UI
  Settings are saved to data\ac8_hud_adjust.json
]]

local api = uevr.api
if api == nil then return end

local ROOTS = {
    "WBP_HUD_Chronicle_MainFlight_000_C",
    "WBP_HUD_Chronicle_Parts_NoGlow_000_C",
}

local cfg = { roots = {}, child_name = "", child_x = 0.0, child_y = 0.0 }
for _, r in ipairs(ROOTS) do cfg.roots[r] = { x = 0.0, y = 0.0 } end
pcall(function()
    local saved = json.load_file("ac8_hud_adjust.json")
    if type(saved) == "table" then
        if type(saved.roots) == "table" then
            for r, v in pairs(saved.roots) do
                if cfg.roots[r] and type(v) == "table" then
                    cfg.roots[r].x = tonumber(v.x) or 0.0
                    cfg.roots[r].y = tonumber(v.y) or 0.0
                end
            end
        end
        if type(saved.child_name) == "string" then cfg.child_name = saved.child_name end
        cfg.child_x = tonumber(saved.child_x) or 0.0
        cfg.child_y = tonumber(saved.child_y) or 0.0
    end
end)
local function save_cfg()
    pcall(function() json.dump_file("ac8_hud_adjust.json", cfg, 4) end)
end

local FH = nil
pcall(function() FH = io.open("ac8_hud_adjust.txt", "w") end)
local function log(s)
    if FH == nil then return end
    pcall(function() FH:write(s .. "\n"); FH:flush() end)
end

local function safe(f)
    local ok, r = pcall(f)
    if ok then return r end
    return nil
end

local function oname(o)
    return safe(function() return o:get_fname():to_string() end) or "?"
end
local function cname(o)
    return safe(function() return o:get_class():get_fname():to_string() end) or "?"
end

--------------------------------------------------------------------------
-- RenderTranslation setter: try the vector types UEVR may accept
--------------------------------------------------------------------------
local vec_mode = nil   -- remembered once one works
local function make_vec(mode, x, y)
    if mode == "2d" then return Vector2d.new(x, y) end
    if mode == "2f" then return Vector2f.new(x, y) end
    return { X = x, Y = y }
end
local function read_translation(w)
    local t = safe(function() return w.RenderTransform.Translation end)
    if t == nil then return nil end
    local x = safe(function() return t.x end) or safe(function() return t.X end)
    local y = safe(function() return t.y end) or safe(function() return t.Y end)
    if x == nil then return nil end
    return x, y
end
local function set_translation(w, x, y)
    local modes = vec_mode and { vec_mode } or { "2d", "2f", "tbl" }
    for _, m in ipairs(modes) do
        local ok = pcall(function() w:SetRenderTranslation(make_vec(m, x, y)) end)
        if ok then
            local rx, ry = read_translation(w)
            if rx == nil or (math.abs(rx - x) < 0.5 and math.abs(ry - y) < 0.5) then
                if vec_mode == nil then
                    vec_mode = m
                    log("SetRenderTranslation accepted vector mode: " .. m
                        .. (rx == nil and " (could not read back)" or " (verified)"))
                end
                return true
            end
        end
    end
    return false
end

--------------------------------------------------------------------------
-- Widget tree walk / dump
--------------------------------------------------------------------------
local function children_of(w)
    local out = {}
    local n = safe(function() return w:GetChildrenCount() end)
    if type(n) == "number" and n > 0 then
        for i = 0, n - 1 do
            local c = safe(function() return w:GetChildAt(i) end)
            if c then out[#out + 1] = c end
        end
    end
    -- UserWidget child: descend into its own tree
    local tree = safe(function() return w.WidgetTree end)
    local rw = tree and safe(function() return tree.RootWidget end)
    if rw then out[#out + 1] = rw end
    return out
end

local function walk(w, depth, fn)
    if depth > 8 then return end
    fn(w, depth)
    for _, c in ipairs(children_of(w)) do walk(c, depth + 1, fn) end
end

local function slot_info(w)
    local slot = safe(function() return w.Slot end)
    if slot == nil then return "" end
    local s = " slot=" .. cname(slot)
    local p = safe(function() return slot:GetPosition() end)
    if p then
        local x = safe(function() return p.x end) or safe(function() return p.X end)
        local y = safe(function() return p.y end) or safe(function() return p.Y end)
        if x then s = s .. string.format(" pos=(%.0f, %.0f)", x, y) end
    end
    local sz = safe(function() return slot:GetSize() end)
    if sz then
        local x = safe(function() return sz.x end) or safe(function() return sz.X end)
        local y = safe(function() return sz.y end) or safe(function() return sz.Y end)
        if x then s = s .. string.format(" size=(%.0f, %.0f)", x, y) end
    end
    return s
end

local dumped = {}
local function dump(root, key)
    if dumped[key] then return end
    dumped[key] = true
    log("==== " .. key)
    local lines = 0
    walk(root, 0, function(w, d)
        lines = lines + 1
        if lines > 400 then return end
        local vis = safe(function() return w:GetVisibility() end)
        log(string.rep("  ", d) .. oname(w) .. " [" .. cname(w) .. "]"
            .. slot_info(w) .. (vis ~= nil and (" vis=" .. tostring(vis)) or ""))
    end)
end

--------------------------------------------------------------------------
-- Find live root widgets
--------------------------------------------------------------------------
local UW = safe(function() return api:find_uobject("Class /Script/UMG.UserWidget") end)
if UW == nil then log("UserWidget class not found"); return end

local ROOT_SET = {}
for _, r in ipairs(ROOTS) do ROOT_SET[r] = true end

local roots = {}   -- { obj, cls, key }
local function find_roots()
    roots = {}
    local arr = safe(function() return UW:get_objects_matching(false) end)
    if type(arr) ~= "table" then return end
    for _, w in ipairs(arr) do
        local nm = safe(function() return w:get_full_name() end)
        if type(nm) == "string" and not nm:find(".WidgetTree", 1, true)
            and not nm:find("Default__", 1, true) then
            local cls = nm:match("^(%S+)")
            if ROOT_SET[cls] and safe(function() return w:IsInViewport() end) == true then
                roots[#roots + 1] = { obj = w, cls = cls, key = nm }
                dump(w, nm)
            end
        end
    end
end

--------------------------------------------------------------------------
-- Apply offsets
--------------------------------------------------------------------------
local status = "searching..."
local child_hits = 0

local function apply_all()
    local ok_n = 0
    child_hits = 0
    local pat = cfg.child_name
    for _, r in ipairs(roots) do
        local o = cfg.roots[r.cls]
        if o and set_translation(r.obj, o.x, o.y) then ok_n = ok_n + 1 end
        if pat ~= nil and pat ~= "" then
            walk(r.obj, 0, function(w, d)
                if d > 0 and oname(w):find(pat, 1, true) then
                    if set_translation(w, cfg.child_x, cfg.child_y) then
                        child_hits = child_hits + 1
                    end
                end
            end)
        end
    end
    status = string.format("roots in viewport: %d, moved: %d, child matches: %d, vec=%s",
        #roots, ok_n, child_hits, tostring(vec_mode))
end

local frame = 0
uevr.sdk.callbacks.on_pre_engine_tick(function(engine, delta)
    frame = frame + 1
    if frame % 120 == 1 then find_roots() end
    if frame % 15 == 1 then apply_all() end
end)

--------------------------------------------------------------------------
-- UI
--------------------------------------------------------------------------
uevr.sdk.callbacks.on_draw_ui(function()
    imgui.text("AC8 HUD Adjust (widget offsets, pixels)")
    imgui.text("Status: " .. status)
    local changed = false
    local c, v

    for _, r in ipairs(ROOTS) do
        local o = cfg.roots[r]
        imgui.text(r)
        c, v = imgui.slider_float("X##" .. r, o.x, -1500.0, 1500.0)
        if c then o.x = v; changed = true end
        c, v = imgui.slider_float("Y##" .. r, o.y, -1000.0, 1000.0)
        if c then o.y = v; changed = true end
    end

    imgui.text("Child widget (name contains, see data\\ac8_hud_adjust.txt)")
    c, v = imgui.input_text("Name##child", cfg.child_name)
    if c then cfg.child_name = v; changed = true end
    c, v = imgui.slider_float("X##child", cfg.child_x, -1500.0, 1500.0)
    if c then cfg.child_x = v; changed = true end
    c, v = imgui.slider_float("Y##child", cfg.child_y, -1000.0, 1000.0)
    if c then cfg.child_y = v; changed = true end

    if imgui.button("Reset all to 0") then
        for _, r in ipairs(ROOTS) do cfg.roots[r].x, cfg.roots[r].y = 0.0, 0.0 end
        cfg.child_x, cfg.child_y = 0.0, 0.0
        changed = true
    end

    if changed then save_cfg(); apply_all() end
end)

log("ac8_hud_adjust (widget offsets) loaded")
