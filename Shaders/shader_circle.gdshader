shader_type canvas_item;

uniform vec2 center = vec2(0.5, 0.5);
uniform float radius = 0.3;
uniform float thickness = 0.02;
uniform float feather = 0.01;
uniform vec4 color : source_color = vec4(1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float dist = length(UV - center);
	float circleness = smoothstep(feather+thickness, thickness, abs(dist-radius));
	//COLOR.rgb = mix(texture(TEXTURE,UV).rgb, color.rgb, circleness);
	//COLOR.a = 1.0;
	COLOR = mix(vec4(0.0), color, circleness);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
