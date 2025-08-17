shader_type canvas_item;
global uniform vec3 primary_color;

void vertex() {
	if (VERTEX.y < 0.) {
		VERTEX.x += VERTEX.y / 2. * sin(2.5 * TIME);
	}
}

void fragment() {
	COLOR.rgb = primary_color;
}