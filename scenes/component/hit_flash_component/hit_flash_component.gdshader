shader_type canvas_item;

uniform float lerp_percent : hint_range(0.0, 1.0);

// access sprite.modulate https://github.com/godotengine/godot/issues/49781#issuecomment-1543250039
varying flat vec4 MODULATE;
void vertex() {
	MODULATE = COLOR;
}

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	vec4 final_color = mix(MODULATE * texture_color, vec4(1.0, 1.0, 1.0, texture_color.a), lerp_percent);
	COLOR = final_color;
}
