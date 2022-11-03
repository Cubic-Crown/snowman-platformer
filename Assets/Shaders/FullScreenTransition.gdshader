shader_type canvas_item;

uniform float transition=1.;

float norm(vec2 u) {
	return sqrt(u.x*u.x + u.y*u.y);
}

void fragment() {
	float r = SCREEN_PIXEL_SIZE.x/SCREEN_PIXEL_SIZE.y;
	vec2 uv = vec2(UV.x, UV.y*r)-mod(vec2(UV.x, UV.y*r), .005); 
	float v = norm(uv-vec2(.5,.5*r));
	COLOR = v<clamp(transition, 0., 1.)?vec4(0.,0.,0.,0.) : vec4(0.,0.,0.,1.);
}
