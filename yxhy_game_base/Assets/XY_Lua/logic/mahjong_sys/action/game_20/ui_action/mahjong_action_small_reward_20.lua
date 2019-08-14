-- 泉州麻将小结算
local base = require "logic.mahjong_sys.action.game_18/ui_action/mahjong_action_small_reward_18"
local mahjong_action_small_reward_20 = class("mahjong_action_small_reward_20", base)

function mahjong_action_small_reward_20:GetTitleInfo(data,win_type,win_viewSeat,byFanType,byFanNumber)
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
			else
				data.titleIndex = 18
				data.number = 2
			end
		end
	end
	return data
end

function mahjong_action_small_reward_20:GetPlayerMoreInfo(playerInfo,rewards,win_type,win_viewSeat,viewSeat,isBanker)
 	playerInfo.difen = self:GetDiFen(rewards,isBanker).."底"
 	playerInfo.pan = self:GetTotalPan(rewards).."盘"

	playerInfo.scoreItem = self:GetScoreItem(rewards,win_type,win_viewSeat,viewSeat)
 	return playerInfo
end

function mahjong_action_small_reward_20:GetDiFen(rewards,isBanker)
	local fen = 0
 	if roomdata_center.bSupportKe then 
 		if isBanker then
 			fen = fen + 10
 		else
 			fen = fen + 5
 		end
 	else
 		if isBanker then
 			fen = fen + 2
 		else
 			fen = fen + 1
 		end
 	end
 	if rewards.lianZhuangFan>0 then
		local point = 1
		if roomdata_center.bSupportKe then
			point = 5
		end
		fen = fen + rewards.lianZhuangFan*point
 	end
 	return fen
end

function mahjong_action_small_reward_20:GetTotalPan(rewards)
 	local pan = 0
 	if rewards.laizi_count>0 or 
 		rewards.flowerFan>0 or 
 		rewards.nWinTripleNum>0 or 
 		rewards.nWinXuKeZi>0 or 
 		rewards.nWinZiKeZi>0 or 
 		rewards.nWinGangFan>0 or
 		rewards.nflower_flag_cxqd>0 or
 		rewards.nflower_flag_mlzj>0 then

 		if rewards.laizi_count>0 then
 			pan = pan + rewards.laizi_count
 		end
 		if rewards.flowerFan>0 and roomdata_center.bSupportKe then
 			pan = pan + rewards.flowerFan
 		end
 		if rewards.nWinTripleNum>0 and roomdata_center.bSupportKe then
 			pan = pan + rewards.nWinTripleNum
 		end
 		if rewards.nWinXuKeZi>0 and roomdata_center.bSupportKe then
 			pan = pan + rewards.nWinXuKeZi
 		end
 		if rewards.nWinZiKeZi>0 and roomdata_center.bSupportKe then
 			pan = pan + rewards.nWinZiKeZi * 2
 		end
 		if rewards.nWinGangFan>0 then
 			pan = pan + rewards.nWinGangFan
 		end
 		if rewards.nflower_flag_cxqd and 
 		 rewards.nflower_flag_cxqd>0 and not roomdata_center.bSupportKe then
 			pan = pan + rewards.nflower_flag_cxqd
 		end
 		if rewards.nflower_flag_mlzj and 
 		 rewards.nflower_flag_mlzj>0 and not roomdata_center.bSupportKe then
 			pan = pan + rewards.nflower_flag_mlzj
 		end
 	end
 	return pan
end

function mahjong_action_small_reward_20:GetScoreItem(rewards,win_type,win_viewSeat,viewSeat)
	local scoreItem = {}

	if rewards.laizi_count > 0 then
 		local item3 = {}
 		item3.des = "金牌"
 		item3.num = ""..rewards.laizi_count.."盘"
 		table.insert(scoreItem,item3)
 	end

 	if roomdata_center.bSupportKe and rewards.flowerFan > 0 then
 		local item4 = {}
 		item4.des = "花牌"
 		item4.num = ""..rewards.flowerFan.."盘"
 		table.insert(scoreItem,item4)
 	end

 	if roomdata_center.bSupportKe and rewards.nWinTripleNum > 0 then
 		local item5 = {}
 		item5.des = "碰牌"
 		item5.num = ""..rewards.nWinTripleNum.."盘"
 		table.insert(scoreItem,item5)
 	end

 	if roomdata_center.bSupportKe and rewards.nWinXuKeZi > 0 then
 		local item6 = {}
 		item6.des = "序数"
 		item6.num = ""..rewards.nWinXuKeZi.."盘"
 		table.insert(scoreItem,item6)
 	end

 	if roomdata_center.bSupportKe and rewards.nWinZiKeZi > 0 then
 		local item7 = {}
 		item7.des = "字牌"
 		item7.num = ""..(rewards.nWinZiKeZi * 2).."盘"
 		table.insert(scoreItem,item7)
 	end

 	if rewards.nWinGangFan > 0 then
 		local item8 = {}
 		item8.des = "杠牌"
 		item8.num = ""..rewards.nWinGangFan.."盘"
 		table.insert(scoreItem,item8)
 	end

 	if not roomdata_center.bSupportKe and rewards.nflower_flag_cxqd and rewards.nflower_flag_cxqd > 0 then
 		local item9 = {}
 		item9.des = "春夏秋冬"
 		item9.num = ""..rewards.nflower_flag_cxqd.."盘"
 		table.insert(scoreItem,item9)
 	end

 	if not roomdata_center.bSupportKe and rewards.nflower_flag_mlzj and rewards.nflower_flag_mlzj > 0 then
 		local item10 = {}
 		item10.des = "梅兰竹菊"
 		item10.num = ""..rewards.nflower_flag_mlzj.."盘"
 		table.insert(scoreItem,item10)
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

return mahjong_action_small_reward_20