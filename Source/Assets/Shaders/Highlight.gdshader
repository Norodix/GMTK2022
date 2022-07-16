shader_type spatial;

render_mode cull_disabled, unshaded, ambient_light_disabled;

uniform sampler2D mask1;
uniform sampler2D mask2;
uniform sampler2D mask3;
uniform sampler2D mask4;

uniform bool mask1_enabled = false;
uniform bool mask2_enabled = false;
uniform bool mask3_enabled = false;
uniform bool mask4_enabled = false;

void vertex()
{
	//VERTEX = (NORMAL * 0.1) + VERTEX;
}

void fragment(){
	vec3 m1 = texture(mask1, UV).rgb;
	vec3 m2 = texture(mask2, UV).rgb;
	vec3 m3 = texture(mask3, UV).rgb;
	vec3 m4 = texture(mask4, UV).rgb;
	
	//ALPHA = m1.r * float(mask1_enabled) + m2.r * float(mask2_enabled);
	ALPHA =   m1.r * float(mask1_enabled) 
			+ m2.r * float(mask2_enabled)
			+ m3.r * float(mask3_enabled)
			+ m4.r * float(mask4_enabled);

	ALBEDO = vec3(2.0, 2.0, 2.0);
}