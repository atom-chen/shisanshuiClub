--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--endregion
local base = require("logic.framework.ui.uibase.ui_window")
local setting_ui = class("setting_ui", base) 

function setting_ui:ctor()
	base.ctor(self)
    self.destroyType = UIDestroyType.Immediately
end

function setting_ui:OnInit()
	self:InitView()
end

function setting_ui:OnOpen()
	self:UpdateView()
end

function setting_ui:OnRefreshDepth()
    local uiEffect = child(self.gameObject.transform, "setting_panel/Panel_Top/Title/Effect_youxifenxiang")
    if uiEffect and self.sortingOrder then
        local topLayerIndex = self.sortingOrder +self.m_subPanelCount +1
        Utils.SetEffectSortLayer(uiEffect.gameObject, topLayerIndex)
    end
end

function setting_ui:InitView()	
	local btn_close = child(self.gameObject.transform,"setting_panel/Panel_Top/btn_close")
    if btn_close ~= nil then
        addClickCallbackSelf(btn_close.gameObject,self.CloseWin,self)
    end 
	
	local Panel_Middle = child(self.gameObject.transform,"setting_panel/Panel_Middle")	
    self.toggle_music = child(Panel_Middle,"Left/toggle/toggle_music")
    if self.toggle_music ~= nil then
        componentGet(self.toggle_music,"UIToggle").value = tonumber(hall_data.playerprefs.music) == 1
        addClickCallbackSelf(self.toggle_music.gameObject,self.MusicClick,self)
    end
    self.toggle_musiceffect = child(Panel_Middle,"Left/toggle/toggle_musiceffect")
    if self.toggle_musiceffect ~= nil then
        addClickCallbackSelf(self.toggle_musiceffect.gameObject,self.MusicEffectClick,self) 
        componentGet(self.toggle_musiceffect,"UIToggle").value = tonumber(hall_data.playerprefs.musiceffect) == 1
    end
    self.toggle_shake = child(Panel_Middle,"Left/toggle/toggle_shake")
    if self.toggle_shake ~= nil then
        addClickCallbackSelf(self.toggle_shake.gameObject,self.ShakeClick,self)
        componentGet(self.toggle_shake,"UIToggle").value = tonumber(hall_data.playerprefs.shake) == 1
    end
	local btn_rule = child(Panel_Middle,"Left/btn_rule")
	if btn_rule then
        addClickCallbackSelf(btn_rule.gameObject,self.OpenRuleClick,self)
    end
	
	self.grid_pokerTable = child(Panel_Middle,"Right/PokerDeskCloth/ScrollView/GridTable")
	for i=1,self.grid_pokerTable.transform.childCount do
        local btn_t = self.grid_pokerTable.transform:GetChild(i-1)
        if btn_t then
            addClickCallbackSelf(btn_t.gameObject,self.ChangeDesk,self)
        end
    end
	self.grid_mjTable = child(Panel_Middle,"Right/MJDeskCloth/ScrollView/GridTable")
	for i=1,self.grid_mjTable.transform.childCount do
        local btn_t = self.grid_mjTable.transform:GetChild(i-1)
        if btn_t then
            addClickCallbackSelf(btn_t.gameObject,self.ChangeDesk,self)
        end
    end
	
	local Panel_Bottom = child(self.gameObject.transform,"setting_panel/Panel_Bottom")
    local btn_mzsm = child(Panel_Bottom,"btn_mzsm")
    if btn_mzsm ~= nil then
        addClickCallbackSelf(btn_mzsm.gameObject,self.OpenMZSM,self)
    end
    local btn_fwtk = child(Panel_Bottom,"btn_fwtk")
    if btn_fwtk ~= nil then
        addClickCallbackSelf(btn_fwtk.gameObject,self.OpenFWTK,self)
    end
    local btn_yszc = child(Panel_Bottom,"btn_yszc")
    if btn_yszc ~= nil then
        addClickCallbackSelf(btn_yszc.gameObject,self.OpenYSZC,self)
    end

    self.versionLabel = self:GetComponent("setting_panel/Panel_Bottom/versionLabel", typeof(UILabel))
    self.versionLabel.text = "当前版本：V"..data_center.GetVerCommInfo().versionNum
end

function setting_ui:UpdateView()
	self:UpdateTableCloth()
	self:MusicClick(self.toggle_music)
    self:MusicEffectClick(self.toggle_musiceffect)
    self:ShakeClick(self.toggle_shake) 
end

function setting_ui:ChangeDesk(obj2) 
    local s = string.split(obj2.name,"_")
	if tonumber(s[2]) <= 10 then
		hall_data.SetPlayerPrefs("desk",s[2])
	else
		PlayerPrefs.SetString("poker_desk", s[2]-10)
	end
    Notifier.dispatchCmd(cmdName.MSG_CHANGE_DESK) 
    PlayerPrefs.Save()
end

function setting_ui:UpdateTableCloth()
	local mjIndex = 1
	local pokerIndex = 11
	
	if  PlayerPrefs.HasKey("desk") then
		mjIndex = tonumber(hall_data.GetPlayerPrefs("desk"))
	end
	if  PlayerPrefs.HasKey("poker_desk") then
		pokerIndex = tonumber(hall_data.GetPlayerPrefs("poker_desk")) + 10
	end
	if tonumber(mjIndex) > 0 then
		local select_item = child(self.grid_mjTable,"btn_"..mjIndex)
		componentGet(select_item.gameObject,"UIToggle").value = true
	end
	
	if tonumber(pokerIndex) > 0 then
		local select_item = child(self.grid_pokerTable,"btn_"..pokerIndex)
		componentGet(select_item.gameObject,"UIToggle").value = true
	end
end

function setting_ui:OpenMZSM() 
    ui_sound_mgr.PlayButtonClick()
	UI_Manager:Instance():ShowUiForms("textView_ui",UiCloseType.UiCloseType_CloseNothing,nil,3)
end

function setting_ui:OpenFWTK() 
    ui_sound_mgr.PlayButtonClick()
	UI_Manager:Instance():ShowUiForms("textView_ui",UiCloseType.UiCloseType_CloseNothing,nil,1)
end

function setting_ui:OpenYSZC() 
    ui_sound_mgr.PlayButtonClick()
	UI_Manager:Instance():ShowUiForms("textView_ui",UiCloseType.UiCloseType_CloseNothing,nil,2)
end

function setting_ui:MusicClick(obj2)
    local value = componentGet(obj2.gameObject,"UIToggle").value
    if value then  
        ui_sound_mgr.controlValue(0.5) 
        hall_data.SetPlayerPrefs("music", "1")
    else 
        ui_sound_mgr.controlValue(0)
        hall_data.SetPlayerPrefs("music", "0")
    end
    PlayerPrefs.Save() 
end

function setting_ui:MusicEffectClick(obj2)
    local value = componentGet(obj2.gameObject,"UIToggle").value
    if value then 
        ui_sound_mgr.ControlCommonAudioValue(0.5) 
        hall_data.SetPlayerPrefs("musiceffect", "1")
    else
        ui_sound_mgr.ControlCommonAudioValue(0) 
        hall_data.SetPlayerPrefs("musiceffect", "0")
    end 
    PlayerPrefs.Save()
end

function setting_ui:ShakeClick(obj2)
    local value = componentGet(obj2.gameObject,"UIToggle").value
    if value then  
        hall_data.SetPlayerPrefs("shake", "1")
	else 
		hall_data.SetPlayerPrefs("shake", "0")
    end 
    PlayerPrefs.Save()
end

function setting_ui:OpenRuleClick()
	ui_sound_mgr.PlayButtonClick()
	if game_scene.getCurSceneType() == scene_type.HALL then
		UI_Manager:Instance():ShowUiForms("help_ui",UiCloseType.UiCloseType_CloseNothing)
	else
		UI_Manager:Instance():ShowUiForms("help_ui",UiCloseType.UiCloseType_CloseNothing,nil,player_data.GetGameId() or ENUM_GAME_TYPE.TYPE_SHISHANSHUI)
	end
end

function  setting_ui:CloseWin()	
    ui_sound_mgr.PlayCloseClick()
	UI_Manager:Instance():CloseUiForms("setting_ui")
end 

function setting_ui:OnClose()
	PlayerPrefs.Save()
end

return setting_ui