local voxelSpec = {
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

local luaBits = require(script.Parent.luaBits)

local sizeCallbacks = {
	['SizeX'] = function(data)
		return luaBits.bitsToRepresentInt(data.MapSize.X)
	end;
	['SizeY'] = function(data)
		return luaBits.bitsToRepresentInt(data.MapSize.Y)
	end;
	['SizeZ'] = function(data)
		return luaBits.bitsToRepresentInt(data.MapSize.Z)
	end;
}

local function encodeXYZ(data, bits)
	return luaBits.integerToBitString(data.X, bits)..luaBits.integerToBitString(data.Y, bits)..luaBits.integerToBitString(data.Z, bits)
end

local function encodeRGB(data)
	return luaBits.integerToBitString(data.R, 8)..luaBits.integerToBitString(data.G, 8)..luaBits.integerToBitString(data.B, 8)
end

local function encodeBoolean(bool, name)
	if bool then
		print("encoding "..name.." as true")
		return "1"
	else
		print("encoding "..name.." as false")
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
			local startLength = voxelData:len()
			print('encoding voxel '..i)
			local voxel = makeVoxelDataIndexable(data.Voxels[i])
			voxelData = voxelData .. encodeXYZ(voxel[1], 8) ..
				encodeXYZ(voxel[2], 8) ..
				luaBits.integerToBitString(voxel[3], 4) ..
				luaBits.integerToBitString(voxel[4], 2) ..
				encodeBoolean(voxel[5], "can break") ..
				encodeBoolean(voxel[6], "gravity")
			print("bitlength is "..voxelData:len()-startLength)
		end
	end
	return mapSizeData .. palletteData .. voxelData
end

return {
	data = voxelData,
	encodedData = encodeVoxelData(voxelData),
	spec = voxelSpec,
	callbacks = sizeCallbacks
}