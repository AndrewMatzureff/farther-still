-- main
-- Andrew Matzureff

g_entities = {}
g_camera_x = 0.0
g_camera_y = 0.0
g_debug = {}
g_enable_debug = false

function _init()
	g_player = Player:_new(0, 0, 0.1)--[[@as Player]]
	g_world  =  World:_new(0, 0,   1)--[[@as World]]
end

function _update60()
	g_player:update()
	g_world:update()
	g_camera_x = g_player.x
	g_camera_y = g_player.y
end

function _draw()
	cls()
	camera(g_camera_x - 64, g_camera_y - 64)
	g_player:draw()
	g_world:draw()
	camera(0, 0)
	g_debug[#g_debug+1]="_draw:g_camera_xy=" .. ("\f8(" .. g_camera_x .. ", " .. g_camera_y .. ")")
	if g_enable_debug then for i = 1, min(16, #g_debug), 1 do
		print(i .. ": " .. g_debug[i])
	end
	g_debug = {} end
end

