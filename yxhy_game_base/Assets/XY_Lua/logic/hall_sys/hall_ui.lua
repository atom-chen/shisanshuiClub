 --[[--
 * @Description: 大厅ui组件
 * @Author:      wx
 * @FileName:    hall_ui.lua
 * @DateTime:    2018-02-27
 ]]
 
require "logic/hall_sys/hall_data"
require "logic/hall_sys/hall_ui_ctrl"  
require "logic/network/http_request_interface"
require "logic/network/majong_request_protocol"
require "logic/common/join_room_ctrl"
require "logic/mahjong_sys/utils/ShareStrUtil"
require "logic/hall_sys/mail_ui/mail_data"


local base = require("logic.framework.ui.uibase.ui_window")
local hall_ui = class("hall_ui",base)

local HallClubRoomsView = require "logic/club_sys/View/new/HallClubRoomsView"
local UIManager = UI_Manager:Instance() 

local isClicked = false				--防止频繁按钮点击
local uiActingTbl = {} 				--防止ui动效短时间执行多次
local isShowClubRoomsView = true	--记录房间列表打开状态，第一次进大厅默认打开

local HallUIKind = {
	club = 1,
	clubCreate = 2
}

local isShowManage = false
local isShowAuth = true

local effectNameTbl = {		---粒子特效在这添加
	"Panel_Middle/btn_createRoom/Effect_cjfj",
	"Panel_Middle/btn_joinRoom/Effect_jrfj",
	"Panel_Middle/btn_openClub/Effect_jlb",
	"Panel_Middle/Texture_avatar/Effect_meinv",
	"Panel_Bottom/btn_store/Effect_xiaoshangcheng",
	"Panel_TopLeft/personInfoArea/sp_fkBackground/Sprite/Effect_xiaozhuanshi",
	"Panel_TopLeft/personInfoArea/sp_fkBackground/btn_shop/Effect_btn_shop",
}

function hall_ui:setUIActive(_uiObj,active)
	local uiObj = _uiObj
	if uiObj then
		uiObj.gameObject:SetActive(active)
	else
		logError("Error,uiObj为空！！！")
	end
end

function hall_ui:setBtnEvent(_uiObj,eventFunc)
	local uiObj = _uiObj
	if uiObj and eventFunc then
		addClickCallbackSelf(uiObj.gameObject,eventFunc,self)
	else
		logError("Error,uiObj或eventFunc为空！！！")
	end
end

function hall_ui:OnInit()


	self.clubModel = model_manager:GetModel("ClubModel")
	self.isShowClubRed = false
	
---Panel_TopLeft---
	self.Panel_TopLeft = self:GetGameObject("Panel_TopLeft")
	self.nameLbl = self:GetComponent("Panel_TopLeft/personInfoArea/sp_nameBackground/lab_name",typeof(UILabel))
	self.idLbl = self:GetComponent("Panel_TopLeft/personInfoArea/sp_nameBackground/lab_id",typeof(UILabel))
	self.cardLbl = self:GetComponent("Panel_TopLeft/personInfoArea/sp_fkBackground/lab_id",typeof(UILabel))
	self.btnGo_addShop = self:GetGameObject("Panel_TopLeft/personInfoArea/sp_fkBackground/btn_shop")
	self.spBtnGo_photo = self:GetGameObject("Panel_TopLeft/personInfoArea/sp_photo")
	self.tex_photo = self:GetComponent("Panel_TopLeft/personInfoArea/sp_photo/tex_photo",typeof(UITexture))
	self.btnGo_manage = self:GetGameObject("Panel_TopLeft/btn_manage")
	
---Panel_TopRight---
	self.Panel_TopRight = self:GetGameObject("Panel_TopRight")
	self.btnGrid_topRight = self:GetComponent("Panel_TopRight/Grid_TopRight", typeof(UIGrid))
	self.btnGo_share = self:GetGameObject("Panel_TopRight/Grid_TopRight/btn_share")
	self.btnGo_auth = self:GetGameObject("Panel_TopRight/Grid_TopRight/btn_auth")
	self.btnGo_game = self:GetGameObject("Panel_TopRight/Grid_TopRight/btn_game")
	

---Panel_Bottom---
	self.Panel_Bottom = self:GetGameObject("Panel_Bottom")
	self.btnGo_store = self:GetGameObject("Panel_Bottom/btn_store")
	self.btnGo_active = self:GetGameObject("Panel_Bottom/Grid/btn_active")
	self.btnGo_record = self:GetGameObject("Panel_Bottom/Grid/btn_record")
	self.btnGo_mail = self:GetGameObject("Panel_Bottom/Grid/btn_mail")
	self.btnGo_feedback = self:GetGameObject("Panel_Bottom/Grid/btn_feedback")
	self.btnGo_setting = self:GetGameObject("Panel_Bottom/Grid/btn_setting")
	
---Panel_Middle---
	self.Panel_Middle = self:GetGameObject("Panel_Middle")
	self.go_textureAvatar = self:GetGameObject("Panel_Middle/Texture_avatar")

	self.btnGo_createRoom = self:GetGameObject("Panel_Middle/btn_createRoom")
	self.btnGo_joinRoom = self:GetGameObject("Panel_Middle/btn_joinRoom")
	self.btnGo_openClub = self:GetGameObject("Panel_Middle/btn_openClub")
	--self.clubNameLbl = self:GetComponent("Panel_Middle/btn_openClub/clubNameLbl",typeof(UILabel))
	self.sp_clubRedState = self:GetGameObject("Panel_Middle/btn_openClub/clubState")
	
---Panel_Left---
	self.clubRoomsView = HallClubRoomsView:create(self:GetGameObject("Panel_Left/hallClubRoomView"))
	self.clubRoomsView:SetActive(false)
	self.clubRoomsView:SetCallback(self.OnRoomViewMoveComplete, self)
	
	self.roomListBtnGo = self:GetGameObject("Panel_Left/roomListBtn")
	self.roomRedIconGo = self:GetGameObject("Panel_Left/roomListBtn/redIcon")
	
---ParticleEffect---
	self.particleGoTbl = {}
	for k,v in ipairs(effectNameTbl) do
		local effectGo = self:GetGameObject(v)
		if effectGo then
			table.insert(self.particleGoTbl,effectGo)
		else
			logError(tostring(v).."特效不存在")
		end
	end
	
	-- self.topLeftPos = self.Panel_TopLeft.transform.localPosition
	-- self.topRightPos = self.Panel_TopRight.transform.localPosition
	-- self.bottomPos = self.Panel_Bottom.transform.localPosition

	self:RegisterUIEvent()
end

--- 注册按钮事件
function hall_ui:RegisterUIEvent() 
	self:setBtnEvent(self.btnGo_addShop,self.OpenShopUI)						--添加房卡
    self:setBtnEvent(self.spBtnGo_photo,self.OpenPersonInfoUI)			--个人信息
	self:setBtnEvent(self.btnGo_manage,self.OpenManagementUI)			--管理后台
	
	self:setBtnEvent(self.btnGo_share,self.OpenShareUI)					--分享
	self:setBtnEvent(self.btnGo_game, self.OpenWebGameUI)
	
	self:setBtnEvent(self.btnGo_auth,self.OpenCertificationUI)				--实名认证
	self:setBtnEvent(self.btnGo_setting,self.OpenSettingUI)					--设置
	
	self:setBtnEvent(self.btnGo_store,self.OpenShopUI)						--商城
	self:setBtnEvent(self.btnGo_active,self.OpenActivityUI)					--活动
	self:setBtnEvent(self.btnGo_record,self.OpenRecordUI)						--战绩
	self:setBtnEvent(self.btnGo_mail,self.OpenMailUI)							--邮箱
	self:setBtnEvent(self.btnGo_feedback,self.OpenFeedbackUI)					--反馈
	
	self:setBtnEvent(self.btnGo_createRoom,self.OpenCreateRoomUI)			--创建房间
	self:setBtnEvent(self.btnGo_joinRoom,self.OpenJoinRoomUI)					--加入房间
	self:setBtnEvent(self.btnGo_openClub,self.OpenClubUI)				--进入俱乐部
	
	self:setBtnEvent(self.roomListBtnGo,self.OnRoomListBtnClick)		--打开房间悬浮
end

function hall_ui:OnOpen()
	self:ShowUI()
	self:UpdateKind(true)
	self:RegistNotifier()
	hall_data.ShowApply = false
end

function hall_ui:PlayOpenAmination()

	---进场ui效果
	-- self:setUIActive(self.Panel_TopLeft,false)
	-- self:setUIActive(self.Panel_TopRight,false)
	-- self:setUIActive(self.Panel_Bottom,false)
	-- local time = 0.3
	-- local length = 150


	-- self:enterUIEffectPos(self.Panel_TopLeft,0,length,time, self.topLeftPos)
	-- self:enterUIEffectPos(self.Panel_TopRight,0,length,time, self.topRightPos)
	-- self:enterUIEffectPos(self.Panel_Bottom,0,-length,time, self.bottomPos)

	local function setScaleY(_gameObject, scaleY)
		if not _gameObject then
			return
		end
		local curValue = _gameObject.transform.localScale
		curValue = Vector3(curValue.x, curValue.y, curValue.z)
		_gameObject.transform.localScale = Vector3(curValue.x, scaleY, curValue.z)
	end
	setScaleY(self.Panel_TopLeft, 0)
	setScaleY(self.Panel_TopRight, 0)
	setScaleY(self.Panel_Bottom, 0)

	local delayTimer = Timer.New(function()
		setScaleY(self.Panel_TopLeft, 1)
		setScaleY(self.Panel_TopRight, 1)
		setScaleY(self.Panel_Bottom, 1)

		local time = 0.3
		local length = 150
		
		self.topLeftPos = self.topLeftPos or self.Panel_TopLeft.transform.localPosition
		self.topRightPos = self.topRightPos or self.Panel_TopRight.transform.localPosition
		self.bottomPos = self.bottomPos or self.Panel_Bottom.transform.localPosition
		
		self:enterUIEffectPos(self.Panel_TopLeft,0,length,time, self.topLeftPos)
		self:enterUIEffectPos(self.Panel_TopRight,0,length,time, self.topRightPos)
		self:enterUIEffectPos(self.Panel_Bottom,0,-length,time, self.bottomPos)
	end, 0.05, 1)
	delayTimer:Start()
end

---posEffect
function hall_ui:enterUIEffectPos(_uiObj, _offsetX, _offsetY, _time, defaultPos)
	local uiObj = _uiObj
	if uiObj then
		local _uiName = tostring(uiObj.name)
		if uiActingTbl[_uiName] then
			return
		end
		local isActing = true
		local curValue = uiObj.gameObject.transform.localPosition
		curValue = Vector3(curValue.x, curValue.y, curValue.z)
		uiObj.gameObject.transform.localPosition = Vector3(curValue.x +_offsetX, curValue.y +_offsetY, curValue.z)
		self:setUIActive(uiObj.gameObject,true)

		local animTweener = uiObj.gameObject.transform:DOLocalMove(curValue,_time,true)
		animTweener:SetEase(DG.Tweening.Ease.Linear):OnComplete(function()
			isActing =  false
			uiActingTbl[_uiName] = false
		end)
		animTweener:OnKill(function()
			-- 销毁动画对象
			uiObj.gameObject.transform.localPosition = defaultPos
			if uiObj and isActing then
				uiObj.gameObject.transform.localPosition = defaultPos
				uiObj = nil
				isActing =  false
				uiActingTbl[_uiName] = false
			end
		end)
	end
end

---scaleEffect
function hall_ui:enterUIEffectScale(_uiObj,_offsetX,_offsetY,_time)
	local uiObj = _uiObj
	if uiObj then
		local _uiName = tostring(uiObj.name)
		if uiActingTbl[_uiName] then
			return
		end
		local isActing = true
		local curValue = uiObj.gameObject.transform.localScale
		curValue = Vector3(curValue.x, curValue.y, curValue.z)
		uiObj.gameObject.transform.localScale = Vector3(curValue.x +_offsetX, curValue.y +_offsetY, curValue.z)
		
		local animTweener = uiObj.gameObject.transform:DOScale(curValue,_time)
		animTweener:SetEase(DG.Tweening.Ease.OutElastic, 0.2):OnComplete(function()
			isActing =  false
			uiActingTbl[_uiName] = false
		end)
		animTweener:OnKill(function()
			-- 销毁动画对象
			if uiObj and isActing then
				uiObj.gameObject.transform.localScale = curValue
				uiObj = nil
				isActing =  false
				uiActingTbl[_uiName] = false
			end
		end)
	end
end

---特效刷新
function hall_ui:OnRefreshDepth()
	for k,v in pairs(self.particleGoTbl) do
		if v and self.sortingOrder then
			Utils.SetEffectSortLayer(v.gameObject,self.sortingOrder + self.m_subPanelCount + 1)		
		end
	end
	if self.go_textureAvatar and self.sortingOrder then
		Utils.SetEffectSortLayer(self.go_textureAvatar,self.sortingOrder)
	end
end

function hall_ui:SetTextureAvatarShow(value)
	if self.avatarTweenAlpha == nil then
		self.avatarTweenAlpha = self.go_textureAvatar:AddComponent(typeof(TweenAlpha))
	end
	self:setUIActive(self.go_textureAvatar,value)
	if value then
		self.avatarTweenAlpha.from = 0.5
		self.avatarTweenAlpha.to = 1
		self.avatarTweenAlpha.duration = 0.5
		self.avatarTweenAlpha.method = UITweener.Method.EaseInOut
		self.avatarTweenAlpha:ResetToBeginning()
		self.avatarTweenAlpha:PlayForward()
	else
	end
end

function hall_ui:ShowUI()
	hall_data.checkIdCard()
	invite_sys.LoadMWParam()
	hall_data.Init()
	self:InitUserInfo()
	self:OnClubAgentChange()
	ui_sound_mgr.PlayBgSound("hall_bgm")
	if hall_data.ShowApply == true then
		hall_data.LoadJPushParam()
		hall_data.ShowApply = false
	end
end

---代理商btn
function hall_ui:OnClubAgentChange()
	if not self.clubModel then
		return
	end
	isShowManage = self.clubModel.canSeeBacksite
	if G_isAppleVerifyInvite then
		isShow = false
	end
	self:setUIActive(self.btnGo_manage,isShowManage)
end

function hall_ui:OnClose()
	self:UnregistNotifier()
	if self.clubRoomsView ~= nil then
		self.clubRoomsView:Hide(true)
	end
end

function hall_ui:RegistNotifier()
	Notifier.regist(GameEvent.OnClearFristState, self.UpdateKind, self)
	Notifier.regist(GameEvent.OnCurrentClubChange, self.OnCurrentClubChange, self)
	Notifier.regist(GameEvent.OnCanSeeBackSite, self.OnClubAgentChange, self)
	Notifier.regist(GameEvent.OnAllClubRoomListUpdate, self.OnAllClubRoomListUpdate, self)	
	Notifier.regist(GameEvent.OnSelfClubNumUpdate, self.OnClubNumUpdate, self)
	--Notifier.regist(GameEvent.OnClubInfoUpdate, self.OnClubInfoUpdate, self)	
	Notifier.regist(GameEvent.OnEnterNewClub, self.OnEnterNewClub, self)
	Notifier.regist(GameEvent.OnPlayerApplyClubChange, self.OnPlayerApplyClubChange, self)
	--Notifier.regist(GameEvent.OnCloseWindow, self.OnCloseWindow, self)
	--Notifier.regist(cmdName.MSG_MOUSE_BTN_DOWN, self.OnMouseBtnDown, self)
	--Notifier.regist(GameEvent.OnClubRoomListUpdate, self.OnClubRoomListUpdate, self)
	Notifier.regist(GameEvent.OnChangeScene, self.OnChangeScene, self)
end

function hall_ui:UnregistNotifier()
	Notifier.remove(GameEvent.OnClearFristState, self.UpdateKind, self)
	Notifier.remove(GameEvent.OnCurrentClubChange, self.OnCurrentClubChange, self)
	Notifier.remove(GameEvent.OnCanSeeBackSite, self.OnClubAgentChange, self)
	Notifier.remove(GameEvent.OnAllClubRoomListUpdate, self.OnAllClubRoomListUpdate,self)	
	Notifier.remove(GameEvent.OnSelfClubNumUpdate, self.OnClubNumUpdate, self)

	--Notifier.remove(GameEvent.OnClubInfoUpdate, self.OnClubInfoUpdate, self)
	Notifier.remove(GameEvent.OnEnterNewClub, self.OnEnterNewClub, self)
	Notifier.remove(GameEvent.OnPlayerApplyClubChange, self.OnPlayerApplyClubChange, self)
	Notifier.remove(GameEvent.OnChangeScene, self.OnChangeScene, self)
	--Notifier.remove(GameEvent.OnCloseWindow, self.OnCloseWindow, self)
	--Notifier.remove(cmdName.MSG_MOUSE_BTN_DOWN, self.OnMouseBtnDown, self)
	--Notifier.remove(GameEvent.OnClubRoomListUpdate, self.OnClubRoomListUpdate, self)
end

function hall_ui:OnChangeScene()
	if game_scene.getCurSceneType() == scene_type.LOGIN then
		isShowClubRoomsView = true
		hall_data.isShowClubApply = true
	end
end

---新的申请
function hall_ui:OnPlayerApplyClubChange()
	self:UpdateClubRedState()
end

---加入新俱乐部
function hall_ui:OnEnterNewClub()
	self.isShowClubRed = true
	self:UpdateClubRedState()
end

---切换当前俱乐部
function hall_ui:OnCurrentClubChange()
	--[[if self.clubNameLbl then
		self.clubNameLbl.text = self.clubModel.currentClubInfo["cname"]
	end--]]
end

---所有房间列表更新
function hall_ui:OnAllClubRoomListUpdate()
	self.clubRoomsView:UpdateDatas()
	self:UpdateRoomRedState(not self.clubRoomsView.isShow)
end

---新增俱乐部
function hall_ui:OnClubNumUpdate()
	self:UpdateKind()
	self.clubRoomsView:UpdateDatas()
end

function hall_ui:UpdateKind(force)
	local kind = nil
	if self.clubModel.isAutoOpenCraeteClub then
		kind = HallUIKind.clubCreate
		self.clubModel.isAutoOpenCraeteClub = false
	else
		kind = HallUIKind.club
	end

	if self.iKind == kind and not force then
		return
	end
	self.clubRoomsView:UpdateDatas()
	self:OpenUI(kind)
end

function hall_ui:OpenUI(_iKind)
	self.iKind = _iKind


	self:setUIActive(self.btnGo_auth,isShowAuth)
	self:setUIActive(self.btnGo_manage,isShowManage)
	self.btnGrid_topRight:Reposition()		
	self:setUIActive(self.clubRoomsView,true)
	
	-- _iKind == HallUIKind.club then
	-- if self.clubModel:HasClub() then
		if isShowClubRoomsView then			
			self:ShowClubRoomsView()
		else
			self:setUIActive(self.roomListBtnGo,true)
		end

	-- else
	-- 	logError("no club")
	-- end	
	--end
	if _iKind == HallUIKind.clubCreate then
		UI_Manager:Instance():ShowUiForms("ClubCreateUI")
	end

---苹果审核隐藏界面
	if G_isAppleVerifyInvite then
		self:setUIActive(self.btnGo_share,false)
		self:setUIActive(self.btnGo_active,false)
		self:setUIActive(self.btnGo_manage,false)
	end
end

function hall_ui:OnRoomViewMoveComplete()
	if self.clubRoomsView.isShow == false then
		self:setUIActive(self.roomListBtnGo,true)
		self:SetTextureAvatarShow(true)
	end	
	self:UpdateRoomRedState(not self.clubRoomsView.isShow)
end

function hall_ui:OnRoomListBtnClick()
	ui_sound_mgr.PlayButtonClick()
	self:ShowClubRoomsView()
end

function hall_ui:ShowClubRoomsView()
	isShowClubRoomsView = true
	self:setUIActive(self.roomListBtnGo,false)
	self:SetTextureAvatarShow(false)
	self.clubRoomsView:Show()
end

function hall_ui:UpdateClubRedState()
	if self.isShowClubRed or self.clubModel:CheckHasApplyHint() then
		self:setUIActive(self.sp_clubRedState,true)
	else
		self:setUIActive(self.sp_clubRedState,false)
	end
end

function hall_ui:UpdateRoomRedState(state)
	if self.clubModel.allClubRoomNums > 0 and state then
		self:setUIActive(self.roomRedIconGo,true)
	else
		self:setUIActive(self.roomRedIconGo,false)
	end
end

function hall_ui:SetShowClubRoomsViewFalse()
	isShowClubRoomsView = false
end

--------------------------------------更新用户信息-----------------------------------------
function hall_ui:InitUserInfo()
	----仅用户首次进入大厅更新数据,其他时候走推送
	if not data_center.GetIsUpdateState() then
		return
	end
	
	data_center.SetIsUpdateState(false)
	local useinfo = data_center.GetLoginUserInfo()
	
	-- self:ShowEmailRedPoint(tonumber(allinfo["hasEmail"]) ~= 0)
	-- self:ShowActivityRedPoint(tonumber(allinfo.hasact) == 1)
	self:CheckHasNewMail()

	if self.nameLbl and useinfo.nickname then
		self.nameLbl.text = useinfo.nickname
	end
	if self.idLbl and useinfo.uid then
		self.idLbl.text = "ID:"..useinfo.uid
	end
	if self.cardLbl and useinfo.card then
		self.cardLbl.text = useinfo.card or 0
	end
	if self.tex_photo then 
		HeadImageHelper.SetImage(self.tex_photo)
	end

	--设置极光推送UID
	if useinfo.uid then
		YX_APIManage.Instance:onPushUID("push_"..useinfo.uid)
	end
end

----------------------------------接收推送消息更新数据-------------------------------------
function hall_ui:UpdateInfo(accountData)
	if self.cardLbl and accountData then
		self.cardLbl.text = accountData.card or 0
	end
end

--------------------------------------按钮相关逻辑----------------------------------------- 

function hall_ui:OpenPersonInfoUI()
	if isClicked == true then
		UI_Manager:Instance():FastTip(LanguageMgr.GetWord(10100))
		return
    else
		isClicked = true
		Timer.New(function() isClicked = false end,1,1):Start()
    end
  
	ui_sound_mgr.PlaySoundClip(data_center.GetAppConfDataTble().appPath.."/sound/common/audio_button_click")
	local uid = data_center.GetLoginUserInfo().uid	
	UI_Manager:Instance():ShowUiForms("personInfo_ui",UiCloseType.UiCloseType_CloseNothing,nil,uid,true)	  
end

function hall_ui:OpenShareUI()
	if isClicked == true then
		UI_Manager:Instance():FastTip(LanguageMgr.GetWord(10100))
		return
    else
		isClicked = true
		Timer.New(function() isClicked = false end,1,1):Start()
    end
	
    ui_sound_mgr.PlaySoundClip(data_center.GetAppConfDataTble().appPath.."/sound/common/audio_button_click")
    report_sys.EventUpload(7)
	UI_Manager:Instance():ShowUiForms("share_ui",UiCloseType.UiCloseType_CloseNothing)
end

function hall_ui:OpenWebGameUI()
	local url = Utils.GetGuessUrl()
	jumpHelper.JumpToUrl(url,false)
	ui_sound_mgr.PlaySoundClip(data_center.GetAppConfDataTble().appPath.."/sound/common/audio_button_click")
end

function hall_ui:OpenActivityUI()
	if isClicked == true then
		UI_Manager:Instance():FastTip(LanguageMgr.GetWord(10100))
		return
    else
		isClicked = true
		Timer.New(function() isClicked = false end,1,1):Start()
    end
	
    ui_sound_mgr.PlaySoundClip(data_center.GetAppConfDataTble().appPath.."/sound/common/audio_button_click")
	report_sys.EventUpload(9)
	UI_Manager:Instance():ShowUiForms("activity_ui",UiCloseType.UiCloseType_CloseNothing)
end

function hall_ui:OpenShopUI()  
    ui_sound_mgr.PlaySoundClip(data_center.GetAppConfDataTble().appPath.."/sound/common/audio_button_click")
    UI_Manager:Instance():ShowUiForms("shop_ui")
end

function hall_ui:OpenRecordUI()
	ui_sound_mgr.PlaySoundClip(data_center.GetAppConfDataTble().appPath.."/sound/common/audio_button_click")
	UI_Manager:Instance():ShowUiForms("record_ui")
end

function hall_ui:OpenFeedbackUI()
   ui_sound_mgr.PlaySoundClip(data_center.GetAppConfDataTble().appPath.."/sound/common/audio_button_click")
   report_sys.EventUpload(4)
   UI_Manager:Instance():ShowUiForms("feedback_ui",UiCloseType.UiCloseType_CloseNothing)
end

function hall_ui:OpenCreateRoomUI()
	if not self.clubModel:HasClub() then
		UI_Manager:Instance():FastTip("请先加入一个俱乐部")
		return
	end
    ui_sound_mgr.PlaySoundClip(data_center.GetAppConfDataTble().appPath.."/sound/common/audio_button_click")
	 report_sys.EventUpload(23)
	 UIManager:ShowUiForms("openroom_ui",nil,nil,nil)--self.clubModel.officalClubList[1])
end

function hall_ui:OpenSettingUI()
	if isClicked == true then
		UI_Manager:Instance():FastTip(LanguageMgr.GetWord(10100))
		return
    else
		isClicked = true
		Timer.New(function() isClicked = false end,1,1):Start()
    end
	
	ui_sound_mgr.PlaySoundClip(data_center.GetAppConfDataTble().appPath.."/sound/common/audio_button_click")
	report_sys.EventUpload(1)
	UI_Manager:Instance():ShowUiForms("setting_ui",UiCloseType.UiCloseType_CloseNothing)
end

function hall_ui:OpenMailUI()
	if isClicked == true then
		UI_Manager:Instance():FastTip(LanguageMgr.GetWord(10100))
		return
    else
		isClicked = true
		Timer.New(function() isClicked = false end,1,1):Start()
    end
	
	ui_sound_mgr.PlaySoundClip(data_center.GetAppConfDataTble().appPath.."/sound/common/audio_button_click") 
	report_sys.EventUpload(3)
	UI_Manager:Instance():ShowUiForms("mail_ui",UiCloseType.UiCloseType_CloseNothing)
end

function hall_ui:OpenJoinRoomUI()	
	if isClicked == true then
		UI_Manager:Instance():FastTip(LanguageMgr.GetWord(10100))
		return
    else
		isClicked = true
		Timer.New(function() isClicked = false end,1,1):Start()
    end
	
    ui_sound_mgr.PlaySoundClip(data_center.GetAppConfDataTble().appPath.."/sound/common/audio_button_click")
    report_sys.EventUpload(24)
	UI_Manager:Instance():ShowUiForms("joinRoom_ui",UiCloseType.UiCloseType_CloseNothing)
end

function hall_ui:OpenCertificationUI()
	if isClicked == true then
		UI_Manager:Instance():FastTip(LanguageMgr.GetWord(10100))
		return
    else
		isClicked = true
		Timer.New(function() isClicked = false end,1,1):Start()
    end
	ui_sound_mgr.PlaySoundClip(data_center.GetAppConfDataTble().appPath.."/sound/common/audio_button_click")
	report_sys.EventUpload(5)
	UI_Manager:Instance():ShowUiForms("certification_ui",UiCloseType.UiCloseType_CloseNothing)
end

function hall_ui:OpenManagementUI()
	ui_sound_mgr.PlaySoundClip(data_center.GetAppConfDataTble().appPath.."/sound/common/audio_button_click")
	local infoTbl = http_request_interface.GetTable()
	if not infoTbl then
		return
	end
	local LoginModel = model_manager:GetModel("LoginModel")
	if not LoginModel then
		return
	end
	local reqUrl = LoginModel.clubagenturl --"http://intest.dstars.cc/club/youxianqipai/club/index.html"
	if reqUrl then
		reqUrl = reqUrl.."?appid="..global_define.appConfig.appId .."&session_key="..infoTbl.session_key
		if tostring(Application.platform) == "WindowsEditor" then
			Application.OpenURL(reqUrl)
		else
			jumpHelper.JumpToUrl(reqUrl,true)
			--[[local webpage= SingleFullWeb.Instance:InitWebPage(reqUrl, -1,-1, -1,-1, true)
			if webpage then
				webpage:Show()
			end--]]
		end
	end
end

function hall_ui:OpenClubUI()
	if self.isShowClubRed then
		self.isShowClubRed = false
		self:UpdateClubRedState()
	end
	 UI_Manager:Instance():ShowUiForms("ClubUI")
end

function hall_ui:CheckHasNewMail()
	mail_data.ReqMailData(function() 
		self:ShowEmailRedPoint(not mail_data.CheckAllRead())
	end)
end


---------------------------------------外部接口---------------------------------------------

function hall_ui:ShowFeedBackRedPoint(status)
	local sp_red = child(self.btnGo_feedback.transform,"sp_red")
	self:setUIActive(sp_red,status)
end

function hall_ui:ShowEmailRedPoint(status)
	local sp_red = child(self.btnGo_mail.transform,"sp_red")
	self:setUIActive(sp_red,status)
end

function hall_ui:ShowActivityRedPoint(status)
	local sp_red = child(self.btnGo_active.transform,"sp_red")
	self:setUIActive(sp_red,status)
end

function hall_ui:SetAuthShow(_show)
	isShowAuth = _show
	self:setUIActive(self.btnGo_auth,isShowAuth)
	self.btnGrid_topRight:Reposition()
end

function hall_ui:ShowClub()
	if not self.clubModel:HasClub() then
		return
	end
	if self.iKind ~= HallUIKind.club then
		self:OpenUI(HallUIKind.club)
	else
		--self.clubRoomsView:UpdateDatas()
	end
end

function hall_ui:ShowActivity()
	-- 是否弹出活动界面
	local is_pop = model_manager:GetModel("LoginModel").is_pop
	if is_pop ==1 then
	    if game_scene.getCurSceneType() ~= scene_type.GAME then
			  UI_Manager:Instance():ShowUiForms("activity_ui", nil, nil, true)
	    end
		model_manager:GetModel("LoginModel").is_pop = 0
	end	
end

return hall_ui

