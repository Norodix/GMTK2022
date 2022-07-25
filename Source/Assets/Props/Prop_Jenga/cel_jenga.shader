//By David Lipps aka DaveTheDev @ EXPWorlds
//v2.0.0 for Godot 3.2

shader_type spatial;
render_mode ambient_light_disabled, depth_draw_always;

uniform bool use_shade = true;
uniform bool use_light = false;
uniform bool use_shadow = false;
uniform bool use_vertex_color = false;

uniform vec4 base_color : hint_color = vec4(1.0);
uniform vec4 shade_color : hint_color = vec4(1.0);

uniform float shade_threshold : hint_range(-1.0, 1.0, 0.001) = 0.0;
uniform float shade_softness : hint_range(0.0, 1.0, 0.001) = 0.01;

uniform float shadow_threshold : hint_range(0.00, 1.0, 0.001) = 0.7;
uniform float shadow_softness : hint_range(0.0, 1.0, 0.001) = 0.1;

uniform sampler2D base_texture: hint_albedo;
uniform sampler2D shade_texture: hint_albedo;
uniform sampler2D palette: hint_albedo;

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

void vertex(){
	COLOR = INSTANCE_CUSTOM;
}

void fragment(){
	ALBEDO = COLOR.rgb;
	ALPHA = COLOR.a;
}

void light()
{
	float rand = ALBEDO.r;
	vec4 randColor = texture(palette, vec2(rand, 0.0));
	vec4 base = texture(base_texture, UV).rgba * randColor * base_color;
	vec4 diffuse = base;
	vec4 shade = texture(shade_texture, UV).rgba * randColor * shade_color.rgba;
	float NdotL = dot(NORMAL, LIGHT);
	float is_lit = step(shade_threshold, NdotL);
	//vec4 base = texture(base_texture, UV).rgba * base_color.rgba;
	
	if (use_shade)
	{
		float shade_value = smoothstep(shade_threshold - shade_softness ,shade_threshold + shade_softness, NdotL);
		diffuse = mix(shade, base, shade_value);
		
		if (use_shadow)
		{
			float shadow_value = smoothstep(shadow_threshold - shadow_softness ,shadow_threshold + shadow_softness, ATTENUATION.r);
			shade_value = min(shade_value, shadow_value);
			diffuse = mix(shade, base, shade_value);
			is_lit = step(shadow_threshold, shade_value);
		}
	}
	
	if (use_light)
	{
		diffuse *= vec4(LIGHT_COLOR, 1.0);
	}
	
	DIFFUSE_LIGHT = diffuse.rgb;
	ALPHA = diffuse.a;
}
