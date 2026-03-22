shader_type canvas_item;


uniform float reverse;
uniform vec2 entry_point; // A 
uniform vec2 exit_point; // B

void fragment() {
	float scalar = (exit_point.x - entry_point.x) * (UV.y - entry_point.y) - (exit_point.y - entry_point.y) * (UV.x - entry_point.x);
	float is_cut_point = step(0.0, scalar * reverse);
	
	vec4 color = texture(TEXTURE, UV);
	COLOR = color;
	COLOR.a = color.a * is_cut_point;
}
