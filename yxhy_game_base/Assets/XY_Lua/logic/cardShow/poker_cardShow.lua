require "logic/poker_sys/common/poker2d_factory"
local poker_cardShow = class("poker_cardShow")
local poolBaseClass = require "logic/common/poolBaseClass"

function poker_cardShow:ctor(tran_pokerShow,cardData,nSpecialType)
	self.tran_cardShow = tran_pokerShow
	self.cardData = cardData
	self.nSpecialType = nSpecialType or 0
	self.isChip = false
	self.scale = Vector3(0.5,0.5,0.5)
	self.gridCellWidth = 0
	self.updateDepth = 0
	self:ResetCards()
	self:InitView()
end

function poker_cardShow:InitView()
	self.cardGrid1 = child(self.tran_cardShow,"cardGrid1")
	self.cardGrid2 = child(self.tran_cardShow,"cardGrid2")
	self.cardGrid3 = child(self.tran_cardShow,"cardGrid3")
end

function poker_cardShow:SetShisanshuiCardShow()
	if self.cardData == nil or isEmpty(self.cardData) then
		return
	end
	local cardObj = nil

	for k, v in ipairs(self.cardData) do
		cardObj = poker2d_factory.GetPoker(v)
		if self.nSpecialType ~= 0 then
			cardObj.transform:SetParent(self.cardGrid1,false)
		else
			if k >= 1 and k <= 5 then
				cardObj.transform:SetParent(self.cardGrid3,false)
			elseif k >= 6 and k <= 10 then
				cardObj.transform:SetParent(self.cardGrid2,false)
			elseif k >= 11 and k <= 13 then
				cardObj.transform:SetParent(self.cardGrid1,false)					
			end
		end
		if cardObj ~= nil then
			cardObj.transform.localScale = self.scale
			componentGet(child(cardObj.transform, "bg"),"UISprite").depth = k * 2 + 3 + self.updateDepth
			componentGet(child(cardObj.transform, "num"),"UISprite").depth = k * 2 + 5 + self.updateDepth
			componentGet(child(cardObj.transform, "color1"),"UISprite").depth = k * 2 + 5 + self.updateDepth
			componentGet(child(cardObj.transform, "color2"),"UISprite").depth = k * 2 + 5 + self.updateDepth
			componentGet(cardObj, "BoxCollider").enabled = false
		end
		if self.isChip == true and v == card_define.GetCodeCard() then
			child(cardObj.transform,"ma").gameObject:SetActive(true)
			componentGet(child(cardObj.transform, "ma"),"UISprite").depth = k * 2 + 4 + self.updateDepth
		end
	end
	componentGet(self.cardGrid1,"UIGrid").cellWidth = self.gridCellWidth
	componentGet(self.cardGrid1,"UIGrid").enabled = true
	componentGet(self.cardGrid2,"UIGrid").cellWidth = self.gridCellWidth
	componentGet(self.cardGrid2,"UIGrid").enabled = true
	componentGet(self.cardGrid3,"UIGrid").cellWidth = self.gridCellWidth
	componentGet(self.cardGrid3,"UIGrid").enabled = true
end

function poker_cardShow:SetNiuNiuCardShow()
	if self.cardData == nil or isEmpty(self.cardData) then
		return
	end
	local cardObj = nil
	
	for k, v in ipairs(self.cardData) do
		cardObj = poker2d_factory.GetPoker(v)
		if k >= 1 and k <= 3 then
			cardObj.transform:SetParent(self.cardGrid1,false)
		elseif k >= 4 and k <= 5 then
			cardObj.transform:SetParent(self.cardGrid2,false)
		end
		if cardObj ~= nil then
			cardObj.transform.localScale = self.scale
			componentGet(child(cardObj.transform, "bg"),"UISprite").depth = k * 2 + 3 + self.updateDepth
			componentGet(child(cardObj.transform, "num"),"UISprite").depth = k * 2 + 5 + self.updateDepth
			componentGet(child(cardObj.transform, "color1"),"UISprite").depth = k * 2 + 5 + self.updateDepth
			componentGet(child(cardObj.transform, "color2"),"UISprite").depth = k * 2 + 5 + self.updateDepth
			componentGet(cardObj, "BoxCollider").enabled = false
		end
	end
	componentGet(self.cardGrid1,"UIGrid").cellWidth = self.gridCellWidth
	componentGet(self.cardGrid1,"UIGrid").enabled = true
	componentGet(self.cardGrid2,"UIGrid").cellWidth = self.gridCellWidth
	componentGet(self.cardGrid2,"UIGrid").enabled = true
end

function poker_cardShow:ResetCards()
	if self.tran_cardShow == nil then
		return
	end	
	for i=1,3 do
		local cardGrid = child(self.tran_cardShow,"cardGrid"..i)	
		for k=cardGrid.transform.childCount-1,0,-1 do		
			local cardTran = cardGrid.transform:GetChild(k)
			cardTran.parent = nil
			cardTran.gameObject:SetActive(false)
			GameObject.Destroy(cardTran.gameObject)
		end
	end
end

function poker_cardShow:SetPokerCardShow(gid)
	if gid == ENUM_GAME_TYPE.TYPE_SHISHANSHUI or gid == ENUM_GAME_TYPE.TYPE_PINGTAN_SSS or gid == ENUM_GAME_TYPE.TYPE_DuoGui_SSS
	  or gid == ENUM_GAME_TYPE.TYPE_PUXIAN_SSS or gid == ENUM_GAME_TYPE.TYPE_ShuiZhuang_SSS or gid == ENUM_GAME_TYPE.TYPE_BaRen_SSS 
	  or gid == ENUM_GAME_TYPE.TYPE_ChunSe_SSS then
		self.gridCellWidth = 29
		self.cardGrid1.localPosition = Vector3(0,-5,0)
		self.cardGrid2.localPosition = Vector3(150,-5,0)
		self.cardGrid3.localPosition = Vector3(360,-5,0)
		self:SetShisanshuiCardShow()
	elseif gid == ENUM_GAME_TYPE.TYPE_NIUNIU  or gid == ENUM_GAME_TYPE.TYPE_SANGONG then
		self.gridCellWidth = 70
		self.cardGrid1.localPosition = Vector3(0,-5,0)
		self.cardGrid2.localPosition = Vector3(243,-5,0)
		self:SetNiuNiuCardShow()
	end
end

return poker_cardShow