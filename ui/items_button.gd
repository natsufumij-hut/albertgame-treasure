extends TextureButton

@export var code: String

func click():
	PlayerAsset.use_asset(code,1)
