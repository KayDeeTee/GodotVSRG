shader_type canvas_item;
render_mode blend_mix;

uniform float h_start_y;
uniform float h_end_y;

uniform float s_start_y;
uniform float s_end_y;

void fragment() {
	float hide = SCREEN_UV.y-h_start_y;
	hide = hide * (1.0/(h_start_y-h_end_y));
	hide = clamp(hide, 0, 1);
	
	float sudden = SCREEN_UV.y-s_start_y;
	sudden = sudden * (1.0/(s_end_y-s_start_y));
	sudden = clamp(sudden, 0, 1);
	
	COLOR.a *= sudden*hide;
}
