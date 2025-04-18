shader_type canvas_item;

uniform float currentTime = 0;
uniform float blinkDuration = .1;

void vertex() {

}

void fragment() {
	vec2 pos = UV / TEXTURE_PIXEL_SIZE;
	vec4 color = texture(TEXTURE, UV);
	if((int(floor(currentTime/blinkDuration)) % 2 == 0) && (color[3] > 0.01)){
		color = vec4(254,255,233,1);
	}
	COLOR = color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
