shader_type canvas_item;
global uniform vec3 primary_color: source_color;

void fragment() {
	COLOR = vec4(primary_color, step(0.01, COLOR.a));
}