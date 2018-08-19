stds.roblox = {
	globals = {"game", "plugin", "script", "shared", "Enum", "workspace"; -- Variables
	"Axes", "BrickColor", "CFrame", "Color3", "ColorSequence", "ColorSequenceKeypoint"; --Constructors
	"DockWidgetPluginGuiInfo", "Faces", "Instance", "NumberRange", "NumberSequence";
	"NumberSequenceKeypoint", "PathWaypoint", "PhysicalProperties", "Random", "Ray";
	"Rect", "Region3", "Region3Int16", "TweenInfo", "UDim", "UDim2", "Vector2", "Vector3";
	"Vector3int16";
	"delay", "elapsedTime", "require", "settings", "spawn", "tick", "time", "typeof";  -- roblox functions
	"UserSettings", "version", "wait", "warn", "debug", "math";
	"tostring"-- lua functions
	}
}

stds.testez = {
	globals = {"expect", "it"}
}

ignore = {
	"421", -- shadowing local variable
	"422", -- shadowing argument
	"431", -- shadowing upvalue
	"432", -- shadowing upvalue argument
	"631",
	"111",
}

std = "lua51+roblox+testez"