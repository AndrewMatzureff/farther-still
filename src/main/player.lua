-- player
-- Andrew Matzureff

---@class Player: Entity
Player = class({_super = Entity})

function Player:init(x, y, speed)
	self._super--[[@as Entity]].init(self, x, y)
	self.speed = speed
end

function Player:update()
	local dx, dy, run = 0.0, 0.0, 1.0
	if btn(5) then run = 100		end  --- run
	if btn(0) then dx -= self.speed end  --- left
	if btn(1) then dx += self.speed end  --- right
	if btn(2) then dy -= self.speed end  --- up
	if btn(3) then dy += self.speed end  --- down

	self.x += dx * run
	self.y += dy * run
end

function Player:draw()
	spr(1, self.x-4+0*64, self.y-4+0*64)
end

