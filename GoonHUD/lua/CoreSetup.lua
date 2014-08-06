
CloneClass( CoreSetup )

-- PrintTable( PackageManager.__index )

-- PackageManager:load("core/packages/base")
-- PackageManager:load("core/packages/editor")

-- Application.__index.ews_enabled = function() return true end
-- Application.__index.production_build = function() return true end
-- Application.__index.editor = function() return true end

function CoreSetup.__pre_init(this)
	this.orig.__pre_init(this)
	Print("Preinit")
end

function CoreSetup.__init(this)

	-- Application.__index.ews_enabled = function() return true end
	-- Application.__index.production_build = function() return true end
	-- Application.__index.editor = function() return true end
	
	-- local success, err = pcall(function()
	-- 	this.orig.__pre_init(this)
	-- end)
	-- if not success then
	-- 	Print("[Error] " .. err)
	-- end

	local success, err = pcall(function()
		-- this.orig.__init(this)
	end)
	if not success then
		Print("[Error] " .. err)
	end

	this.orig.__init(this)

end
