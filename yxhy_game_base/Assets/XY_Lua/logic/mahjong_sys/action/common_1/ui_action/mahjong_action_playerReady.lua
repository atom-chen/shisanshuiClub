local base = require "logic.mahjong_sys.action.common.mahjong_action_base"
local mahjong_action_playerReady = class("mahjong_action_playerReady", base)



function mahjong_action_playerReady:Execute(tbl)
	local logicSeat = tbl["_src"]
	local viewSeat = self.gvblFun(logicSeat)

	if viewSeat == 1 then
		mahjong_ui:ResetAll()
		mahjong_ui:SetReadyBtnVisible(false)

	end

	mahjong_ui:SetPlayerReady(viewSeat, true)
end

return mahjong_action_playerReady