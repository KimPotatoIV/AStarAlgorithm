extends Node2D

##################################################
const EMPTY_TEXTURE = preload("res://scenes/tile/empty_tile.png")
const MOUSE_OVER_TEXTURE = preload("res://scenes/tile/mouse_over_tile.png")
const START_TEXTURE = preload("res://scenes/tile/start_tile.png")
const END_TEXTURE = preload("res://scenes/tile/end_tile.png")
const OBSTACLE_TEXTURE = preload("res://scenes/tile/obstacle_tile.png")
const PATH_TEXTURE = preload("res://scenes/tile/path_tile.png")
# 각 타일 별 상태 이미지 텍스처 상수

var area_node: Area2D
# Area2D 노드 변수
var sprite_node: Sprite2D
# Sprite2D 노드 변수
var state: GM.TILE_STATE
# 타일 상태 값 변수

##################################################
func _ready() -> void:
	area_node = $Area2D
	sprite_node = $Area2D/Sprite2D
	# 노드 변수 설정
	
	state = GM.TILE_STATE.EMPTY
	# 타일 상태 값 EMPTY로 초기 설정
	
	area_node.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	area_node.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	area_node.connect("input_event", Callable(self, "_on_input_event"))
	# 마우스 액션에 따른 함수 연결

##################################################
func _on_mouse_entered() -> void:
# 마우스가 들어왔을 때
	if state <= GM.TILE_STATE.MOUSE_OVER:
	# 타일 상태가 EMPTY or MOUSE_OVER일 때
		if GM.get_is_dragging():
		# 드래그 중이면
			state = GM.TILE_STATE.OBSTACLE
			# OBSTACLE 상태로 설정
		else:
		# 드래그 중이 아니면
			state = GM.TILE_STATE.MOUSE_OVER
			# MOUSE_OVER 상태로 설정
	update_tile()
	# 타일 텍스처 업데이트

##################################################
func _on_mouse_exited() -> void:
# 마우스가 나갔을 때
	if state == GM.TILE_STATE.MOUSE_OVER:
	# MOUSE_OVER 상태면
		state = GM.TILE_STATE.EMPTY
		# 타일 상태를 EMPTY로 설정
		update_tile()
		# 타일 텍스처 업데이트

##################################################
func update_tile() -> void:
# 타일 텍스처 업데이트 함수
	match state:
		GM.TILE_STATE.EMPTY:
			sprite_node.texture = EMPTY_TEXTURE
		GM.TILE_STATE.MOUSE_OVER:
			sprite_node.texture = MOUSE_OVER_TEXTURE
		GM.TILE_STATE.START:
			sprite_node.texture = START_TEXTURE
		GM.TILE_STATE.END:
			sprite_node.texture = END_TEXTURE
		GM.TILE_STATE.OBSTACLE:
			sprite_node.texture = OBSTACLE_TEXTURE
		GM.TILE_STATE.PATH:
			sprite_node.texture = PATH_TEXTURE

##################################################
func set_tile(state_value: GM.TILE_STATE) -> void:
# 타일 상태 설정 함수
	state = state_value
	update_tile()
	# 타일 텍스처 업데이트

##################################################
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
# 입력 이벤트가 있을 때 실행되는 함수
	if event is InputEventMouseButton:
	# 이벤트가 마우스 버튼 클릭이면
		if event.button_index == MOUSE_BUTTON_LEFT:
		# 이벤트 버튼 입력이 마우스 좌클릭이면
			if event.is_pressed():
			# 마우스 버튼을 눌렀을 때
				GM.set_is_dragging(true)
				# 드래그 중으로 설정
				if not state == GM.TILE_STATE.START and \
				not state == GM.TILE_STATE.END:
				# 타일 상태가 START와 END가 아니면
					state = GM.TILE_STATE.OBSTACLE
					# 타일 상태를 OBSTACLE로 설정
				update_tile()
				# 타일 텍스처 업데이트
			else:
			# 마우스 버튼을 뗐을 때
				GM.set_is_dragging(false)
				# 드래그 중이 아니게 설정
