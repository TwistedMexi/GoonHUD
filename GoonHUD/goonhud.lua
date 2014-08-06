
if not RequiredScript then return end

local scriptsToLoad = {
	"CustomWaypoints.lua",
}

local requiredScriptsToLoad = {

	["core/lib/setups/coresetup"] = "CoreSetup.lua",
	["lib/managers/chatmanager"] = "ChatManager.lua",
	["lib/managers/enemymanager"] = "EnemyManager.lua",
	["lib/managers/menumanager"] = "MenuManager.lua",
	["lib/managers/localizationmanager"] = "LocalizationManager.lua",
	["lib/units/weapons/grenades/quicksmokegrenade"] = "QuickSmokeGrenade.lua",
	["lib/tweak_data/skilltreetweakdata"] = "SkillTreeTweak.lua",
	["lib/managers/hud/hudsuspicion"] = "HUDSuspicion.lua",
	["lib/managers/hud/hudteammate"] = "HUDTeammate.lua",
	["lib/managers/hudmanager"] = "HUDManager.lua",
	["lib/units/enemies/cop/logics/coplogictravel"] = "CopLogic.lua",
	["lib/tweak_data/charactertweakdata"] = "CharacterTweakData.lua",
	["lib/managers/statisticsmanager"] = "StatisticsManager.lua",

	["lib/units/civilians/civiliandamage"] = "CivilianDamage.lua",
	["lib/managers/trademanager"] = "TradeManager.lua",
	["lib/managers/hintmanager"] = "HintManager.lua",
	["lib/managers/playermanager"] = "PlayerManager.lua",
	["lib/managers/hud/hudstageendscreen"] = "HUDStageEndScreen.lua",
	["lib/units/beings/player/playerdamage"] = "PlayerDamage.lua",
	["lib/managers/hud/hudblackscreen"] = "HUDBlackScreen.lua",
	["lib/managers/hud/hudmissionbriefing"] = "HUDMissionBriefing.lua",
	["lib/managers/hud/hudplayercustody"] = "HUDPlayerCustody.lua",
	["lib/network/handlers/connectionnetworkhandler"] = "ConnectionNetworkHandler.lua",
	["lib/managers/menu/contractboxgui"] = "ContractBoxGUI.lua",

}

-- HUD
if not _G.GoonHUD then
	_G.GoonHUD = {}
	_G.GoonHUD.Version = "0.02"
	_G.GoonHUD.LuaPath = "GoonHud/lua/"
	_G.GoonHUD.SafeMode = true
end

-- Load Utils
if not _G.GoonHUD.UtilsLoaded then
	dofile( "GoonHud/util.lua" )
end

if not _G.Print then
	function _G.Print(args)
		io.stderr:write( tostring(args) .. "\n" )
	end
end

if not _G.CloneClass then
	function _G.CloneClass(class)
		if not class.orig then
			class.orig = clone(class)
		end
	end
end

if not _G.PrintTable then
	function _G.PrintTable (tbl, cmp)
	    cmp = cmp or {}
	    if type(tbl) == "table" then
	        for k, v in pairs (tbl) do
	            if type(v) == "table" and not cmp[v] then
	                cmp[v] = true
	                Print( string.format("[\"%s\"] -> table", tostring(k)) );
	                PrintTable (v, cmp)
	            else
	                Print( string.format("\"%s\" -> %s", tostring(k), tostring(v)) )
	            end
	        end
	    else Print(tbl) end
	end
end

if not _G.SaveTable then
	function _G.SaveTable(tbl, cmp, fileName, fileIsOpen, preText)

		local file = nil
		if fileIsOpen == nil then
			file = io.open(fileName, "w")
		else
			file = fileIsOpen
		end

		cmp = cmp or {}
	    if type(tbl) == "table" then
	        for k, v in pairs(tbl) do
	            if type(v) == "table" and not cmp[v] then
	                cmp[v] = true
	                file:write( preText .. string.format("[\"%s\"] -> table", tostring (k)) .. "\n" )
	                SaveTable(v, cmp, fileName, file, preText .. "\t")
	            else
	                file:write( preText .. string.format( "\"%s\" -> %s", tostring(k), tostring(v) ) .. "\n" )
	            end
	        end
	    else
	    	file:write( preText .. tbl .. "\n")
	    end

	    if fileIsOpen == nil then
	    	file:close()
	    end

	end
end

if not _G.SafeDoFile then

	function _G.SafeDoFile( fileName )

		if _G.GoonHUD.SafeMode then
		
			local success, errorMsg = pcall(function() dofile( fileName ) end)
			if not success then
				Print("[Error]\nFile: " .. fileName .. "\n" .. errorMsg)
			end

		else
			dofile(fileName)
		end

	end

end

-- Hooks
if not _G.GoonHUD.Hook then
	_G.GoonHUD.Hooks = {}
end
if not _G.Hooks then

	_G.Hooks = GoonHUD.Hooks

	function Hooks:RegisterHook( key )
		self[key] = self[key] or {}
	end

	function Hooks:Add( key, id, func )
		self[key] = self[key] or {}
		self[key][id] = func
	end

	function Hooks:Remove( id )

		for k, v in pairs(self) do
			if v[id] ~= nil then
				v[id] = nil
			end
		end

	end

	function Hooks:Call( key, ... )

		if self[key] ~= nil then
			for k, v in pairs(self[key]) do
				if v ~= nil and type(v) == "function" then
					v( ... )
				end
			end
		end

	end

	function Hooks:PCall( key, ... )

		if self[key] ~= nil then
			for k, v in pairs(self[key]) do
				if v ~= nil and type(v) == "function" then
					local args = ...
					local success, err = pcall( function() v( args ) end )
					if not success then
						Print("[Error]\nHook: " .. k .. "\n" .. err)
					end
				end
			end
		end

	end

end

-- Load Options
if not _G.GoonHUD.Options then 
	dofile( "GoonHud/options.lua" )
end

-- Load Localization
if not _G.GoonHUD.Localization then
	dofile( "GoonHud/localization.lua" )
end

-- Load Ironman Mode
if not _G.GoonHUD.Ironman then 
	dofile( "GoonHud/ironman.lua" )
end

-- Network Helper
if not _G.GoonHUD.Network then

	_G.GoonHUD.Network = {}

	function _G.GoonHUD.Network:IsMultiplayer()
		return Network
	end

	function _G.GoonHUD.Network:IsHost()
		if not Network then
			return false
		end
		return not Network:is_client()
	end

	function _G.GoonHUD.Network:IsClient()
		if not Network then
			return false
		end
		return Network:is_client()
	end

end

-- Load Post Require Scripts
local path = _G.GoonHUD.LuaPath
local requiredScript = RequiredScript:lower()
if requiredScriptsToLoad[requiredScript] then
	
	if type( requiredScriptsToLoad[requiredScript] ) == "table" then
		for k, v in pairs( requiredScriptsToLoad[requiredScript] ) do
			SafeDoFile( path .. v )
		end
	else
		SafeDoFile( path .. requiredScriptsToLoad[requiredScript] )
	end

end

-- Load Scripts
if not _G.GoonHUD.HasLoadedScripts then

	for k, v in pairs( scriptsToLoad ) do
		SafeDoFile( path .. v )
	end

	_G.GoonHUD.HasLoadedScripts = true

end
