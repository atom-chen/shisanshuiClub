--[[--
 * @Description: 大厅UI控制
 * @Author:      shine
 * @FileName:    hall_ui_ctrl.lua
 * @DateTime:    2017-05-19 14:32:55
 ]]

hall_ui_ctrl = {}
local this = hall_ui_ctrl

local firstLogin = true
-- local loadDataCor = nil 

function this.Init()
    -- body
end

function this.UInit()
  -- if loadDataCor ~= nil then
  --   coroutine.stop(loadDataCor)
  --   loadDataCor = nil
  -- end    
end

--[[--
 * @Description: 加载完场景做的第一件事
 ]]
function this.HandleLevelLoadComplete()
  Trace("gs_mgr.state_main_hall-------------------------------")
  gs_mgr.ChangeState(gs_mgr.state_main_hall)
  map_controller.SetIsLoadingMap(false)

  --查询游戏重连状态
  if firstLogin then
      -- loadDataCor = coroutine.start(function ()
      --     this.OnGetClientConfig(data_center.GetClientConfData())
      -- end)
      firstLogin = false

      require "logic/gvoice_sys/gvoice_sys"
      if(not gvoice_sys.GetIsInit()) then
        if data_center.GetCurPlatform()  == "Android" or data_center.GetCurPlatform() == "IPhonePlayer" then
          gvoice_sys.GVoiceInit()   --语音服务初始化
        end
        --gvoice_engine = gvoice_sys.GetEngine()
      end
  end    

  --发一个通知出去告诉活动页面 大厅已经加载完成了
  Notifier.dispatchCmd(cmdName.SHOW_PAGE_HALL)
end
 