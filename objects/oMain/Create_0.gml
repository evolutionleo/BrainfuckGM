/// @desc

//bf_run(",>,>,.<<.", "abc")

code = "+++++[-.]"
input = ""

ran = false

run = function() {
	bf_run(code, input)
	show_debug_message(global.__bf_memory)
	
	ran = true
}