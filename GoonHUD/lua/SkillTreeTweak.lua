
CloneClass( SkillTreeTweakData )

Hooks:RegisterHook( "SkillTreeTweakDataInitialize" )
function SkillTreeTweakData.init(this)
	SkillTreeTweakData.orig.init(this)
	Hooks:Call( "SkillTreeTweakDataInitialize", this )
end

Hooks:Add( "SkillTreeTweakDataInitialize", "SkillTreeTweakData_AddCustom", function( this )

	local digest = function(value)
		return Application:digest_value(value, true)
	end

	this.unlock_tree_cost = {
		digest(0),
		digest(0),
		digest(0),
		digest(0),
		digest(0)
	}

	this.skills.test_skill = {
		["name_id"] = "Skill_Test",
		["desc_id"] = "Skill_TestDesc",
		["icon_xy"] = {2, 9},
		[1] = {
			upgrades = {
			},
			cost = this.costs.default
		},
		[2] = {
			upgrades = {
			},
			cost = this.costs.default
		}
	}

	this.skills.custom = {
		["name_id"] = "Skill_Class",
		["desc_id"] = "Skill_ClassDesc",
		["icon_xy"] = {2, 7},
		[1] = {
			upgrades = {
			},
			cost = this.costs.unlock_tree,
			desc_id = "Skill_ClassTier1"
		},
		[2] = {
			upgrades = {
				"team_passive_stamina_multiplier_1"
			},
			desc_id = "menu_mastermind_tier_2"
		},
		[3] = {
			upgrades = {
				"player_passive_intimidate_range_mul"
			},
			desc_id = "menu_mastermind_tier_3"
		},
		[4] = {
			upgrades = {
				"team_passive_health_multiplier",
				"player_passive_convert_enemies_health_multiplier",
				"player_passive_convert_enemies_damage_multiplier"
			},
			desc_id = "menu_mastermind_tier_4"
		},
		[5] = {
			upgrades = {
				"player_convert_enemies_interaction_speed_multiplier"
			},
			desc_id = "menu_mastermind_tier_5"
		},
		[6] = {
			upgrades = {
				"player_passive_empowered_intimidation",
				"passive_player_assets_cost_multiplier"
			},
			desc_id = "menu_mastermind_tier_6"
		}
	}

	this.trees[5] = {
		name_id = "Skill_Class",
		skill = "custom",
		background_texture = "guis/textures/pd2/skilltree/bg_mastermind",
		tiers = {}
	}

	this.trees[5].tiers[1] = {
		"test_skill"
	}

end )
