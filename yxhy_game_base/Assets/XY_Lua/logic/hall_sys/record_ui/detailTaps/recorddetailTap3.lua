local base = require("logic.framework.ui.uibase.ui_childwindow")
local Tab_class = class("recorddetailTap3",base)

local ruleCfgBase = config_mgr.getConfigs("cfg_rule")
local ruleCfg = {}
for k,v in pairs(ruleCfgBase) do
	ruleCfg[k] = v
	local ruleKey = v.RoomRuleKey
	if ruleKey and string.len(ruleKey) >0 then
		ruleCfg[ruleKey] = v
	end
end

function Tab_class:ctor()
	base.ctor(self)
end

function Tab_class:OnInit()
	base.OnInit(self)
end

function Tab_class:OnOpen()
	base.OnOpen(self)
	Trace("Tab_c OnOpen")
end

function Tab_class:OnClose()
	base.OnClose(self)
	Trace("Tab_c OnClose")
end

function Tab_class:UpdateView(_data, _isTimer)

	if not self.updateTimer then
	    self.updateTimer = FrameTimer.New(function()
	        self:UpdateView(_data, true)
	        self.updateTimer = nil
	      end,1,1)
	    self.updateTimer:Start()
	end
	if not _isTimer then
		return
	end
	
	if not _data then
		return
	end

	local gid = _data.gid
	local cfgTbl = {}
	for k,v in pairs(_data.cfg or {}) do
		cfgTbl[k] = v
	end
	
	Trace("cfgTbl------"..GetTblData(cfgTbl))
	local function getRuleString(_ruleKeyTbl, _context)
		if not _ruleKeyTbl or type(_ruleKeyTbl) ~="table" then
			return ""
		end

		local context = _context
		
		for k,v in pairs(_ruleKeyTbl or {}) do
			local cfgValue = cfgTbl[v]
			if not cfgValue then
				--id没对应的则在RoomRuleKey找
				if ruleCfg[v] then
					cfgValue = cfgTbl[ruleCfg[v].RoomRuleKey]
				else
					logError("cfg_rule不存在key:"..v)
				end
			end

			if cfgValue then
				local valueTbl
				if ruleCfg[v] then
					if gid and ruleCfg[v].shareValueByGid and ruleCfg[v].shareValueByGid[gid] then
						valueTbl = ruleCfg[v].shareValueByGid[gid]
					else
						valueTbl = ruleCfg[v].shareValue
					end
				else
					logError("cfg_rule不存在key:"..v)
				end
				if valueTbl and type(valueTbl) =="table" then
					local ruleName = valueTbl[cfgValue]
					if ruleName and string.len(ruleName) >0 then
						if string.len(context) <1 then
							context = ruleName
						else
							context = context..", "..ruleName
						end
						cfgTbl[v] = nil
					end
				else
					local valueTbl
					if ruleCfg[v] then
						valueTbl = ruleCfg[v].value
					else
						logError("cfg_rule不存在key:"..v)
					end
					if valueTbl and type(valueTbl) =="table" then
						local tempContent
						if gid and ruleCfg[v].nameByGid and ruleCfg[v].nameByGid[gid] then
							tempContent = ruleCfg[v].nameByGid[gid]
						else
							tempContent = ruleCfg[v].name
						end
						if valueTbl[cfgValue] then
							tempContent = tempContent..":"..valueTbl[cfgValue]
						end
						if string.len(context) <1 then
							context = tempContent
						else
							context = context..", "..tempContent
						end
						cfgTbl[v] = nil
					end
				end
			end
			
			---牛牛特殊处理
			if ENUM_GAME_TYPE.TYPE_NIUNIU == gid  or ENUM_GAME_TYPE.TYPE_SANGONG == gid then
				require "logic/poker_sys/utils/PokerShareSpecialDeal"
				local shareStr = PokerShareSpecialDeal.ProduceValue(gid,v,cfgTbl[v])
				if shareStr then
					context = context..", "..shareStr
				end
			end
		end
		return context
	end

	--模式(roomRulesKey中存在的)
	-- local context = GameUtil.GetGameName(datatable.gid)..", 牌局人数:"..datatable.cfg.pnum
	local context = getRuleString(GameUtil.GetRoomRulesKeys(gid), GameUtil.GetGameName(gid))
	local Label_mode = child(self.gameObject.transform, "Label_content1")
	if Label_mode then
		context = string.gsub(context, "玩法:", "")
		componentGet(Label_mode, "UILabel").text = (string.len(context) >0 and context or "无")
	end

	--其他(roomRulesOtherKey中存在的)
	context = getRuleString(GameUtil.GetRoomRulesOtherKeys(gid), "")
	local Label_other = child(self.gameObject.transform, "Label_content3")
	if Label_other then
		context = string.gsub(context, ":是", "")
		componentGet(Label_other, "UILabel").text = (string.len(context) >0 and context or "无")
	end

	--玩法(shareValue)
	context = getRuleString(GameUtil.GetRoomGamePlayKeys(gid), "")
	
	local Label_content = child(self.gameObject.transform, "Label_content2")
	if Label_content then
		componentGet(Label_content, "UILabel").text = (string.len(context) >0 and context or "无")
	end

end

return Tab_class