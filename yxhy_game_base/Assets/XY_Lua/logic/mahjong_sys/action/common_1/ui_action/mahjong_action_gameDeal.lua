local base = require "logic.mahjong_sys.action.common.mahjong_action_base"
local mahjong_action_gameDeal = class("mahjong_action_gameDeal", base)



function mahjong_action_gameDeal:Execute(tbl)
	--Trace(GetTblData(tbl))
	mahjong_ui:HideOperTips()
	roomdata_center.SetRoomLeftCard(mode_manager.GetCurrentMode().config.MahjongTotalCount)
	roomdata_center.nCurrJu = tbl._para.subRound
	mahjong_ui:SetGameInfoVisible(true)
	mahjong_ui:SetRoundInfo(tbl._para.subRound, roomdata_center.nJuNum)
	--Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.GAME_SOCKET_GAME_DEAL)

end

return mahjong_action_gameDeal