extends Control
#onready
@onready var timer: Timer = $Timer
@onready var spot_1 = %spot1
@onready var spot_2 = $ScoreEntry/GridContainer/spot2
@onready var spot_3 = $"ScoreEntry/GridContainer/spot 3"


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var warning = $ScoreEntry/warning
@onready var leaderboard = $Leaderboard
@onready var score_entry = $ScoreEntry
@onready var score_earned: Label = $ScoreEntry/Label2
@onready var leaderboard_place_label = $Leaderboard/LeaderboardPlaceLabel


@onready var v_box_container = $Leaderboard/VBoxContainer
@onready var return_button = $Leaderboard/return_button

var score = 14 #GameManager.total_crystals
var players = [
	{"name": "TEST", "score": 999999999}
]


var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var max_letters = len(alphabet)
var current_letter = 0
var curr_spot = 0
var flash = false
var curr_name = []
var to_be_filtered_name = []


var curr_name_index =  [0, 0, 0]


var alphebet_index = 0
var spot_array = []
var spot_updated = false
var opaque = Color8(255,255,255,255)
var half_opaque = Color8(255,255,255,127)

var block_inputs = false
const nono_words = ['ass', 'fuc', 'fuk', 'fuq', 'fux', 'fck', 'coc', 'cok', 'coq',
 'kox', 'koc', 'kok', 'koq', 'cac', 'cak', 'caq', 'kac', 'kak', 'kaq', 'dic', 'dik',
 'diq', 'dix',
 'dck', 'pns', 'psy', 'fag', 'fgt', 'ngr', 'nig', 'cnt', 'knt', 'sht', 'dsh', 'twt',
 'bch', 'cum', 'clt', 'kum', 'klt', 'suc', 'suk', 'suq', 'sck', 'lic', 'lik', 'liq',
 'lck', 'jiz', 'jzz', 'gay', 'gey', 'gei', 'gai', 'vag', 'vgn', 'sjv', 'fap', 'prn',
 'lol', 'jew', 'joo', 'gvr', 'pus', 'pis', 'pss', 'snm', 'tit', 'fku', 'fcu', 'fqu',
 'hor', 'slt', 'jap', 'wop', 'kik', 'kyk', 'kyc', 'kyq', 'dyk', 'dyq', 'dyc', 'kkk',
 'jyz', 'prk', 'prc', 'prq', 'mic', 'mik', 'miq', 'myc', 'myk', 'myq', 'guc', 'guk',
 'guq', 'giz', 'gzz', 'sex', 'sxx', 'sxi', 'sxe', 'sxy', 'xxx', 'wac', 'wak', 'waq',
 'wck', 'pot', 'thc', 'vaj', 'vjn', 'nut', 'std', 'lsd', 'poo', 'azn', 'pcp', 'dmn',
 'orl', 'anl', 'ans', 'muf', 'mff', 'phk', 'phc', 'phq', 'xtc', 'tok', 'toc', 'toq',
 'mlf', 'rac', 'rak', 'raq', 'rck', 'sac', 'sak', 'saq', 'pms', 'nad', 'ndz', 'nds',
 'wtf', 'sol', 'sob', 'fob', 'sfu' ,  # for testing
]

var DEBUG_RESET_SCORES = false  # Debug flag to reset scores

func _ready() -> void:
	score_earned.text = "YOUR SCORE IS: " + str(score)
	if DEBUG_RESET_SCORES:
		reset_scores()  # Call function to reset scores if debug flag is true
	_update_leaderboard()
	spot_array = [
		spot_1,
		spot_2,
		spot_3
	]
	_update_leaderboard_place()  # Call new function to update place label





func _input(event: InputEvent) -> void:
	if event.is_action_pressed("p1_move_up") and block_inputs == false: # or event.is_action_pressed("p1_move_down"): # SW
		spot_manager()
	elif event.is_action_pressed("p1_shoot") and block_inputs == false: # H
		_one_key_keyboard()
	elif event.is_action_pressed("p1_select") and block_inputs == false: # A
		filter_names()
	elif event.is_action_pressed("p1_move_down") and block_inputs == false: # REMOVE FOR TURN IN
		leaderboard.visible = !leaderboard.visible
		score_entry.visible = !score_entry.visible
		_update_leaderboard()
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
	#print(str(current_letter))
	if current_letter >= max_letters:
		current_letter = 0

func save_name():
	curr_name_index[curr_spot] = current_letter #saves the index of the current name to the current letter before switching
	#curr_name[curr_spot] = alphabet[current_letter]



func filter_names():
	for i in range(len(spot_array)):
		curr_name.append(spot_array[i].text)
		to_be_filtered_name = ''.join(curr_name)

	curr_name.clear()
	print('To be filtered name is: ' + to_be_filtered_name.to_lower())

	if "_" in to_be_filtered_name:
		print("ERROR: text contains a underscore")
		timer.stop()
		spot_array[curr_spot].modulate = opaque
		animation_player.play("bad_word")
		curr_name.clear()
		warning.text = "Name cannot contain '_' !"
		warning.show()
		await animation_player.animation_finished
		warning.hide()
		timer.start()
		return

	elif to_be_filtered_name.to_lower() in nono_words:
		print("bad word")
		animation_player.play("bad_word")
		timer.stop()
		spot_array[curr_spot].modulate = opaque
		curr_spot = 0
		curr_name_index = [0, 0, 0]
		current_letter = 0
		warning.text = 'Name is invalid!'
		warning.show()
		await animation_player.animation_finished
		warning.hide()
		for i in range(len(spot_array)):
			spot_array[i].text = '_'
		timer.start()
		curr_name.clear()
		return

	# Check if the name is already in the leaderboard
	var players = load_players()
	for player in players:
		if player["name"] == to_be_filtered_name:
			print("Name already exists in the leaderboard")
			animation_player.play("bad_word")
			timer.stop()
			spot_array[curr_spot].modulate = opaque
			curr_spot = 0
			curr_name_index = [0, 0, 0]
			current_letter = 0
			warning.text = 'Name already exists!'
			warning.show()
			await animation_player.animation_finished
			warning.hide()
			for i in range(len(spot_array)):
				spot_array[i].text = '_'
			timer.start()
			curr_name.clear()
			return

	save_high_score(to_be_filtered_name, score)
	_update_leaderboard()
	GameManager._reset()
	block_inputs = true
	return_button.grab_focus()
	leaderboard.show()
	score_entry.hide()









func _update_leaderboard():
	var total_labels = v_box_container.get_child_count()
	var players = load_players()  # Load from file instead of a global variable
	var total_players = players.size()
	for i in range(total_labels):
		var label = v_box_container.get_child(i)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		if i < total_players:
			var score_str = str(int(players[i]["score"]))
			score_str = score_str.pad_zeros(5)
			label.bbcode_text = "[color=yellow]%d. %s[/color] - [color=green]%s[/color]" % [
				i + 1,
				players[i]["name"],
				score_str
			]
		else:
			label.bbcode_text = "[color=gray]%d. ---[/color] - [color=darkgray]00000[/color]" % (i + 1)




func load_players() -> Array:
	var path = "user://highscore.save"
	print("Loading high scores from: ", path)
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		var parsed = JSON.parse_string(content)
		if parsed and parsed.has("players"):
			return parsed["players"]
	return []  # Return empty array if file missing or invalid




func save_high_score(name: String, score: int):
	var path = "user://highscore.save"
	print("Saving high scores to: ", path)
	var players = load_players()  # Load existing scores
	players.append({"name": name, "score": score})  # Add new score

	# Sort players by score in descending order
	players.sort_custom(func(a, b): return a["score"] > b["score"])

	# Keep only top 10 scores
	if players.size() > 10:
		players = players.slice(0, 9)

	var save_data = {"players": players}
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()


func load_high_score() -> Dictionary:
	if FileAccess.file_exists("user://highscore.save"):
		var file = FileAccess.open("user://highscore.save", FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		var data = JSON.parse_string(content)
		if data:
			return data
	return {"name": "---", "score": 0}



func _process(_delta: float) -> void:
	pass

func _update_leaderboard_place():
	var players = load_players()
	var player_place = 0
	var found = false

	for i in range(players.size()):
		if players[i]["score"] == score:
			player_place = i + 1
			found = true
			break

	if not found:
		if players.size() == 0:
			player_place = 1  # If no scores exist, the player is first
		else:
			for i in range(players.size()):
				if score > players[i]["score"]:
					player_place = i + 1
					break
				else:
					player_place = players.size() + 1

	leaderboard_place_label.text = "Your place: " + str(player_place)

func reset_scores():
	var path = "user://highscore.save"
	var empty_data = {"players": []}
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(empty_data))
	file.close()
	print("Scores have been reset.")


func _on_return_button_pressed():
	GameManager._reset()
	get_tree().change_scene_to_file("res://scenes/ui/menus/main_menu.tscn")
