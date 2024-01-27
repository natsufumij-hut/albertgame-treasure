class_name SnarioLoad

var cache: Dictionary = {}

func readScenario(area: String, title: String,code: String) -> Array[String]:
	var path:="res://snario/"+area+"/"+title+".txt" 
	if cache.has(path):
		var dic: Dictionary = cache[path]
		return dic[code].paragraphs
	var file := FileAccess.open(path, FileAccess.READ)
	if file==null:
		GameSignal.log.emit("找不到剧本文件!!!!")
	var content = file.get_as_text()
	print("找到内容!!>>")
	print(content)
	var dic = splitScenario(content)
	return dic[code].paragraphs

## [CodeName]
## 不显示说话的人
## 不显示说话的人
## 不显示说话的人
func splitScenario(content: String)-> Dictionary:
	var split = content.split("\n\n")
	print(split)
	var scenarios: Dictionary = {}
	for sc in split:
		var sce = splitGraph(sc)
		if sce!=null:
			scenarios[sce.code]=sce
	print("导入完成！！！")
	return scenarios

func splitGraph(content: String) -> Scenario:
	var all: PackedStringArray = content.split("\n")
	var scenario = Scenario.new()
	var code = all[0].substr(1,all[0].length()-2)
	scenario.code = code
	for i in range(1, all.size()):
		var p:  = all[i] as String
		if !p.is_empty():
			scenario.paragraphs.append(p)
	return scenario

class Scenario:
	var code: String
	var paragraphs: Array[String] = []
