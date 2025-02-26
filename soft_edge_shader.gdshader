shader_type canvas_item;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    // Calculate distance from the edges (left, right, top, bottom)
    float edge_softness = 0.05;  // Adjust for stronger or weaker fade
    float fade = smoothstep(0.0, edge_softness, UV.x) *
                 smoothstep(0.0, edge_softness, 1.0 - UV.x) *
                 smoothstep(0.0, edge_softness, UV.y) *
                 smoothstep(0.0, edge_softness, 1.0 - UV.y);

    // Apply fading only to the edges, not the center
    tex_color.a *= fade;

    COLOR = tex_color;
}
