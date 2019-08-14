local base = require "logic.mahjong_sys.action.common.mahjong_action_base"
local mahjong_action_game_followBanker = class("mahjong_action_game_followBanker", base)


local game_followBanker_ui = nil

function mahjong_action_game_followBanker:Execute(tbl)
	Trace(GetTblData(tbl))
	local followNum = tbl._para.followNum

	if game_followBanker_ui == nil then
		game_followBanker_ui = require "logic/mahjong_sys/ui_mahjong/game/game_followBanker_ui"
	end

	if followNum and followNum > 0 then
		game_followBanker_ui.Show(followNum)
	end
end

return mahjong_action_game_followBanker