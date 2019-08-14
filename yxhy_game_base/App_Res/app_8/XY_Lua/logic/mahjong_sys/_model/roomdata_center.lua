--[[--
 * @Description: 房间数据缓存中心
 * @Author:      ShushingWong
 * @FileName:    roomdata_center.lua
 * @DateTime:    2017-06-19 15:24:43
 ]]
require "logic/shisangshui_sys/card_data_manage"
roomdata_center = {}

local this = roomdata_center

this.chairid = 0--房间id
this.rid = 0    --rid
this.gid = 0    --gid
this.roomnumber = 0--房号
-- 几人桌
this.maxplayernum = 0 --最大人数
this.gamesetting = nil
this.timersetting = nil
this.ownerId = 0

this.gameRuleStr = "" --游戏规则串

-- 当前局数
this.nCurrJu = 0
-- 总局数
this.nJuNum = 0
this.nMoneyMode = 0

--庄位置
this.zhuang_viewSeat = 0

this.ownerLogicSeat = 0

this.leftCard = 144

this.isStart = false

-- 是否已经开始出牌
this.beginSendCard = false

-- 花牌
this.playerFlowerCards = {}

-- 出哪张排后可以听
this.hintInfoMap = nil
-- 听牌 和 胡的番数
this.currentTingInfo = nil

-- 是否是听得状态
this.isTing = false

-- 自己上一次出的牌 用于自动出牌的交验
this.selfOutCard = 0

this.isSelfVote = false

-- 是否已经开始一局
this.isRoundStart = false


this.gameCfg = nil

-- 是否支持客户端计算听
this.supportClientTing = false

-- 当前出牌玩家
this.currentPlayViewSeat = 0

this.mjMap = {}

this.tingVersion = 0

-- 牌数据中心
function this.AddMj(value, num)
  num = num or 1
  if this.mjMap[value] == nil then
      this.mjMap[value] = num
  else
      this.mjMap[value] = this.mjMap[value] + num
      if this.mjMap[value] > 4 then
        logError("this.mjMap[value] > 4", value)
        this.mjMap[value] = 4
      end
  end
end

function this.GetLeftMjCount(value)
  local count = this.mjMap[value]
  if count == nil then
    count = 0
  end
  local res = 4 - count
  if res < 0 then
    res = 0
  end
  return res
end




  -- "stTingCards": {
  --     {
  --       "give": 21,   --出哪张牌
  --       "flag": 0,    --0普通胡 1任意胡
  --       "win":{-- 和牌信息
  --         {"nCard":21, "nFan":10, "nLeft":2},
  --         {"nCard":22, "nFan":10, "nLeft":2},
  --         ... ---这里可以有多个
  --       }
  --     },
  --     {},
  --     .... ---这里可以有多个
  --   }

-- 特殊牌  金 混
this.specialCard = nil
-- 备用特殊牌
this.specialCard1 = nil



function this.SetSpecialCard(card)
  this.specialCard = card
end
-- 备用  防止双金
function this.SetSpecialCard1(card)
  this.specialCard1 = card
end

-- 返回 结果 如果需要可以添加是哪张特殊牌
function this.CheckIsSpecialCard(card)
  local res = this.specialCard == card
  return res , ""
end

-- givecard 做key
function this.SetHintInfoMap(tbl)
  this.hintInfoMap = {}
  local tingCards = tbl._para.stTingCards
  if tingCards == nil then
    return
  end
  for i = 1, #tingCards do
    this.hintInfoMap[tingCards[i]["give"]] = {tingCards[i].flag, tingCards[i].win} 
  end
end


-- 出牌后 检测打的牌 是否可以听
function this.CheckTingWhenGiveCard(giveCard)

  if this.hintInfoMap == nil then
    this.isTing = false
    return
  end
  if this.hintInfoMap[giveCard] == nil or giveCard == -1 then
    this.isTing = false
    this.currentTingInfo = nil
    this.hintInfoMap = nil
  else
    this.isTing = true
    this.currentTingInfo = this.hintInfoMap[giveCard]
    this.hintInfoMap = nil
  end
end

-- 检测出完这张牌后 是否可以听牌
function this.CheckCardTing(value)
  return this.hintInfoMap ~= nil and this.hintInfoMap[value] ~= nil
end

function  this.GetTingInfo(paiValue)
    return this.hintInfoMap and this.hintInfoMap[paiValue]
end


-- 开局是设置一次
function this.SetPlayerFlowersCards(viewSeat, cards)
  -- cards = cards or {}
  -- this.playerFlowerCards[viewSeat] = cards or {}
  if this.playerFlowerCards[viewSeat] == nil then
    this.playerFlowerCards[viewSeat] = cards 
  else   
    for i = 1, #cards do
      table.insert(this.playerFlowerCards[viewSeat], cards[i])
    end
  end
  Notifier.dispatchCmd(cmdName.MSG_UPDATE_PLAYER_HUA_CARD, {viewSeat, #this.playerFlowerCards[viewSeat]})
end

function this.GetAllFlowerCardsCount()
  local tab = {}
  for i = 1, this.MaxPlayer() do
    local logicSeat = player_seat_mgr.GetLogicSeatNumByViewSeat(i)
    local count = 0
    if this.playerFlowerCards[i] ~= nil then
      count = #this.playerFlowerCards[i]
    end
    tab[logicSeat] = count
  end
  for i = this.MaxPlayer() + 1, 4 do
    tab[i] = 0
  end
  return tab
end

function this.AddFlowerCard(viewSeat, card)
  table.insert(this.playerFlowerCards[viewSeat], card)
  Notifier.dispatchCmd(cmdName.MSG_UPDATE_PLAYER_HUA_CARD, {viewSeat, #this.playerFlowerCards[viewSeat]})
end

function this.AddFlowerCardToZhuang(card)
  if this.playerFlowerCards[this.zhuang_viewSeat] == nil then
    this.playerFlowerCards[this.zhuang_viewSeat] = {}
  end
  table.insert(this.playerFlowerCards[this.zhuang_viewSeat], card)
  Notifier.dispatchCmd(cmdName.MSG_UPDATE_PLAYER_HUA_CARD, {this.zhuang_viewSeat, #this.playerFlowerCards[this.zhuang_viewSeat]})
end

function this.GetFlowerCards(viewSeat)
  return this.playerFlowerCards[viewSeat] or {}
end


-- 更新房间剩余牌数
function this.UpdateRoomCard(delta)
  if this.leftCard + delta < 0 then
    return
  end
  this.SetRoomLeftCard(this.leftCard + delta)
end

--设置房间剩余牌数
function this.SetRoomLeftCard(num)
  this.leftCard = num
  Notifier.dispatchCmd(cmdName.MSG_UPDATE_ROOM_LEFT_CARD, num)
end


--[[--
 * @Description: 
  {"_cmd":"game_cfg","_para":{"CardPoolType":["char","bamboo","ball","wind","fabai"],
                              "GameSetting":{"bCounterLian":false,"bSupportCollect":false,"bSupportDealerAdd":true,"bSupportGangCi":false,"bSupportGangFlowAdd":true,"bSupportGangPao":true,"bSupportGunWin":true,"bSupportHiddenQuadruplet":true,"bSupportHun":true,"bSupportQuadruplet":true,"bSupportSevenDoubleAdd":true,"bSupportTing":false,"bSupportTriplet":true,"bSupportTriplet2Quadruplet":true,"bSupportWind":true,"bSupportXiaPao":true,"bTingCanPlayOther":true,"nTimeOutCountToAuto":-1},
                              "TimerSetting":{"AutoPlayTimeOut":2,"TimeOutLimit":-1,"XiaPaoTimeOut":10,"blockTimeOut":10,"giveTimeOut":15,"readyTimeOut":10},
                              "chairID":4,
                              "nCurrJu":1,
                              "nJuNum":2,
                              "nMoneyMode":11,
                              "nPlayerNum":4,
                              "rno":0},
           "_src":"p4",
           "_st":"nti"}
]]
function this.SetRoomCfgInfo(cfgData)

	this.chairid = cfgData["_para"].chairID
	this.roomnumber = cfgData["_para"].rno
	this.maxplayernum = cfgData["_para"].nPlayerNum
    this.gamesetting = cfgData["_para"].GameSetting
    this.nCurrJu = cfgData["_para"].nCurrJu

	this.nJuNum = cfgData["_para"].nJuNum
	this.nMoneyMode = cfgData["_para"].nMoneyMode
	this.ownerId = cfgData["_para"].owner_uid
	
	room_data.GetSssRoomDataInfo().owner_uid = cfgData["_para"].owner_uid
	
	this.timersetting = cfgData["_para"].TimerSetting
	this.rid = cfgData["_para"].rid
  this.gid = cfgData["_para"]._gid

  this.RoomDataInit()
end

function this.RoomDataInit()
  this.ownerLogicSeat = 0
end



function this.SetShiSangShuiRoomCfgInfo(cfgData)
	Trace( "-----game_cfgData配置房间-----".. GetTblData(cfgData))
	local param = cfgData["_para"]
	this.chairid = param.chairID
	this.roomnumber = param.rno
	this.maxplayernum = param.nPlayerNum
	this.nJuNum = param.nJuNum
	this.nCurrJu = param.nCurrJu
    this.rid = param.rid
	
	room_data.GetSssRoomDataInfo().people_num = this.maxplayernum
	room_data.GetSssRoomDataInfo().play_num = this.nJuNum
	room_data.GetSssRoomDataInfo().cur_playNum = this.nCurrJu	
	room_data.GetSssRoomDataInfo().rid = param.rid
	room_data.GetSssRoomDataInfo().gid = param._gid
    this.gid = param._gid
	room_data.GetSssRoomDataInfo().rno = param.rno
	room_data.GetSssRoomDataInfo().owner_uid = param.owner_uid
	room_data.GetSssRoomDataInfo().isZhuang = param["GameSetting"]["bSupportWaterBanker"]
	room_data.GetSssRoomDataInfo().isChip = param["GameSetting"]["bSupportBuyCode"]
	room_data.GetSssRoomDataInfo().add_card =  param["GameSetting"]["nSupportAddColor"]
	local addghost = param["GameSetting"]["bSupportGhostCard"]
	if addghost == true then
	   room_data.GetSssRoomDataInfo().add_ghost = 1
	else
      room_data.GetSssRoomDataInfo().add_ghost = 0
	end
	room_data.GetSssRoomDataInfo().max_multiple = param["GameSetting"]["nSupportMaxMult"]
	room_data.GetSssRoomDataInfo().placeCardTime = param["TimerSetting"]["chooseCardTypeTimeOut"]
end


function this.SetCurPlayerMaxCount(num)
	this.maxplayernum = num
end

function this.GetCurPlayerMaxCount()
	return this.maxplayernum
end

this.MaxPlayer = function()
  return this.GetCurPlayerMaxCount()
end

function this.SetBanker( bankerViewSeat )
  this.zhuang_viewSeat = bankerViewSeat
end

--[[--
 * @Description: 获取庄家座位的号码，两人时为1,3  
 ]]
function this.GetBankerViewSeat()
  if this.maxplayernum == 4 then
    return this.zhuang_viewSeat
  elseif this.maxplayernum == 3 then
    local myLogicSeat = player_seat_mgr.GetMyLogicSeat()
    if myLogicSeat == 1 then
      return this.zhuang_viewSeat
    elseif myLogicSeat == 2 then
      if this.zhuang_viewSeat == 3 then
        return 4
      else
        return this.zhuang_viewSeat
      end
    elseif myLogicSeat == 3 then
      if this.zhuang_viewSeat == 2 then
        return 3
      elseif this.zhuang_viewSeat == 3 then
        return 4
      else
        return this.zhuang_viewSeat
      end
    end
  elseif this.maxplayernum == 2 then
    if this.zhuang_viewSeat == 2 then 
      return 3
    else
      return this.zhuang_viewSeat
    end
  end
end

function this.SetSubRoundNum(num)
  this.nCurrJu = num
end

--[[--
 * @Description: 是否是金币场，否则房卡场  
 ]]
function this.IsCoinRoom()
  if this.nMoneyMode == 2 then
    return true
  elseif this.nMoneyMode == 11 then
    return false
  end
end


-- 清楚临时数据
function this.ClearData()
  this.mjMap = {}
  this.playerFlowerCards = {}
  this.hintInfoMap = nil
  this.currentTingInfo = nil
  this.isTing = false
  this.specialCard = nil
  this.specialCard1 = nil
  this.hasVoted = false
  this.beginSendCard = false
  this.isStart = false
  this.selfOutCard = 0
  this.isSelfVote = false
  this.currentPlayViewSeat = 0
end