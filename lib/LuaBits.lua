--[[
	The luabits module provides an API for creating and serializing binary data
	formats with the intention of compressing data for easier storage and
	transportation.
]]

local NAT_LOG_2 = math.log(2)

local LuaBits = {}

-- Returns the number of bits needed to represent an integer in binary format.

function LuaBits.NumberBitsToRepresentInt(integer)
	integer = math.floor(integer)
	return math.ceil(math.log(integer+1)/NAT_LOG_2)
end

-- Converts an integer into a sequence of bits, stored as a string
function LuaBits.IntegerToBitTable(integer, bits)
	if not bits then
		bits = LuaBits.NumberBitsToRepresentInt(integer)
	end
	local bitTable = {}
	for i = bits, 1, -1 do
		local bitNumber = 2^(i-1)
		if integer >= bitNumber then
			bitTable[#bitTable+1] = true
			integer = integer - bitNumber
		else
			bitTable[#bitTable+1] = false
		end
	end
	return bitTable
end

-- Converts a sequence of bits back into an integer
function LuaBits.BitTableToInteger(bitTable)
	local value = 0
	local length = #bitTable
	for i = 1, #bitTable do
		length = length - 1
		local bit = bitTable[i]
		if bit == true then
			value = value + 2^length
		end
	end
	return value
end

function LuaBits.SerializeBitTable(bitTable, forDatastore)
	local charSize = forDatastore and 6 or 8
	 --[[
		When serializing for DataStores, we can only encoded ASCII characters between
		the values 0-127. Because of quirks with how JSON encodes certain control
		characters, 36 of those characters use up to 6 characters in the datastore to
		encode a single character, meaning 7 bits have the potential to take up to 42
		bits of space. Thus, it turns out that it's more efficient to forgo 7-bit
		serialization into all valid 128 ASCII character and use only 6-bit
		serialization instead.
		https://devforum.roblox.com/t/text-compression/163637/6
	 ]]
	local charValue = 0
	local bitPosition = 1
	local compressedStringTable = {}
	for i = 1, #bitTable do
		local bit = bitTable[i]
		if bit == true then
			charValue = charValue + 2^(charSize-bitPosition)
		end
		if bitPosition == charSize then
			if forDatastore then
				charValue = charValue + 35
				if charValue >= 92 then
					-- We skip 92 because the backslash character (92) is encoded in JSON
					--datastores as 2 characters, "\\", an escape backslash, followed by an
					--actual backslash. Characters 1-31 and 34 are also encoded as more than
					--one character, so we start on character 35.
					charValue = charValue + 1
				end
			end
			print("encoding", charValue, string.char(charValue))
			compressedStringTable[#compressedStringTable+1] = string.char(charValue)
			charValue = 0
			bitPosition = 1
		else
			bitPosition = bitPosition + 1
		end
	end
	local remainingBits
	if bitPosition > 1 then
		if forDatastore then
			charValue = charValue + 35
			if charValue >= 92 then
				charValue = charValue + 1
			end
		end
		remainingBits = charSize - (bitPosition - 1)
		print("encoding extra", charValue, string.char(charValue))
		compressedStringTable[#compressedStringTable+1] = string.char(charValue)
	end
	return table.concat(compressedStringTable), remainingBits
end

function LuaBits.DeserializeBitTable(bitString, forDatastore, padding)
	local numberBits = forDatastore and 6 or 8
	local bits = {}
	for char in string.gmatch(bitString, ".") do
		local integer = string.byte(char)
		if forDatastore and integer >= 93 then
			integer = integer - 1 - 35
			-- We do this, because if the serialized integer is 92 or greater, it is
			-- stored as 1 greater than its actual value in order to skip ASCII character
			-- 92. (see above comments)
		elseif forDatastore then
			integer = integer - 35
		end
		print("decoded", char, "to", integer)
		local bitTable = LuaBits.IntegerToBitTable(integer, numberBits)
		for i = 1, numberBits do
			bits[#bits+1] = bitTable[i]
		end
	end
	if padding then
		for i = #bits, #bits-padding do
			bits[i] = nil
		end
	end
	return bits
end

function LuaBits.DataTreeToBitTable(data, spec, sizeCallbacks, rootData, bitTable)
	bitTable = bitTable or {}
	if spec.Type == "Table" then
		if not typeof(data) == "table" then
			error("luaBits serializeDataTree: expected data "..(spec.Key or "[keyless]").." to be a table, "..typeof(data).." was given")
		end
		--repeatedVals ensures we can have multiple sets of repeated values in one table
		local repeatedVals = 0
		for ind, value in pairs(spec.Values) do
			if value.Repeat then
				for i = 1, value.Repeat do
					local repeatVal = data[repeatedVals+i]
					if not repeatVal then
						error("luaBits serializeDataTree: expected index ["..i.."] in table "..(value.Key or "[keyless]"))
					end
					LuaBits.DataTreeToBitTable(repeatVal, value, sizeCallbacks, rootData or data, bitTable)
				end
				repeatedVals = repeatedVals + value.Repeat
			elseif value.RepeatToEnd then
				for i = repeatedVals+1, #data do
					LuaBits.DataTreeToBitTable(data[i], value, sizeCallbacks, rootData or data, bitTable)
				end
			else
				local subData do
					if value.Key then
						subData = data[value.Key]
						if subData == nil then
							error("luaBits serializeDataTree: expected field "..value.Key.. " in table "..(spec.Key or "[keyless]"))
						end
					else
						subData = data[ind]
						if not subData then
							error("luaBits serializeDataTree: expected index ["..ind.. "] in table "..(spec.Key or "[keyless]"))
						end
					end
				end
				LuaBits.DataTreeToBitTable(subData, value, sizeCallbacks, rootData or data, bitTable)
			end
		end
		return bitTable
	elseif spec.Type == "Integer" then
		if not typeof(data) == "number" then
			error("luaBits serializeDataTree: expected data "..(spec.Key or "[keyless]").." to be a number, "..typeof(data).." was given")
		end
		local intSize do
			if typeof(spec.Size) == "number" then
				intSize = spec.Size
			elseif typeof(spec.Size) == "string" then
				if not sizeCallbacks then
					error("LuaBits deserializeBitString: Callback "..spec.Size.." failed; callbacks table is undefined")
				end
				local callback = sizeCallbacks[spec.Size]
				if callback then
					if typeof(callback) == "function" then
						intSize = callback(rootData)
						if typeof(intSize) ~= "number" then
							error("LuaBits deserializeBitString: Expected integer to return from size callback "..spec.Size..", "..typeof(intSize).." was given")
						end
						sizeCallbacks[spec.Size] = intSize
					elseif typeof(callback) == "number" then
						intSize = callback
					else
						error("LuaBits deserializeBitString: Incorrect type given for callback "..spec.Size.." ("..typeof(spec.Size).."), value must be a function")
					end
				else
					error("LuaBits deserializeBitString: Callback '"..spec.Size.."' is undefined.")
				end
			else
				error("LuaBits deserializeBitString: Incorrect size given for int value ".. (spec.Key or "[keyless]") ..", must be callback string or integer")
			end
		end
		local integerBits = LuaBits.IntegerToBitTable(data, intSize)
		for i = 1, intSize do
			table.insert(bitTable, i, integerBits[i])
		end
	elseif spec.Type == "Boolean" then
		if not typeof(data) == "boolean" then
			error("luaBits serializeDataTree: expected data "..(spec.Key or "[keyless]").." to be a boolean, "..typeof(data).." was given")
		end
		table.insert(bitTable, 1, data)
	else
		error("luaBits serializeDataTree: invalid [Type] field given for "..(spec.Key or "[keyless]").." must be 'Integer', 'Boolean', or 'Table'")
	end
end

function LuaBits.BitTableToDataTree(bitTable, spec, sizeCallbacks, container, root, position)
	position = position or 1
	if spec.Type == "Table" then
		local thisTable = {}
		if not root then
			root = thisTable
		else
			if spec.Key then
				container[spec.Key] = thisTable
			else
				container[#container+1] = thisTable
			end
		end
		for i = 1, #spec.Values do
			local value = spec.Values[i]
			if value.Repeat then
				for _ = 1, value.Repeat do
					position = LuaBits.BitTableToDataTree(bitTable, value, sizeCallbacks, thisTable, root, position)
				end
			elseif value.RepeatToEnd then
				repeat
					position = LuaBits.BitTableToDataTree(bitTable, value, sizeCallbacks, thisTable, root, position)
				until position >= #bitTable
			else
				position = LuaBits.BitTableToDataTree(bitTable, value, sizeCallbacks, thisTable, root, position)
			end
		end
		if thisTable ~= root then
			return position
		else
			return root
		end
	elseif spec.Type == "Integer" then
		if spec.Size then
			local intSize do
				if typeof(spec.Size) == "number" then
					intSize = spec.Size
				elseif typeof(spec.Size) == "string" then
					if not sizeCallbacks then
						error("LuaBits deserializeBitString: Callbacks table is undefined")
					end
					local callback = sizeCallbacks[spec.Size]
					if callback then
						if typeof(callback) == "function" then
							intSize = callback(root)
							sizeCallbacks[spec.Size] = intSize
						elseif typeof(callback) == "number" then
							intSize = callback
						else
							error("LuaBits deserializeBitString: Incorrect type given for callback ''"..spec.Size.. "', Value must be a function")
						end
					else
						error("LuaBits deserializeBitString: Callback '"..spec.Size.."' is undefined.")
					end
				else
					error("LuaBits deserializeBitString: Incorrect size given for int value ''".. (spec.Key or "[keyless]") .."', must be callback string or integer")
				end
				local integerBits = {}
				for i = position, position+intSize-1 do
					integerBits[#integerBits+1] = bitTable[i]
				end
				container[spec.Key or #container+1] = LuaBits.BitTableToInteger(integerBits)
				return position + intSize
			end
		else
			error("LuaBits deserializeBitString: No or size given for int value ".. (spec.Key or "[keyless]"))
		end
	elseif spec.Type == "Boolean" then
		local bit = bitTable[position]
		container[spec.Key or #table+1] = bit
		return position + 1
	end
end

return LuaBits