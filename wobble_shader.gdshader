shader_type canvas_item;

void fragment() {
    vec2 wobble = vec2(
        sin(TIME * 2.0 + UV.y * 10.0) * 0.01,
        cos(TIME * 3.0 + UV.x * 10.0) * 0.01
    );

    COLOR = texture(TEXTURE, UV + wobble);
}
