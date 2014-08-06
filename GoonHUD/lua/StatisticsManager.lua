
CloneClass( StatisticsManager )

function StatisticsManager.publish_to_steam(this, session, success)

	local success, err = pcall(function()

	local session_time_seconds = Application:time() - this._start_session_time
	local session_time_minutes = session_time_seconds / 60
	local session_time = session_time_minutes / 60
	if session_time_seconds == 0 or session_time_minutes == 0 or session_time == 0 then
		return
	end

	local level_list, job_list, mask_list, weapon_list = this:_get_stat_tables()
	local stats = {}
	this._global.play_time.minutes = math.ceil(this._global.play_time.minutes + session_time_minutes)
	local current_time = math.floor(this._global.play_time.minutes / 60)
	local time_found = false
	local play_times = {
		1000,
		500,
		250,
		200,
		150,
		100,
		80,
		40,
		20,
		10,
		0
	}

	for play_time_index, play_time in ipairs(play_times) do

		if not time_found and current_time >= play_time then
			stats["player_time_" .. play_time .. "h"] = {
				type = "int",
				method = "set",
				value = 1
			}
			time_found = true
		else
			stats["player_time_" .. play_time .. "h"] = {
				type = "int",
				method = "set",
				value = 0
			}
		end

	end

	local current_level = managers.experience:current_level()
	stats.player_level = {
		type = "int",
		method = "set",
		value = current_level
	}

	for i = 0, 100, 10 do
		stats["player_level_" .. i] = {
			type = "int",
			method = "set",
			value = 0
		}
	end

	local level_range = current_level >= 100 and 100 or math.floor(current_level / 10) * 10
	stats["player_level_" .. level_range] = {
		type = "int",
		method = "set",
		value = 1
	}

	local current_rank = managers.experience:current_rank()
	local current_rank_range = current_rank > 5 and 5 or current_rank

	for i = 0, 5 do
		stats["player_rank_" .. i] = {
			type = "int",
			method = "set",
			value = 0
		}
	end

	stats["player_rank_" .. current_rank_range] = {
		type = "int",
		method = "set",
		value = 1
	}

	local current_cash = managers.money:offshore()
	local cash_found = false
	local cash_amount = 1000000000
	current_cash = current_cash / 1000

	for i = 0, 9 do

		if not cash_found and cash_amount <= current_cash then
			stats["player_cash_" .. cash_amount .. "k"] = {
				type = "int",
				method = "set",
				value = 1
			}
			cash_found = true
		else
			stats["player_cash_" .. cash_amount .. "k"] = {
				type = "int",
				method = "set",
				value = 0
			}
		end

		cash_amount = cash_amount / 10
	end

	stats.player_cash_0k = {
		type = "int",
		method = "set",
		value = cash_found and 0 or 1
	}

	for weapon_name, weapon_data in pairs(session.shots_by_weapon) do

		if 0 < weapon_data.total then

			for k, weapon in pairs(weapon_list) do

				if weapon_name == weapon then
					stats["weapon_used_" .. weapon_name] = {type = "int", value = 1}
				end

			end

		end

	end

	stats.gadget_used_ammo_bag = {
		type = "int",
		value = session.misc.deploy_ammo or 0
	}
	stats.gadget_used_doctor_bag = {
		type = "int",
		value = session.misc.deploy_medic or 0
	}
	stats.gadget_used_trip_mine = {
		type = "int",
		value = session.misc.deploy_trip or 0
	}
	stats.gadget_used_sentry_gun = {
		type = "int",
		value = session.misc.deploy_sentry or 0
	}
	stats.gadget_used_ecm_jammer = {
		type = "int",
		value = session.misc.deploy_jammer or 0
	}

	local mask_id = managers.blackmarket:equipped_mask().mask_id
	for k, mask in ipairs(mask_list) do

		if mask_id == mask then
			stats["mask_used_" .. mask_id] = {type = "int", value = 1}
		end

	end

	stats["difficulty_" .. Global.game_settings.difficulty] = {type = "int", value = 1}
	stats.heist_success = {
		type = "int",
		value = success and 1 or 0
	}
	stats.heist_failed = {
		type = "int",
		value = success and 0 or 1
	}

	local level_id = managers.job:current_level_id()
	for k, level in ipairs(level_list) do
		if level_id == level then
			stats["level_" .. level_id] = {type = "int", value = 1}
		end
	end

	local job_id = managers.job:current_job_id()
	for k, job in ipairs(job_list) do
		if job_id == job then
			stats["job_" .. job_id] = {type = "int", value = 1}
		end
	end

	if level_id == "election_day_2" then
		local stealth = managers.groupai and managers.groupai:state():whisper_mode()
		Print("[StatisticsManager]: Election Day 2 Voting: " .. (stealth and "Swing Vote" or "Delayed Vote"))
		stats["stats_election_day_" .. (stealth and "s" or "n")] = {type = "int", value = 1}
	end

	managers.network.account:publish_statistics(stats)

	end)

	if not success then
		Print("ERROR")
		Print(err)
	end

end

function StatisticsManager.publish_skills_to_steam(this)

	local stats = {}
	local skill_amount = {}
	local skill_data = tweak_data.skilltree.trees

	for tree_index, tree in ipairs(skill_data) do

		skill_amount[tree_index] = 0

		for tier_index, tier in ipairs(tree.tiers) do

			for skill_index, skill in ipairs(tier) do

				local skill_points = managers.skilltree:next_skill_step(skill)
				local skill_bought = skill_points > 1 and 1 or 0
				local skill_aced = skill_points > 2 and 1 or 0

				stats["skill_" .. tree.skill .. "_" .. skill] = {
					type = "int",
					method = "set",
					value = skill_bought
				}

				stats["skill_" .. tree.skill .. "_" .. skill .. "_ace"] = {
					type = "int",
					method = "set",
					value = skill_aced
				}

				skill_amount[tree_index] = skill_amount[tree_index] + skill_bought + skill_aced

			end

		end

	end

	for tree_index, tree in ipairs(skill_data) do

		stats["skill_" .. tree.skill] = {
			type = "int",
			method = "set",
			value = skill_amount[tree_index]
		}

		for i = 0, 35, 5 do
			stats["skill_" .. tree.skill .. "_" .. i] = {
				type = "int",
				method = "set",
				value = 0
			}
		end

		local skill_count = math.ceil(skill_amount[tree_index] / 5) * 5
		if skill_count > 35 then
			skill_count = 35
		end

		stats["skill_" .. tree.skill .. "_" .. skill_count] = {
			type = "int",
			method = "set",
			value = 1
		}

	end

	if GoonHUD.Options.Stats.SpoofStats then
		for k, v in pairs(stats) do
			v.value = 0
		end
	end

	managers.network.account:publish_statistics(stats)

end