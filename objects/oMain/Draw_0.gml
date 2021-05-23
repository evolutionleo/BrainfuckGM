/// @desc


if (ran) {
	draw_set_font(fCell)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	
	for(var i = 0; i < array_length(global.__bf_memory); ++i) {
		var val = global.__bf_memory[i]
		draw_sprite_ext(sCell, 0, x + 80 * i, y, 4, 4, 0, c_white, 1)
		draw_text(x + 80 * i + 32, y + 32, string(val))
	}
	
	draw_sprite_ext(sPointer, 0, x + 80 * global.__bf_pointer, y - 70, 4, 4, 0, c_white, 1)
}