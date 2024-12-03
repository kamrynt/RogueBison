shader_type canvas_item;
uniform int pixel_size : hint_range(1, 100) = 100;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 pos = UV / TEXTURE_PIXEL_SIZE;
	vec2 square = vec2(float(pixel_size), float(pixel_size));
	vec2 top_left = floor(pos / square) * square;
	vec4 total = vec4(0., 0., 0., 0.);
	for (int x = int(top_left.x); x < int(top_left.x) + pixel_size; x++){
		for (int y = int(top_left.y); y < int(top_left.y) + pixel_size; y++){
			total += texture(TEXTURE, vec2(float(x), float(y)) * TEXTURE_PIXEL_SIZE);
		}
	}
	COLOR = total / float(pixel_size * pixel_size);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
