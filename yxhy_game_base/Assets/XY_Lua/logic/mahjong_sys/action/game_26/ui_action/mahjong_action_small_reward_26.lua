-- 漳州麻将小结算
local base = require "logic.mahjong_sys.action.game_25/ui_action/mahjong_action_small_reward_25"
local mahjong_action_small_reward_26 = class("mahjong_action_small_reward_26", base)

function mahjong_action_small_reward_26:GetPlayerMoreInfo(playerInfo,rewards,win_type,win_viewSeat,viewSeat,isBanker)
 	playerInfo.difen = self:GetDiFen(rewards,isBanker).."底"
	playerInfo.pan = self:GetTotalPan(rewards).."分"

	playerInfo.scoreItem = self:GetScoreItem(rewards,win_type,win_viewSeat,viewSeat)
 	return playerInfo
end

function mahjong_action_small_reward_26:GetDiFen(rewards,isBanker)
	local fen = 0
	if isBanker then
		fen = 6
	else
		fen = 5
	end

 	if rewards.lianZhuangFan>0 then
		fen = fen + rewards.lianZhuangFan
 	end
 	return fen
end

function mahjong_action_small_reward_26:GetTotalPan(rewards)
	local pan = 0
 	if rewards.flowerFan>=4 or rewards.nWinGangFan>0 then
 		if rewards.flowerFan>=4 and roomdata_center.bSupportKe then
 			pan = pan + rewards.flowerFan -3
 		end
 		if rewards.nWinGangFan>0 then
 			pan = pan + rewards.nWinGangFan
 		end
 	end
 	if rewards.follow_score then
 		pan = pan + tonumber(rewards.follow_score)
 	end
 	return pan
end

function mahjong_action_small_reward_26:GetScoreItem(rewards,win_type,win_viewSeat,viewSeat)
	local scoreItem = {}

 	if roomdata_center.bSupportKe and rewards.flowerFan >=4 then
 		local item4 = {}
 		item4.des = "花分"
 		item4.num = ""..(rewards.flowerFan - 3).."分"
 		table.insert(scoreItem,item4)
 	end

 	if rewards.nWinGangFan > 0 then
 		local item8 = {}
 		item8.des = "杠分"
 		item8.num = ""..rewards.nWinGangFan.."分"
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

return mahjong_action_small_reward_26