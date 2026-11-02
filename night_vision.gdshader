shader_type canvas_item;
render_mode blend_mix;

uniform bool on = true;

uniform vec4 vision_colour: source_color; // I use linear values: 0, 0.08, 0, 1
uniform vec4 glow_colour: source_color; // I use linear values: 0.475, 0.957, 0.439, 1
uniform float blur_amount = 1.5;
uniform float glow_amount = 0.4;   //allows control of glow whilst still using standard perceptual luminance weight

uniform float lens_radius = 0.5;
uniform vec4 lens_colour: source_color = vec4(vec3(0.0), 1);
uniform float lens_edge = 0.05;

uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_linear_mipmap;

// Use Perceptual weight to compare to gauge brightness
const vec3 luminance_weight = vec3(0.299, 0.587, 0.114);

float make_circle(vec2 uv, vec2 pos_offset)
{
	float pos = length(uv + pos_offset);
	float c = smoothstep(lens_radius, lens_radius - lens_edge, pos);
	return c;
}

void fragment() {
	// Setup Lens UV
	vec2 uv = UV - 0.5;
	uv.x *= 1.706666667;    // Account for aspect ratio - change for your aspect

	vec4 final_col;

	if (on)
	{
		// Blur screen image by blur amount
		vec3 col = textureLod(screen_texture, SCREEN_UV, blur_amount).rgb;

		// Calculate brightness
		float brightness = dot(col, luminance_weight);

		// Use brightness to determine glow from glow colour
		vec4 glow = brightness * glow_colour * glow_amount;

		final_col = vec4(vec3(col), 1.0) + glow + vision_colour;
	}
	else
	{
		final_col = texture(screen_texture, SCREEN_UV);
	}
	
	// MIXING
	float circle = make_circle(uv, vec2(0,0));
	COLOR =  mix(lens_colour, final_col, circle);
	
	// FOR TWO CIRCLES REPLACE MIXING ABOVE WITH THIS:::
	//float circle = make_circle(uv, vec2(-0.25, 0));
	//float circle2 = make_circle(uv, vec2(0.25, 0));
	//COLOR =  mix(lens_colour, final_col, max(circle, circle2));
}