local mode_comp_base = require "logic/mahjong_sys/components/base/mode_comp_base"

local comp_mjItemMgr = class("comp_mjItemMgr", mode_comp_base)

function comp_mjItemMgr:ctor(itemPath)
	itemPath = itemPath or "logic/mahjong_sys/components/base/comp_mjItem"
	self.name = "comp_mjItemMgr"
    self.mjItemClass = require (itemPath)

    self.mjItemList = {}--麻将子组件列表，从视图玩家1左边第一墩从下至上开始

    self.mjObjDict = {}
    setmetatable(self.mjObjDict, {__mode = "kv"})
    self.config = nil
end

function comp_mjItemMgr:Initialize()
	mode_comp_base.Initialize(self)
	self:InitMJItems()
end

--[[--
 * @Description: 初始化麻将子  
 ]]
function comp_mjItemMgr:InitMJItems()
    if self.config == nil then
        self.config = self.mode.config
    end
    if #self.mjItemList == 0 then

        for i=1,self.config.MahjongTotalCount,1 do
            local mj = self.mjItemClass:new()
            mj:CreateObj()
            mj.mode = self.mode
            mj.mjObj.name = "MJ"..i

            mj:Init()
            table.insert(self.mjItemList, mj)
            self.mjObjDict[mj.mjObj] = mj            
        end
    else

        for i=1,self.config.MahjongTotalCount,1 do
            self.mjItemList[i]:Init()
        end
    end

end

function comp_mjItemMgr:Uninitialize()
	mode_comp_base.Uninitialize(self)
    for i,v in ipairs(self.mjItemList) do
        if v~=nil then
            v:Uninitialize()
        end
    end
    mjObjDict = {}
end

return comp_mjItemMgr