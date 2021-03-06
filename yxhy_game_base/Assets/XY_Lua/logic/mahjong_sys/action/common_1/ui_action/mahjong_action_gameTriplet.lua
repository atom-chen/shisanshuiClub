local base = require "logic.mahjong_sys.action.common.mahjong_action_base"
local mahjong_action_gameTriplet = class("mahjong_action_gameTriplet", base)



function mahjong_action_gameTriplet:Execute(tbl)
	local operPlayViewSeat = self.gvblFun(tbl._src)
	if operPlayViewSeat ==1 then
		mahjong_ui:HideOperTips()
		--mahjong_ui:HideTingBackBtn()

		roomdata_center.CheckTingWhenGiveCard(-1)
		mahjong_ui.cardShowView:ShowHuBtn(roomdata_center.isTing)
	end

	mahjong_effectMgr:PlayUIEffectById(20002,mahjong_ui.playerList[operPlayViewSeat].operPos)
end

return mahjong_action_gameTriplet