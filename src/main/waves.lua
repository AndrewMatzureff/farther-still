PI = 3.141592653589793
TWO_PI = 2 * PI

-- waves
waves = {
    -- util
    util = {
        fourier = {
            get = function(x, phase, offset, prefab, precision)
                local y = 0.0
                local count = min(precision == nil and prefab.precision or precision, prefab.precision)
                -- print("c=" .. prefab.coefficients[2])
                for i = 1, count, 1 do
                    local coefficient = prefab.coefficients[i]
                    -- local sample = waves.util.fourier.sample
                    --     (
                    --         coefficient * (x + prefab.phase) / (prefab.period * prefab.scale)
                    --     ) / (
                    --         coefficient ~= 0.0 and coefficient or 1.0
                    --     )
                    -- local sample = waves.util.fourier.sample
                    --     (
                    --         coefficient * (x + prefab.phase) / (prefab.period * prefab.scale) + coefficient * prefab.period
                    --     ) / (
                    --         coefficient ~= 0.0 and coefficient or 1.0
                    --     )
                        -- g_enable_debug = true
                        -- g_debug[#g_debug+1] = "get:y += " .. sample--sin(self.coefficients[i] * (x + p) / f) .. " / " .. self.coefficients[i] .. " == " .. harmonic
                    --y += sample
                end
                -- return y * prefab.amplitude * prefab.scale
                local S = prefab.scale
                local T = g_camera_x
                -- g_debug[#g_debug+1] = "get:x=" .. S*sin(x/S+T)
                return S*(sin((((x-phase)/S)+phase)/TWO_PI)-offset)--y * prefab.scale
            end,

            coefficients = function(count, seed, fun)
                local coefficients = {}
                local e = seed
                for i = 1, count, 1 do
                    e = fun(e)
                    coefficients[i] = e
                end
                return coefficients
            end,

            sample = sin--function (angle) return sin(angle / TWO_PI) end
        }
    },

    -- data
    data = {
        fourier = {}
    },

    -- prefabs
    prefabs = {
        fourier = {},
        
        functions = {
            funnel = function(x) return min(2^x, 2^-x) end
        }
    }
}

waves.data.fourier.coefficients = {
    pow4 = function (count) return waves.util.fourier.coefficients(count, 0, function (e) return 4 ^ e end) end,
    square_wave = function (count) return waves.util.fourier.coefficients(count, -1, function (n) return n + 2 end) end
}

waves.prefabs.fourier.mountain = {
    coefficients = waves.data.fourier.coefficients.square_wave(5),--waves.util.fourier.coefficients(5, 0, function (e) return 4 ^ e end),--{1,2,3,4,5},--waves.data.fourier.coefficients.pow4(5),
    precision = 5,
    phase = 0.0,
    period = 5.0,
    amplitude = 25,
    scale = 1.0
}