--[[--
 * @Description: 场景逻辑类型，目前包括登陆、大厅、麻将
 * @Author:      shine
 * @FileName:    scene_type.lua
 * @DateTime:    2015-06-04 14:30:47
 ]]
require"logic/common/global_define"
scene_type = 
{
	NONE = "SCENE_NONE",       -- 无
	LOGIN = "SCENE_LOGIN",     -- 登陆页
	HALL = "SCENE_HALL",       -- 大厅
    HENANMAHJONG = "HENAN_MAHJONG", -- 河南麻将游戏  
    GAME = "GAME",    --- 所有玩法的场景均为Game  
    --FUJIANSHISANGSHUI = "FUJIANSHISANGSHUI" ,--福建 十三水 
	--NIUNIU = ENUM_GAME_TYPE.TYPE_NIUNIU --牛牛
}