return function(s)
	if s == screen.primary then
		return wibox.widget.systray()
	else
		return {}
	end
end
