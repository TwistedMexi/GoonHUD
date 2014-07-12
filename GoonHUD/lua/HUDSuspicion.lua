
CloneClass( HUDSuspicion )

function HUDSuspicion.init(this, hud, sound_source)

	HUDSuspicion.orig.init(this, hud, sound_source)

	if not GoonHUD.Options.Suspicion.ShowPercentage then
		return
	end

	if GoonHUD.Options.Suspicion.ShowPercentageOutline then

		for i = 1, 4 do
			this["_suspicion_text_" .. i] = this._suspicion_panel:text({
				name = "suspicion_text_" .. i,
				visible = true,
				text = "100%",
				valign = "center",
				align = "center",
				layer = 2,
				color = Color.black:with_alpha(0.3),
				font = tweak_data.menu.pd2_large_font,
				font_size = 24,
				h = 64
			})
		end

	end

	this._suspicion_text = this._suspicion_panel:text({
		name = "suspicion_text",
		visible = true,
		text = "100%",
		valign = "center",
		align = "center",
		layer = 2,
		color = Color.white,
		font = tweak_data.menu.pd2_large_font,
		font_size = 24,
		h = 64
	})

	local posX, posY = 0, this._suspicion_panel:h() / 4
	this["_suspicion_text"]:set_x( posX )
	this["_suspicion_text"]:set_y( posY )

	if GoonHUD.Options.Suspicion.ShowPercentageOutline then

		this["_suspicion_text_1"]:set_x( posX - 1 )
		this["_suspicion_text_1"]:set_y( posY - 1 )
		this["_suspicion_text_2"]:set_x( posX + 1 )
		this["_suspicion_text_2"]:set_y( posY - 1 )
		this["_suspicion_text_3"]:set_x( posX - 1 )
		this["_suspicion_text_3"]:set_y( posY + 1 )
		this["_suspicion_text_4"]:set_x( posX + 1 )
		this["_suspicion_text_4"]:set_y( posY + 1 )

	end

end

function HUDSuspicion.animate_eye(this)

	this.orig.animate_eye(this)

	if not GoonHUD.Options.Suspicion.ShowPercentage then
		return
	end

	local lowDetectionColor = Color(0.105, 0.545, 0.749)
	local highDetectionColor = Color(1.000, 0.266, 0.059)
	local suspicionText = math.round(this._suspicion_value * 100) .. "%"
	if this._suspicion_value < 0.03 or this._discovered then
		suspicionText = ""
	end

	this["_suspicion_text"]:set_text( suspicionText )
	this["_suspicion_text"]:set_color( this._suspicion_value <= 0.5 and lowDetectionColor or highDetectionColor )
	if GoonHUD.Options.Suspicion.ShowPercentageOutline then
		for i = 1, 4 do
			this["_suspicion_text_" .. i]:set_text( suspicionText )
		end
	end

end
