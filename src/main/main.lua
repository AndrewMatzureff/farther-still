-- main.lua
-- Entry point containing main pico-8 loop hooks (_init(), _update(), _update60(), _draw(), etc.).

-- #include main/class.lua
-- #include entity.lua
-- #include player.lua

g_player = Player.null
g_world = World.null
g_entities = {}
g_camera_x = 0.0
g_camera_y = 0.0
g_debug = {}
g_enable_debug = false

function _init()
	g_player = Player:new(0.0, 0.0, 0.1)
	g_world = World:new(0, 0, 1)
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

