return function()
	local luaBits = require(script.Parent.luaBits)

	it("should encode 8 bit data properly", function()
		expect(Change.Text).to.be.ok()
		expect(Change.Selected).to.be.ok()
	end)
end