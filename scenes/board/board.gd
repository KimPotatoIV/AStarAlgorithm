extends Node2D

##################################################
const TILE_SCENE: PackedScene = preload("res://scenes/tile/tile.tscn")
# 타일 씬 미리 불러오기 변수
const ROWS_COLS: int = 100
# 보드 가로 세로 타일 개수
const TILE_SIZE: float = 10
# 타일 픽셀 크기

var board: Array = []
# 각 타일 인스턴스를 저장하는 변수
var path: Array = []
# 경로 변수
var generating: bool = false
# 연산 중 여부 변수
var timer_node: Timer
# Timer 노드 변수

##################################################
func _ready() -> void:
	timer_node = $Timer
	timer_node.wait_time = 0.01
	timer_node.connect("timeout", Callable(self, "_on_timer_node_timeout"))
	# timer_node 변수 설정
	
	init_board()
	# 보드 초기화

##################################################
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
	# 스페이스 키를 누르면
		timer_node.start()
		# 타이머 시작

##################################################
func init_board() -> void:
# 보드 초기화 함수
	for row in range(ROWS_COLS):
	# 행 개수만큼 순회하며
		var row_data: Array = []
		# 행 데이터를 임시 저장할 변수
		for col in range(ROWS_COLS):
		# 열 개수만큼 순회하며
			var tile_instance = TILE_SCENE.instantiate()
			# TILE_SCENE 인스턴스화
			tile_instance.position = Vector2(col * TILE_SIZE, row * TILE_SIZE)
			# tile_instance 좌표 설정
			add_child(tile_instance)
			# 자식 노드에 추가
			
			if row == 0 and col == 0:
			# Start 노드라면
				tile_instance.set_tile(GM.TILE_STATE.START)
				# START 상태로 설정
			elif row == ROWS_COLS - 1 and col == ROWS_COLS - 1:
			# End 노드라면
				tile_instance.set_tile(GM.TILE_STATE.END)
				# End 상태로 설정
			
			row_data.append(tile_instance)
			# row_data에 tile_instance 추가
		board.append(row_data)
		# 한 행이 들어간 변수인 row_data를 board에 추가

##################################################
func update_board() -> void:
# board 갱신 함수
	for i in path.size():
	# path 크기만큼 순회하며
		board[path[i].x][path[i].y].state = GM.TILE_STATE.PATH
		# board 내에 path 인자 좌표의 타일 상태값을 PATH로 설정
		board[path[i].x][path[i].y].update_tile()
		# 타일 텍스처 업데이트
		timer_node.start()
		# 타이머 재시작

##################################################
func _on_timer_node_timeout() -> void:
# 타이머 시간이 만료됐을 때 실행되는 함수
	generating = AS.find_path(board, path)
	# 경로를 한 단계 찾고 연산 중인지 여부 반환 및 설정
	if generating:
	# 연산 중이면
		update_board()
		# board 갱신
		timer_node.start()
		# 타이머 재시작
	else:
	# 연산 중이 아니면(길이 없거나 길을 찾았거나)
		timer_node.stop()
		# 타이머 정지
		
		board[0][0].set_tile(GM.TILE_STATE.START)
		board[ROWS_COLS - 1][ROWS_COLS - 1].set_tile(GM.TILE_STATE.END)
		# Start, End 타일 재설정
