local indent = "    "
local function prettyPrint(value, indentLevel)
	indentLevel = indentLevel or 0
	local output = {}

	if typeof(value) == "table" then
		table.insert(output, "{\n")

		for key, value in pairs(value) do
			table.insert(output, indent:rep(indentLevel + 1))
			table.insert(output, tostring(key))
			table.insert(output, " = ")

			table.insert(output, prettyPrint(value, indentLevel + 1))
			table.insert(output, "\n")
		end

		table.insert(output, indent:rep(indentLevel))
		table.insert(output, "}")
	elseif typeof(value) == "string" then
		table.insert(output, string.format("%q", value))
		table.insert(output, " (string)")
	else
		table.insert(output, tostring(value))
		table.insert(output, " (")
		table.insert(output, typeof(value))
		table.insert(output, ")")
	end

	return table.concat(output, "")
end

local function deepEqual(table1, table2)
	for ind, value in pairs(table1) do
		if typeof(value) == "table" then
			if not deepEqual(value, table2[ind]) then
				return false
			end
		elseif value ~= table2[ind] then
			return false
		end
	end
	return true
end
return function()
	local LuaBits = require(script.Parent.LuaBits)

	it("should give number of bits needed for integers", function()
		local bits = LuaBits.NumberBitsToRepresentInt(1)
		expect(bits).to.equal(1)
		bits = LuaBits.NumberBitsToRepresentInt(3)
		expect(bits).to.equal(2)
		bits = LuaBits.NumberBitsToRepresentInt(7)
		expect(bits).to.equal(3)
		bits = LuaBits.NumberBitsToRepresentInt(15)
		expect(bits).to.equal(4)
		bits = LuaBits.NumberBitsToRepresentInt(31)
		expect(bits).to.equal(5)
		bits = LuaBits.NumberBitsToRepresentInt(63)
		expect(bits).to.equal(6)
		bits = LuaBits.NumberBitsToRepresentInt(127)
		expect(bits).to.equal(7)
		bits = LuaBits.NumberBitsToRepresentInt(255)
		expect(bits).to.equal(8)
		bits = LuaBits.NumberBitsToRepresentInt(511)
		expect(bits).to.equal(9)
		bits = LuaBits.NumberBitsToRepresentInt(1023)
		expect(bits).to.equal(10)
	end)

	it("should encode and decode integers", function()
		local bitTable = LuaBits.IntegerToBitTable(145, 8)
		local integer = LuaBits.BitTableToInteger(bitTable)
		expect(integer).to.equal(145)
	end)

	it("should compress and decompress 8 bit data", function()
		local bitTable = LuaBits.IntegerToBitTable(145, 8)
		local serializedBitTable, padding = LuaBits.SerializeBitTable(bitTable)
		print("145 is " ..serializedBitTable)
		local deserializedBitTable = LuaBits.DeserializeBitTable(serializedBitTable, false, padding)
		local integer = LuaBits.BitTableToInteger(deserializedBitTable)
		expect(integer).to.equal(145)

		bitTable = LuaBits.IntegerToBitTable(1000, 10)
		print("1000 binary is ".. LuaBits.ConvertBitTableToString(bitTable))
		serializedBitTable, padding = LuaBits.SerializeBitTable(bitTable)
		print("1000 is " ..serializedBitTable)
		deserializedBitTable = LuaBits.DeserializeBitTable(serializedBitTable, false, padding)
		print("1000 deserialized binary is ".. LuaBits.ConvertBitTableToString(deserializedBitTable))
		integer = LuaBits.BitTableToInteger(deserializedBitTable)
		expect(integer).to.equal(1000)
	end)

	it("should compress and decompress 6 bit data", function()
		local bitTable = LuaBits.IntegerToBitTable(30, 6)
		local serializedBitTable, padding = LuaBits.SerializeBitTable(bitTable, true)
		local deserializedBitTable = LuaBits.DeserializeBitTable(serializedBitTable, true, padding)
		local integer = LuaBits.BitTableToInteger(deserializedBitTable)
		expect(integer).to.equal(30)

		bitTable = LuaBits.IntegerToBitTable(1000, 10)
		serializedBitTable, padding = LuaBits.SerializeBitTable(bitTable, true)
		deserializedBitTable = LuaBits.DeserializeBitTable(serializedBitTable, true, padding)
		integer = LuaBits.BitTableToInteger(deserializedBitTable)
		expect(integer).to.equal(1000)
	end)

	local voxelData = require(script.Parent.voxelData)

	it("should encode and decode complex data structures according to specs", function()
		local bitTable = LuaBits.DataTreeToBitTable(voxelData.data, voxelData.spec, voxelData.callbacks)
		local dataTree = LuaBits.BitTableToDataTree(bitTable, voxelData.spec, voxelData.callbacks)
		print(prettyPrint(voxelData.data))
		print("---------------")
		print(prettyPrint(dataTree))
		expect(deepEqual(voxelData.data, dataTree)).to.equal(true)

		-- 8 bit compression
		local serializedBitTable, padding = LuaBits.SerializeBitTable(bitTable)
		local deserializedBitTable = LuaBits.DeserializeBitTable(serializedBitTable, false, padding)
		dataTree = LuaBits.BitTableToDataTree(deserializedBitTable, voxelData.spec, voxelData.callbacks)
		expect(deepEqual(voxelData.data, dataTree)).to.equal(true)

		-- 6 bit compression (datastore)
		serializedBitTable, padding = LuaBits.SerializeBitTable(bitTable, true)
		deserializedBitTable = LuaBits.DeserializeBitTable(serializedBitTable, true, padding)
		dataTree = LuaBits.BitTableToDataTree(deserializedBitTable, voxelData.spec, voxelData.callbacks)
		expect(deepEqual(voxelData.data, dataTree)).to.equal(true)
	end)
end