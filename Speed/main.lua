local ONUPDATE_INTERVAL = 0.1
local player_lastupdate = 0
local target_lastupdate = 0
if show_player_speed == nil then show_player_speed = true end
if show_target_speed == nil then show_target_speed = true end
function player_speed_onupdate(self,elapsed)
	player_lastupdate = player_lastupdate + elapsed;
	if player_lastupdate >= ONUPDATE_INTERVAL then
		player_lastupdate = 0
		local isGliding, canGlide, forwardSpeed = C_PlayerInfo.GetGlidingInfo()
		if isGliding then
			self.text:SetText(format("%s",math.floor((forwardSpeed/0.07)+0.5)))
		else
			self.text:SetText(format("%s",math.floor((GetUnitSpeed("player")/0.07)+0.5)))
		end
	end
end
function target_speed_onupdate(self,elapsed)
	target_lastupdate = target_lastupdate + elapsed;
	if target_lastupdate >= ONUPDATE_INTERVAL then
		target_lastupdate = 0
		self.text:SetText(format("%s",math.floor((GetUnitSpeed("target")/0.07)+0.5)))
	end
end
local f = CreateFrame("Frame","PlayerSpeedFrame",UIParent)
f:SetSize(50,50)
f:SetPoint("CENTER",-25,0)
f.text = f.text or f:CreateFontString(nil,"ARTWORK","GameFontHighlightLarge")
f.text:SetAllPoints(true)
f:SetScript("OnUpdate", player_speed_onupdate)
f:SetMovable(true)
f:EnableMouse(true)
f:SetScript("OnMouseDown",function() f:StartMoving() end)
f:SetScript("OnMouseUp",function() f:StopMovingOrSizing() end)
local g = CreateFrame("Frame","TargetSpeedFrame",UIParent)
g:SetSize(50,50)
g:SetPoint("CENTER",25,0)
g.text = g.text or g:CreateFontString(nil,"ARTWORK","GameFontDisableLarge")
g.text:SetAllPoints(true)
g:SetScript("OnUpdate", target_speed_onupdate)
g:SetMovable(true)
g:EnableMouse(true)
g:SetScript("OnMouseDown",function() g:StartMoving() end)
g:SetScript("OnMouseUp",function() g:StopMovingOrSizing() end)
g:Hide()
local l = CreateFrame("Frame")
l:RegisterEvent("PLAYER_ENTERING_WORLD")
l:SetScript("OnEvent", function(self, event)
	print("Speed addon is active. Type /speed to see available commands.")
end);
local h = CreateFrame("Frame")
h:RegisterEvent("ADDON_LOADED")
h:SetScript("OnEvent", function(self, event)
	if not show_player_speed then
		f:Hide()
	end
end);
local k = CreateFrame("Frame")
k:RegisterEvent("PLAYER_TARGET_CHANGED")
k:SetScript("OnEvent", function(self, event)
	if UnitExists("target") and show_target_speed then
		g:Show()
	else
		g:Hide()
	end
end);

SLASH_SPEED1 = '/speed';
local function handler(msg, editbox)
	msg = string.lower(msg);
	if msg == 'reset' then
		f:ClearAllPoints()
		f:SetPoint("CENTER",-25,0)
		f:Show()
		show_player_speed = true
		g:ClearAllPoints()
		g:SetPoint("CENTER",25,0)
		g:Show()
		show_target_speed = true
	elseif msg == 'showplayer' then
		f:Show()
		show_player_speed = true
	elseif msg == 'hideplayer' then
		f:Hide()
		show_player_speed = false
	elseif msg == 'showtarget' then
		g:Show()
		show_target_speed = true
	elseif msg == 'hidetarget' then
		g:Hide()
		show_target_speed = false
	else
		print("/speed reset to center the frames.")
		print("/speed showplayer/hideplayer to show or hide player speed.")
		print("/speed showtarget/hidetarget to show or hide target speed.")
	end
end
SlashCmdList["SPEED"] = handler;
