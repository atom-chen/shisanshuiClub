local base = require "logic/framework/ui/uibase/ui_view_base"
local BaseClass = class("WebComponent", base)

function BaseClass:ctor(_go, _url, _callback)
  base.ctor(self, _go)
  self._callback = _callback

  if not self._webView then
    if self.gameObject then
      local webViewBg = self:GetComponent("Sprite", typeof(UISprite))
      if webViewBg then
        local webViewPos = webViewBg.transform.position
        -- print("webViewPos0000-----", webViewPos.x,webViewPos.y, webViewBg.width,webViewBg.height)
        -- print("Screen-----", Screen.width,Screen.height)
        local camera = UICamera.currentCamera 
        if camera == nil then
          camera = GameObject.Find("uiroot_xy/Camera"):GetComponent(typeof(Camera))
        end
        local screenPos = camera:WorldToScreenPoint(webViewPos)

        local designWidth = 1280
        local designHeight = 720
        local screenProportion = 1
        local isBig177 = (Screen.width/Screen.height) >(designWidth/designHeight) --特宽屏
        if isBig177 then
          screenProportion = Screen.height/designHeight
          -- designHeight = (designWidth *Screen.height)/Screen.width
        else
          screenProportion = Screen.width/designWidth
          -- designWidth = (designHeight *Screen.width)/Screen.height
        end
        local webViewBgWidth = webViewBg.width *screenProportion
        local webViewBgHeight = webViewBg.height *screenProportion

        --左下
        local webPosL = screenPos.x -webViewBgWidth/2
        local webPosB = screenPos.y -webViewBgHeight/2
        --右上
        local webPosR = Screen.width -(webPosL +webViewBgWidth)
        local webPosT = Screen.height -(webPosB +webViewBgHeight)

        -- if isBig177 then
          local vWidth = designWidth/Screen.width
          local vHeight = designHeight/Screen.height
          webPosL = webPosL *vWidth
          webPosR = webPosR *vWidth
          webPosB = webPosB *vHeight
          webPosT = webPosT *vHeight
        -- end
        -- _url = "https://www.baidu.com"

        -- print("webViewPos1111-----", designWidth, designHeight, screenPos.x, screenPos.y, screenProportion, isBig177)
        -- print("webViewPos-----", webPosT,webPosB, webPosL,webPosR)
        -- print("InitWebPage:", _url)
		
		
		local infoTbl = http_request_interface.GetTable()
        local userInfo = data_center.GetLoginUserInfo()
        local param
        local url = "http://intest1.dstars.cc/minigame/web/index.html?token="
        if infoTbl and userInfo then
          param = {}
          param.sessionKey = infoTbl.session_key 
          param.nickname = userInfo.nickname
          param.heading = userInfo.imageurl
          param.sex = userInfo.sex
          param.card = userInfo.card
          local jsonStr = CombinJsonStr(param)
          url = url .. jsonStr
          Trace("request------------url---------" .. url)
        end	
		
		
		_url = "http://intest1.dstars.cc/minigame/web/index.html";
        self._webView = SingleWeb.Instance:InitWebPage(url or "https://www.baidu.com", webPosT,webPosB, webPosL,webPosR)
      end
    end
  end
end
function BaseClass:OnInit()
  -- Trace("WebComponent---OnInit---")
end
function BaseClass:OnOpen(data)
  -- Trace("WebComponent---OnOpen---")
end
function BaseClass:OnHide()
  self:Show(false)
end

function BaseClass:Show()
  if self.gameObject then
    -- self.gameObject:SetActive(true)

    if self._webView then
      self._webView:Show()
    end
  end
end
function BaseClass:Hide()
  if self.gameObject then
    -- self.gameObject:SetActive(false)
    if self._webView then
      self._webView:Hide()
    end
  end
end

-------------页面委托事件添加-------------------
function BaseClass:AddCompleteFunction(_fun)
  if self._webView and _fun then
    self._webView.complete = function(webView,success,errorMessage) 
      _fun(webView,success,errorMessage)
    end
  end
end

function BaseClass:AddReceiveFunction(_fun)
  if self._webView and _fun then
    self._webView.receive = function(webView,message) 
      _fun(webView,message)
    end
  end
end

return BaseClass
