
_G.GoonHUD.Ironman = _G.GoonHUD.Ironman or {}
local Ironman = _G.GoonHUD.Ironman

Ironman.HiddenChannel = 4
Ironman.EnableKey = "IME"
Ironman.DisableKey = "IMD"
Ironman.ClientEnable = false

function Ironman:SetEnabled(enabled)

	if managers.menu_component._contract_gui ~= nil then
		managers.menu_component._contract_gui:refresh()
	end

	if GoonHUD.Network:IsMultiplayer() and GoonHUD.Network:IsHost() then

		if enabled then
			Ironman:SendClientActivationMessage()
		else
			Ironman:SendClientDeactivationMessage()
		end

	end

end

function Ironman:IsEnabled()
	if GoonHUD.Network:IsClient() then
		return self.ClientEnable
	end
	return GoonHUD.Options.Ironman.Enabled
end

function Ironman:PlayerShouldDie(playerDamage)
	if playerDamage._ironman_has_been_downed ~= nil then
		return true
	end
	return false
end

Hooks:Add("PlayerDamageOnDowned", "PlayerDamageOnDowned_Ironman", function(playerDamage)

	if playerDamage._ironman_has_been_downed == nil then
		playerDamage._ironman_has_been_downed = true
	end

	-- for k, ply in pairs( managers.player:players() ) do
	-- 	Print(k)
	-- 	PrintTable( ply )
	-- end

end)

Hooks:Add("PlayerDamageOnRegenerated", "PlayerDamageOnRegenerated_Ironman", function(playerDamage, no_messiah)
	playerDamage._ironman_has_been_downed = nil
end)

Hooks:Add("HUDManagerSetMugshotDowned", "HUDManagerSetMugshotDowned_Ironman", function(hudManager, mugshotId)
	-- local data = hudManager:_get_mugshot_data(mugshotId)
	-- PrintTable(data)
	-- CriminalsManager:character_unit_by_peer_id(peer_id)
end)

Hooks:Add( "ChatManagerOnReceiveMessage", "ChatManagerOnReceiveMessage_Ironman", function(channel_id, name, message, color, icon)
	if channel_id == Ironman.HiddenChannel then

		if message == Ironman.EnableKey then
			Ironman.ClientEnable = true
		end
		if message == Ironman.DisableKey then
			Ironman.ClientEnable = false
		end

		if managers.menu_component ~= nil then
			if managers.menu_component._contract_gui ~= nil then
				managers.menu_component._contract_gui:refresh()
			end
		end

	end

end)

Hooks:Add("HUDMissionBriefingInitialize", "HUDMissionBriefingInitialize_Ironman", function(this, hud, workspace)
	if GoonHUD.Network:IsClient() then
		Ironman.ClientEnable = false
	end
end)

Hooks:Add("HUDBlackScreenSetJobData", "HUDBlackScreenSetJobData_Ironman", function(self)
	if Ironman:IsEnabled() then
		Ironman:SendClientActivationMessage()
	else
		Ironman:SendClientDeactivationMessage()
	end
end)

function Ironman:SendClientActivationMessage()
	if ChatManager._receivers == nil then
		ChatManager._receivers = {}
	end
	ChatManager:send_message( Ironman.HiddenChannel, "", Ironman.EnableKey )
end

function Ironman:SendClientDeactivationMessage()
	if ChatManager._receivers == nil then
		ChatManager._receivers = {}
	end
	ChatManager:send_message( Ironman.HiddenChannel, "", Ironman.DisableKey )
end
