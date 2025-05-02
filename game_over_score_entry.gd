extends Control
#onready
@onready var timer: Timer = $Timer
@onready var spot_1: Label = %spot1
@onready var spot_2: Label = $Panel/GridContainer/spot2
@onready var spot_3: Label = $"Panel/GridContainer/spot 3"
@onready var animation_player: AnimationPlayer = $AnimationPlayer



var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" 
var max_letters = len(alphabet)
var current_letter = 0
var curr_spot = 0
var flash = false
var curr_name = []



var curr_name_index =  [0, 0, 0]


var alphebet_index = 0
var spot_array = []
var spot_updated = false
var opaque = Color8(255,255,255,255)
var half_opaque = Color8(255,255,255,127)


const nono_words = ['ass', 'fuc', 'fuk', 'fuq', 'fux', 'fck', 'coc', 'cok', 'coq', 'kox', 'koc', 'kok', 'koq', 'cac', 'cak', 'caq', 'kac', 'kak', 'kaq', 'dic', 'dik', 'diq', 'dix', 'dck', 'pns', 'psy', 'fag', 'fgt', 'ngr', 'nig', 'cnt', 'knt', 'sht', 'dsh', 'twt', 'bch', 'cum', 'clt', 'kum', 'klt', 'suc', 'suk', 'suq', 'sck', 'lic', 'lik', 'liq', 'lck', 'jiz', 'jzz', 'gay', 'gey', 'gei', 'gai', 'vag', 'vgn', 'sjv', 'fap', 'prn', 'lol', 'jew', 'joo', 'gvr', 'pus', 'pis', 'pss', 'snm', 'tit', 'fku', 'fcu', 'fqu', 'hor', 'slt', 'jap', 'wop', 'kik', 'kyk', 'kyc', 'kyq', 'dyk', 'dyq', 'dyc', 'kkk', 'jyz', 'prk', 'prc', 'prq', 'mic', 'mik', 'miq', 'myc', 'myk', 'myq', 'guc', 'guk', 'guq', 'giz', 'gzz', 'sex', 'sxx', 'sxi', 'sxe', 'sxy', 'xxx', 'wac', 'wak', 'waq', 'wck', 'pot', 'thc', 'vaj', 'vjn', 'nut', 'std', 'lsd', 'poo', 'azn', 'pcp', 'dmn', 'orl', 'anl', 'ans', 'muf', 'mff', 'phk', 'phc', 'phq', 'xtc', 'tok', 'toc', 'toq', 'mlf', 'rac', 'rak', 'raq', 'rck', 'sac', 'sak', 'saq', 'pms', 'nad', 'ndz', 'nds', 'wtf', 'sol', 'sob', 'fob', 'sfu']
func _ready() -> void:
	spot_array = [
		spot_1,
		spot_2,
		spot_3
	]





func _input(event: InputEvent) -> void:
	if event.is_action_pressed("p1_l1"): # U
		spot_manager()
	elif event.is_action_pressed("p1_a"): # H
		_one_key_keyboard()
	elif event.is_action_pressed("p1_r1"): # I
		filter_names()

func spot_manager():

	spot_array[curr_spot].modulate = opaque

	save_name()
	curr_spot = curr_spot + 1
	if curr_spot >= 3:
		curr_spot = 0
	current_letter = curr_name_index[curr_spot]
	
	spot_updated = false
	spot_array[curr_spot].modulate = half_opaque
	flash = true
	timer.start()
	_on_timer_timeout()


func _on_timer_timeout() -> void:
	if flash: #true
		flash = !flash
		spot_array[curr_spot].modulate = half_opaque
	else:
		flash = !flash #false
		spot_array[curr_spot].modulate = opaque
	timer.start()




func _one_key_keyboard():

	spot_array[curr_spot].text = str(alphabet[current_letter])
	current_letter += 1
	print(str(current_letter))
	if current_letter >= max_letters:
		current_letter = 0

func save_name():
	curr_name_index[curr_spot] = current_letter #saves the index of the current name to the current letter before switching
	#curr_name[curr_spot] = alphabet[current_letter]
	


func filter_names():
	for i in range(len(spot_array)):
		curr_name.append(spot_array[i].text)
	var to_be_filtered_name  =''.join(curr_name)
	print(to_be_filtered_name)
	
	if to_be_filtered_name.to_lower() in nono_words:
		print("what the sigma man")
		animation_player.play("bad_word")
		timer.stop()
		spot_array[curr_spot].modulate = opaque
		curr_spot = 0
		
		curr_name_index =  [0, 0, 0]
		await animation_player.animation_finished
		for i in range(len(spot_array)):
			spot_array[i].text = '_'
		timer.start()
		
	curr_name = []






func _process(_delta: float) -> void:
	pass
