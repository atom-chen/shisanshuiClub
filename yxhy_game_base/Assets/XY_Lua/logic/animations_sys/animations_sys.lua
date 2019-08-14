
--[[--
 * @Description:负责spine动画的统一处理
 * @Author:      xuemin.lin
 * @FileName:    animations_sys
 * @DateTime:    
 ]]

animations_sys = {}
local this  = animations_sys

local animationCatchList = {}

local animationLoopCacheMap = {}
local animationsPath = "Prefabs/Animations/"

local animationQueue = {}
function animationQueue.New()
	return {first = 0, last = -1}
end

function animationQueue.pushLast(animationQueue, value)
	local last = animationQueue.last + 1;
	animationQueue.last = last;
	animationQueue[last] = value
end

function animationQueue.popFirst(animationQueue)
	local first = animationQueue.first
	if first > animationQueue.last then error("animationQueue is empty") end
	local value = animationQueue[first]
	animationQueue[first] = nil
	animationQueue.first = first + 1
	return value
end


--[[

parentsTrans:父结点
animationsID：动画Prefab的名字
animationName：动画名称
width：宽
height：高
PlayComPletecallback：播放完成回调
调用参考 吃碰杠糊动画名称分别为 chi1  gang1 peng1 hu1 zimo1
animations_sys.PlayAnimation(this.gameObject.transform,"chi_peng_gang_hu","gang1",100,100,flase,function() 
		Trace("PlayComPlete111111")
	end)

]]
function this.PlayAnimation(parentsTrans,animationsID,animationName,width,height,isLoop,PlayComPletecallback,renderQueue,sortingOrder)
	local animObj = nil 
--	if animationCatchList[animationsID] ~= nil and not IsNil(animationCatchList[animationsID]) then
	if animationCatchList[animationsID] ~= nil  then
	--	logError("找到缓存动画:"..animationsID)
		animObj = animationCatchList[animationsID];
	else
	--	logError("新建缓存动画:"..animationsID)
		animObj = newNormalUI(animationsID)
		animationCatchList[animationsID] = animObj
		
	end
	if animObj ~= nil then
		animObj.transform.parent = parentsTrans
		animObj.transform.localPosition = Vector3.zero
		animObj.transform.localScale = Vector3.New(width,height,1)
		animObj:SetActive(true);
		local skeletonAnimComponet = componentGet(animObj.transform,"SkeletonAnimation")
		if skeletonAnimComponet ~= nil then	
			if renderQueue ~= nil then
				skeletonAnimComponet:ChangeQueue(tonumber(renderQueue))
			end
			if sortingOrder ~= nil then	--renderQueue需要为nil
				Utils.SetEffectSortLayer(animObj.gameObject,sortingOrder)
			end
			local sketonAnimState = skeletonAnimComponet.AnimationState;
		--	skeletonAnimComponet.Skeleton:SetSlotsToSetupPose()
			sketonAnimState:ClearTracks()
			sketonAnimState:SetAnimation(0,animationName,isLoop)
			skeletonAnimComponet.playComPleteCallBack = function(trackEntry)
		--		Trace("PlayComPlete")
				animObj:SetActive(false);
				if PlayComPletecallback ~= nil then
					PlayComPletecallback()
					PlayComPletecallback = nil
					
				end
			end
		end
	end
end

function this.PlayAnimationByScreenPosition(parentsTrans,offsetx,offsety,animationsID,animationName,width,height,isLoop,PlayComPletecallback,renderQueue,isDestroy,sortingOrder)
	
	--if animationCatchList[animationsID] ~= nil and not IsNil(animationCatchList[animationsID]) then
	local animObj = newNormalUI(animationsID)
	if animObj ~= nil then
		animObj.transform.parent = parentsTrans
		animObj.transform.localPosition = Vector3(offsetx,offsety,0)
		animObj.transform.localScale = Vector3.New(width,height,1)
		animObj:SetActive(true);
		local skeletonAnimComponet = componentGet(animObj.transform,"SkeletonAnimation")
		if skeletonAnimComponet ~= nil then
			if renderQueue ~= nil then
				skeletonAnimComponet:ChangeQueue(renderQueue)
			end
			if sortingOrder ~= nil then	
				Utils.SetEffectSortLayer(animObj.gameObject,sortingOrder)
			end
			local sketonAnimState = skeletonAnimComponet.AnimationState;
		--	skeletonAnimComponet.Skeleton:SetSlotsToSetupPose()
			sketonAnimState:ClearTracks()
			sketonAnimState:SetAnimation(0,animationName,isLoop)
			skeletonAnimComponet.playComPleteCallBack = function(trackEntry)
		--		Trace("PlayComPlete")
			--	animObj:SetActive(false);
				
				if PlayComPletecallback ~= nil then
					PlayComPletecallback()
					PlayComPletecallback = nil	
				end
				if isDestroy == nil or isDestroy == true then
					Trace("动画被销毁")
					GameObject.Destroy(animObj.gameObject)
				end
			end
	
		end
		-- return animObj.transform
		return animObj.gameObject
	end
	return GameObject.New().transform

--	else
--		this.AddAnimationToList(animationsID)
--		this.PlayAnimation(parentsTrans,animationsID,animationNam
end

function this.PlayAnimationByObj(animObj, offsetx, offsety, animationName, width, height, PlayComPletecallback, renderQueue)
	if animObj ~= nil then
		animObj.transform.localPosition = Vector3(offsetx, offsety, 0)
		animObj.transform.localScale = Vector3.New(width, height, 1)
		animObj.gameObject:SetActive(true)
		local skeletonAnimComponet = componentGet(animObj.transform, "SkeletonAnimation")
		if skeletonAnimComponet ~= nil then
			if renderQueue ~= nil then
				skeletonAnimComponet:ChangeQueue(renderQueue)
			end
			local sketonAnimState = skeletonAnimComponet.AnimationState
			sketonAnimState:ClearTracks()
			sketonAnimState:SetAnimation(0, animationName, false)
			if playComPleteCallBack ~= nil then
				skeletonAnimComponet.playComPleteCallBack = function(trackEntry)			
					if PlayComPletecallback ~= nil then
						PlayComPletecallback()
						PlayComPletecallback = nil	
					end
				end
			end
	
		end
	end
	return animObj.transform
end

function this.PlayAnimationWithLoop(parentsTrans,animationsID,animationName,width,height)
	local gameObj = newNormalUI(animationsID)
	if gameObj ~= nil then
		gameObj.transform.parent = parentsTrans
		gameObj.transform.localPosition = Vector3.zero
		gameObj.transform.localScale = Vector3.New(width,height,1)
		gameObj:SetActive(true);
		local skeletonAnimComponet = componentGet(gameObj.transform,"SkeletonAnimation")
		if skeletonAnimComponet ~= nil then
			skeletonAnimComponet:ChangeQueue(1406)
			local sketonAnimState = skeletonAnimComponet.AnimationState;
		--	skeletonAnimComponet.Skeleton:SetSlotsToSetupPose()
			sketonAnimState:ClearTracks()
			sketonAnimState:SetAnimation(0,animationName,true)
		--	skeletonAnimComponet.playComPleteCallBack = function(trackEntry)
			--	Trace("PlayComPlete")
			--	gameObj:SetActive(false);
			--	Destroy(gameObj.gameObject)
		--	end
		end
	end
	return gameObj.transform
end

function this.StopPlayAnimation(trans)
	if not IsNil(trans) then
		local skeletonAnimComponet = componentGet(trans.transform,"SkeletonAnimation")
		if skeletonAnimComponet ~= nil then
		local sketonAnimState = skeletonAnimComponet.AnimationState
			sketonAnimState:ClearTracks()
			sketonAnimState:SetEmptyAnimation(0,0);
			trans.gameObject:SetActive(false);
			GameObject.Destroy(trans.gameObject)
			Trace("Destory animations")
		end
	end
end


function this.PlayLoopAnimation(parentsTrans,animationsID,animationName,width,height, renderQueue)
	local tr = this.GetAnimationFromCacheMap(animationsID)
	if tr == nil or IsNil(tr)then
		local go = newNormalUI(animationsID)
		if go == nil then
			logError("找不到 animation", animationsID)
			return nil
		end
		tr = go.transform
	end
	if tr == nil then
		return
	end

	tr:SetParent(parentsTrans, false) 
	tr.localPosition = Vector3.zero
	tr.localScale = Vector3.New(width,height,1)
	
	local skeletonAnimComponet = componentGet(tr,"SkeletonAnimation")
	if skeletonAnimComponet ~= nil then
		if renderQueue ~= nil then
			skeletonAnimComponet:ChangeQueue(renderQueue)
		end
		local sketonAnimState = skeletonAnimComponet.AnimationState;
	--	skeletonAnimComponet.Skeleton:SetSlotsToSetupPose()
		sketonAnimState:ClearTracks()
		sketonAnimState:SetAnimation(0,animationName,true)
	end
	tr.gameObject:SetActive(true);
	return tr
end

function this.StopPlayAnimationToCache(trans, animationsID)
	if not IsNil(trans) then
		local skeletonAnimComponet = componentGet(trans.transform,"SkeletonAnimation")
		if skeletonAnimComponet ~= nil then
			local sketonAnimState = skeletonAnimComponet.AnimationState
			sketonAnimState:ClearTracks()
			sketonAnimState:SetEmptyAnimation(0,0);
			trans.gameObject:SetActive(false);
			-- GameObject.Destroy(trans.gameObject)
			-- Trace("Destory animations")
			if animationsID ~= nil then
				this.AddToCacheMap(trans, animationsID)
			else
				GameObject.Destroy(trans.gameObject)
			end
		end

	end
end

function this.GetAnimationFromCacheMap(animationsID)
	local cacheList = animationLoopCacheMap[animationsID]
	if cacheList == nil or #cacheList == 0 then
		return nil
	end
	for i = #cacheList, 1, -1 do
		if cacheList[i] ~= nil then
			local tr = cacheList[i]
			table.remove(cacheList, i)
			if tr ~= nil then
				return  tr;
			end
		end
	end
	return nil
end

function this.AddToCacheMap(tr, animationsID)
	if tr == nil then
		return
	end
	if animationLoopCacheMap[animationsID] == nil then
		animationLoopCacheMap[animationsID] = {}
	end
	table.insert(animationLoopCacheMap[animationsID], tr)
end

--[[function this.StopPlayAnimation(animationID)
		if animationCatchList[animationsID] ~= nil then 
			local skeletonAnimComponet = componentGet(trabs.transform,"SkeletonAnimation")
			if skeletonAnimComponet ~= nil then
				local sketonAnimState = skeletonAnimComponet.AnimationState
				sketonAnimState:ClearTracks()
				sketonAnimState:SetEmptyAnimation(0,0);
				SkeletonAnimation.transform.SetActive(false);
			end
		else
			Trace("StopPlayAnimation Error! animationsID is not exist")
		end
	
end
]]
function this.test(trackEntry)
	Trace("PlayComPlete")
end

function this.AddAnimationToList(animationsID)
	local gameObj = newNormalUI(animationsID)
	if gameObj ~= nil then
		animationCatchList[animationsID] = gameObj;
	end
end
