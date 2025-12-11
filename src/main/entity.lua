-- entity
-- Andrew Matzureff

---@class Entity: Object
Entity = class()

function Entity:init(x, y)
	self.x, self.y = x, y
end

function Entity:update()
end

function Entity:draw()
end
