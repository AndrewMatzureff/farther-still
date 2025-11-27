-- world
-- Logic related to the procedural scrolling ground in the game scene.

World = class(Entity)

function World:init(scroll_x, scroll_y, seed)
	Entity.init(self, 0, 0)
	--self.waveform = AperiodicWaveform:new(5, -1, function (n) return n + 2 end)--Waveform.coefficients(25, -1, function (n) return n + 2 end)--)--0, function (n) return 4 ^ n end))
	self.seed = seed
	self.scroll_x = scroll_x
	self.scroll_y = scroll_y
	self.t=0.0
end

function World:update()
	-- self.scroll_x += dx
	-- self.scroll_y += dy
	self.t+=0.01
end

function World:draw()
	--spr(0, self.x, self.y)
	-- local bounds = -64...63
	-- global bounds = self.xy + -64...63
	--
	-- screen bounds = camera.xy + -64...63
	-- 
            g_enable_debug = true
			g_debug[#g_debug+1] = "...mountain.scale=" .. waves.prefabs.fourier.mountain.scale
	for i = -64, 63 do
		local x = g_camera_x + i
		local smol_x = x >> 12
		-- local curve = waves.util.fourier.get(0 + i, waves.prefabs.fourier.mountain, 5)--, 125)*25---(smol_x * smol_x) << 12
		local curve = waves.util.fourier.get(x, g_camera_x, g_camera_y, waves.prefabs.fourier.mountain, 5)--, 125)*25---(smol_x * smol_x) << 12
			----g_debug[#g_debug+1] = "draw:x,y = "..x..","..curve
		-- print(-x*x/100.0)
		-- line(x, (smol_x * smol_x)<<16, x, 127, 3)
		-- line(i+0*64, curve+0*64, i+0*64, curve + 4+0*64, 3)
		line(x, curve, x, curve + 4, 3)
	end
	line(g_camera_x,g_camera_y-64,g_camera_x,g_camera_y+63,8)
	line(g_camera_x-64,g_camera_y,g_camera_x+63,g_camera_y,8)
	line()
	waves.prefabs.fourier.mountain.scale = sin(self.t) * 25 + 26
end