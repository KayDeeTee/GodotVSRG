shader_type canvas_item;

uniform sampler2D gradient : hint_default_white, filter_nearest;
uniform sampler2D font : hint_default_white, filter_nearest;

uniform vec4 line_colour : source_color;

uniform vec2 c_scale;
uniform vec2 c2_scale;

vec4 draw_char(vec2 _uv, vec2 tps, float x, float y, float index, vec4 prev_col, vec4 colour){
	vec2 uv_start = tps*vec2(x,y);
	vec2 uv_end = uv_start+vec2(3.0,5.0)*tps;
	
	vec2 c_lookup = _uv-uv_start;
	c_lookup /= uv_end-uv_start;
	
	if(c_lookup.x <0.0 || c_lookup.y < 0.0 || c_lookup.x > 1.0 || c_lookup.y > 1.0 ){
		return prev_col;
	}
	
	c_lookup /= vec2(13.0,1.0);
	c_lookup += vec2((3.0*index)/39.0, 0.0);	
	
	vec4 c = texture(font, c_lookup);
	return mix(prev_col, c*colour, c.a);
	//return vec4(c_lookup.x, c_lookup.y, 0, 1.0);
}

vec4 draw_shadow(vec2 _uv, vec2 tps, float x, float y, float index, vec4 prev_col, vec4 colour, vec4 shadow_colour){
	vec4 c = draw_char(_uv, tps, x, y, index, prev_col, colour);
	if(c != prev_col){
		return c;
	}
	return draw_char(_uv, tps, x+1.0, y+1.0, index, prev_col, shadow_colour);
}



void fragment() {
	vec2 cur_nps = texture(TEXTURE, vec2(0,0)).yz;
	COLOR = texture(gradient, UV);
	if(UV.y < TEXTURE_PIXEL_SIZE.y*16.5 && UV.y > TEXTURE_PIXEL_SIZE.y*15.5){
		COLOR += vec4(0.4,0.4,0.4,0);
	}
	if(UV.y < TEXTURE_PIXEL_SIZE.y*32.5 && UV.y > TEXTURE_PIXEL_SIZE.y*31.5){
		COLOR += vec4(0.4,0.4,0.4,0);
	}
	if(UV.y < TEXTURE_PIXEL_SIZE.y*48.5 && UV.y > TEXTURE_PIXEL_SIZE.y*47.5){
		COLOR += vec4(0.4,0.4,0.4,0);
	}
	
	float diff = (1.0-UV.y)-texture(TEXTURE, vec2(UV.x,0)).r;
	float next = (1.0-UV.y)-texture(TEXTURE, vec2(UV.x+TEXTURE_PIXEL_SIZE.x,0)).r;
	float prev = (1.0-UV.y)-texture(TEXTURE, vec2(UV.x-TEXTURE_PIXEL_SIZE.x,0)).r;
	if(diff < TEXTURE_PIXEL_SIZE.y && diff > 0.0 || (next < 0.0 && diff > 0.0) || (prev < 0.0 && diff > 0.0)){
		COLOR = line_colour;
	} else if (diff > 0.0) {
		COLOR *= vec4(1,1,1,.5);
	} else {
		COLOR *= vec4(.6,.6,.6,.5);
	}
	COLOR = draw_shadow(UV, TEXTURE_PIXEL_SIZE, 1,9,3, COLOR, vec4(1,1,1,1), vec4(0,0,0,.5));
	COLOR = draw_shadow(UV, TEXTURE_PIXEL_SIZE, 5,9,0, COLOR, vec4(1,1,1,1), vec4(0,0,0,.5));
	
	COLOR = draw_shadow(UV, TEXTURE_PIXEL_SIZE, 1,25,2, COLOR, vec4(1,1,1,1), vec4(0,0,0,.5));
	COLOR = draw_shadow(UV, TEXTURE_PIXEL_SIZE, 5,25,0, COLOR, vec4(1,1,1,1), vec4(0,0,0,.5));
	
	COLOR = draw_shadow(UV, TEXTURE_PIXEL_SIZE, 1,41,1, COLOR, vec4(1,1,1,1), vec4(0,0,0,.5));
	COLOR = draw_shadow(UV, TEXTURE_PIXEL_SIZE, 5,41,0, COLOR, vec4(1,1,1,1), vec4(0,0,0,.5));
	
	COLOR = draw_shadow(UV, TEXTURE_PIXEL_SIZE, 1,57,cur_nps.x*9.0, COLOR, vec4(1,1,1,1), vec4(0,0,0,.5));
	COLOR = draw_shadow(UV, TEXTURE_PIXEL_SIZE, 5,57,cur_nps.y*9.0, COLOR, vec4(1,1,1,1), vec4(0,0,0,.5));
	COLOR = draw_shadow(UV, TEXTURE_PIXEL_SIZE, 9,57,10, COLOR, vec4(1,1,1,1), vec4(0,0,0,.5));
	COLOR = draw_shadow(UV, TEXTURE_PIXEL_SIZE, 13,57,11, COLOR, vec4(1,1,1,1), vec4(0,0,0,.5));
	COLOR = draw_shadow(UV, TEXTURE_PIXEL_SIZE, 17,57,12, COLOR, vec4(1,1,1,1), vec4(0,0,0,.5));
}
