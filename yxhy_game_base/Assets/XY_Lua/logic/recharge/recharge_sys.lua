require "logic/recharge/rechargeConfig"
recharge_sys = {}
local this = recharge_sys
-- "stype":支付平台类型(1微信2支付宝3爱贝4UC5腾讯6笨手机8百度),

function this.requestIAppPayOrder( stype,pid,pnum,proParam)
  Trace("requestIAppPayOrder:"..stype..","..pid..","..pnum..","..proParam)
  
  if not stype or not pid then return end

  -- 刷新房卡
  local freshRCardFun = function()
      http_request_interface.getAccount("", function(str)
        local s=string.gsub(str,"\\/","/")
        Trace("getAccount callback =="..s)
        local t=ParseJsonStr(s)
        if t.ret and tonumber(t.ret) == 0 then
          -- 刷新当前携带货币数量
          if t.account and t.account.card then
            Notifier.dispatchCmd(cmdName.MSG_ROOMCARD_REFRESH, t.account)
          end
        end
      end)
  end

  http_request_interface.GetPayOrder(stype,pid,pnum,function (str )
    local s=string.gsub(str,"\\/","/")  
        local t=ParseJsonStr(s)
        Trace("requestIAppPayOrder  callback ==".. s);
        if t.ret == 0 then -- 下单成功
          if stype == rechargeConfig.IAppPay then
            if t.transid then
              YX_APIManage.Instance:startIAppPay(tostring(t.transid),function ( msg )
                Trace("requestIAppPayOrder  callback success startIAppPay  " ..  msg);
                --{"ret":0,"account":{"uid":5647672,"diamond":0,"card":100000,"coin":5000000,"vip":0,"safecoin":0,"bankrupt":0,"bankruptc":0,"feewin":0,"feelose":0}}
                http_request_interface.getAccount("",function (str )
                    local s=string.gsub(str,"\\/","/")
                    Trace("getAccount callback =="..s)
                    local t=ParseJsonStr(s)
                    if t.ret == 0 then
                      -- 刷新当前携带货币数量


                    end
                  end)
                local msgT=ParseJsonStr(msg)
                if msgT.result == 0 then
                  
                else

                end

              end)
            end

          elseif stype == rechargeConfig.Douyou8 then
              
              --proParam:money
              local money = math.floor(tonumber(proParam))
              YX_APIManage.Instance:douYouPay(money, tostring(t.pid),function(msg)
                Trace("requestIAppPayOrder douYouPay  " ..  msg)
                --{"ret":0,"account":{"uid":5647672,"diamond":0,"card":100000,"coin":5000000,"vip":0,"safecoin":0,"bankrupt":0,"bankruptc":0,"feewin":0,"feelose":0}}

                freshRCardFun()

                local msgT=ParseJsonStr(msg)
                if msgT and tonumber(msgT.result) == 0 then
                  
                else

                end
              end)

          elseif stype == rechargeConfig.AppleStore then
              
              -- waiting_ui.Show(true)
              UI_Manager:Instance():ShowUiForms("waiting_ui")

              --proParam:productID
              YX_APIManage.Instance:applePay(proParam,function(msg)

                if msg and string.len(msg) >0 then
                  local curPid = t.pid
                  local receipt = msg
                  Trace("applePay success " ..curPid ..", " ..msg)

                  --支付succeed
                  http_request_interface.iosPay(curPid, receipt, function(str)

                      freshRCardFun()
                    end)
                else
                  Trace("applePay failed")
                end

                -- waiting_ui.Hide()
                UI_Manager:Instance():CloseUiForms("waiting_ui")
              end)
          end

                    
        else

        end
  end)
end