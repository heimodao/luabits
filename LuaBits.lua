-- luabits by zoe
-- 8/14/2018

local logBase2 = math.log(2)

local function NumberBitsForRepresentingUnsignedInt(integer)
	integer = math.floor(integer)
	local bits = math.ceil(math.log(integer+1)/logBase2)
	return math.log(integer)/logBase2, bits, (2^bits)-1
end

local function IntegerToBitArray(integer, bits)
	local array = {}
	for i = bits, 1, -1 do
		local bitNumber = 2^i-1
		if bitNumber >= integer then
			table.insert(array, 1, true)
			integer = integer - bitNumber
		else
			table.insert(array, 1, false)
		end
	end
end

local function BitArrayToInteger(array)
	local value = 0
	for i = 1, array do
		local bit = array[i]
		if bit then
			value = value + 2^(i-1)
		end
	end
end

local function appendBitArray(array, appendArray)
	for i = 1, #appendArray do
		array[#array+1] = appendArray[i]
	end
	return array
end

local function SerializeBitArrays(arrays, use8BitCharacters)
	local charSize = use8BitCharacters and 8 or 7
	local charValue = 0
	local bitPosition = 1
	local serializedArray = ""
	for _, array in pairs(arrays) do
		for _, bit in pairs(array) do
			if bit then
				charValue = charValue+2^(bitPosition-1)
			end
			if bitPosition == charSize then
				serializedArray  = serializedArray..string.char(charValue)
				charValue   = 0
				bitPosition = 1
			else
				bitPosition = bitPosition + 1
			end
		end
	end
	if charValue > 0 then
		local remainingBits = charSize-bitPosition
		charValue = charValue * (2^remainingBits) -- Shifts bits #remainingBits places left, i.e. appends #remainingBits zeroes to the end, adding enough bits to even out the very last value
		serializedArray = serializedArray..string.char(charValue)
	end
	return serializedArray
end

local function DecodeSerializedArray(array, specification)
	local bits = {}
	for char in string.gsub(array, ".") do
		local newBits = BitArrayToInteger(string.byte(char))
		appendBitArray(bits, newBits)
	end
	--[[for ind, spec do

	end]]
	if specification.Type == "Dictionary" then
		local dict = {}
		for index, value in pairs(specification.Values) do
			local int = string.byte
		end
	elseif specification.Type == "List" then

	elseif specification.Type == "Integer" then
	end
end

local spec = {
	['Type']   = "Dictionary";
	['Values'] = {
		{
			['Key']       = "Size";
			['Type']      = "Dictionary";
			['Size']      = 33;
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
			['Type']   = "List";
			['Size']   = 336;
			['Values'] = {
				{
					['Type']      = "Dictionary";
					['Size']      = 21;
					['Repeating'] = 16;
					['Values']    = {
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
			['Key']  = "Voxels";
			['Type'] = "List";
			['Values'] = {
				{
					['Type']        = "Dictionary";
					['Size']        = "Variable";
					['RepeatToEnd'] = true;
					['Values']      = {
						{
							['Key']    = "StartPosition";
							['Type']   = "Dictionary";
							['Size']   = "Variable";
							['Values'] = {
								{
									['Key'] = "X";
									['Type'] = "Integer";
									['Size'] = "Variable";
								};{
									['Key'] = "Y";
									['Type'] = "Integer";
									['Size'] = "Variable";
								};{
									['Key'] = "Z";
									['Type'] = "Integer";
									['Size'] = "Variable";
								}
							}
						};{
							['Key'] = "EndPosition";
							['Type'] = "Dictionary";
							['Size'] = "Variable";
							['Values'] = {
								{
									['Key'] = "X";
									['Type'] = "Integer";
									['Size'] = "Variable";
								};
								{
									['Key'] = "Y";
									['Type'] = "Integer";
									['Size'] = "Variable";
								};
								{
									['Key'] = "Z";
									['Type'] = "Integer";
									['Size'] = "Variable";
								}
							}
						};{
							['Key'] = "Material";
							['Type'] = "Integer";
							['Size'] = 2;
						};{
							['Key'] = "IsBreakable";
							['Type'] = "Boolean";
							['Size'] = 1;
						};{
							['Key'] = "HasGravity";
							['Type'] = "Boolean";
							['Size'] = 1;
						}
					}
				}
			}
		}
	}
}

--- Type up the spec