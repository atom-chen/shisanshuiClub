local base = require "logic/framework/ui/uibase/ui_view_base"
local MoreBtnsView = class("MoreBtnsView", base)
local addClickCallbackSelf = addClickCallbackSelf
function MoreBtnsView:ctor(go, callback, comp)

	-- @todo  如果需要 做成完全配置
	self.btnsMap = 
	{					-- function  enable
		["setting"] 	= {self.OnSettingClick, true},			--设置
		["result"] 		= {self.OnResultClick, true},			--战绩
		["gameplay"] 	= {self.OnGamePlayClick, true},			--玩法
		["rule"] 		= {self.OnRuleClick, true},				--规则
		["machine"] 	= {self.OnMachineClick, false},			--托管
		["gps"]			= {self.OnGpsClick, true},				--定位
		["apply"]		= {self.OnApplyHintClick, false}		--申请
	}
	self.hideCallback = callback
	self.relateBtn = comp
	self.clubModel = model_manager:GetModel("ClubModel")

	--  ios 屏蔽定位
	if tostring(Application.platform) == "IPhonePlayer" or tostring(Application.platform) == "OSXEditor" then
		self.btnsMap["gps"][2] = false
	end

	base.ctor(self, go)

end

function MoreBtnsView:InitView()
	self.btnGoList = {}
	self.bgRt = self:GetComponent("bgBlack", typeof(UISprite))
	self.checkList = {self.bgRt, self.relateBtn }
	local applyBtnGo
	local ruleGo
	for k, tab in pairs(self.btnsMap) do
		local go = self:GetGameObject(k)
		if go ~= nil then
			addClickCallbackSelf(go, 
				function()
					tab[1](self)
					if self.hideCallback ~= nil then
						self.hideCallback()
					end
				end, self)
			go:SetActive(tab[2] or false)
			table.insert(self.btnGoList, go)

			if k == "apply" then
				applyBtnGo = go
			end

			if k == "rule" then
				ruleGo = go
			end
		end
	end


	if tostring(Application.platform) == "IPhonePlayer" or tostring(Application.platform) == "OSXEditor" then
		if applyBtnGo ~= nil then
			LuaHelper.SetTransformLocalY(applyBtnGo.transform, -173)
		else
			LuaHelper.SetTransformLocalY(applyBtnGo.transform, -245)
		end
		if ruleGo ~= nil then
			LuaHelper.SetTransformLocalY(ruleGo.transform, -101)
		else
			LuaHelper.SetTransformLocalY(ruleGo.transform, -173)
		end
	end

	-- local startY = 114
	-- for i = 1, #self.btnGoList do
	-- 	logError(self.btnGoList[i], self.btnGoList[i].activeSelf)
	-- 	if self.btnGoList[i].activeSelf == true then
	-- 		LuaHelper.SetTransformLocalY(self.btnGoList[i].transform, startY)
	-- 		startY = startY - 72
	-- 	end
	-- end
end


function MoreBtnsView:OnShow()
	InputManager.AddLock()
	Notifier.regist(cmdName.MSG_MOUSE_BTN_DOWN, slot(self.OnMouseBtnDown, self))
	Notifier.regist(GameEvent.OnPlayerApplyClubChange, self.UpdateApplyHintBtn, self)

	self:UpdateApplyHintBtn()
end

function MoreBtnsView:OnHide()
	InputManager.ReleaseLock()
	Notifier.remove(cmdName.MSG_MOUSE_BTN_DOWN, slot(self.OnMouseBtnDown, self))
	Notifier.remove(GameEvent.OnPlayerApplyClubChange, self.UpdateApplyHintBtn, self)
end

function MoreBtnsView:UpdateApplyHintBtn()
	local btnGo = self:GetGameObject("apply")
	local clubList = self.clubModel.clubList
	if clubList == nil then
		btnGo:SetActive(false)
		return
	end
	for i = 1, #clubList do
		if self.clubModel:CheckShowApplyHint(clubList[i].cid) then
			btnGo:SetActive(true)
			return
		end
	end
	btnGo:SetActive(false)
end

function MoreBtnsView:OnMouseBtnDown(pos)
	if not Utils.CheckPointInUIs(self.checkList, pos) then
		if self.hideCallback ~= nil then
			self.hideCallback()
		end
	end
end

function MoreBtnsView:OnGamePlayClick()
	ui_sound_mgr.PlayButtonClick()
	report_sys.EventUpload(35,player_data.GetGameId())
	UI_Manager:Instance():ShowUiForms("help_ui",UiCloseType.UiCloseType_CloseNothing,function() 
                            Trace("Close help_ui")
                          end, player_data.GetGameId())
end

function MoreBtnsView:OnRuleClick()
	ui_sound_mgr.PlayButtonClick()
	report_sys.EventUpload(34,player_data.GetGameId())
	-- UI_Manager:Instance():ShowUiForms("waiting_ui")
	-- http_request_interface.getRoomByRid(roomdata_center.rid,1,function (str)
	-- 	local s=string.gsub(str,"\\/","/")  
	-- 	local t=ParseJsonStr(s)
	-- 	Trace("OnRuleClick--------"..str)
	-- 	t.isRule = true
	-- 	UI_Manager:Instance():ShowUiForms("recorddetails_ui",UiCloseType.UiCloseType_CloseNothing,function() 
	--                             Trace("Close recorddetails_ui")
	--                           end, t)
 --       UI_Manager:Instance():CloseUiForms("waiting_ui")
 --   end)
     HttpProxy.SendRoomRequest(
        HttpCmdName.GetRoomRecordInfo, {rid = roomdata_center.rid}, 
        function (_param, _errno)
        	_param.isRule = true
            UI_Manager:Instance():ShowUiForms("recorddetails_ui",UiCloseType.UiCloseType_CloseNothing,nil,_param)
        end, nil, HttpProxy.ShowWaitingSendCfg)
end

function MoreBtnsView:OnApplyHintClick()
	local list = self.clubModel:GetHasApplyMemeberList()
	if #list == 0 then
		return
	end
	if #list == 1 then
		UI_Manager:Instance():ShowUiForms("ClubApplyUI", nil, nil, list[1].cid)
	else
		UI_Manager:Instance():ShowUiForms("ClubGameApplyUI")
	end
end


function MoreBtnsView:OnResultClick()
	ui_sound_mgr.PlayButtonClick()
	report_sys.EventUpload(37,player_data.GetGameId())
	-- UI_Manager:Instance():ShowUiForms("waiting_ui")
	-- http_request_interface.getRoomByRid(roomdata_center.rid,1,function (str)
 --       local s=string.gsub(str,"\\/","/")  
 --       local t=ParseJsonStr(s)
 --       Trace("Onbtn_resultClick--------"..str)
	-- 	UI_Manager:Instance():ShowUiForms("recorddetails_ui",UiCloseType.UiCloseType_CloseNothing,function() 
	--                             Trace("Close recorddetails_ui")
	--                           end, t)
 --       UI_Manager:Instance():CloseUiForms("waiting_ui")
 --   end)
    HttpProxy.SendRoomRequest(
        HttpCmdName.GetRoomRecordInfo, {rid = roomdata_center.rid}, 
        function (_param, _errno)   
            UI_Manager:Instance():ShowUiForms("recorddetails_ui",UiCloseType.UiCloseType_CloseNothing,nil,_param)
        end, nil, HttpProxy.ShowWaitingSendCfg)
end

function MoreBtnsView:OnSettingClick()
	ui_sound_mgr.PlayButtonClick()
	report_sys.EventUpload(36,player_data.GetGameId())
	--setting_ui.Show()
	UI_Manager:Instance():ShowUiForms("setting_ui",UiCloseType.UiCloseType_CloseNothing,function() 
		Trace("Close setting_ui")
	end)
end

function MoreBtnsView:OnMachineClick()
	--mahjong_play_sys.AutoPlayReq(autoPlay)
end

function MoreBtnsView:OnGpsClick()
	ui_sound_mgr.PlayButtonClick()
	UI_Manager:Instance():ShowUiForms("gps_ui",UiCloseType.UiCloseType_CloseNothing,nil,gps_data.GetGpsData())
end


return MoreBtnsView