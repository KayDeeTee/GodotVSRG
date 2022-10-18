shader_type canvas_item;

uniform sampler2D noise: source_color, filter_nearest;
uniform vec4 tint_black_pf: source_color;
uniform vec4 tint_white_pf: source_color;
uniform vec4 tint_black_ma: source_color;
uniform vec4 tint_white_ma: source_color;
uniform vec4 tint_black_gr: source_color;
uniform vec4 tint_white_gr: source_color;
uniform vec4 tint_black_gd: source_color;
uniform vec4 tint_white_gd: source_color;
uniform vec4 tint_black_bd: source_color;
uniform vec4 tint_white_bd: source_color;
uniform vec4 tint_black_ms: source_color;
uniform vec4 tint_white_ms: source_color;

uniform float life;
uniform float fade;


void fragment() {
	vec2 _uv = UV*vec2(.001, 0.72/9.0);
	_uv += vec2(TIME*0.0025,TIME*0.0125);
	_uv = mod(_uv, vec2(1.0,1.0));
	float r = smoothstep(0.25,0.75, texture(noise, _uv).r);
	
	vec3 c1 = mix(tint_black_ma, tint_white_ma, r).rgb;
	vec3 c2 = mix(tint_black_pf, tint_white_pf, r).rgb;
	vec3 c3 = mix(tint_black_gr, tint_white_gr, r).rgb;
	vec3 c4 = mix(tint_black_gd, tint_white_gd, r).rgb;
	vec3 c5 = mix(tint_black_bd, tint_white_bd, r).rgb;
	vec3 c6 = mix(tint_black_ms, tint_white_ms, r).rgb;
	
	if(fade < 1.0){
		COLOR.rgb = mix(c1,c2,fade);
	} else if (fade < 2.0 ){
		COLOR.rgb = mix(c2,c3,fade-1.0);
	} else if (fade < 3.0 ){
		COLOR.rgb = mix(c3,c4,fade-2.0);
	} else if (fade < 4.0 ){
		COLOR.rgb = mix(c4,c5,fade-3.0);
	} else if (fade < 5.0 ){
		COLOR.rgb = mix(c5,c6,fade-4.0);
	} else {
		COLOR.rgb = c6;
	}
	
	
	
	
	
}
