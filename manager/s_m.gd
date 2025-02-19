extends Node

##################################################
const GNERATING_SOUND: AudioStream = preload("res://sounds/maou_se_8bit16.wav")
# 연산 효과음 미리 불러오기

var effect_sound_player: AudioStreamPlayer
# 효과음 재생 플레이어 변수

##################################################
func _ready() -> void:
	effect_sound_player = AudioStreamPlayer.new()
	add_child(effect_sound_player)
	effect_sound_player.stream = GNERATING_SOUND
	# 효과음 재생 플레이어 설정
	

##################################################
func effect_sound_play() -> void:
	effect_sound_player.play()
	# 효과음 재생
