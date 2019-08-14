local base = require "logic.mahjong_sys.action.common.mahjong_action_base"
local mahjong_action_gameTingType = class("mahjong_action_gameTingType", base)

function mahjong_action_gameTingType:Execute(tbl)
	 local tingType = tbl._para.tingType
	 local tingChair = tbl._para.tingChair
	 local handCard = tbl._para.handCard
	 local tingFlag = tbl._para.tingFlag
	 local operPlayViewSeat = self.gvblnFun(tingChair)

	 roomdata_center.tingPlayerSign[tingChair] = true

 	if tingChair == player_seat_mgr.GetMyLogicSeat() then
 		roomdata_center.tingType = tingType
    	roomdata_center.isTing=true
    	if tingFlag == nil or tingFlag == 1 then
	 		local player = self.compPlayerMgr:GetPlayer(1)
	    	self.compPlayerMgr.selfPlayer:SetDisableCardShow(self.cfg.showTingDisableCard)
	 		player:SetCanOut(false, self:GetFilterCards(player.handCardList))
	        if player:IsRoundSendCard(#player.handCardList) then 
	            if player.handCardList[#player.handCardList]~=nil  then   
	               player.handCardList[#player.handCardList]:SetDisable(false)     
	            end  
		 	end
		 end
	 else
	 	if self.cfg.tingTypeMap[tingType] and self.cfg.tingTypeMap[tingType][1] == "TingJinKan" then
	 		local operData = operatordata:New(MahjongOperAllEnum.TingJinKan,nil, handCard)
	 		self.compPlayerMgr:GetPlayer(operPlayViewSeat):OperateCard(operData)
	 	end
	end
	local aniId = 20004
	 if self.cfg.tingTypeMap[tingType] then
		aniId = self.cfg.tingTypeMap[tingType][2]
	end
	mahjong_ui:SetYoustatus(operPlayViewSeat,aniId)
end

function mahjong_action_gameTingType:GetFilterCards( handCardList )
	local filterCards = {}
    for _,v in ipairs(handCardList) do
    	table.insert(filterCards,v.paiValue)
    end
    return filterCards
end

return mahjong_action_gameTingType