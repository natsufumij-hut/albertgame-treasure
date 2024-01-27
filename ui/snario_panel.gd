class_name SnarioPanel
extends NinePatchRect

signal snarioEnd(code: String)

@export var wordList: Array[String]
@export var readTimer: Timer
@export var label: Label

var wordIndex := 0
var chaIndex :=0
var nowCode: String = "Code"

func start(list: Array[String]):
	visible=true
	wordList = list
	wordIndex=0
	startLine(wordList[wordIndex])

func _ready() -> void:
	#startLine(wordList[0])
	pass

# area.title.code
func trigger(id: String):
	var spl = id.split(".")
	if spl.size()==3:
		trigger_snario(spl[0],spl[1],spl[2])

func trigger_snario(area: String, title: String, code: String):
	var load := SnarioLoad.new()
	var snario = load.readScenario(area,title,code)
	start(snario)

func startLine(word: String):
	chaIndex=0
	label.text = ""
	readTimer.start()

func startNewLine():
	if wordIndex==wordList.size()-1:
		snarioEnd.emit(nowCode)
		visible=false
		return
	wordIndex+=1
	startLine(wordList[wordIndex])

func putLine():
	readTimer.stop()
	label.text = wordList[wordIndex]

func readWord():
	if chaIndex==wordList[wordIndex].length():
		readTimer.stop()
	else:
		chaIndex+=1
		label.text = wordList[wordIndex].substr(0,chaIndex+1)

func open():
	visible = true

func close():
	visible = false

func click():
	if !readTimer.is_stopped():
		putLine()
	else:
		startNewLine()
