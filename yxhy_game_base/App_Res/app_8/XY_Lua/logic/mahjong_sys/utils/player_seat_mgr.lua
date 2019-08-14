--[[--
 * @Description: 处理本地座位号转换，校验
 * @Author:      --
 * @FileName:    player_seat_mgr.lua
 * @DateTime:    2017-06-19 16:13:09
 ]]

require "logic/mahjong_sys/_model/roomdata_center"
player_seat_mgr = {}
local this = player_seat_mgr

local myLocalSeat = nil
local myServerSeatId = nil 

function this.Init()
	
end

function this.SetMyLocalSeat(localSeat)
	myLocalSeat = localSeat
end

function this.GetMyLocalSeat()
	return myLocalSeat or 1
end

function this.SetMyServerSeatId(serverSeatId)
	myServerSeatId = serverSeatId
end

--[[--
 * @Description: 获取自己的逻辑（服务器）座位号，不带p  
 ]]
function this.GetMyLogicSeat()
	return myServerSeatId
end

--[[--
 * @Description: 获取去掉p的逻辑（服务器）座位号
 ]]
function this.GetLogicSeatByStr(seatStr)
	if seatStr == nil or seatStr == "" then
		return 1
	end
	local LogicSeat  = string.sub(seatStr, 2)
	LogicSeat = tonumber(LogicSeat)
	return LogicSeat
end

--[[--
 * @Description: 通过逻辑座位号字符，获取视图（本地）座位号
 ]]
function this.GetViewSeatByLogicSeat(seatStr)
	local viewSeat 
	local logicSeatNum = this.GetLogicSeatByStr(seatStr)
	viewSeat = this.GetViewSeatByLogicSeatNum(logicSeatNum)
	return viewSeat
end

--[[--
 * @Description: 通过逻辑座位号数字，获取视图（本地）座位号  
 ]]
function this.GetViewSeatByLogicSeatNum(seatId)
	local svrSeatId = this.GetMyLogicSeat()
	if not svrSeatId or svrSeatId == -1 then
		return seatId
	end
	local myLocalSeat = this.GetMyLocalSeat()
	local maxCount = roomdata_center.GetCurPlayerMaxCount()
	seatId = seatId or -1
	local localSeat = ((seatId - svrSeatId) % maxCount + myLocalSeat) % maxCount
	if localSeat == 0 then
		localSeat = maxCount
	end
	return localSeat
end

--[[--
 * @Description: 通过视图座位号数字，获取逻辑（服务器）座位号数字    
 ]]
function this.GetLogicSeatNumByViewSeat(localSeat)
	local svrSeatId = this.GetMyLogicSeat()
	if not svrSeatId or svrSeatId == -1 then
		return localSeat
	end
	local myLocalSeat = this.GetMyLocalSeat()
	local maxCount = roomdata_center.GetCurPlayerMaxCount()
	localSeat = localSeat or -1
	local seatId = (localSeat - myLocalSeat + svrSeatId ) % maxCount
	if seatId == 0 then
		seatId = maxCount
	end
	return seatId
end

-- function this.IsSeatLeagl(localSeat)
-- 	if type(localSeat) ~= "number" then
-- 		return false
-- 	end
-- 	local maxCount = roomdata_center.GetCurPlayerMaxCount()
-- 	if localSeat >=1 and localSeat <= maxCount then
-- 		return true
-- 	end
-- 	return false
-- end

function this.GetNexSeat(localSeat)
	local curSeat = localSeat + 1
	local maxCount = roomdata_center.GetCurPlayerMaxCount()
	if curSeat > maxCount then
		return 1
	end
	return curSeat
end

function this.GetPreviousSeat(localSeat)
	local curSeat = localSeat - 1
	if curSeat <=0 then
		return roomdata_center.GetCurPlayerMaxCount()
	end
	return curSeat
end

-- function this.IsMySelf(uId)
-- 	if uId == uid then
-- 		return true
-- 	end
-- 	return false
-- end