local base = require "logic/mahjong_sys/ui_mahjong/reward/ui_view_base"
local reward_head_view = class("reward_head_view", base)


-- huicon 不需要处理
function reward_head_view:InitView()
	base.InitView(self)
	self.headIconTex = self:GetComponent("headIcon", typeof(UITexture))
	self.nameLabel = self:GetComponent("name", typeof(UILabel))
	self.zhuangIconGo = self:GetGameObject("zhuangIcon")
	self.winIconGo = self:GetGameObject("huIcon")

	self.zhuangIconGo:SetActive(false)
end

function reward_head_view:SetInfo(name, url, isBanker, imgType)
	self.nameLabel.text = name
	self.zhuangIconGo:SetActive(isBanker)
	hall_data.getuserimage(self.headIconTex,imgType,url)
end

function reward_head_view:ShowWinIcon(value)
	if self.winIconGo ~= nil then
		self.winIconGo:SetActive(value)
	end
end


return reward_head_view