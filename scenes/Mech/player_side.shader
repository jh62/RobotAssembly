shader_type canvas_item;

uniform vec4 other_color : hint_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    vec4 curr_color = texture(TEXTURE,UV); // Get current color of pixel

    if (round(curr_color) == round(other_color)){
        COLOR = vec4(0.75,0.05, 0.05,1.0);
    }else{
        COLOR = curr_color;
    }
}