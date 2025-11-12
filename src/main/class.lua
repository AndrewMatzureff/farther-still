-- class
-- Andrew Matzureff

--[[
Simple Lua class system
Works in PICO-8 or standard Lua 5.2+
------------------------------------
Features:
- class([parent]) → creates a new class (optionally inheriting from parent)
- :new(...)       → creates a new instance and calls :init(...) if defined
- :init(...)      → optional initializer (like a constructor)
--]]

function class(parent)
	-- create a new prototype table, inheriting from parent if given
	local prototype = setmetatable({}, { __index = parent })
	prototype.__index = prototype

	-- define a universal :new() method for instance creation
	function prototype:new(...)
		local instance = setmetatable({}, self)
		if instance.init then
			instance:init(...)
		end
		return instance
	end

	-- define a universal :class() method for identifying the class of an instance
	function prototype:class() return getmetatable(self) end

	-- define a universal :is() method for identifying whether an object is an instance of the given class
	function prototype:is(class)
		local mt = getmetatable(self)
		while mt do
			if mt == class then return true end
			mt = getmetatable(mt)
		end
		return false
	end

	return prototype
end
