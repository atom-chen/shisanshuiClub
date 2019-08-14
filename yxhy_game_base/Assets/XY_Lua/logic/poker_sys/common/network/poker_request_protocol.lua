poker_request_protocol = {}
local this  = poker_request_protocol

-- @des: ���������Ϸ
-- @param: _app_id(Ӧ��id), gameData(php�·���������)
function this.EnterGameReq(gameData,dst)
	local msgTbl = {}
	local eventTbl = {}
	local paraTbl = {}
	local saved = {}
	--msg
	msgTbl[messagedefine.EField_Sn] = "enter"
	msgTbl[messagedefine.EField_Ver] = 1
	msgTbl[messagedefine.EField_Session] = gameData[messagedefine.EField_Session] or {}
	--����
	if dst ~= nil then
		msgTbl[messagedefine.EField_Session] = dst
	end
	--events
	eventTbl[messagedefine.EField_EID] = "enter"
	eventTbl[messagedefine.EField_EType] = "req"
	--para
	eventTbl[messagedefine.EField_EPara] = paraTbl
	paraTbl[messagedefine.EField_Rule] = "default"	 -- �̶�ֵ
	paraTbl["_gid"] = gameData.gid
	paraTbl[messagedefine.EField_SitMode] = "byCard" 	----����ʲô���ҷ�, ֧��bykey, byid, ����Ӧ���ֶεô���
	paraTbl[messagedefine.EFiled_TableKey] = "" 	---����key, ��php��base64(AES��
	paraTbl[messagedefine.EField_TableConfig] = gameData 	----��������
	paraTbl["saved"] = saved
	saved.latitude = player_data.localtionData.latitude
	saved.longitude = player_data.localtionData.longitude
	
	return eventTbl
end

-- @TER0419
-- @des: ����׼����Ϸ
-- @param: _tableID(��λID), _seat(��λ)
function this.ReadyGame(_tableID, _seat)
	local eventTbl = {}
	local paraTbl = {}

	--events
	eventTbl[messagedefine.EField_EID] = "ready"
	eventTbl[messagedefine.EField_EType] = "req"
	--para
	eventTbl[messagedefine.EField_EPara] = paraTbl
	return eventTbl
end

-- @TER0419
-- @des: ����׼����Ϸ
-- @param: _tableID(��λID), _seat(��λ)
function this.ApplyForGame(nChair, bStatus)
	local eventTbl = {}
	local paraTbl = {}
	paraTbl.nChair = nChair
	paraTbl.bStatus = bStatus
	--events
	eventTbl[messagedefine.EField_EID] = "applyfor"
	eventTbl[messagedefine.EField_EType] = "req"
	--para
	eventTbl[messagedefine.EField_EPara] = paraTbl
	return eventTbl
end

-- ������ɢ����
function this.requestDissolution(gid,tableid,seat)
	local msgTbl = {}
	local sessionTbl = {}
	local eventTbl = {}
	local paraTbl = {}
	--msg
	msgTbl[messagedefine.EField_Sn] = "dissolution"
	msgTbl[messagedefine.EField_Ver] = 1
	msgTbl[messagedefine.EField_Session] = sessionTbl
	sessionTbl[messagedefine.EField_TableID] = tableid
	sessionTbl[messagedefine.EField_SeatID] = seat
	--events
	eventTbl[messagedefine.EField_EID] = "dissolution"
	eventTbl[messagedefine.EField_EType] = "req"
	eventTbl[messagedefine.EField_EPath] = "p1"
	--para
	eventTbl[messagedefine.EField_EPara] = paraTbl
	paraTbl["gid"] = gid
	paraTbl[messagedefine.EField_Rule] = "default"
	return eventTbl

end

--����Ͼ�
function this.requestVoteDraw(flag,tableID,seat)
	if not tableID or not seat  then
		return
	end
	local acceptStatus = false
	if flag == true then
		acceptStatus = true
	end
	local msgTbl = {}
	local sessionTbl = {}
	local eventTbl = {}
	local paraTbl = {}
	--msg
	msgTbl[messagedefine.EField_Sn] = "vote_draw"
	msgTbl[messagedefine.EField_Ver] = 1
	msgTbl[messagedefine.EField_Session] = sessionTbl
	sessionTbl[messagedefine.EField_TableID] = tableID
	sessionTbl[messagedefine.EField_SeatID] = seat
	--events
	eventTbl[messagedefine.EField_EID] = "vote_draw"
	eventTbl[messagedefine.EField_EType] = "req"
	--para
	eventTbl[messagedefine.EField_EPara] = paraTbl
	paraTbl["accept"] = acceptStatus
	return eventTbl
end

--����˳�
function this.requestLeave()
	local eventTbl = {}
	local paraTbl = {}
	--events
	eventTbl[messagedefine.EField_EID] = "leave"
	eventTbl[messagedefine.EField_EType] = "req"
	--para
	eventTbl[messagedefine.EField_EPara] = paraTbl

	return eventTbl
end

function this.requestChat(contenttype,content,tableID,seat,givewho)
	if not tableID or not seat  or not contenttype or not content then
		return
	end

	local msgTbl = {}
	local sessionTbl = {}
	local eventTbl = {}
	local paraTbl = {}
	--msg
	msgTbl[messagedefine.EField_Sn] = "chat"
	msgTbl[messagedefine.EField_Ver] = 1
	msgTbl[messagedefine.EField_Session] = sessionTbl
	sessionTbl[messagedefine.EField_TableID] = tableID
	sessionTbl[messagedefine.EField_SeatID] = seat
	--events
	
	eventTbl[messagedefine.EField_EID] = "chat"
	eventTbl[messagedefine.EField_EType] = "req"
	--para
	eventTbl[messagedefine.EField_EPara] = paraTbl
	paraTbl["contenttype"] = contenttype
	paraTbl["content"] = content
	paraTbl["givewho"] = givewho

	return eventTbl
end

-- @des: ������ע����
-- @param:beishu(����) _tableID(��λID), _seat(��λ)
function this.requestMult(beishu, tableID, seat)
	if not beishu  or  not tableID or  not seat then 
		return
	end
	local msgTbl = {}
	local sessionTbl = {}
	local eventTbl = {}
	local paraTbl = {}
	--msg
	msgTbl[messagedefine.EField_Sn] = "mult"
	msgTbl[messagedefine.EField_Ver] = 1
	msgTbl[messagedefine.EField_Session] = sessionTbl
	sessionTbl[messagedefine.EField_TableID] = tableID
	sessionTbl[messagedefine.EField_SeatID] = seat
	--events
	
	eventTbl[messagedefine.EField_EID] = "mult"
	eventTbl[messagedefine.EField_EType] = "req"
	--para
	eventTbl[messagedefine.EField_EPara] = paraTbl
	paraTbl["nBeishu"] = beishu

	return eventTbl	
end

-- @des: ������Ҫ��ׯ
-- @param: _tableID(��λID), _seat(��λ)
function this.ChooseBankerReq(_tableID,_seat)
	local msgTbl = {}
	local sessionTbl = {}
	local eventTbl = {}
	local paraTbl = {}
	local sessionTbl = {}
	--msg
	msgTbl[messagedefine.EField_Sn] = "choosebanker"
	msgTbl[messagedefine.EField_Ver] = 1
	msgTbl[messagedefine.EField_Session] = sessionTbl
	sessionTbl[messagedefine.EField_TableID] = _tableID
	sessionTbl[messagedefine.EField_SeatID] = _seat
	--events
	eventTbl[messagedefine.EField_EID] = "choosebanker"
	eventTbl[messagedefine.EField_EType] = "req"
	--para
	eventTbl[messagedefine.EField_EPara] = paraTbl
	return eventTbl
end

-- @des: ��������ׯ
-- @param: _tableID(��λID), _seat(��λ)
function this.robbankerReq(beishu,tableID,seat)
	if not beishu  or  not tableID or  not seat then 
		return
	end
	local msgTbl = {}
	local sessionTbl = {}
	local eventTbl = {}
	local paraTbl = {}
	--msg
	msgTbl[messagedefine.EField_Sn] = "robbanker"
	msgTbl[messagedefine.EField_Ver] = 1
	msgTbl[messagedefine.EField_Session] = sessionTbl
	sessionTbl[messagedefine.EField_TableID] = tableID
	sessionTbl[messagedefine.EField_SeatID] = seat
	--events
	eventTbl[messagedefine.EField_EID] = "robbanker"
	eventTbl[messagedefine.EField_EType] = "req"
	--para
	eventTbl[messagedefine.EField_EPara] = paraTbl
	paraTbl["nBeishu"] = beishu
	return eventTbl	
end

-- @des: ������Ҫ����
-- @param:
function this.OpenCardReq()
	local eventTbl = {}
	local paraTbl = {}

	--events
	eventTbl[messagedefine.EField_EID] = "opencard"
	eventTbl[messagedefine.EField_EType] = "req"
	--para
	eventTbl[messagedefine.EField_EPara] = paraTbl
	return eventTbl
end