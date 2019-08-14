-- 平潭麻将小结算
local base = require "logic.mahjong_sys.action.game_43/ui_action/mahjong_action_small_reward_43"
local mahjong_action_small_reward_64 = class("mahjong_action_small_reward_64", base)


function mahjong_action_small_reward_64:GetPlayerMoreInfo(playerInfo,rewards,win_type,win_viewSeat,viewSeat,isBanker)
 	playerInfo.difen = "1底"

	playerInfo.scoreItem = self:GetScoreItem(rewards,win_type,win_viewSeat,viewSeat)
 	return playerInfo
end

function mahjong_action_small_reward_64:GetScoreItem(rewards,win_type,win_viewSeat,viewSeat)
	local scoreItem = {}

	if rewards.win_info.nFanDetailInfo~=nil then
		for i,v in ipairs(rewards.win_info.nFanDetailInfo) do
 			if v.byFanType ~= 0 then
		 		if IsTblIncludeValue(viewSeat,win_viewSeat) then
					local item = {}
					if win_type == "gunwin" then
						item.des = "点炮"
					elseif win_type == "selfdraw" then
						item.des = "自摸"
					elseif win_type == "robgangwin" then
						item.des = "抢杠"
					else
						break
					end
				 	table.insert(scoreItem,item)
				end
				break
			end
		end

 		for i,v in ipairs(rewards.win_info.nFanDetailInfo) do
 			local item1 = {}
 			item1.des = ""
		 	item1.num = ""
 			if v.byFanType ~= 0 then
	 			item1.des = tostring(v.szFanName)
		 		item1.num = ""..v.byFanNumber.."分"
		 	else
		 		if win_type == "selfdraw" then
		 			item1.des = "自摸"
		 		elseif win_type == "gunwin" then
		 			item1.des = "点炮"
		 		elseif win_type == "robgangwin" then
		 			item1.des = "抢杠"
		 		else
		 			logError("未知win_type："..tostring(win_type))
		 		end
		 	end
	 		table.insert(scoreItem,item1)
 		end
 	end

	if rewards.lianZhuangFan>0 then
 		local item2 = {}
 		item2.des = "连庄"
 		item2.num = ""..rewards.lianZhuangFan.."次"
 		table.insert(scoreItem,item2)
 	end

 	if rewards.laizi_count > 0 and IsTblIncludeValue(viewSeat,win_viewSeat) then
 		local item3 = {}
 		item3.des = "金牌"
 		item3.num = ""..rewards.laizi_count.."分"
 		table.insert(scoreItem,item3)
 	end

 	if rewards.flowerFan > 0 and IsTblIncludeValue(viewSeat,win_viewSeat) then
 		local item4 = {}
 		item4.des = "花牌"
 		item4.num = ""..rewards.flowerFan.."分"
 		table.insert(scoreItem,item4)
 	end

 	if rewards.an_gang > 0 and IsTblIncludeValue(viewSeat,win_viewSeat) then
 		local item6 = {}
 		item6.des = "暗杠"
 		item6.num = ""..(rewards.an_gang*2).."分"
 		table.insert(scoreItem,item6)
 	end

 	if rewards.ming_gang > 0 and IsTblIncludeValue(viewSeat,win_viewSeat) then
 		local item7 = {}
 		item7.des = "明杠"
 		item7.num = ""..rewards.ming_gang.."分"
 		table.insert(scoreItem,item7)
 	end

 	if rewards.flower_gang > 0 and IsTblIncludeValue(viewSeat,win_viewSeat) then
 		local item7 = {}
 		item7.des = "花杠"
 		item7.num = ""..rewards.flower_gang.."分"
 		table.insert(scoreItem,item7)
 	end

 	if rewards.follow_score and rewards.follow_score ~= 0 then
 		local item11 = {}
 		item11.des = "分饼"
 		item11.num = ""..rewards.follow_score.."分"
 		table.insert(scoreItem,item11)
 	end

 	if rewards.xiapao and rewards.xiapao > 0 then
 		local item5 = {}
 		item5.des = "下注"
 		item5.num = "+"..rewards.xiapao
 		table.insert(scoreItem,item5)
 	end
 	return scoreItem
end

return mahjong_action_small_reward_64