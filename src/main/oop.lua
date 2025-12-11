-- oop
-- Andrew Matzureff

---@class Object
---@field _class Object
---@field _super Object | nil
---@field init function | nil
Object = {}

--- Static Methods (self == class) ---

function Object:__call(instance)
	return self:_instantiate(instance)
end

function Object:_named(name)
	getmetatable(self).__name = name
	return self
end

function Object:_new(...)
	local instance = self:_instantiate({}, ...)
	if instance.init then
		instance:init(...)
	elseif select("#", ...) ~= 0 then
		local class_name = getmetatable(self).__name or tostring(self)
		error("Tried to call '" .. class_name .. ":_new(...)' without having defined constructor: '" .. class_name .. ":init(...)'. Use literal construction: '" .. class_name .. "({...})', instead.")
	end
	return instance
end

function Object:_instantiate(instance, ...)
	setmetatable(instance, {__index = self})
	instance._class = self
	instance._super = self._super
	return instance
end

--- Instance Methods (self == instance) ---

function Object:_is(class)
	local self_class = self ~= nil and self._class or nil
	while self_class ~= nil do
		if self_class == class then return true end
		self_class = self_class._super
	end
	return false
end

--- Create a new class using the given prototype to define its structure and behavior.
---Specifying an existing class as the value of 'prototype.super' creates a subclass
---of 'prototype.super' while specifying no such value results in an implicit
---subclass of the 'Object' class (i.e.: 'prototype.super' == 'Object' by default).
---@param prototype? any optional table containing member fields which define the structure of the new class and, extra-optionally, a 'super' field designating a parent class to inherit other properties from
---@return Object prototype the given prototype as a registered class if provided or an empty prototype inheriting from the 'Object' class
function class(prototype)
	if prototype == nil then prototype = {} end
	if prototype._super == nil then prototype._super = Object end
	prototype._class = prototype
	setmetatable(prototype, prototype) -- Prototype must be its own metatable so that it can properly index the __call(...) operation, otherwise we'll get an error for attempting to call a table.
	getmetatable(prototype).__index = prototype._super
	getmetatable(prototype).__call = Object.__call
	return prototype
end
