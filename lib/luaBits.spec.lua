return function()
	local luaBits = require(script.Parent.luaBits)

	it("should encode 8 bit data properly", function()
		local bitString = luaBits.integerToBitString(145, 8)
		local compressedBitString = luaBits.compressedBitString(bitString)
		local decompressedBitString = luaBits.decompressedBitString(compressedBitString)
		local integer = luaBits.bitStringToInteger(decompressedBitString)
		expect(integer).to.equal(145)
	end)
end