local OperationView_93 = class("OperationView_93")
local yingsanzhang_data_manage = require("logic.poker_sys.yingsanzhang_sys.cmd_manage.yingsanzhang_data_manage")
local BetBtnView = require "logic/poker_sys/yingsanzhang_sys/ui/sub_ui/BetBtnView"

local btnColor = {
	[1] = Color(1,1,1),
	[2] = Color(77/255,77/255,77/255),	--灰
}

local chipType = {		---筹码1、5、10、50
	[1] = "ysz_15",	
	[5] = "ysz_16",
	[10] = "ysz_17",
	[50] = "ysz_18",
}

function OperationView_93:ctor(transfrom)
	self.parent = transfrom
	self.BiPaiViewSeat = 1
	self._xiaopaoTime = 0
	self.xiaopaoTimer_Elapse = nil
	self.xiaopaoCallBack = nil
	self.BtnBiPaiOnClickDelegate = nil
	self.chipObjTbl = {}
	self.operationObj = {}		---1加注2跟注3比牌4弃牌
	self.turnCount = 0
	self.totalCoin = 0
	self:InitWidgets()
end

function OperationView_93:InitWidgets()
	self.dichi = child(self.parent,"Panel/Anchor_Center/dichi")
	self.lunshu = componentGet(child(self.parent,"Panel/Anchor_Center/dichi/lunshu/label"),"UILabel")
	self.choumashu = componentGet(child(self.parent,"Panel/Anchor_Center/dichi/chouma/label"),"UILabel")
	
	self.btn_jiazhu = child(self.parent,"Panel/Anchor_BottomRight/option/btn_jiazhu")
	if self.btn_jiazhu ~= nil then
		addClickCallbackSelf(self.btn_jiazhu.gameObject,self.BtnJiaZhuOnClick,self)
		self.operationObj[1] = self.btn_jiazhu
	end
	self.btn_genzhu = child(self.parent,"Panel/Anchor_BottomRight/option/btn_genzhu")
	if self.btn_genzhu ~= nil then
		addClickCallbackSelf(self.btn_genzhu.gameObject,self.BtnGenZhuOnClick,self)
		self.operationObj[2] = self.btn_genzhu
	end
	self.btn_bipai = child(self.parent,"Panel/Anchor_BottomRight/option/btn_bipai")
	if self.btn_bipai ~= nil then
		addClickCallbackSelf(self.btn_bipai.gameObject,self.BtnBiPaiOnClick,self)
		self.operationObj[3] = self.btn_bipai
	end
	self.btn_qipai = child(self.parent,"Panel/Anchor_BottomRight/option/btn_qipai")
	if self.btn_qipai ~= nil then
		addClickCallbackSelf(self.btn_qipai.gameObject,self.BtnQiPaiOnClick,self)
		self.operationObj[4] = self.btn_qipai
	end
	self.btn_opencard = child(self.parent,"Panel/Anchor_Center/btn_opencard")
	if self.btn_opencard ~= nil then
		addClickCallbackSelf(self.btn_opencard.gameObject,self.BtnOpenCardOnClick,self)
	end
	self.optionGrid = componentGet(child(self.parent,"Panel/Anchor_BottomRight/option"),"UIGrid")

	
	self.chipObj = child(self.parent,"Panel/Anchor_Center/ChipAnchor/chip")
	self.chipObj.gameObject:SetActive(false)
	
	self.betBtnView = BetBtnView:create(child(self.parent,"Panel/Anchor_BottomRight/beishu").gameObject)			---加注面板
	
	self:IsShowWidgets(false)
	self:IsShowLabel(false)	
end

function OperationView_93:SetTurnCountLbl()
	local maxTurnData = yingsanzhang_data_manage:GetInstance().roomInfo.GameSetting.maxTurn	
	self.lunshu.text = "轮数: "..tostring(self.turnCount + 1).."/"..tostring(maxTurnData)
end

function OperationView_93:SetPotLbl()
	self.choumashu.text = "底池: "..tostring(self.totalCoin)
end

---是否显示操作btn，excTbl:除外的btn索引表{[1]=1,[2]=2,[3]=3,[4]=4}) --1加注2跟注3比牌4弃牌
function OperationView_93:IsShowOptionBtn(isShow,excTbl)
	--self.optionGrid.enabled = false
	for k,v in ipairs(self.operationObj) do
		if excTbl and excTbl[k] then
			v.gameObject:SetActive(not isShow)
		else
			v.gameObject:SetActive(isShow)
		end
	end

	--[[FrameTimer.New(function()		---间隔一帧再显示UI，处理UI显示没刷新的问题
		self.optionGrid.enabled = true
		self.optionGrid:Reposition()
	end,2,1):Start()--]]
end

function OperationView_93:IsShowWidgets(isShow)
	self.betBtnView:SetActive(isShow)
	self:IsShowOptionBtn(isShow)
	self:IsShowOpenCardBtn(isShow)
end

function OperationView_93:IsShowLabel(isShow)
	self.dichi.gameObject:SetActive(isShow)
	if isShow then
		self:SetTurnCountLbl()
		self:SetPotLbl()
	end
end

--发牌下底注更新底池
function OperationView_93:AfterDealBet(tbl)
	self.totalCoin = tbl["_para"]["nTotalCoin"]
	self:SetPotLbl()
	if not self:CheckIsBlindTurn(self.turnCount + 1)  then
		self:AfterBlindTurn()
	else
		self:OnBlindTurn()
	end
end

--加注
function OperationView_93:OnRaise(tbl)
	self.totalCoin = tbl["_para"]["nTotalCoin"]
	self:SetPotLbl()
	local viewSeat = player_seat_mgr.GetViewSeatByLogicSeat(tbl["_src"])
	if viewSeat == 1 then
		if not self:CheckIsBlindTurn(self.turnCount + 1)  then
			self:AfterBlindTurn()
		else		--正常流程不会进来这里
			self:OnBlindTurn()
		end
	end
end

--弃牌
function OperationView_93:OnFold(tbl)
	local data = yingsanzhang_data_manage:GetInstance()
	self:IsShowOptionBtn(false)
	self:IsShowOpenCardBtn(not data.isSelfOpenCard)
end

function OperationView_93:OnTrun(tbl)
	self.turnCount = tbl["_para"]["nCurrTurn"]
	self:IsShowLabel(true)
	if not self:CheckIsBlindTurn(self.turnCount + 1)  then
		self:AfterBlindTurn()
	else
		self:OnBlindTurn()
	end
end

--闷牌中
function OperationView_93:OnBlindTurn()
	self:IsShowOptionBtn(true)
	self:SetBtnState(self.operationObj[1],false)
	self:SetBtnState(self.operationObj[2],false)
	self:SetBtnState(self.operationObj[3],false)
	self:SetBtnState(self.operationObj[4],false)
end

function OperationView_93:AfterBlindTurn()
	local data = yingsanzhang_data_manage:GetInstance()
	
	if data.isSelfLose then				--比牌输	
		self:IsShowOptionBtn(false)
		self:IsShowOpenCardBtn(not data.isSelfOpenCard)
		
	elseif data.isSelfFold then				--弃牌了
		self:IsShowOptionBtn(false)
		self:IsShowOpenCardBtn(not data.isSelfOpenCard)
		
	elseif data.isSelfOpenCard then				--开牌了
		self:IsShowOptionBtn(true)
		--跟注灰掉
		self:SetBtnState(self.operationObj[1],false)
		self:SetBtnState(self.operationObj[2],false)
		self:SetBtnState(self.operationObj[3],false)
		self:SetBtnState(self.operationObj[4],true)	
		self:IsShowOpenCardBtn(false)
	else
		self:IsShowOptionBtn(true)
		--跟注灰掉
		self:SetBtnState(self.operationObj[1],false)
		self:SetBtnState(self.operationObj[2],false)
		self:SetBtnState(self.operationObj[3],false)
		self:SetBtnState(self.operationObj[4],true)
		self:IsShowOpenCardBtn(true)
	end
end

--跟注
function OperationView_93:OnCall(tbl)
	self.totalCoin = tbl["_para"]["nTotalCoin"]
	self:SetPotLbl()
	
	local viewSeat = player_seat_mgr.GetViewSeatByLogicSeat(tbl["_src"])
	if viewSeat == 1 then
		if not self:CheckIsBlindTurn(self.turnCount + 1)  then
			self:AfterBlindTurn()
		else
			self:OnBlindTurn()
		end
		self.betBtnView:SetActive(false)
	end
end

--比牌
function OperationView_93:OnCompare(tbl)
	self.totalCoin = tbl["_para"]["nTotalCoin"]
	self:SetPotLbl()
	
	local winViewSeat =  player_seat_mgr.GetViewSeatByLogicSeatNum(tbl["_para"]["nWinChair"])
	local loseViewSeat =  player_seat_mgr.GetViewSeatByLogicSeatNum(tbl["_para"]["nLooseChair"])	
	if winViewSeat == 1 then
		self:AfterBlindTurn()
	elseif loseViewSeat == 1 then
		self:IsShowOptionBtn(false)
	else
		
	end
end

--回合
function OperationView_93:OnAskAction(tbl)
	---1加注2跟注3比牌4弃牌
	
	--if not self:CheckIsBlindTurn(self.turnCount + 1)  then	
		self:SetBtnState(self.operationObj[1],tbl._para.stAction.bRaise)
		self:SetBtnState(self.operationObj[2],tbl._para.stAction.bCall)
		self:SetBtnState(self.operationObj[3],tbl._para.stAction.bCompare)
		self:SetBtnState(self.operationObj[4],tbl._para.stAction.bFold)
		self:IsShowOpenCardBtn(tbl._para.stAction.bOpencard)
	--[[else
		self:IsShowOptionBtn(false,{[2]=2,[4]=4})
		self:SetBtnState(self.operationObj[2],tbl._para.stAction.bCall)
		self:SetBtnState(self.operationObj[4],tbl._para.stAction.bFold)
		self:IsShowOpenCardBtn(tbl._para.stAction.bOpencard)
	end--]]

	self.optionGrid:Reposition()	
	self.betBtnView:SetBetBtnActive(tbl["_para"]["stAction"]["nBlindCoin"])
end

--开牌
function OperationView_93:OnOpenCard(tbl)
	self.betBtnView:SetBetBtnActive(tbl["_para"]["nBlindCoin"])
end

function OperationView_93:OnSyncTable(tbl)
	self.turnCount = tbl["_para"]["nCurrTurn"]
	self.totalCoin = tbl["_para"]["nTotalCoin"]
	self:IsShowLabel(true)
	
	local whosTurnViewSeat = player_seat_mgr.GetViewSeatByLogicSeatNum(tbl["_para"]["whoisOnTurn"])
	if whosTurnViewSeat ~= 1 then
		if not self:CheckIsBlindTurn(self.turnCount + 1)  then
			self:AfterBlindTurn()
		else
			self:OnBlindTurn()
		end	
	else
		---自己回合走ask_action协议
	end
end

---按钮是否置灰
function OperationView_93:SetBtnState(btnTran,value)
	btnTran.gameObject:SetActive(true)
	if value then
		componentGet(btnTran.gameObject.transform,"BoxCollider").enabled = true
		componentGet(btnTran.gameObject.transform,"UISprite").color = btnColor[1]
		subComponentGet(btnTran,"label","UILabel").color = btnColor[1]
	else
		componentGet(btnTran.gameObject.transform,"BoxCollider").enabled = false
		componentGet(btnTran.gameObject.transform,"UISprite").color = btnColor[2]
		subComponentGet(btnTran,"label","UILabel").color = btnColor[2]
	end
end

---检查是否闷牌阶段
function OperationView_93:CheckIsBlindTurn(curTurn)
	local blindTurn = yingsanzhang_data_manage:GetInstance().roomInfo["GameSetting"]["blindTurn"]
	return  curTurn <= blindTurn 
end

function OperationView_93:IsShowOpenCardBtn(isShow)
	self.btn_opencard.gameObject:SetActive(isShow)
end

function OperationView_93:IsShowAnchor(IsShow)
	self.dichi.gameObject:SetActive(IsShow)
end

function OperationView_93:BtnJiaZhuOnClick(mySelf,obj)
	self.betBtnView:SetActive(true)
end

function OperationView_93:BtnGenZhuOnClick()
	pokerPlaySysHelper.GetCurPlaySys().CallReq()
end

function OperationView_93:BtnBiPaiOnClick()
	self.BtnBiPaiOnClickDelegate()
end

function OperationView_93:BtnQiPaiOnClick()
	pokerPlaySysHelper.GetCurPlaySys().FoldReq()
end

function OperationView_93:BtnOpenCardOnClick()
	pokerPlaySysHelper.GetCurPlaySys().OpenCardReq()
end

function OperationView_93:PlayChipAnimation(player,nBetCoin)
	local baseDepth = 26
	for _,v in ipairs(self.chipObjTbl) do
		if not IsNil(v) then
			componentGet(v,"UISprite").depth = baseDepth
		end
	end
	
	local count50,count10,count5,count1 = self:CalChipMember(nBetCoin)
	local totalCoin = count50 + count10 + count5 + count1
	for i = 1,totalCoin do
		local obj = GameObject.Instantiate(self.chipObj.gameObject)
		obj.transform.parent = self.chipObj.transform.parent	
		obj.transform.localPosition = Vector3(0,0,0)
		obj.transform.localScale = Vector3(1,1,1)
		obj.transform.position = player.position
		local objSp = componentGet(obj.gameObject,"UISprite")
		if i <= count50 then
			objSp.spriteName = chipType[50]
			objSp.depth = baseDepth + 3
		elseif i > count50 and i <= (count50 + count10) then
			objSp.spriteName = chipType[10]
			objSp.depth = baseDepth + 2
		elseif i > (count50 + count10) and i <= (count50 + count10 + count5) then
			objSp.spriteName = chipType[5]
			objSp.depth = baseDepth + 1
		else
			objSp.spriteName = chipType[1]
			objSp.depth = baseDepth
		end
		
		local random_x = math.random(-100,100)
		local random_y = math.random(-30,80)
		local endTrans = self.chipObj.transform.localPosition
		obj.gameObject:SetActive(true)
		obj.gameObject.transform:DOLocalMove(Vector3(endTrans.x + random_x,endTrans.y + random_y,endTrans.z),0.3,false):SetEase(DG.Tweening.Ease.OutCubic)	
		table.insert(self.chipObjTbl,obj)
	end
end

function OperationView_93:ChipFlyToWinViewSeat(player,playerTotalCount,playerIndex)
	local endTrans = player.localPosition
	coroutine.start(function()
		local chipCount = table.getn(self.chipObjTbl)
		local perCount = math.ceil(chipCount/playerTotalCount)
		for i = 1,chipCount do
			if i > ((playerIndex-1)*perCount) and i <= (playerIndex*perCount) then
				if self.chipObjTbl[i] then
					self.chipObjTbl[i].transform:DOLocalMove(endTrans,0.3,false):OnComplete(function()
						self.chipObjTbl[i].gameObject:SetActive(false)
					end)
					if chipCount < 20 then
						coroutine.wait(0.005)
					else
						if i%20 == 0 then
							coroutine.wait(0.01)
						end
					end
				end	
			end			
		end
	end)
end

---清除筹码
function OperationView_93:ClearChipObjTabel()
	if #self.chipObjTbl > 0 then
		local count = #self.chipObjTbl	
		for i = count,1 ,-1 do 
			local v = self.chipObjTbl[i]
			if v ~= nil then
				v.transform.parent = nil
				v.transform.gameObject:SetActive(false)
				GameObject.Destroy(v.transform.gameObject)
			end
		end
		self.chipObjTbl = {}
	end
end

--1 5 10 50
function OperationView_93:CalChipMember(nBetCoin)
	local count50 = math.floor(nBetCoin / 50)
	local count10 = math.floor(nBetCoin % 50 / 10)
	local count5 = math.floor(nBetCoin % 50 % 10 / 5)
	local count1 = math.floor(nBetCoin % 50 % 10 % 5)
	
	return count50,count10,count5,count1
end

function OperationView_93:Reset()
	self.lunshu.text = ""
	self.choumashu.text = ""	
	self:IsShowLabel(false)
	self:ClearChipObjTabel()
	self:IsShowOptionBtn(false)
	self:IsShowOpenCardBtn(false)
	self.turnCount = 0
	self.totalCoin = 0
	yingsanzhang_data_manage:GetInstance():SetSelfOpenCardState(false)
	yingsanzhang_data_manage:GetInstance():SetSelfFoldState(false)
	yingsanzhang_data_manage:GetInstance():SetSelfLoseState(false)
end

return OperationView_93