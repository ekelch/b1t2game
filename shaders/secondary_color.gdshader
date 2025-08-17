shader_type canvas_item;
global uniform vec3 secondary_color: source_color;

void fragment() {
	COLOR = vec4(secondary_color, step(0.01, COLOR.a));
}