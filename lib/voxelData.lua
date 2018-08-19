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
							['Key']  = "Red";
							['Type'] = "Integer";
							['Size'] = 7;
						};{
							['Key']  = "Green";
							['Type'] = "Integer";
							['Size'] = 7;
						};{
							['Key']  = "Blue";
							['Type'] = "Integer";
							['Size'] = 7;
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

local function encodeBoolean(bool)
	return bool and "1" or "0"
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
			local voxel = data.Voxels[i]
			voxelData = voxelData .. encodeXYZ(voxel.StartPosition, 8) .. encodeXYZ(voxel.EndPosition, 8) ..
				luaBits.integerToBitString(voxel.Color, 4) ..
				luaBits.integerToBitString(voxel.Material, 2) ..
				encodeBoolean(voxel.IsBreakable) ..
				encodeBoolean(voxel.HasGravity)
		end
	end
	return mapSizeData .. palletteData .. voxelData
end

return voxelData, encodeVoxelData(voxelData), voxelSpec, sizeCallbacks