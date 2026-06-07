#pragma header

uniform float iTime;
uniform float glitchIntensity; // 0.0 is off, 1.0+ is full crazy glitch

// Simple pseudo-random generator
float rand(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    vec2 uv = openfl_TextureCoordv;
    
    if (glitchIntensity > 0.0) {
        // 1. Screen Tearing / Horizontal Lines Shift
        float glitchLines = step(1.0 - (0.05 * glitchIntensity), rand(vec2(floor(uv.y * 20.0), iTime)));
        uv.x += glitchLines * sin(uv.y * 10.0 + iTime) * 0.04 * glitchIntensity;
        
        // 2. Heavy Blocky Distortion
        if (rand(vec2(floor(iTime * 10.0), 0.0)) < 0.3 * glitchIntensity) {
            float blockLine = floor(uv.y * 6.0);
            uv.x += (rand(vec2(blockLine, iTime)) - 0.5) * 0.08 * glitchIntensity;
        }
    }
    
    // 3. Chromatic Aberration (RGB Split)
    float splitAmt = 0.005 * glitchIntensity;
    vec4 redCol = texture2D(bitmap, vec2(uv.x - splitAmt, uv.y));
    vec4 greenCol = texture2D(bitmap, uv);
    vec4 blueCol = texture2D(bitmap, vec2(uv.x + splitAmt, uv.y));
    
    vec4 finalColor = vec4(redCol.r, greenCol.g, blueCol.b, greenCol.a);
    
    if (glitchIntensity > 0.0) {
        // 4. White Noise Static Mix
        float noise = rand(uv + vec2(iTime, 0.0));
        finalColor.rgb = mix(finalColor.rgb, vec3(noise), 0.12 * glitchIntensity);
    }
    
    gl_FragColor = finalColor;
}
