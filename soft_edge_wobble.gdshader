shader_type canvas_item;

void fragment() {
    vec2 wobble = vec2(
        sin(TIME * 2.0 + UV.y * 10.0) * 0.01,
        cos(TIME * 3.0 + UV.x * 10.0) * 0.01
    );

    vec2 uv_wobbled = UV + wobble; // Apply wobble effect

    vec4 tex_color = texture(TEXTURE, uv_wobbled);

    // Soft edge effect
    float edge_softness = 0.05;  // Adjust for stronger or weaker fade
    float fade = smoothstep(0.0, edge_softness, UV.x) *
                 smoothstep(0.0, edge_softness, 1.0 - UV.x) *
                 smoothstep(0.0, edge_softness, UV.y) *
                 smoothstep(0.0, edge_softness, 1.0 - UV.y);

    tex_color.a *= fade; // Apply fading to the alpha channel

    COLOR = tex_color;
}
