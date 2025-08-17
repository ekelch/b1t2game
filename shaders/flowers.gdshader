shader_type canvas_item;
global uniform vec3 primary_color: source_color;

const float AMPLITUDE = 5.0;
const float TIME_MOD = 3.0;

void vertex() {
	VERTEX.y += AMPLITUDE * sin(TIME_MOD * TIME);
}

void fragment() {
	COLOR.rgb = primary_color;
}
