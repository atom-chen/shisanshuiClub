--[[--
 * @Description: 房间数据  
 ]]
local gameRoom_data = {
	-- 房间固定设置
	chairid = 0, -- 房间id
	rid = 0, -- rid
	gid = 0, -- gid
	roomnumber = 0, -- 房号
	maxplayernum = 0, -- 几人桌
	gamesetting = {}, -- 游戏规则
	timersetting = {}, -- 倒计时配置
	gameRuleStr = "", -- 游戏规则串
	nJuNum = 0, -- 总局数
	nMoneyMode = 0, -- 2为金币场，11为房卡
	ownerId = 0, -- 房主id
	ownerLogicSeat = 0, -- 房主服务器座位号
	bSupportKe = false, -- 是否打课模式

	-- 房间运行时
	nCurrJu = 0, -- 当前局数
	isSelfVote = false, -- 是否解散
	isRoundStart = false, -- 是否开始标志
	keEnd = false, -- 打课模式下，结束标志
}

function gameRoom_data:New(o)
	local o = o or {}
	setmetatable(o,{__index = self})
	return o
end

return gameRoom_data