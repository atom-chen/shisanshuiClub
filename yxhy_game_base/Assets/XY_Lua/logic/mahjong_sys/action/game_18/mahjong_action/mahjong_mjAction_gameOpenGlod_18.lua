local base = require "logic.mahjong_sys.action.common.mahjong_action_base"
local mahjong_mjAction_gameOpenGlod_18 = class("mahjong_mjAction_gameOpenGlod_18", base)

function mahjong_mjAction_gameOpenGlod_18:Execute(tbl)
    Trace(GetTblData(tbl))
    local cardValue = tbl._para.nCard
    local isGold = tbl._para.bGold
    comp_show_base.curState = self.config.game_state.opengold
    roomdata_center.AddMj(cardValue)

    self.compTable:HideAllFlowerInTable(function ()
        if mahjong_anim_state_control.GetCurrentStateName() == MahjongGameAnimState.changeFlower then
            mahjong_anim_state_control.SetStateByName(MahjongGameAnimState.openGold)
        end 
        mahjong_anim_state_control.ShowAnimState(MahjongGameAnimState.openGold, 
            function()
                if isGold then
                    roomdata_center.SetSpecialCard(cardValue)
                else
                    roomdata_center.AddFlowerCardToZhuang(cardValue)
                end

                self:ShowJinAction(cardValue, isGold, true, function()
                    self.compPlayerMgr:GetPlayer(1):ShowSpecialInHand()
                    Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.MAHJONG_OPEN_GOLD)
                end)
            end, true)
    end)
    ui_sound_mgr.PlaySoundClip(mahjong_path_mgr.GetMjCommonSoundPath("kaijin"))
end

function mahjong_mjAction_gameOpenGlod_18:ShowJinAction( cardValue, isJin,isAnim, callback )

    local mj = self.compMjItemMgr.mjItemList[self.compTable.lastIndex]
    roomdata_center.UpdateRoomCard(-1)

    mj:SetMesh(cardValue)
    mj:SetState(MahjongItemState.other)

    if isJin then
        self.compTable.mjJin[1] = mj
        self.compTable.mjJin[1].mjObj.name = "jin"
    end


    --@todo  更新牌数量，self.lastIndex 
    if not isAnim then
        if isJin then
            mahjong_ui:ShowSpecialCard(cardValue,1,self.cfg.specialCardSpriteName)
            self.compTable.mjJin[1]:Show(true)
            self.compTable:UpdateJinPosition()
        else
            mj:HideAndReset()
        end
        return
    end
    local ShowJin_c = coroutine.start(function() 

        local originPos = mj.transform.localPosition
        local originScale = mj.transform.localScale
        local originEuler = mj.localEulers
        local originParent = mj.transform.parent

        self.compTable:MoveMjTo3DCenter(mj, 0.2)
        coroutine.wait(0.25)
        self.compTable:MoveMjTo2DCenter(mj, 0)

        coroutine.wait(0.5)

        -- 是金 则返回原位置
        if isJin then
            mj:Set3DLayer()
            mj:SetParent(originParent)
            mj.transform.localScale = originScale
            mj:DOLocalRotate(originEuler.x, originEuler.y, originEuler.z, 0)
            local x,y,z = originPos:Get()
            mj:DOLocalMove(x,y,z, 0)
            coroutine.wait(0.1)
            mj:Show(true, false)
            mahjong_ui:ShowSpecialCard(mj.paiValue,1,self.cfg.specialCardSpriteName)

        else
            self.compTable.lastIndex = self.compTable:GetNextLastIndex(self.compTable.lastIndex)
            self.compTable:DoHideHuaCardsToPoint({mj}, roomdata_center.zhuang_viewSeat, 0.2, nil, true)
            coroutine.wait(0.21)
        end

        if callback ~= nil then
            callback()
        end
    end)
    table.insert(self.compTable.ShowJin_c_List, ShowJin_c)
end

function mahjong_mjAction_gameOpenGlod_18:OnSync(jin,pos)
     if jin ~= nil then
        roomdata_center.SetSpecialCard(jin)
        self:ShowJinAction(jin, true)
        roomdata_center.AddMj(jin)
        self.compPlayerMgr:GetPlayer(1):ShowSpecialInHand()
    end
end

return mahjong_mjAction_gameOpenGlod_18