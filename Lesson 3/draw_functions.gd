extends Node

func draw_dotted_line(d, from, to, dotdistance, color, width=1.0, antialiased=true):
	var linedir = (to-from).normalized()
	var dist = (to-from).length()
	var accum = 0.0
	while accum < dist:
		d.draw_circle(from + (linedir * accum), width, color)
		accum += dotdistance
		
func draw_dashed_line(d, from, to, dashspace, dashlength, color, width=1.0, antialiased=true):
	var linedir = (to-from).normalized()
	var dist = (to-from).length()
	var accum = 0.0
	while accum < dist:
		var pos = from + accum * linedir
		var dashlength_mod = min(dashlength, dist-accum)
		d.draw_line(pos, pos + dashlength_mod * linedir, color, width, antialiased)
		accum += dashspace + dashlength