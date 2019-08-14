-- 莆田麻将小结算
local base = require "logic.mahjong_sys.action.game_18/ui_action/mahjong_action_small_reward_18"
local mahjong_action_small_reward_44 = class("mahjong_action_small_reward_44", base)

function mahjong_action_small_reward_44:GetTitleInfo(data,win_type,win_viewSeat,byFanType,byFanNumber,byCount)
 	data.isWinBG = true
 	data.winViewSeat = win_viewSeat
 	if win_type == "huangpai" then
 		data.isHuang = true
		data.titleIndex = self.cfg.huangArtId
		data.isWinBG = false
	else
		if byFanType>0 then
			data.titleIndex = byFanType
			data.number = byFanNumber * byCount
		else
 			if win_type == "gunwin" then
				data.titleIndex = 0
			elseif win_type == "robgoldwin" then
				data.titleIndex = 31
				data.number = 2
			else
				data.titleIndex = 18
				data.number = 2
			end
		end
	end
	return data
end

function mahjong_action_small_reward_44:GetPlayerMoreInfo(playerInfo,rewards,win_type,win_viewSeat,viewSeat,isBanker)
	playerInfo.difen = "1底"
	playerInfo.scoreItem = self:GetScoreItem(rewards,win_type,win_viewSeat,viewSeat)
	if rewards.flowerFan > 0 and IsTblIncludeValue(viewSeat,win_viewSeat) then
		playerInfo.specialFlower = {37,rewards.flowerFan}
	end
 	return playerInfo
end

function mahjong_action_small_reward_44:GetScoreItem(rewards,win_type,win_viewSeat,viewSeat)
	local scoreItem = {}

 	if rewards.hu_score ~= 0 then
 		local item4 = {}
 		item4.des = "胡牌"
 		item4.num = ""..rewards.hu_score.."分"
 		table.insert(scoreItem,item4)
 	end

 	if rewards.laizi_count and rewards.laizi_count > 0 then
 		local item3 = {}
 		item3.des = "金牌"
 		item3.num = ""..rewards.laizi_count.."分"
 		table.insert(scoreItem,item3)
 	end

 	if rewards.nWinGangFan and rewards.nWinGangFan~=0 then
 		local item3 = {}
 		item3.des = "杠牌"
 		item3.num = ""..rewards.nWinGangFan.."分"
 		table.insert(scoreItem,item3)
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

return mahjong_action_small_reward_44