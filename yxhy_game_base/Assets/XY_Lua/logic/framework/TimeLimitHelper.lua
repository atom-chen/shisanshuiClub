local TimeLimitHelper = {}
local Time = Time
local _timeMap = {}


function TimeLimitHelper.CheckTimeLimit(key, totalTime)
	local time = _timeMap[key]
	if time ~= nil and time > 0 then
		return false
	end
	_timeMap[key] = totalTime
	return true
end

function TimeLimitHelper.Update()
	for k, v in pairs(_timeMap) do
		if v > 0 then
			_timeMap[k] = v - Time.deltaTime
		end
	end
end

function TimeLimitHelper.Init()
	UpdateBeat:Add(TimeLimitHelper.Update)
end

TimeLimitHelper.Init()


return TimeLimitHelper