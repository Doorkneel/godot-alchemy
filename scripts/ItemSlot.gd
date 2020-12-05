extends CenterContainer

export var default_color := Color(0.5, 0.5, 0.5)
export var highlight_color: Color = default_color.lightened(0.3)

func highlight():
	$ColorRect.color = highlight_color

func unhighlight():
	$ColorRect.color = default_color
