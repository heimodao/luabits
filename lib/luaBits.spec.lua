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
	local luaBits = require(script.Parent.luaBits)

	it("should give number of bits needed for integers", function()
		local bits = luaBits.bitsToRepresentInt(1)
		expect(bits).to.equal(1)
		bits = luaBits.bitsToRepresentInt(3)
		expect(bits).to.equal(2)
		bits = luaBits.bitsToRepresentInt(7)
		expect(bits).to.equal(3)
		bits = luaBits.bitsToRepresentInt(15)
		expect(bits).to.equal(4)
		bits = luaBits.bitsToRepresentInt(31)
		expect(bits).to.equal(5)
		bits = luaBits.bitsToRepresentInt(63)
		expect(bits).to.equal(6)
		bits = luaBits.bitsToRepresentInt(127)
		expect(bits).to.equal(7)
		bits = luaBits.bitsToRepresentInt(255)
		expect(bits).to.equal(8)
		bits = luaBits.bitsToRepresentInt(511)
		expect(bits).to.equal(9)
		bits = luaBits.bitsToRepresentInt(1023)
		expect(bits).to.equal(10)
	end)

	it("should encode and decode integers", function()
		local bitString = luaBits.integerToBitString(145, 8)
		local integer = luaBits.bitStringToInteger(bitString)
		expect(integer).to.equal(145)
	end)

	it("should compress and decompress 8 bit data", function()
		local bitString = luaBits.integerToBitString(145, 8)
		local compressedBitString, padding = luaBits.compressBitString(bitString)
		local decompressedBitString = luaBits.decompressBitString(compressedBitString, false, padding)
		local integer = luaBits.bitStringToInteger(decompressedBitString)
		expect(integer).to.equal(145)

		bitString = luaBits.integerToBitString(1000, 10)
		compressedBitString, padding = luaBits.compressBitString(bitString)
		decompressedBitString = luaBits.decompressBitString(compressedBitString, false, padding)
		integer = luaBits.bitStringToInteger(decompressedBitString)
		expect(integer).to.equal(1000)
	end)

	it("should compress and decompress 6 bit data", function()
		local bitString = luaBits.integerToBitString(30, 6)
		local compressedBitString, padding = luaBits.compressBitString(bitString, true)
		local decompressedBitString = luaBits.decompressBitString(compressedBitString, true, padding)
		local integer = luaBits.bitStringToInteger(decompressedBitString)
		expect(integer).to.equal(30)

		bitString = luaBits.integerToBitString(1000, 10)
		compressedBitString, padding = luaBits.compressBitString(bitString, true)
		decompressedBitString = luaBits.decompressBitString(compressedBitString, true, padding)
		integer = luaBits.bitStringToInteger(decompressedBitString)
		expect(integer).to.equal(1000)
	end)

	local voxelData = require(script.Parent.voxelData)

	it("should encode and decode complex data structures according to specs", function()
		local serializedData = luaBits.serializeDataTree(voxelData.data, voxelData.spec, voxelData.callbacks)
		local deserializedData = luaBits.deserializeBitString(serializedData, voxelData.spec, voxelData.callbacks)
		expect(deepEqual(voxelData.data, deserializedData)).to.equal(true)

		-- 8 bit compression
		local compressedData, padding = luaBits.compressBitString(serializedData)
		local decompressedData = luaBits.decompressBitString(compressedData, false, padding)
		deserializedData = luaBits.deserializeBitString(decompressedData, voxelData.spec, voxelData.callbacks)
		expect(deepEqual(voxelData.data, deserializedData)).to.equal(true)

		-- 6 bit compression (datastore)
		compressedData, padding = luaBits.compressBitString(serializedData, true)
		decompressedData = luaBits.decompressBitString(compressedData, true, padding)
		deserializedData = luaBits.deserializeBitString(decompressedData, voxelData.spec, voxelData.callbacks)
		expect(deepEqual(voxelData.data, deserializedData)).to.equal(true)
	end)
end