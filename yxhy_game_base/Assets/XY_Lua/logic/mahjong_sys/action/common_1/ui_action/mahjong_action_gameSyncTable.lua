local base = require "logic.mahjong_sys.action.common.mahjong_action_base"
local mahjong_action_gameSyncTable = class("mahjong_action_gameSyncTable", base)



function mahjong_action_gameSyncTable:Execute(tbl)
	Trace("重连同步表")
	Trace(GetTblData(tbl))
	

	--[[
		game_state:
		prepare     
		deal        
		laizi       
		xiapao      
		round       
		reward      
		gameend  
		]]

	local ePara = tbl._para
	--[[--
	 * @Description: game_state
	 * ["game_state"]="round";  
	 ]]
	local game_state = ePara.game_state 		-- 游戏阶段
	--[[--
	 * @Description: dealer
	 * ["dealer"]="p1";  
	 ]]
	local dealer = ePara.dealer 				-- 庄家
	local lianZhuang = ePara.lianZhuang         -- 连庄数
	--[[--
	 * @Description: dice
	 * ["dice"]={
			[1]=3;[2]=5;
		};  
	 ]]
	local dice = ePara.dice 					-- 骰子
	--[[--
	 * @Description: laizi
	 * ["laizi"]={
			["laizi"]={				[1]=9;			};
			["sit"]={				[1]=14;			};
			["card"]={				[1]=8;			};
		};  
	 ]]
	local laizi = ePara.laizi 					-- 癞子
	local ci = ePara.ci                         -- 次牌
	--[[--
	 * @Description: player_state
	 * ["player_state"]={
			[1]=2;[2]=2;[3]=2;[4]=2;
		};  
	 ]]
	local player_state = ePara.player_state 	-- 玩家状态
	--[[--
	 * @Description: tileCount
	 * ["tileCount"]={
			[1]=13;[2]=13;[3]=13;[4]=14;
		};  
	 ]]
	local tileCount = ePara.tileCount 			-- 各玩家手牌数
	--[[--
	 * @Description: tileLeft
	 * ["tileLeft"]=60;  
	 ]]
	local tileLeft = ePara.tileLeft 			-- 剩余牌子
	--[[--
	 * @Description: tileList
	 * ["tileList"]={
			[1]=8;[2]=17;[3]=33;[4]=35;[5]=23;[6]=18;[7]=23;[8]=28;[9]=28;[10]=21;[11]=35;[12]=36;[13]=23;
		};  
	 ]]
	local tileList = ePara.tileList 			-- 玩家手牌值
	local combineTile = ePara.combineTile 		-- 各玩家吃碰杠
	--[[--
	 * @Description: xiapao
	 * ["xiapao"]={
			[1]=0;[2]=1;[3]=3;[4]=2;
		};  
	 ]]
	local xiapao = ePara.xiapao 				-- 下跑
	local winTile = ePara.winTile 				-- 各家所赢
	--[[--
	 * @Description: discardTile
	 * ["discardTile"]={
			[1]={
				[1]=13;[2]=28;[3]=29;[4]=7;[5]=3;[6]=4;
			};[2]={
				[1]=22;[2]=9;[3]=23;[4]=21;[5]=4;[6]=7;
			};[3]={
				[1]=14;[2]=19;[3]=32;[4]=28;[5]=1;[6]=2;
			};[4]={
				[1]=3;[2]=29;[3]=27;[4]=14;[5]=1;
			};
		};  
	 ]]
	local discardTile = ePara.discardTile 		-- 各玩家出的牌
	--[[--
	 * @Description: whoisOnTurn
	 * ["whoisOnTurn"]=4  
	 ]]
	local whoisOnTurn = ePara.whoisOnTurn 		-- 谁的回合
	--[[--
	 * @Description: nleftTime
	 * ["nleftTime"]=0;  
	 ]]
	local nleftTime = ePara.nleftTime 			-- 
	--local cardLastDraw = ePara.cardLastDraw 		-- 
	local stPlayerNoChair = ePara.stPlayerNoChair

	local state = self.config.mahjongSyncGameState[game_state]
	if state == nil then
		state = 0 
	end

	if state >= 510 then
		mahjong_ui:SetAllHuaPointVisible(self.cfg.isHasFlower and true)
	else
		mahjong_ui:SetAllHuaPointVisible(false)
	end

	-- if state >= 600 then
	-- 	mahjong_ui:SetAllScoreVisible(true)
	-- else
	-- 	mahjong_ui:SetAllScoreVisible(false)
	-- end

	mahjong_ui:HideOperTips()
	mahjong_ui:HideCardShowView()
	mahjong_ui:HideKouOperTips()
	mahjong_ui:HideTingBackBtn()
	if game_state == "prepare" then  		--准备阶段
		--显示准备提示准备
		mahjong_ui:ResetAll()

		for i=1,roomdata_center.MaxPlayer() do
			local viewSeat = self.gvblnFun(i)
			local state = player_state[i]
			if state ~= nil then
				if state == 2 then
					mahjong_ui:SetPlayerReady(viewSeat, true)
					if viewSeat == 1 then
						mahjong_ui:SetReadyBtnVisible(false)
					end
				elseif state == 1 then
					if viewSeat == 1 then
						mahjong_ui:ShowReadyBtns()
					end
				end
			end
		end
	elseif game_state == "xiapao" then 		--下跑阶段
		roomdata_center.isStart = true
		mahjong_ui:HideAllReadyBtns()
		--定庄
		--self:OnResetDealer( dealer,lianZhuang )
		self:ResetXiaPaoState(xiapao)
	elseif game_state == "deal" then 		--发牌阶段
		roomdata_center.isStart = true
		mahjong_ui:HideAllReadyBtns()
		--定庄
		self:OnResetDealer( dealer,lianZhuang )
		--显示下跑
		if xiapao~=nil then
			self:OnResetXiaPao( xiapao )
		end
	elseif game_state == "laizi" then 		--癞子阶段

		roomdata_center.isStart = true
		mahjong_ui:HideAllReadyBtns()
		--定庄
		self:OnResetDealer( dealer,lianZhuang )
		--显示下跑
		if xiapao~=nil then
			self:OnResetXiaPao( xiapao )
		end
	elseif game_state == "round" then 		--出牌阶段
		roomdata_center.isStart = true
		mahjong_ui:HideAllReadyBtns()
		--定庄
		self:OnResetDealer( dealer,lianZhuang )
		--显示下跑
		if xiapao~=nil then
			self:OnResetXiaPao( xiapao )
		end
		--显示癞子
		if laizi~=nil and laizi.laizi[1]~=nil then
			mahjong_ui:ShowSpecialCard(laizi.laizi[1],1,self.cfg.specialCardSpriteName)
		end

		--恢复次牌
        if ci and ci.cards~=0 then
            mahjong_ui:ShowSpecialCard(ci.cards,1,self.cfg.specialCardSpriteName)
        end

		local viewSeat = self.gvblnFun(whoisOnTurn)
		if viewSeat ~= 1 then
	    	mahjong_ui:ShowHeadEffect(viewSeat)
	    end
		--roomdata_center.leftCard = tileLeft

	elseif game_state == "reward" then 		--结算阶段
		--todo
	elseif game_state == "gameend" then 	--结束阶段
		--todo
	end

	local gameStart = game_state ~= "reward" and game_state ~= "prepare" and game_state ~= "reward" 

	if gameStart then
        for i=1,roomdata_center.MaxPlayer() do
            mahjong_ui:SetPlayerReady(i, false)
        end
        mahjong_ui:HideAllReadyBtns()
    end

    mahjong_ui:HideRewards()

    if stPlayerNoChair ~= nil then
    	for i = 1, #stPlayerNoChair do
    		local viewSeat = self.gvblnFun(stPlayerNoChair[i])
    		mahjong_ui:HidePlayer(viewSeat)
    	end
    end
end

function mahjong_action_gameSyncTable:ResetXiaPaoState(xiapao)
	for i = 1, roomdata_center.MaxPlayer() do
		local value = xiapao[i]
		local viewSeat = self.gvblnFun(i)
		if value ~= -1 then
			if value == 0 then
				mahjong_ui:UpdateXiaPaoState(viewSeat,4,self.cfg)
			else
				mahjong_ui:UpdateXiaPaoState(viewSeat,3,self.cfg)
			end
		else
			if viewSeat == 1 then
				-- 自己没有下马中的状态
				mahjong_ui:UpdateXiaPaoState(viewSeat,1,self.cfg)
			else
				mahjong_ui:UpdateXiaPaoState(viewSeat,2,self.cfg)
			end
		end
	end

end

function mahjong_action_gameSyncTable:OnResetDealer( dealer,lianZhuang )
	--定庄
	local banker_viewSeat = self.gvblFun(dealer)
	roomdata_center.zhuang_viewSeat = banker_viewSeat
	mahjong_ui:SetBanker(banker_viewSeat)
	mahjong_ui:SetLianZhuang(banker_viewSeat,lianZhuang)
end

function mahjong_action_gameSyncTable:OnResetXiaPao( xiapao )
	mahjong_ui:HideXiaPao()
	--显示下跑
	for i=1,roomdata_center.MaxPlayer() do
		local viewSeat = self.gvblnFun(i)
        if roomdata_center.gamesetting.bSupportXiaPao then
			mahjong_ui:UpdateXiaPaoState(viewSeat,1,self.cfg)
			mahjong_ui:SetXiaoPao(viewSeat,(self.cfg.xiapaoChinese or "")..xiapao[i])
        end
	end
end

return mahjong_action_gameSyncTable