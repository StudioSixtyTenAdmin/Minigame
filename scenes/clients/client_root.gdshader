shader_type canvas_item;

uniform float intensity = 0.5;
uniform float speed = 0.5;
uniform float smoothness = 1.0;
uniform sampler2D gradient;

// Simple noise function
float noise(float var) {
    return fract(sin(var) * 43758.5453);
}

void fragment() {
    float time = TIME * speed;
    float flicker = (cos(time * smoothness + noise(time)) + 1.0) * 0.5; // Added noise to the cos wave
    vec4 color = texture(gradient, vec2(flicker, 0.0));
    color.rgb *= intensity;

    // Diffuse transparency from bottom to top
    color.a *= UV.y;

    COLOR = color;
}
