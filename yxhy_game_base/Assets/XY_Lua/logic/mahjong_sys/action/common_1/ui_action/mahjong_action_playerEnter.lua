local base = require "logic.mahjong_sys.action.common.mahjong_action_base"
local mahjong_action_playerEnter = class("mahjong_action_playerEnter", base)



function mahjong_action_playerEnter:Execute(tbl)
	Trace(GetTblData(tbl))
	if game_scene.getCurSceneType() == scene_type.HALL or game_scene.getCurSceneType() == scene_type.LOGIN then
		return
	end

	local viewSeat = self.gvblFun(tbl["_src"])
	self:UpdatePlayerEnter(tbl, true)
	ui_sound_mgr.PlaySoundClip(mahjong_path_mgr.GetMjCommonSoundPath("sitdown"))

	--金币场不显示，以后处理
	if viewSeat == 1 then		
	    if not roomdata_center.isRoundStart then
	    	mahjong_ui:ShowReadyBtns()
	    end
	    mahjong_ui:SetRoundInfo(1, roomdata_center.nJuNum)
	end
end

function mahjong_action_playerEnter:UpdatePlayerEnter(tbl, needGameInfo)
	local viewSeat = self.gvblFun(tbl["_src"])
	local logicSeat = player_seat_mgr.GetLogicSeatByStr(tbl["_src"])
	local uid = tbl["_para"]["_uid"]
	local coin = tbl["_para"]["score"]["coin"]
	local saved = tbl["_para"]["saved"]

	local userdata = room_usersdata.New()
	if uid == roomdata_center.ownerId then
		roomdata_center.ownerLogicSeat = logicSeat
		userdata.owner = true
	end
	room_usersdata_center.AddUser(logicSeat,userdata)
	userdata.uid = uid
	userdata.coin = coin
	userdata.vip  = 0
	userdata.viewSeat = viewSeat
	userdata.logicSeat = logicSeat
	userdata.saved = saved
	mahjong_ui:SetPlayerInfo( viewSeat, userdata)

	local param={["uid"]=uid,["type"]=1}

	local name = hall_data.GetPlayerPrefs(uid.."name")
	local headurl = hall_data.GetPlayerPrefs(uid.."headurl")
	local imagetype = hall_data.GetPlayerPrefs(uid.."imagetype")
	if name~=nil and headurl~=nil and imagetype~=nil then
		userdata.name = name
		userdata.headurl = headurl
		userdata.imagetype = imagetype
		room_usersdata_center.AddUser(logicSeat,userdata)
		mahjong_ui:SetPlayerInfo(viewSeat, userdata)
	end

	if needGameInfo then
		HttpProxy.GetGameInfo(param, function(info) 
			       	userdata.zhengzhoumj = info
		        if info.nickname~=name then
					userdata.name = info.nickname
					hall_data.SetPlayerPrefs(uid.."name",info.nickname)
				end
				if info.imageurl~=headurl then
					userdata.headurl = info.imageurl
					hall_data.SetPlayerPrefs(uid.."headurl",info.imageurl)
				end
				if info.imagetype~=imagetype then
					userdata.imagetype = info.imagetype
					hall_data.SetPlayerPrefs(uid.."imagetype",info.imagetype)
				end
				room_usersdata_center.AddUser(logicSeat,userdata)
				mahjong_ui:SetPlayerInfo(viewSeat, userdata)
		end)
		-- http_request_interface.getGameInfo(param,function (str) 
		-- 	local s=string.gsub(str,"\\/","/")
	 --        local t=ParseJsonStr(s)

	 --        if t["data"] then
	 --        	userdata.zhengzhoumj = t["data"]
		--         if t["data"].nickname~=name then
		-- 			userdata.name = t["data"].nickname
		-- 			hall_data.SetPlayerPrefs(uid.."name",t["data"].nickname)
		-- 		end
		-- 		if t["data"].imageurl~=headurl then
		-- 			userdata.headurl = t["data"].imageurl
		-- 			hall_data.SetPlayerPrefs(uid.."headurl",t["data"].imageurl)
		-- 		end
		-- 		if t["data"].imagetype~=imagetype then
		-- 			userdata.imagetype = t["data"].imagetype
		-- 			hall_data.SetPlayerPrefs(uid.."imagetype",t["data"].imagetype)
		-- 		end
		-- 		room_usersdata_center.AddUser(logicSeat,userdata)
		-- 		mahjong_ui:SetPlayerInfo(viewSeat, userdata)
		-- 	end
		-- end)
	end
end

return mahjong_action_playerEnter