local card_poker = class("card_poker")
function card_poker:ctor()
	self.cardvalue = nil;
	self.gameObject = nil;
	self.isFront = false;
	self.EventOnClick = nil;
	self.meshFilter = nil;
	self.meshRenderer = nil
	self.originalMat = nil
	self.resPath = "Prefas/Scene/shisangshui/PokerCard"
	self:createObj(self.resPath)
    	
end

function card_poker:createObj(path)
	local resCardObj = newNormalObjSync(self.resPath,typeof(GameObject))
	self.gameObject = newobject(resCardObj)
	self.meshFilter = self.gameObject:GetComponentInChildren(typeof(UnityEngine.MeshFilter))
	self.meshRenderer = self.gameObject:GetComponentInChildren(typeof(UnityEngine.MeshRenderer))
	self.originalMat = self.meshRenderer.sharedMaterial
	
end

function card_poker:setMesh(value)
	self.cardvalue = value
	if self.gameObject ~= nil and self.meshFilter ~= nil then
		local index = card_define.GetCardMeshByValue(self.cardvalue)
		self.meshFilter.mesh = resMgr_component:GetCardMesh(index)
	end
end

--��ʾ
function card_poker:Show(front,isAnim)
	if front~=nil then
		isFront = front
	end
	if(self.gameObject~=nil) then
		self.gameObject:SetActive(true)
		if isFront then
			if isAnim~=nil and isAnim then
				self.gameObject.transform:DOLocalRotate(Vector3(0,0,0), 0.3, DG.Tweening.RotateMode.Fast)
			else
				self.gameObject.transform.localEulerAngles = Vector3(0, 0, 0)
			end
		else
			if isAnim~=nil and isAnim then
				self.gameObject.transform:DOLocalRotate(Vector3(0,0,180), 0.3, DG.Tweening.RotateMode.Fast)
			else
				self.gameObject.transform.localEulerAngles = Vector3(0, 0, 180)
			end
		end
	end
end

--����
function card_poker:Hide()
	if(self.gameObject ~= nil) then
		self.gameObject:SetActive(false)
	end
end

return card_poker