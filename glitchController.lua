local shaderName = "vcrGlitch"
local isGlitchActive = false
local currentIntensity = 0.0

function onCreatePost()
    -- Initialize shader on both game and HUD cameras
    initLuaShader(shaderName)
    
    -- Set default variables so it doesn't crash or act weird on start
    setShaderFloat(shaderName, "iTime", 0.0)
    setShaderFloat(shaderName, "glitchIntensity", 0.0)
    
    -- Assign shader to the cameras
    runHaxeCode([[
        var shader = game.getLuaObject(']]..shaderName..[[');
        if (shader != null) {
            game.camGame.setFilters([new openfl.filters.ShaderFilter(shader.shader)]);
            game.camHUD.setFilters([new openfl.filters.ShaderFilter(shader.shader)]);
        }
    ]])
end

function onUpdate(elapsed)
    -- Continuously update time uniform for movement if active
    if isGlitchActive then
        setShaderFloat(shaderName, "iTime", os.clock())
    end
end

-- Custom function to change shader values smoothly or instantly
-- intensity: 0.0 is completely off, 1.0 is default glitch, 3.0+ is terminal breakdown
function setGlitch(intensity)
    currentIntensity = intensity
    if intensity > 0 then
        isGlitchActive = true
        setShaderFloat(shaderName, "glitchIntensity", intensity)
    else
        isGlitchActive = false
        setShaderFloat(shaderName, "glitchIntensity", 0.0)
    end
end

-- Triggers via chart steps or events
function onStepEvent(step)
    -- EXAMPLES OF HOW TO USE DURING THE SONG:
    
    -- Turn ON at Step 64 with standard intensity
    if step == 64 then
        setGlitch(1.0)
    end
    
    -- Turn OFF at Step 96
    if step == 96 then
        setGlitch(0.0)
    end
    
    -- Make it super extreme during a drop at Step 128
    if step == 128 then
        setGlitch(3.5)
    end
    
    -- Calm it back down to normal
    if step == 160 then
        setGlitch(0.8)
    end
    
    -- Completely kill it at the end of a section
    if step == 192 then
        setGlitch(0.0)
    end
end
