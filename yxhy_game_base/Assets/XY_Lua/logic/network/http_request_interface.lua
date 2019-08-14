--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
require "common/json" 
http_request_interface={}
local this=http_request_interface

local version = "1.1.2"
local uid = 0 
local session_key = 0 
local deviceid = 0 
local devicetype = 0  
local siteid = 0 
-- local timeStart=nil

function this.ErrorCodeHandler(dicID)
    -- waiting_ui.Hide()
    UI_Manager:Instance():CloseUiForms("waiting_ui")
    local time = nil
    if dicID == 8072 then
        time = 2
    end
    UI_Manager:Instance():FastTip(GetDictString(dicID), time)
end

function this.setUserInfo(Uid, Session_key, Deviceid, Devicetype, Siteid, Version)
    uid=Uid 
    session_key=Session_key 
    deviceid=Deviceid 
    devicetype=Devicetype 
    siteid=Siteid 

    if Version ~= nil and Version ~= "" then
        version=Version  
    end
end

function this.GetTable(method, param)
    -- 福州 --- siteid android 1 ios 1001 pc 3001
    if data_center.GetCurPlatform() ==  "WindowsEditor"   then
        siteid = 1
    elseif data_center.GetCurPlatform() == "Android" then
        siteid = 1
    elseif data_center.GetCurPlatform() == "IPhonePlayer" then
        siteid = 1001
    end

    local _version = data_center.GetVerCommInfo().versionNum    
    if (_version == nil) then
        _version = version
    end

    local t={["appid"]= global_define.appConfig.appId, ["uid"]=uid, ["session_key"]=session_key, ["siteid"]=siteid, ["version"]=_version, ["method"]=method,["deviceid"]=deviceid,["devicetype"]=devicetype,["param"]=param}   
    return t
end 

function this.fetchCheckTag( callback,isQuit )
    local t=this.GetTable("GameSAR.getFunFbd","") 
    local rt=json.encode(t)
    LogW("fetchCheckTag-------http url----",NetWorkManage.Instance.BaseUrl)
    LogW("fetchCheckTag-------http rt----",rt)
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end,nil,nil,nil,isQuit)
end

--获取个人游戏信息{"uid":113565,"type":1}
function this.getGameInfo(param,callback) 
    local t=this.GetTable("GameMember.getGameInfo",param) 
    local rt=json.encode(t)
    this.HttpPOSTRequest(rt,function (str)
        Trace("getGameInfo --------- " .. str)
        local s=string.gsub(str,"\\/","/")
        local retStr = ParseJsonStr(s)
        local ret = retStr.ret
        if ret ~= 0 then
            --101 102
            local dicID = nil
            if ret == 101 then
                dicID = 8011
            elseif ret == 102 then
                dicID = 8012
            else
                logError("ret code:".. ret)
            end
            if dicID ~= nil then
                this.ErrorCodeHandler(dicID)
            end
        else
            callback(str)
        end
    end) 
    Trace("-----------Finish_getGameInfo--------") 
end
  
--获取分享配置
function this.GetShareConfig( param,callback )
    local t=this.GetTable("GameShare.getGameShare",param)
    local rt=json.encode(t) 
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end) 
    Trace("-----------Finish_GetShareConfig--------") 
end

--设置游戏配置 param: (string)    "1|1|1"
function  this.setting(param,callback) 
    local t=this.GetTable("GameMember.setting",param) 
    local rt=json.encode(t)
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end) 
    Trace("-----------Finish_setting--------") 
end

function this.delEmail(param,callback)
    local t=this.GetTable("GameEmail.delEmail",param) 
    local rt=json.encode(t)
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end)
end

--用户反馈 param:   (string)    "我的金币丢了"
function  this.feedBack(param,callback)
    local t=this.GetTable("GameTools.feedBack",param)  
    local rt=json.encode(t) 
    this.HttpPOSTRequest(rt, function (str)
        callback(str)
    end) 
    Trace("-----------Finish_feedBack--------") 
end



--获得用户反馈信息列表 param: (string)    
function  this.getFeedBack(param,callback)
    local t=this.GetTable("GameTools.getFeedBack",param)  
    local rt=json.encode(t)
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end, true) 
    Trace("-----------Finish_getFeedBack--------") 
end



--修改用户资料 {"nickname":用户呢称,有修改就传,没修改传空,"sex":用户性别,有修改就传,没修改传空,0未知,1男2女}
function  this.actUser(nickname,sex,callback)
    local param={["nickname"]=nickname,["sex"]=sex} 
    local t=this.GetTable("GameMember.actUser",param)
    local rt=json.encode(t)  
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end) 
    Trace("-----------Finish_actUser--------") 
end



--根据uid获得验证码 {"mtype":2忘记保险箱密码,"stype":发送类型（0手机1邮箱)}
function  this.getValidByUid(mtype,stype,callback)
    local param={["mtype"]=mtype,["stype"]=stype}
    local t=this.GetTable("GameTools.getValidByUid",param)
    local rt=json.encode(t)
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end) 
    Trace("-----------Finish_getValidByUid--------") 
end



--获得用户详细信息 {"uid":用户id,"gid":游戏id}
function  this.getUserInfo(uid,gid,callback)
    local param={["uid"]=uid,["gid"]=gid}
    local t=this.GetTable("GameMember.getUserInfo", param)
    local rt=json.encode(t) 
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end) 
    Trace("-----------Finish_getUserInfo--------") 
end


--获得系统时间
function  this.sysTime(param,callback) 
    local t=this.GetTable("GameMember.sysTime",param)
    local rt=json.encode(t)
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end) 
    Trace("-----------Finish_sysTime--------") 
end

 
--用户设置头像{"imagetype":用户头像类型(1系统2自定义),"imageurl":"用户头像地址"}
function  this.setImage(imagetype, imageurl, callback)
    local param={["imagetype"]=imagetype, ["imageurl"]=imageurl}
    local t=this.GetTable("GameMember.setImage", param)
    local rt=json.encode(t)
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end) 
    Trace("-----------Finish_setImage--------") 
end



--获得用户头像[用户id,用户id,用户id.....][6,7,8]
function  this.getImage(param, callback) 
    local t=this.GetTable("GameMember.getImage", param)
    local rt=json.encode(t)
    this.HttpPOSTRequest(rt, function (str)
        local str = string.gsub(str, "\\/", "/")
        local retStr = ParseJsonStr(str)
        local ret = retStr.ret
        if ret ~= 0 then
            logError("ret code:".. ret)
        else
            callback(str)
        end 
    end) 
    Trace("-----------Finish_getImage--------") 
end


--{"share_uid":"分享用户ID","rtype":第三方注册类型(2微信 3QQ 4ucgame 5ysdk微信 6ysdkQQ 7笨手机 8富豪 9游客 10奇酷),"openid":微信code,"access_token":token,"logintime":登陆时间,"subrtype":"code 或者 openid"}
function  this.otherLogin(rtype,openid,access_token,logintime,subrtype,share_uid,callback,isQuit)
    local param={["rtype"]=rtype,["openid"]=openid,["access_token"]=access_token,["logintime"]=logintime,["subrtype"]=subrtype,["share_uid"] = share_uid} 
    --local param={["rtype"]=2,["openid"]="oBR9e00iHFrB3gypQf5mRyq_-ljs",["access_token"]=access_token,["logintime"]=logintime,["subrtype"]="openid",["share_uid"] = share_uid} 
    local t=this.GetTable("GameMember.otherLogin", param) 
    --logError(GetTblData(t))
    local rt=json.encode(t) 
    Trace("http_request_interface------" .. rt)
    --logError(rt)
    this.HttpPOSTRequest(rt, function (str,code, msg)
        Trace("otherLogin------" .. str)
        if code == 0 then
            local str = string.gsub(str, "\\/", "/")
            local retStr = ParseJsonStr(str)
            local ret = retStr.ret
            Trace(str)
            if ret ~= 0 then
                if ret == 100 then
                    UI_Manager:Instance():FastTip("此账号不允许登录，请联系客服")
                elseif ret == 999 then 
                    UI_Manager:Instance():FastTip("账号已被封停，登录游戏失败")
                else
                    logError("ret code:".. ret, str)
                end
            else
                callback(code,msg,str)
            end 
        end

    end,nil,nil,nil,isQuit) 
    Trace("-----------Finish_otherLogin--------") 
end
 

--第三方账号绑定手机号或者邮箱{"uno":"手机或者邮箱","verify":验证码}
function  this.otherBind(uno,verify,callback)
    local param={["uno"]=uno,["verify"]=verify} 
    local t=this.GetTable("GameMember.otherBind",param) 
    local rt=json.encode(t)  
    this.HttpPOSTRequest(rt,function (str)
        local retStr = ParseJsonStr(str)
        local ret = retStr.ret
        if ret ~= 0 then
            --100 101
            local dicID = nil
            if ret == 100 then
                dicID = 8021
            elseif ret == 101 then
                dicID = 8022
            else
                logError("ret code:".. ret)
            end
            if dicID ~= nil then
                this.ErrorCodeHandler(dicID)
            end
        else
            callback(str)
        end
    end) 
    Trace("-----------Finish_otherBind--------") 
end


--ysdk查询余额{"openid":openid,"access_token":pay_token,"openkey":openkey,"pf":"pf","pfkey":pfkey,"accout_type":qq或者wx}
function  this.getBalanceM(openid,access_token,openkey,pf,pfkey,accout_type,callback)
    local param={["openid"]=openid,["access_token"]=access_token,["openkey"]=openkey,["pf"]=pf,["pfkey"]=pfkey,["accout_type"]=accout_type}
    local t=this.GetTable("GameMember.getBalanceM",param)
    local rt=json.encode(t) 
    this.HttpPOSTRequest(rt,function (str)
        local retStr = ParseJsonStr(str)
        local ret = retStr.ret
        if ret ~= 0 then
            --100 101
            local dicID = nil
            if ret == 100 then
                dicID = 8031
            elseif ret == 110 then
                dicID = 8032
            else
                logError("ret code:".. ret)
            end
            if dicID ~= nil then
                this.ErrorCodeHandler(dicID)
            end
        else
            callback(str)
        end
    end) 
    Trace("-----------Finish_getBalanceM--------") 
end



--验证身份证{"name":"姓名","id_no":"身份证号"}
function  this.idCardVerify(name,id_no,callback)
    local param={["name"]=name,["id_no"]=id_no}
    local t=this.GetTable("GameMember.idCardVerify",param)
    local rt=json.encode(t)
    this.HttpPOSTRequest(rt,function (str)
        local retStr = ParseJsonStr(str)
        local ret = retStr.ret
        if ret ~= 0 then
            --100 101 102
            local dicID = nil
            if ret == 100 then
                dicID = 8041
            elseif ret == 101 then
                dicID = 8042
            elseif ret == 102 then
                dicID = 8043
            else
                logError("ret code:".. ret)
            end
            if dicID ~= nil then
                this.ErrorCodeHandler(dicID)
            end
        else
            callback(str)
        end
    end) 
    Trace("-----------Finish_idCardVerify--------") 
end





--获得账户信息null
function  this.getAccount(param,callback) 
    local t=this.GetTable("GameMember.getAccount",param)
    local rt=json.encode(t)
    this.HttpPOSTRequest(rt,function (str)
        local str = string.gsub(str, "\\/", "/")
        local retStr = ParseJsonStr(str)
        local ret = retStr.ret
        if ret ~= 0 then
            logError(str)
        else
            if callback ~= nil then
                callback(str)
            end
        end
    end) 
    Trace("-----------Finish_getAccount--------") 
end




--是否填写过身份 null
function  this.checkIdCard(param, callback) 
    local t=this.GetTable("GameMember.checkIdCard", param) 
    local rt=json.encode(t)
    this.HttpPOSTRequest(rt, function (str)
        local retStr = ParseJsonStr(str)
        local ret = retStr.ret
        if ret ~= 0 then
            --100 101
            local dicID = nil
            if ret == 100 then
                dicID = 8051
            elseif ret == 101 then
                --dicID = 8052
            else
                logError("ret code:".. ret)
            end
            if dicID ~= nil then
                this.ErrorCodeHandler(dicID)
            end
        else
            if callback ~= nil then
                callback(str)
            end
        end
    end) 
    Trace("-----------Finish_checkIdCard--------") 
end


--获得客户端配置 null
function  this.getClientConfig(param, callback,isQuit) 
    local t = this.GetTable("GameSAR.getClientConfig", param) 
    local rt = json.encode(t)
    this.HttpPOSTRequest(rt, function (str)
        callback(str)
    end,nil,nil,nil,isQuit) 
    Trace("-----------Finish_getClientConfig--------"..rt)
end


--获取房间列表{gid:游戏ID}
function this.getRoomListByGid(param,callback)
    local t=this.GetTable("GameSAR.getRoomListByGid",param) 
    local rt=json.encode(t)
    -- waiting_ui.Show()
    UI_Manager:Instance():ShowUiForms("waiting_ui")
    this.HttpPOSTRequest(rt,function (str)
        -- waiting_ui.Hide()
        UI_Manager:Instance():CloseUiForms("waiting_ui")
        if code == -1 then
            UI_Manager:Instance():FastTip(GetDictString(6015))
        else 
            callback(str)
        end 
    end)
    Trace("-----------Finish_getRoomListByGid--------")
end

--快速入座{gid:游戏ID}
function this.roomFastEnter(param,callback)
    local t=this.GetTable("GameSAR.roomFastEnter",param) 
    local rt=json.encode(t)
    this.HttpPOSTRequest(rt,function (str)
        local str = string.gsub(str, "\\/", "/")
        local retStr = ParseJsonStr(str)
        local ret = retStr.ret
        if ret ~= 0 then
            --101
            local dicID = nil
            if ret == 101 then
                dicID = 8061
            else
                logError("ret code:".. ret)
            end
            if dicID ~= nil then
                this.ErrorCodeHandler(dicID)
            end
        else
            callback(str)
        end
    end)
    Trace("-----------Finish_roomFastEnter--------")
end


--开房{"gid":游戏id,"rounds":局数,"pnum",人数,"hun",混牌,"hutype":胡牌,"wind":风牌,"lowrun":下跑,"gangrun":杠跑,"dealeradd":庄家加底,"gfadd":杠上花加倍,"spadd":七对加倍}
function  this.createRoom(param, callback) 
   -- local param={["gid"]=gid,["rounds"]=rounds,["pnum"]=pnum,["hun"]=hun,["hutype"]=hutype,["wind"]=wind,["lowrun"]=lowrun,["gangrun"]=gangrun,["dealeradd"]=dealeradd,["gfadd"]=gfadd,["spadd"]=spadd} 
    local t=this.GetTable("GameSAR.createRoom",param)  
    local rt=json.encode(t)
    Trace ("createroom:  "..tostring(rt))
    this.HttpPOSTRequest(rt,function (str)
        callback(str) 
    end) 
    Trace("-----------Finish_createRoom--------") 
end

function this.createClubRoom(param, callback)
    local t=this.GetTable("GameClub.createClubRoom",param)  
    local rt=json.encode(t)
    Trace ("createroom:  "..tostring(rt))
    this.HttpPOSTRequest(rt,function (str)
        callback(str) 
    end) 
end

--获得用户已开房间列表 {"gid":游戏id,"status":状态0已开房1已开局2已结算,"page":第几页,从0开始}
function  this.getGameRoomList(gid,status,page,callback) 
    local param={["gid"]=gid,["status"]=status,["page"]=page}
    local t=this.GetTable("GameSAR.getGameRoomList",param) 
    local rt=json.encode(t)  
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end) 
    Trace("-----------Finish_getGameRoomList--------") 
end

function this.getRoomSimpleList(gid,status,page,callback)
    local param={["gid"]=gid,["status"]=status,["page"]=page}
    local t=this.GetTable("GameSAR.getRoomSimpleList",param) 
    local rt=json.encode(t)  
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end) 
    Trace("-----------Finish_getGameRoomList--------")     
end

-- 根据房号查找房间信息{"gid":游戏id,"rno":房号}
function  this.getRoomByRno(rno, callback, dontShowWaiting)
    local param={["rno"]=rno}
    local t=this.GetTable("GameSAR.getRoomByRno", param)     
    local rt=json.encode(t)
    -- waiting_ui.Show()
    if not dontShowWaiting then
        UI_Manager:Instance():ShowUiForms("waiting_ui")
    end
    this.HttpPOSTRequest(rt, function (str)
        -- waiting_ui.Hide()
        UI_Manager:Instance():CloseUiForms("waiting_ui")
		callback(str)
    end) 

    Trace("-----------Finish_getRoomByRno--------")
end

--根据房id查找房间信息 {"rid":房号}
function  this.getRoomByRid(rid,rank,callback) 
    local param={["rid"]=rid,["rank"]=rank} 
    local t=this.GetTable("GameSAR.getRoomByRid",param) 
    local rt=json.encode(t)  
    this.HttpPOSTRequest(rt,function (str)
		Trace("查找房间信息--------"..str)
        callback(str)
    end) 
    Trace("-----------Finish_getRoomByRid--------") 
end


--根据用户ID获取玩牌列表 {"gid":游戏id,"status":状态0已开房1已开局2已结算,"page":第几页,从0开始}
function  this.getGameRoomListByUid(gid,status,page,callback) 
    local param={["gid"]=gid,["status"]=status,["page"]=page} 
    local t=this.GetTable("GameSAR.getGameRoomListByUid",param) 
    local rt=json.encode(t)  
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end) 
    Trace("-----------Finish_getGameRoomListByUid--------") 
end

--根据用户ID获取简单玩牌数据列表 {"gid":游戏id,"status":状态0已开房1已开局2已结算,"page":第几页,从0开始}
function this.getRoomSimpleByUid(gid,status,page,callback)
    local param={["gid"]=gid,["status"]=status,["page"]=page} 
    local t=this.GetTable("GameSAR.getRoomSimpleByUid",param) 
    local rt=json.encode(t)  
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end) 
    Trace("-----------Finish_getGameRoomSimpleByUid--------") 
end


--获得公告列表 null
function  this.getNotice(param,callback)  
    local t=this.GetTable("GameEmail.getNotice",param) 
    local rt=json.encode(t) 
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end) 
    Trace("-----------Finish_getNotice--------") 
end



--获得接收到的邮件 param:       int 页码,第一次传0
function  this.getEmails(param,callback)  
    local t=this.GetTable("GameEmail.getEmails",param)
    local rt=json.encode(t) 
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end, true) 
    Trace("-----------Finish_getEmails--------") 
end




--读邮件 param:        int 邮件eid
function  this.readEmail(param,callback)  
    local t=this.GetTable("GameEmail.readEmail",param)
    local rt=json.encode(t)  
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end) 
    Trace("-----------Finish_readEmail--------") 
end





--领取邮件附件 param:     int 邮件eid
function  this.getEmailAttachment(param,callback)  
    local t=this.GetTable("GameEmail.getEmailAttachment",param)
    local rt=json.encode(t)  
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end) 
    Trace("-----------Finish_getEmailAttachment--------") 
end



--获得新邮件 null
function  this.getNewEmails(param,callback)  
    local t=this.GetTable("GameEmail.getNewEmails",param)
    local rt=json.encode(t) 
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end) 
    Trace("-----------Finish_getNewEmails--------") 
end



--创建订单 {"stype":支付平台类型(1微信2支付宝3爱贝4UC5腾讯6笨手机8百度),"dpid":钻石价格id,"orderid":百度支付单号}
function  this.prepay(param,callback)  
    local t=this.GetTable("GameOrder.prepay",param)
    local rt=json.encode(t)
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end) 
    Trace("-----------Finish_prepay--------") 
end


function this.getTask(param,callback)
    local t=this.GetTable("Modwelfare.getTask",param)
    local rt=json.encode(t)
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end) 
    Trace("-----------Finish_getTask--------") 
    -- body
end

function this.GetLotteryDayData(param,callback)
    Trace("inter----------------GetLotteryDayData")
    local t=this.GetTable("ModDayrwd.roll",param)
    local rt=json.encode(t)
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end) 
    Trace("-----------GetLotteryDayData--------") 

end

function this.GetLotteryCfgData(param,callback)
    local t=this.GetTable("ModDayrwd.getRollSignin",param)
    local rt=json.encode(t)
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end) 
    Trace("-----------GetLotteryCfgDayData--------") 

end

function this.rwd(param,callback)
    local t=this.GetTable("Modwelfare.rwd",param)
    local rt=json.encode(t)
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end) 
    Trace("-----------Finish_rwd--------") 
end

--获取商品配置列表
function this.getProductCfg(param,callback)
    local t=this.GetTable("GameStore.getProductCfg",param) 
    local rt=json.encode(t)
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end)
    Trace("-----------Finish_roomFastEnter--------")
end


-- 请求支付订单
-- "stype":支付平台类型(1微信2支付宝3爱贝4UC5腾讯6笨手机8百度),
-- "dpid":钻石价格id,
-- "orderid":百度支付单号
function this.GetPayOrder( stype,pid,num,callback)
    if not stype or not pid or not num then return end

    local param={["pid"]=pid,["stype"]=stype,["num"]=num} 
    local t=this.GetTable("GameStore.prepay",param) 
    local rt=json.encode(t)
    Trace("-----------GetPayOrder--------" .. rt )
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end) 
    Trace("-----------Finish_GetIAppPayOrder--------") 
end

--苹果支付
function  this.iosPay(pid, receipt, callback)
    if not pid or not receipt then
        return
    end
    
    local param={["pid"]=pid,["receipt"]=receipt}
    local t=this.GetTable("GameOrder.iospay", param)
    local rt=json.encode(t)
    this.HttpPOSTRequest(rt,function (str)
        callback(str)
    end)
    Trace("-----------Finish_iospay--------")
end

--endregion


function this.ToRoom(param, callback)
    -- waiting_ui.Show()
    UI_Manager:Instance():ShowUiForms("waiting_ui")
    local t=this.GetTable("GameSAR.toRoom", param)     
    local rt=json.encode(t)  
    Trace("ToRoom------" .. rt)   
    this.HttpPOSTRequest(rt, function (str)        
        -- waiting_ui.Hide()
        UI_Manager:Instance():CloseUiForms("waiting_ui")
        local retStr = ParseJsonStr(str)
        local ret = retStr.ret               
        local dicID = nil 
        if ret ~= 0 then
            --101 102
            local dicID = nil    
            if ret == 101 then
                dicID = 8081
            elseif ret == 102 then
                dicID = 8082
            else
                logError("ret code:".. ret)
            end
            if dicID ~= nil then
                this.ErrorCodeHandler(dicID)
            end
        else 
            callback(str)
        end 
    end)   
end

--[[--
 * @Description: 只在进第一次进游戏时查询状态  
 ]]
function this.QueryStatus(param, callback)
    local t=this.GetTable("GameSAR.queryStatus", param) 
    local rt=json.encode(t)    
    Trace("rt------------------------------"..tostring(rt))
    this.HttpPOSTRequest(rt, function (str)        
        callback(str)
    end)    
end

-- 检查是否绑定代理
function this.CheckIsBindAgent(callback)
    local t = this.GetTable("GameMember.checkIsBindAgent", nil)
    local rt = json.encode(t)
    this.HttpPOSTRequest(rt, function(str)
        local retStr = ParseJsonStr(str)
        if callback ~= nil then
            callback(retStr.ret, retStr.bindstatus)
        end
    end)
end
-- 分享是否成功
function this.ShareDone(callback)
    local t = this.GetTable("Modact.doShare", nil)
    local rt = json.encode(t)
    this.HttpPOSTRequest(rt, function(str)
        local retStr = ParseJsonStr(str)
        if callback ~= nil then
            callback(retStr)
        end
    end)
end

--数据上报埋点
function this.EventUpload(param)
	local t = this.GetTable("GameEvent.eventUpload",param)
    local rt = json.encode(t)    
    NetWorkManage.Instance:HttpPOSTRequest(rt, function(str) 
		Trace("-------上报成功-------"..GetTblData(str)) 
	end)
end

-- 绑定代理
function this.BindAgent(ag_uid, callback)
    local param = {["ag_uid"] = ag_uid}
    local t = this.GetTable("GameMember.bindAgent", param)
    local rt = json.encode(t)
    this.HttpPOSTRequest(rt, function(str)
        local retStr = ParseJsonStr(str)
        if callback ~= nil then
            callback(retStr.ret)
        end
    end)
end

function this.GetVersionUp(version, callback, gid)
    local t = this.GetTable("GameSAR.getVersionUp", nil)
    t["version"] = version
    if gid then
        t["gid"] = gid
    end
    local rt = json.encode(t)
    this.HttpPOSTRequest(rt, function(str)
        if callback ~= nil then
            callback(str)
        end
    end) 
end

--互动表情付费
function this.sendPaidface(callback, faceid)
    local t = this.GetTable("GameSAR.sendPaidface", nil)
    if faceid then
        t["faceid"] = faceid
    end
    local rt = json.encode(t)
    this.HttpPOSTRequest(rt, function(str)
        if callback ~= nil then
            callback(str)
        end
    end) 
end
--互动表情付费配置
function this.getPaidface(callback)
    local t = this.GetTable("GameSAR.getPaidface", nil)
    local rt = json.encode(t)
    this.HttpPOSTRequest(rt, function(str)
        if callback ~= nil then
            callback(str)
        end
    end) 
end

--拉取俱乐部广告
function this.GetClubAds(callback)
	local t = this.GetTable("GameClub.getClubAds",nil)
    local rt = json.encode(t)
	this.HttpPOSTRequest(rt, function(str)
        if callback ~= nil then
            callback(str)
        end
    end) 
end


function this.SendHttpRequest(key, param, dontShowWaiting, needRetry, isQuit)
    -- 默认打开等待界面
    if not dontShowWaiting then
        -- waiting_ui.Show()
        UI_Manager:Instance():ShowUiForms("waiting_ui")
    end
    local t = this.GetTable(key, param)
    local rt = json.encode(t)
    -- 暂时先使用HttpPOSTRequest逻辑 之后整理
    if Debugger.useLog then
        logWarning(rt)
    end
    this.HttpPOSTRequest(rt,
        function(str, code, msg) 
             if Debugger.useLog then
                logWarning("receive:" .. str)
            end
            local s =string.gsub(str,"\\/","/")
            this.OnReceiveHttpResponse(key, s)
        end,
        showaiting, needRetry, isQuit)
end

function this.SendHttpRequestWithCallback(key, param,callback, target, dontShowWaiting, needRetry, isQuit)
   if not dontShowWaiting then
        -- waiting_ui.Show()
        UI_Manager:Instance():ShowUiForms("waiting_ui")
    end
    local t = this.GetTable(key, param)
    local rt = json.encode(t)
    -- 暂时先使用HttpPOSTRequest逻辑 之后整理
    if Debugger.useLog then
        logWarning(rt)
    end
    this.HttpPOSTRequest(rt,
        function(str, code, msg) 
             if Debugger.useLog then
                logWarning("receive:" .. str)
            end
            local s =string.gsub(str,"\\/","/")
            this.OnReceiveHttpResponseWithCallback(key, s, callback, target)
        end,
        showaiting, needRetry, isQuit)
end


function this.OnReceiveHttpResponse(key, retStr)
    local tab = nil
    if not pcall( function () tab = ParseJsonStr(retStr) end) then
        ParseJsonStr(retStr)
        -- waiting_ui.Hide()
        UI_Manager:Instance():CloseUiForms("waiting_ui")
        return
    end
    Notifier.dispatchCmd(key, tab)
end

function this.OnReceiveHttpResponseWithCallback(key, retStr, callback, target)
    local tab = nil
    if not pcall( function () tab = ParseJsonStr(retStr) end) then
        -- waiting_ui.Hide()
        UI_Manager:Instance():CloseUiForms("waiting_ui")
        return
    end
    if callback ~= nil then
        if target ~= nil then
            callback(target, tab, retStr)
        else
            callback(tab)
        end
    end
end


function this.HttpPOSTRequest(rt,callback,dontShowWaiting, needRetry, retryTime,isQuit) 
    NetWorkManage.Instance:HttpPOSTRequest(rt,function(code, msg, str)
        -- if not dontShowWaiting then
        --     waiting_ui.Hide()
        -- end 
        if code == 0 then
            -- waiting_ui.Hide()
            UI_Manager:Instance():CloseUiForms("waiting_ui")
            callback(str,code, msg)
            
            -- if timeStart~=nil then
            -- if timeStart~=nil then
            --     timeStart:Stop()
            --     timeStart=nil
            -- end
        else
            if needRetry == nil then
                needRetry = true
            end
            if not needRetry then
                this.ShowError(code,rt,callback,dontShowWaiting, needRetry, retryTime,isQuit)
            else
                if retryTime == 3 then
                    this.ShowError(code,rt,callback,dontShowWaiting, needRetry, retryTime,isQuit)
                    return
                end
                retryTime = retryTime or 1
                retryTime = retryTime + 1
                this.HttpPOSTRequest(rt,callback,dontShowWaiting, needRetry, retryTime,isQuit)
                --timeStart= Timer.New(function ()this.HttpPOSTRequest(rt,callback,dontShowWaiting, needRetry, retryTime,isQuit)end,3,1)
	            -- timeStart:Start()
            end
        end    
    end)
end

function this.ShowError(code,rt,callback,dontShowWaiting, needRetry, retryTime,isQuit)
    if code == -1 then
        -- waiting_ui.Hide()
        UI_Manager:Instance():CloseUiForms("waiting_ui")

        -- local msgBox = UI_Manager:Instance():ShowGoldBox("网络请求失败，是否重新请求",{
        --         function ()UI_Manager:Instance():CloseUiForms("message_box")
        --          if isQuit then
        --             Application.Quit() 
        --          end
        --         end,
        --         function ()
        --             UI_Manager:Instance():CloseUiForms("message_box")
        --             this.HttpPOSTRequest(rt,callback,dontShowWaiting, needRetry,nil,isQuit) waiting_ui.Show()
        --          end 
        --     },{"quxiao","queding"},{"button_03","button_02"})
        -- if isQuit then 
        --     msgBox:SetBtnCloseCallBack(function () Application.Quit() end)
        -- end

        MessageBox.ShowYesNoBox("网络请求失败，是否重新请求",  
            function() 
                this.HttpPOSTRequest(rt,callback,dontShowWaiting, needRetry,nil,isQuit) 
                -- waiting_ui.Show()
                UI_Manager:Instance():ShowUiForms("waiting_ui")
            end, 
            function()
                if isQuit then
                   Application.Quit() 
                end
             end,
            function ()
                if isQuit then
                   Application.Quit() 
                end
            end)

		-- if timeStart ~= nil then
		-- 	timeStart:Stop()
		-- 	timeStart=nil
		-- end
    else
        logError("HTTP请求错误！错误码："..code.."，错误信息：")
    end
end

--根据uid获取用户信息
function this.GetUserInfo(uid,callback)
	local param = {["uid"] = uid}
    local t = this.GetTable("GameMember.getUserInfo100", param)
    local rt = json.encode(t)
    this.HttpPOSTRequest(rt, function(str)
		Trace("----------GetUserInfo--------"..str)
        if callback ~= nil then
            callback(str)
        end
    end, true)
	Trace("-----------Finish_GetUserInfo--------") 
end

--设置用户城市编号
function this.SetUserCity(cityID,callback)
	local param = {["city"] = cityID}
    local t = this.GetTable("GameMember.setCity", param)
    local rt = json.encode(t)
    this.HttpPOSTRequest(rt, function(str)
		Trace("----------GetUserCity--------"..str)
        if callback ~= nil then
            callback(str)
        end
    end, true)
	Trace("-----------Finish_GetUserCity--------") 
end