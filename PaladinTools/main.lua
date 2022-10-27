local ONUPDATE_INTERVAL = 0.1
local INNERGRACE_INTERVAL = 12
local player_incombat = false
local innergrace_timer = INNERGRACE_INTERVAL
local starttime = 0
local innergrace_lastupdate = 0
if show_innergrace  == nil then show_innergrace = true end

function innergrace_onupdate(self,elapsed)
    if player_incombat then
        innergrace_lastupdate = innergrace_lastupdate + elapsed;
        if innergrace_lastupdate >= ONUPDATE_INTERVAL then
            innergrace_lastupdate = 0
            self.text:SetText(format("%s",math.fmod(math.floor(starttime),INNERGRACE_INTERVAL)+1))
        end
    else
        innergrace_timer = INNERGRACE_INTERVAL
    end
end

local f = CreateFrame("Frame","innergrace",UIParent)
f:SetSize(50,50)
f:SetPoint("CENTER",0,0)
f.text = f.text or f:CreateFontString(nil,"ARTWORK","NumberFontNormalYellow")
f.text:SetAllPoints(true)
f:SetScript("OnUpdate", innergrace_onupdate)
f:SetMovable(true)
f:EnableMouse(true)
f:SetScript("OnMouseDown",function() f:StartMoving() end)
f:SetScript("OnMouseUp",function() f:StopMovingOrSizing() end)

local l = CreateFrame("Frame")
l:RegisterEvent("PLAYER_LOGIN")
l:SetScript("OnEvent", function(self, event) 
    print("Paladintools addon is active. Type /paladintools to see available commands.")
end);

local h = CreateFrame("Frame")
h:RegisterEvent("PLAYER_REGEN_ENABLED")
h:SetScript("OnEvent", function(self, event) 
    player_incombat = false
end);

local k = CreateFrame("Frame")
k:RegisterEvent("PLAYER_REGEN_DISABLED")
k:SetScript("OnEvent", function(self, event) 
    starttime = GetTime()
    player_incombat = true
end);

SLASH_PALADINTOOLS1 = '/paladintools';
local function handler(msg, editbox)
    msg = string.lower(msg);
    if msg == 'reset' then
        f:ClearAllPoints()
        f:SetPoint("CENTER",0,0)
        f:Show()
        show_innergrace = true
    elseif msg == 'showinnergrace' then
        f:Show()
        show_innergrace = true
    elseif msg == 'hideinnergrace' then
        f:Hide()
        show_innergrace = false
    else
        print("/speed reset to center the frame.")
        print("/speed showinnergrace/hideinnergrace to show or hide inner grace timer.")
    end
end
SlashCmdList["PALADINTOOLS"] = handler;
