-- 龙岩麻将小结算
local base = require "logic.mahjong_sys.action.game_25/ui_action/mahjong_action_small_reward_25"
local mahjong_action_small_reward_41 = class("mahjong_action_small_reward_41", base)

function mahjong_action_small_reward_41:GetTitleInfo(data,win_type,win_viewSeat,byFanType,byFanNumber)
 	data.isWinBG = true
 	data.winViewSeat = win_viewSeat
 	if win_type == "huangpai" then
 		data.isHuang = true
		data.titleIndex = self.cfg.huangArtId
		data.isWinBG = false
	else
		if byFanType>0 then
			data.titleIndex = byFanType
			data.number = byFanNumber
		else
 			if win_type == "gunwin" then
				data.titleIndex = 0
			elseif win_type == "robgoldwin" then
				data.titleIndex = 31
				data.number = 4
			else
				data.titleIndex = 18
				data.number = 2
			end
		end
	end
	return data
end

function mahjong_action_small_reward_41:GetPlayerMoreInfo(playerInfo,rewards,win_type,win_viewSeat,viewSeat,isBanker)
 	playerInfo.difen = self:GetDiFen(rewards,isBanker).."底"

	playerInfo.scoreItem = self:GetScoreItem(rewards,win_type,win_viewSeat,viewSeat)
 	return playerInfo
end

function mahjong_action_small_reward_41:GetDiFen(rewards,isBanker)
	local fen = 0
	local double = false
	if roomdata_center.gamesetting.bBankerDouble then
		double = true
	end
	if isBanker and double then
		fen = 2
	else
		fen = 1
	end

 	return fen
end

function mahjong_action_small_reward_41:GetScoreItem(rewards,win_type,win_viewSeat,viewSeat)
	local scoreItem = {}

	if rewards.hu_score ~= 0 then
 		local item4 = {}
 		item4.des = "胡牌"
 		item4.num = ""..rewards.hu_score.."分"
 		table.insert(scoreItem,item4)
 	end

 	if rewards.flower_score ~= 0 then
 		local item4 = {}
 		item4.des = "花杠"
 		item4.num = ""..rewards.flower_score.."分"
 		table.insert(scoreItem,item4)
 	end

 	if rewards.gangFan ~= 0 then
 		local item8 = {}
 		item8.des = "杠分"
 		item8.num = ""..rewards.gangFan.."分"
 		table.insert(scoreItem,item8)
 	end

 	if rewards.follow_score ~= 0 then
 		local item11 = {}
 		item11.des = "分饼"
 		item11.num = ""..rewards.follow_score.."分"
 		table.insert(scoreItem,item11)
 	end

 	if rewards.qingyise and rewards.qingyise==1 then
 		local item5 = {}
 		item5.des = "清一色"
 		item5.num = "2倍"
 		table.insert(scoreItem,item5)
 	end

 	if rewards.xiapao and rewards.xiapao > 0 then
 		local item5 = {}
 		item5.des = "下注"
 		item5.num = "+"..rewards.xiapao
 		table.insert(scoreItem,item5)
 	end
 	return scoreItem
end

return mahjong_action_small_reward_41