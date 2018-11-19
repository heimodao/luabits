local voxelSpec = {
	['Key']    = "Root";
	['Type']   = "Table";
	['Values'] = {
		{
			['Key']       = "MapSize";
			['Type']      = "Table";
			['Values']    = {
				{
					['Key']  = "X";
					['Type'] = "Integer";
					['Size'] = 12;
				};{
					['Key']  = "Y";
					['Type'] = "Integer";
					['Size'] = 12;
				};{
					['Key']  = "Z";
					['Type'] = "Integer";
					['Size'] = 12;
				};
			}
		};{
			['Key']    = "Pallette";
			['Type']   = "Table";
			['Values'] = {
				{
					['Type']   = "Table";
					['Repeat'] = 16;
					['Values'] = {
						{
							['Key']  = "R";
							['Type'] = "Integer";
							['Size'] = 8;
						};{
							['Key']  = "G";
							['Type'] = "Integer";
							['Size'] = 8;
						};{
							['Key']  = "B";
							['Type'] = "Integer";
							['Size'] = 8;
						};
					}
				}
			}
		};{
			['Key']    = "Voxels";
			['Type']   = "Table";
			['Values'] = {
				{
					['Type']        = "Table";
					['RepeatToEnd'] = true;
					['Values']      = {
						{
							['Key']    = "StartPosition";
							['Type']   = "Table";
							['Values'] = {
								{
									['Key']  = "X";
									['Type'] = "Integer";
									['Size'] = "SizeX";
								};{
									['Key']  = "Y";
									['Type'] = "Integer";
									['Size'] = "SizeY";
								};{
									['Key']  = "Z";
									['Type'] = "Integer";
									['Size'] = "SizeZ";
								}
							}
						};{
							['Key']    = "EndPosition";
							['Type']   = "Table";
							['Values'] = {
								{
									['Key']  = "X";
									['Type'] = "Integer";
									['Size'] = "SizeX";
								};{
									['Key']  = "Y";
									['Type'] = "Integer";
									['Size'] = "SizeY";
								};{
									['Key']  = "Z";
									['Type'] = "Integer";
									['Size'] = "SizeZ";
								}
							}
						};{
							['Key']  = "Color";
							['Type'] = "Integer";
							['Size'] = 4;
						};{
							['Key']  = "Material";
							['Type'] = "Integer";
							['Size'] = 2;
						};{
							['Key']  = "IsBreakable";
							['Type'] = "Boolean";
						};{
							['Key']  = "HasGravity";
							['Type'] = "Boolean";
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

local LuaBits = require(script.LuaBits)

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