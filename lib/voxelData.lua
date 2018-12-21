local LuaBits = require(script.LuaBits)

local voxelSpec = {
	['Key']    = "Root";
	['Type']   = LuaBits.DataTypes.TABLE;
	['Values'] = {
		{
			['Key']       = "MapSize";
			['Type']      = LuaBits.DataTypes.TABLE;
			['Values']    = {
				{
					['Key']  = "X";
					['Type'] = LuaBits.DataTypes.INT;
					['Size'] = 12;
				};{
					['Key']  = "Y";
					['Type'] = LuaBits.DataTypes.INT;
					['Size'] = 12;
				};{
					['Key']  = "Z";
					['Type'] = LuaBits.DataTypes.INT;
					['Size'] = 12;
				};
			}
		};{
			['Key']    = "Pallette";
			['Type']   = LuaBits.DataTypes.TABLE;
			['Values'] = {
				{
					['Type']   = LuaBits.DataTypes.TABLE;
					['Repeat'] = 16;
					['Values'] = {
						{
							['Key']  = "R";
							['Type'] = LuaBits.DataTypes.INT;
							['Size'] = 8;
						};{
							['Key']  = "G";
							['Type'] = LuaBits.DataTypes.INT;
							['Size'] = 8;
						};{
							['Key']  = "B";
							['Type'] = LuaBits.DataTypes.INT;
							['Size'] = 8;
						};
					}
				}
			}
		};{
			['Key']    = "Voxels";
			['Type']   = LuaBits.DataTypes.TABLE;
			['Values'] = {
				{
					['Type']        = LuaBits.DataTypes.TABLE;
					['RepeatToEnd'] = true;
					['Values']      = {
						{
							['Key']    = "StartPosition";
							['Type']   = LuaBits.DataTypes.TABLE;
							['Values'] = {
								{
									['Key']  = "X";
									['Type'] = LuaBits.DataTypes.INT;
									['Size'] = "SizeX";
								};{
									['Key']  = "Y";
									['Type'] = LuaBits.DataTypes.INT;
									['Size'] = "SizeY";
								};{
									['Key']  = "Z";
									['Type'] = LuaBits.DataTypes.INT;
									['Size'] = "SizeZ";
								}
							}
						};{
							['Key']    = "EndPosition";
							['Type']   = LuaBits.DataTypes.TABLE;
							['Values'] = {
								{
									['Key']  = "X";
									['Type'] = LuaBits.DataTypes.INT;
									['Size'] = "SizeX";
								};{
									['Key']  = "Y";
									['Type'] = LuaBits.DataTypes.INT;
									['Size'] = "SizeY";
								};{
									['Key']  = "Z";
									['Type'] = LuaBits.DataTypes.INT;
									['Size'] = "SizeZ";
								}
							}
						};{
							['Key']  = "Color";
							['Type'] = LuaBits.DataTypes.INT;
							['Size'] = 4;
						};{
							['Key']  = "Material";
							['Type'] = LuaBits.DataTypes.INT;
							['Size'] = 2;
						};{
							['Key']  = "IsBreakable";
							['Type'] = LuaBits.DataTypes.BOOL;
						};{
							['Key']  = "HasGravity";
							['Type'] = LuaBits.DataTypes.BOOL;
						}
					}
				}
			}
		}
	}
}

local voxelData = {
	MapSize = {
		['X'] = 255;
		['Y'] = 255;
		['Z'] = 255;
	};
	Pallette = {
		{
			['R'] = 255;
			['G'] = 255;
			['B'] = 255;
		};{
			['R'] = 255;
			['G'] = 255;
			['B'] = 255;
		};{
			['R'] = 255;
			['G'] = 255;
			['B'] = 255;
		};{
			['R'] = 255;
			['G'] = 255;
			['B'] = 255;
		};{
			['R'] = 255;
			['G'] = 255;
			['B'] = 255;
		};{
			['R'] = 255;
			['G'] = 255;
			['B'] = 255;
		};{
			['R'] = 255;
			['G'] = 255;
			['B'] = 255;
		};{
			['R'] = 255;
			['G'] = 255;
			['B'] = 255;
		};{
			['R'] = 255;
			['G'] = 255;
			['B'] = 255;
		};{
			['R'] = 255;
			['G'] = 255;
			['B'] = 255;
		};{
			['R'] = 255;
			['G'] = 255;
			['B'] = 255;
		};{
			['R'] = 255;
			['G'] = 255;
			['B'] = 255;
		};{
			['R'] = 255;
			['G'] = 255;
			['B'] = 255;
		};{
			['R'] = 255;
			['G'] = 255;
			['B'] = 255;
		};{
			['R'] = 255;
			['G'] = 255;
			['B'] = 255;
		};{
			['R'] = 255;
			['G'] = 255;
			['B'] = 255;
		};
	};
	Voxels = {
		{
			['StartPosition'] = {
				X = 0,
				Y = 0,
				Z = 0,
			};
			['EndPosition'] = {
				X = 255,
				Y = 0,
				Z = 255,
			};
			Color = 0;
			Material = 0;
			IsBreakable = false;
			HasGravity  = false;
		};{
			['StartPosition'] = {
				X = 0,
				Y = 1,
				Z = 0,
			};
			['EndPosition'] = {
				X = 255,
				Y = 1,
				Z = 255,
			};
			Color = 1;
			Material = 1;
			IsBreakable = true;
			HasGravity  = true;
		};
		{
			['StartPosition'] = {
				X = 0,
				Y = 2,
				Z = 0,
			};
			['EndPosition'] = {
				X = 255,
				Y = 2,
				Z = 255,
			};
			Color = 2;
			Material = 2;
			IsBreakable = true;
			HasGravity  = true;
		};
	}
}

local sizeCallbacks = {
	['SizeX'] = function(data)
		return LuaBits.NumberBitsToRepresentInt(data.MapSize.X)
	end;
	['SizeY'] = function(data)
		return LuaBits.NumberBitsToRepresentInt(data.MapSize.Y)
	end;
	['SizeZ'] = function(data)
		return LuaBits.NumberBitsToRepresentInt(data.MapSize.Z)
	end;
}

--[[local function encodeXYZ(data, bits)
	return LuaBits.integerToBitString(data.X, bits)..LuaBits.integerToBitString(data.Y, bits)..LuaBits.integerToBitString(data.Z, bits)
end

local function encodeRGB(data)
	return LuaBits.integerToBitString(data.R, 8)..LuaBits.integerToBitString(data.G, 8)..LuaBits.integerToBitString(data.B, 8)
end

local function encodeBoolean(bool)
	if bool then
		return "1"
	else
		return "0"
	end
end

local function makeVoxelDataIndexable(data)
	local newData = {}
	newData[1] = data.StartPosition
	newData[2] = data.EndPosition
	newData[3] = data.Color
	newData[4] = data.Material
	newData[5] = data.IsBreakable
	newData[6] = data.HasGravity
	return newData
end

local function encodeVoxelData(data)
	local mapSizeData = encodeXYZ(data.MapSize, 12)
	local palletteData = "" do
		for i = 1, 16 do
			palletteData = palletteData .. encodeRGB(data.Pallette[i])
		end
	end
	local voxelData = "" do
		for i = 1, #data.Voxels do
			local voxel = makeVoxelDataIndexable(data.Voxels[i])
			voxelData = voxelData .. encodeXYZ(voxel[1], 8) ..
				encodeXYZ(voxel[2], 8) ..
				LuaBits.integerToBitString(voxel[3], 4) ..
				LuaBits.integerToBitString(voxel[4], 2) ..
				encodeBoolean(voxel[5], "can break") ..
				encodeBoolean(voxel[6], "gravity")
		end
	end
	return mapSizeData .. palletteData .. voxelData
end]]

return {
	data = voxelData,
	--encodedData = encodeVoxelData(voxelData),
	spec = voxelSpec,
	callbacks = sizeCallbacks
}