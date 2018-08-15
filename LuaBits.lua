-- luabits by zoe
-- 8/14/2018

local natLog2 = math.log(2)
local function NumberBitsForRepresentingUnsignedInt(integer)
	-- Returns the number of bits needed to represent a given integer
	integer = math.floor(integer)
	local bits = math.ceil(math.log(integer+1)/natLog2)
	return math.log(integer)/natLog2, bits, (2^bits)-1
end

local function IntegerToBitArray(integer, bits)
	-- Converts an integer into a (backwards) array of bits
	local array = {}
	for i = bits, 1, -1 do
		local bitNumber = 2^i-1
		if bitNumber >= integer then
			array[#array+1] = true
			integer = integer - bitNumber
		else
			array[#array+1] = false
		end
	end
end

local function BitArrayToInteger(array)
	-- Turns an array of bits into an integer
	local value = 0
	local length = #array
	for i = 1, length do
		local bit = array[i]
		if bit then
			value = value + 2^(length-i)
		end
	end
end

local function appendBitArray(array, appendArray)
	-- Connects appendArray to the end of array
	for i = 1, #appendArray do
		array[#array+1] = appendArray[i]
	end
	return array
end

local function SerializeBitArrays(arrays, use8BitCharacters)
	--- This function will chunk up a bit array and encode it into characters
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

local function DeserializeBitArray(serial, bits)
	--- Turns a string of serialized bits back into a bit array
	local bits = {}
	for char in string.gsub(array, ".") do
		local newBits = IntegerToBitArray(string.byte(char), bits)
		appendBitArray(bits, newBits)
	end
	return bits
end

local function DecodeBitArray(array, spec, table, sizeFunctions)
	if not root then
		print("No root")
	end
	local root = root or {}
	local table = table or root
	if spec.Type == "Table" then
		for i = 1, #spec.Values do
			local value = spec.Values[i]
			DecodeBitArray(array, value, table, sizeFunctions)
		end
	elseif spec.Type == "Integer" then
		if spec.Size then
			local intSize do
				if typeof(spec.Size) == "number" then
					intSize = spec.Size
				elseif typeof(spec.Size) == "string" then
					intSize = sizeFunctions[spec.Size](root)
				else
					error("DecodeBitArray: Incorrect given for int value ".. (spec.Key or "[keyless]") ..", must be string or integer") 
				end
			end
			local integerBits = {}
			for i = 1, intSize do
				integerBits[i] = array[1]
				table.remove(array, 1)
			end
			table[spec.Key or #table+1] = BitArrayToInteger(integerBits)
		else
			error("DecodeBitArray: No or size given for int value ".. (spec.Key or "[keyless]"))
		end
	elseif spec.Type == "Boolean" then
		table[spec.Key or #table+1] = array[1]
		table.remove(array, 1)
	end
end