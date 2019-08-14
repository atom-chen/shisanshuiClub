-- 最后一圈牌

local base = require "logic.mahjong_sys.action.common.mahjong_action_base"
local mahjong_action_lastLap = class("mahjong_action_lastLap", base)



function mahjong_action_lastLap:Execute(tbl)
	local leftNum = tbl._para.leftNum
	--logWarning(leftNum)

	local obj = mahjong_ui:ShowUIAnimationById(20016,2)
	if obj and leftNum then
		local zhangshu_sp = subComponentGet(obj.transform,"Effect_zhuihouxzhnag(Clone)/zhihouyiqian/shuzhi","UISprite")
		if zhangshu_sp then
			zhangshu_sp.spriteName = "number_2"..leftNum
		end
	end

end

return mahjong_action_lastLap