-- player
-- Andrew Matzureff

Player = class(Entity)

function Player:init(x, y, hp)
	Entity.init(self, x, y)
	self.hp = hp
end
