return function()
	local luaBits = require(script.Parent.luaBits)

	it("should convert and deconvert", function()
		local bitString = luaBits.integerToBitString(145, 8)
		print(bitString)
		local integer = luaBits.bitStringToInteger(bitString)
		expect(integer).to.equal(145)
	end)

	it("should encode 8 bit data properly", function()
		local bitString = luaBits.integerToBitString(255, 8)
		print(bitString)
		local compressedBitString = luaBits.compressBitString(bitString)
		local decompressedBitString = luaBits.decompressBitString(compressedBitString)
		print(decompressedBitString)
		local integer = luaBits.bitStringToInteger(decompressedBitString)
		expect(integer).to.equal(255)
	end)
end



--[[0   1  0  1  0 0 1 0
128 64 32 16 8 4 2 1]]
