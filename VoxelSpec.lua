local VoxelSpec = {
	['Type']   = "Table";
	['Values'] = {
		{
			['Key']       = "MapSize";
			['Type']      = "Table";
			['Values']    = {
				{
					['Key']  = "X";
					['Type'] = "Integer";
					['Size'] = 11;
				};{
					['Key']  = "Y";
					['Type'] = "Integer";
					['Size'] = 11;
				};{
					['Key']  = "Z";
					['Type'] = "Integer";
					['Size'] = 11;
				};
			}
		};{
			['Key']    = "Pallette";
			['Type']   = "Table";
			['Values'] = {
				{
					['Type']   = "Table";
					['Size']   = 21;
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

local SizeFunctions = {
	['SizeX'] = function(data)
		return NumberBitsForRepresentingUnsignedInt(data.MapSize.X)
	end;
	['SizeY'] = function(data)
		return NumberBitsForRepresentingUnsignedInt(data.MapSize.Y)
	end;
	['SizeZ'] = function(data)
		return NumberBitsForRepresentingUnsignedInt(data.MapSize.Z)
	end;
}

--- Type up the spec