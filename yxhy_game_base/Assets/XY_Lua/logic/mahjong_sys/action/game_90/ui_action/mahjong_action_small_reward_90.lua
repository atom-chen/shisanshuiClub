-- 福安麻将小结算
local base = require "logic.mahjong_sys.action.game_25/ui_action/mahjong_action_small_reward_25"
local mahjong_action_small_reward_90 = class("mahjong_action_small_reward_90", base)

function mahjong_action_small_reward_90:GetTitleInfo(data,win_type,win_viewSeat)
	data.isWinBG = false
 	data.winViewSeat = win_viewSeat
 	if win_type == "huangpai" then
		data.titleIndex = self.cfg.huangArtId
		data.isHuang = true
	elseif IsTblIncludeValue(1,win_viewSeat) then
		data.titleIndex = 10001
		data.isWinBG = true
	else
		data.titleIndex = 10002
	end
	return data
end

function mahjong_action_small_reward_90:GetPlayerMoreInfo(playerInfo,rewards,win_type,win_viewSeat,viewSeat,isBanker)
 	playerInfo.pan = self:GetTotalPan(rewards,win_type,IsTblIncludeValue(viewSeat,win_viewSeat)).."分"

	playerInfo.scoreItem = self:GetScoreItem(rewards,win_type,win_viewSeat,viewSeat)
 	return playerInfo
end

function mahjong_action_small_reward_90:GetTotalPan(rewards,win_type,isWin)
	local pan = 0
 	if rewards.laizi_count>0 or
 		rewards.an_gang>0 or
 		rewards.ming_gang>0 or 
 		rewards.ming_gold_gang>0 or
 		rewards.an_gold_gang>0 then

 		if rewards.laizi_count>0 then
 			pan = pan + rewards.laizi_count
 		end

 		if rewards.an_gang>0 then
 			pan = pan + rewards.an_gang*2
 		end

 		if rewards.ming_gang>0 then
 			pan = pan + rewards.ming_gang
 		end

 		if rewards.ming_gold_gang>0 then
 			pan = pan + rewards.ming_gold_gang*200
 		end

 		if rewards.an_gold_gang>0 then
 			pan = pan + rewards.an_gold_gang *100
 		end
 	end

 	local double = 1
	if isWin and (win_type == "selfdraw" or win_type == "robgoldwin") then
		double = 2
	end

 	return pan*double
end

function mahjong_action_small_reward_90:GetScoreItem(rewards,win_type,win_viewSeat,viewSeat)
	local scoreItem = {}

	if rewards.win_info.nFanDetailInfo~=nil then
		if IsTblIncludeValue(viewSeat,win_viewSeat) then
			local item = {}
			if win_type == "selfdraw" then
				item.des = "自摸"
			 	table.insert(scoreItem,item)
			end

			for i,v in ipairs(rewards.win_info.nFanDetailInfo) do
	 			if v.byFanType ~= 0 then
	 				local item1 = {}
		 			item1.des = tostring(v.szFanName)
			 		item1.num = ""..v.byFanNumber.."分"
		 			table.insert(scoreItem,item1)
			 	end
	 		end
		end
 	end

 	if rewards.ping_hu and rewards.ping_hu>0 then
 		local item2 = {}
 		item2.des = "平胡"
 		item2.num = ""..rewards.ping_hu.."分"
 		table.insert(scoreItem,item2)
 	end

	if rewards.lianZhuangFan>0 then
 		local item2 = {}
 		item2.des = "连庄"
 		item2.num = ""..rewards.lianZhuangFan.."次"
 		table.insert(scoreItem,item2)
 	end

 	if rewards.laizi_count > 0 then
 		local item3 = {}
 		item3.des = "金牌"
 		item3.num = ""..rewards.laizi_count.."分"
 		table.insert(scoreItem,item3)
 	end

 	if rewards.an_gang > 0 then
 		local item6 = {}
 		item6.des = "暗杠"
 		item6.num = ""..(rewards.an_gang*2).."分"
 		table.insert(scoreItem,item6)
 	end

 	if rewards.ming_gang > 0 then
 		local item7 = {}
 		item7.des = "明杠"
 		item7.num = ""..rewards.ming_gang.."分"
 		table.insert(scoreItem,item7)
 	end

 	if rewards.ming_gold_gang > 0 then
 		local item8 = {}
 		item8.des = "明金杠"
 		item8.num = ""..(rewards.ming_gold_gang*200).."分"
 		table.insert(scoreItem,item8)
 	end

 	if rewards.an_gold_gang > 0 then
 		local item8 = {}
 		item8.des = "暗金杠"
 		item8.num = ""..(rewards.an_gold_gang*100).."分"
 		table.insert(scoreItem,item8)
 	end

 	if rewards.xiapao and rewards.xiapao > 0 then
 		local item5 = {}
 		item5.des = "下注"
 		item5.num = "+"..rewards.xiapao
 		table.insert(scoreItem,item5)
 	end
 	
 	return scoreItem
end

return mahjong_action_small_reward_90