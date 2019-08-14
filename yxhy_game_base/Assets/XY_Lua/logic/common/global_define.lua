--[[--
 * @Description: 定义全局数据结构
 * @Author:      shine
 * @FileName:    global_define.lua
 * @DateTime:    2017-05-16
 ]]

global_define = {} 
local this = global_define

this.chatTextIntervalTime = 5
this.userNameLen = 7
this.color = 
{
	["WHITE"] = "[FFFFFF]",
	["GREEN"] = "[32E646]",
	["BLUE"]  = "[32E6F0]",
	["PURPLE"] = "[BE32F0]",
	["ORANGE"] = "[F0A032]",
}

--游戏类型
ENUM_GAME_TYPE = 
{
	TYPE_FUZHOU_MJ = 2235018,            --福州麻将
	
	TYPE_SHISHANSHUI = 1291001,         	--福建十三水
	TYPE_PINGTAN_SSS = 1291002,				--平潭十三水
	TYPE_PUXIAN_SSS = 1291004,				--莆仙十三水
	TYPE_BaRen_SSS = 1291005,				--八人十三水
	TYPE_DuoGui_SSS = 1291006,				--多鬼十三水
	TYPE_ShuiZhuang_SSS = 1291007,			--水庄十三水
	TYPE_ChunSe_SSS = 1291008,				--纯色十三水
	
	TYPE_QUANZHOU_MJ = 2235020,            --泉州麻将
	TYPE_XIAMEN_MJ = 2235025,            -- 厦门麻将
	TYPE_ZHANGZHOU_MJ = 2235026,        -- 漳州麻将
	TYPE_NIUNIU = 1292001,                 --牛牛 
	TYPE_HONGZHONG_MJ = 2235040,                 --红中麻将
	TYPE_LONGYAN_MJ = 2235041,                 --龙岩麻将
	TYPE_NINGDE_MJ = 2235042,                 -- 宁德麻将
	TYPE_SANMING_MJ = 2235043,             -- 三明
	TYPE_PUTIANSHISAN_MJ = 1235044,        -- 莆田十三张
	TYPE_FUDING_MJ = 2235045,              -- 福鼎
	TYPE_DAXI_MJ = 2235060,              -- 大溪
	TYPE_PINGTAN_MJ = 2235064,              -- 平潭
	TYPE_FUQING_MJ = 2235065,              -- 福清
	TYPE_FUAN_MJ = 2235090,              -- 福安
	TYPE_XIAPU_MJ = 2235091,              -- 霞浦
	TYPE_SANGONG = 1290001,				--三公
	TYPE_YINGSANZHANG = 1293001,			--赢三张
	TYPE_ZHENZHOU_MJ = 2241008,         --郑州麻将
	TYPE_LUOYANGGANGCI_MJ = 2241009,    --洛阳麻将
	TYPE_ZHUMADIAN_MJ = 2241010,        --驻马店麻将
	TYPE_NANYANG_MJ = 2241029,          --南阳麻将
	TYPE_ZHOUKOU_MJ = 2241030,          --周口麻将
	TYPE_XUCHANG_MJ=2241048,            --许昌麻将
	TYPE_PUYANG_MJ=2241049,             --濮阳麻将
	TYPE_XINXIANG_MJ=2241054,           --新乡麻将
	TYPE_KAIFENG_MJ=2241055,            --开封麻将
	TYPE_JIAOZUO_MJ=2241056,            --焦作麻将
	TYPE_SHANGQIU_MJ=2241057,           --商丘麻将
	TYPE_ANYANG_MJ=2241068,             --安阳麻将
	TYPE_PINGDINGSHAN_MJ=2241069,       --平顶山麻将
	TYPE_SHIJIAZHUANG_MJ = 2213015, -- 石家庄
	TYPE_LANGFANG_MJ = 2213017,     -- 廊坊
	TYPE_TANGSHAN_MJ = 2213024,     -- 唐山
	TYPE_BAODING_MJ = 2213080,      -- 保定
	TYPE_XINGTAI_MJ = 2213081,      -- 邢台
	TYPE_CANGZHOU_MJ = 2213082,     -- 沧州
	TYPE_ZHANGJIAKOU_MJ = 2213083,  -- 张家口
	TYPE_CHENGDE_MJ = 2213084,      -- 承德
	TYPE_HENGSHUI_MJ = 2213085,     -- 衡水
	TYPE_TUIDAOHU_MJ = 2213086,     -- 推倒胡
	TYPE_QINHUANGDAO_MJ = 2213087,  -- 秦皇岛
	TYPE_HANDAN_MJ = 2213089,       -- 邯郸
	TYPE_XIANYOU_MJ = 2235092,       -- 仙游
	TYPE_MINQING_MJ = 2235093,       -- 闽清
	TYPE_TONGLIAO_MJ = 2215001,       -- 通辽
	TYPE_XINGANMENGTUIDAO_MJ = 2215002,       -- 兴安盟推倒胡
	TYPE_XINGANMENGQIONGHU_MJ = 2215003,       -- 兴安盟穷胡
	TYPE_KAWUXING_MJ = 2242001,       -- 卡五星麻将
	TYPE_GUIYANGZHUOJI_MJ = 2252001,       -- 贵阳捉鸡麻将
	TYPE_SONGYUAN_MJ = 2222001,       -- 松原麻将
}

--登陆类型
LoginType=
{
    WXLOGIN = 2,
    QQLOGIN = 3,
    YOUKE = 9,
}

this.preWebUrl = "http://b.feiyubk.com"
local hallShareSubUrl = "/gamewap/youxianqipai/view/youxixiazai.html?uid=%s"
this.gameShareTitle = "有闲【%s】房号:%s"

this.CreateRoomPlayerPrefs = "createRoomCache_" -- 开房数据持久化固定字符串createRoomCache_gid
this.ClubCreateRoomPlayerPrefs = "clubCreateRoomCache_"
this.CUR_TYPE_ID = "CUR_TYPE_ID_NEW"
this.CUR_GAME_ID = "CUR_GAME_ID_NEW"
this.NEXT_GAME_ID = "NEXT_GAME_ID_NEW"
-- this.HideRoomNumFlag = "HideRoomNumFlag"
this.ClubHideRoomNumFlag = "ClubHideRoomNumFlag"
this.RemberPassWordFlag = "RemberPassWordFlag" --手机登录记住密码
this.Account = "Account"
this.Password = "Password"
this.ClubKickReasonConfig = {
	[1] = "牌品极差，人不诚信",
	[2] = "脏话连篇，辱骂他人",
	[3] = "频繁广告，拉人进群",
	[4] = "其他",
}

this.winXin = "yxqpkefu"
this.qq = 1715804250
this.adUrlTbl = {}

----------------------Oem配置相关------------------------
this.appConfig = {}

this.appConfig.MWInviteURL = "https://aqvvrq.mlinks.cc/Acss?id=%s&uid=%s&cid=%s"   -----魔窗地址配置-----
-- 不带参数的魔窗分享链接，参数自己拼接
this.appConfig.MWBaseInviteURL = "https://aqvvrq.mlinks.cc/Acss?"
this.appConfig.appId = 4
this.appConfig.jsonurl = Application.persistentDataPath.."/games/gamerule"
this.appConfig.qzoneShareIcon = "http://fjmj.dstars.cc/gamewap/youxianqipai/src/images/icon_108.png" 	----分享到空间icon


this.appConfig.hallShareTitle = "超酷炫棋牌大合集！玩法齐全，免费开打！"
this.appConfig.hallShareQTitle = "超酷炫棋牌大合集！玩法齐全，免费开打！"
this.appConfig.hallShareFriendContent = "十三张、拼十、各地麻将，酷到没朋友！美女在线发牌，还能互动哟！"
this.appConfig.hallShareFriendQContent = "十三张、拼十、各地麻将，酷到没朋友！美女在线发牌，还能互动哟！"

-- local httpmzsm = this.preWebUrl.."/gamewap/youxianqipai/view/yonghuxieyi.html"
-- local httpfwtk = this.preWebUrl.."/gamewap/youxianqipai/view/fuwutiaokuan.html"
-- local httpyszc = this.preWebUrl.."/gamewap/youxianqipai/view/yinsizhengce.html"
local httpactivity = this.preWebUrl.."/gamewap/youxianqipai/view/huodonggonggao.html"
this.defineimg = "http://portrait3.sinaimg.cn/1674470754/blog/180"

function this.SetClubKickReason(reasonTbl)
	if reasonTbl ~= nil and not isEmpty(reasonTbl) then
		for i=1,4 do 
			----策划需求暂只支持四条踢人理由
			this.ClubKickReasonConfig[i] = reasonTbl[tostring(i)]["reason"]
			--this.ClubKickReasonConfig[reasonTbl[i]["type"]] = reasonTbl[i]["reason"]
    end
	end
end

function this.SetURL(activity,shareurl) 
    -- if mzsm ~= nil and mzsm ~= "" then
    --     httpmzsm = mzsm
    -- end
    -- if fwtk ~= nil and fwtk ~= "" then
    --     httpfwtk = fwtk
    -- end
    -- if yszc ~= nil and yszc ~= "" then
    --     httpyszc = yszc
    -- end
    if activity ~= nil and activity ~= "" then
        httpactivity = activity
    end
    if shareurl ~= nil and shareurl ~= "" then
        hallShareSubUrl = shareurl
    end 
end

function this.SetShareContext(shareContent)
	if shareContent ~= nil and not isEmpty(shareContent) then
		this.appConfig.hallShareTitle = shareContent["hallShareTitle"]
		this.appConfig.hallShareQTitle = shareContent["hallShareQTitle"]
		this.appConfig.hallShareFriendContent = shareContent["hallShareFriendContent"]
		this.appConfig.hallShareFriendQContent = shareContent["hallShareFriendQContent"]
	end
end

function this.SetServiceNumber(serviceTbl)
	if serviceTbl ~= nil and not isEmpty(serviceTbl) then
		this.winXin = serviceTbl["wx"]
		this.qq = serviceTbl["qq"]
	end
end

function this.SetAdUrlTbl(urlTbl)
	if urlTbl ~= nil and not isEmpty(urlTbl) then
		this.adUrlTbl = urlTbl
	end
end

-----------------------外部获取接口-----------------------
function  this.GetUrlData()
   local t = http_request_interface.GetTable()
   local url = httpactivity.."?session_key="..t.session_key.."&siteid="..t.siteid.."&version="..t.version
   return url
end

-- function this.GetMzsmUrl()
--    local t = http_request_interface.GetTable()
--      if httpmzsm == "" then
--       httpmzsm = "http://b.feiyubk.com/gamewap/youxianqipai/view/yonghuxieyi.html"
--    end
--    local url = httpmzsm.."?session_key="..t.session_key.."&siteid="..t.siteid.."&version="..t.version
--    return url
-- end

-- function this.GetFwtkUrl()
--    local t = http_request_interface.GetTable()
--    if httpfwtk == "" then
--       httpfwtk = "http://b.feiyubk.com/gamewap/youxianqipai/view/fuwutiaokuan.html"
--    end
--    local url = httpfwtk.."?session_key="..t.session_key.."&siteid="..t.siteid.."&version="..t.version
--    return url
-- end

-- function this.GetYszcUrl()
--    local t = http_request_interface.GetTable()
--    if httpyszc == "" then
--       httpyszc = "http://b.feiyubk.com/gamewap/youxianqipai/view/yinsizhengce.html"
--    end
--    local url = httpyszc.."?session_key="..t.session_key.."&siteid="..t.siteid.."&version="..t.version
--    return url
-- end

function this.GetShareUrl()
   local url = hallShareSubUrl.."?uid=%s"
   return url
end

function this.CheckHasName(gid)
  for k,v in pairs(ENUM_GAME_TYPE) do
    if gid == v then
      return true
    end
  end
  return false
end