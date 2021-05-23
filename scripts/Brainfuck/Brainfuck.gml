#macro BF_MEMORY_SIZE 15 // the classic size is 30000
#macro BF_INTEGER_LIMIT 32767

#macro BF_PLUS "+"
#macro BF_MINUS "-"
#macro BF_RIGHT ">"
#macro BF_LEFT "<"
#macro BF_INPUT ","
#macro BF_OUTPUT "."
#macro BF_START "["
#macro BF_END "]"


function bf_reset() {
	global.__bf_memory = array_create(BF_MEMORY_SIZE, 0)
	global.__bf_pointer = 0
	global.__bf_input_pointer = 1 // because strings
	global.__bf_input = ""
	global.__bf_output = ""
}

function bf_run(code, input) {
	bf_reset()
	global.__bf_input = input
	
	__bf_execute(code)
	
	__bf_print(global.__bf_output)
}

// for loops
function __bf_execute(code) {
	var pos = 1
	var len = string_length(code)
	while(pos <= len) {
		var cmd = string_char_at(code, pos)
		
		switch(cmd) {
			case BF_PLUS:
				bf_increment()
				break
			case BF_MINUS:
				bf_decrement()
				break
			case BF_RIGHT:
				bf_shift_right()
				break
			case BF_LEFT:
				bf_shift_left()
				break
			case BF_INPUT:
				bf_input()
				break
			case BF_OUTPUT:
				bf_output()
				break
			case BF_START:
				// find the end
				var loop_start = pos+1
				var loop_end = string_last_pos(BF_END, code)
				var loop_len = loop_end-loop_start
				
				var loop_code = string_copy(code, loop_start, loop_len)
				show_debug_message("loop: "+loop_code)
				__bf_loop(loop_code)
				
				pos += loop_len // and +1 more below
				break
			case BF_END:
				break
			default:
				// not an operator - skipping
				break
		}
		
		pos++
	}
}

function __bf_loop(code) {
	while(true) {
		__bf_execute(code)
		
		if bf_get() == 0
			break
	}
}

function __bf_print(str) {
	if !is_string(str) str = string(str)
	
	show_debug_message("[Branfuck]: "+str)
}

#region BF Actions

function bf_get() {
	gml_pragma("forceinline")
	return global.__bf_memory[global.__bf_pointer]
}

function bf_set(value) {
	gml_pragma("forceinline")
	global.__bf_memory[global.__bf_pointer] = value
}

function bf_increment() {
	gml_pragma("forceinline")
	var val = bf_get() + 1
	if val > BF_INTEGER_LIMIT
		val = 0
	bf_set(val)
}

function bf_decrement() {
	gml_pragma("forceinline")
	var val = bf_get() - 1
	if val < 0
		val = BF_INTEGER_LIMIT
	bf_set(val)
}

function bf_shift_right() {
	gml_pragma("forceinline")
	global.__bf_pointer++
	if global.__bf_pointer >= BF_MEMORY_SIZE
		global.__bf_pointer = 0
}

function bf_shift_left() {
	gml_pragma("forceinline")
	global.__bf_pointer--
	if global.__bf_pointer < 0
		global.__bf_pointer = BF_MEMORY_SIZE-1
}

function bf_input() {
	gml_pragma("forceinline")
	var char = string_char_at(global.__bf_input, global.__bf_input_pointer)
	global.__bf_input_pointer++
	bf_set(ord(char))
}

function bf_output() {
	global.__bf_output += chr(bf_get())
}

#endregion