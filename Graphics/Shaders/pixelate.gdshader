shader_type canvas_item;

uniform vec2 pixel_size = vec2(32.0, 32.0);

void fragment() {
	NORMAL_MAP = vec3(-0.5, 1.0, 1.0);
    vec2 snapped = floor(VERTEX.xy / pixel_size) * pixel_size + 0.5 * pixel_size;
    LIGHT_VERTEX = vec3(snapped, 0.0);
	COLOR = texture(TEXTURE, UV);
}