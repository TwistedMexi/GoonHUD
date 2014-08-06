
CloneClass( CharacterTweakData )

function CharacterTweakData.init(this, tweak_data)

	this.orig.init(this, tweak_data)

	this.presets.move_speed.lightning = {
		stand = {
			walk = {
				ntl = {
					fwd = 300,
					strafe = 240,
					bwd = 220
				},
				hos = {
					fwd = 570,
					strafe = 450,
					bwd = 430
				},
				cbt = {
					fwd = 570,
					strafe = 450,
					bwd = 430
				}
			},
			run = {
				hos = {
					fwd = 1600,
					strafe = 800,
					bwd = 700
				},
				cbt = {
					fwd = 1500,
					strafe = 760,
					bwd = 640
				}
			}
		},
		crouch = {
			walk = {
				hos = {
					fwd = 490,
					strafe = 420,
					bwd = 380
				},
				cbt = {
					fwd = 510,
					strafe = 380,
					bwd = 380
				}
			},
			run = {
				hos = {
					fwd = 840,
					strafe = 600,
					bwd = 500
				},
				cbt = {
					fwd = 824,
					strafe = 600,
					bwd = 560
				}
			}
		}
	}

	this.security.move_speed = this.presets.move_speed.lightning
	this.gensec.move_speed = this.presets.move_speed.lightning
	this.cop.move_speed = this.presets.move_speed.lightning
	this.fbi.move_speed = this.presets.move_speed.lightning
	this.swat.move_speed = this.presets.move_speed.lightning
	this.heavy_swat.move_speed = this.presets.move_speed.lightning
	this.fbi_swat.move_speed = this.presets.move_speed.lightning
	this.city_swat.move_speed = this.presets.move_speed.lightning
	this.gangster.move_speed = this.presets.move_speed.lightning
	this.biker_escape.move_speed = this.presets.move_speed.lightning
	this.tank.move_speed = this.presets.move_speed.lightning
	this.spooc.move_speed = this.presets.move_speed.lightning
	this.shield.move_speed = this.presets.move_speed.lightning
	this.taser.move_speed = this.presets.move_speed.lightning
	this.civilian.move_speed = this.presets.move_speed.lightning
	this.bank_manager.move_speed = this.presets.move_speed.lightning
	this.russian.move_speed = this.presets.move_speed.lightning
	this.german.move_speed = this.presets.move_speed.lightning
	this.spanish.move_speed = this.presets.move_speed.lightning
	this.american.move_speed = this.presets.move_speed.lightning

end