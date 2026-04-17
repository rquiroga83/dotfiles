-- ~/.config/yazi/init.lua — Cyberpunk Red
-- Override del layout: agrega una fila vacía entre tabs y contenido

-- Layout original: Header | Tabs | Content | Status
-- Layout nuevo:    Header | Tabs | Spacer | Content | Status

Root.layout = function(self)
	self._chunks = ui.Layout()
		:direction(ui.Layout.VERTICAL)
		:constraints({
			ui.Constraint.Length(1),              -- Header (barra de ruta)
			ui.Constraint.Length(Tabs.height()),  -- Tabs
			ui.Constraint.Length(1),              -- Espacio visual entre tabs y contenido
			ui.Constraint.Fill(1),                -- Contenido del tab activo
			ui.Constraint.Length(1),              -- Status bar
		})
		:split(self._area)
end

Root.build = function(self)
	self._children = {
		Header:new(self._chunks[1], cx.active),
		Tabs:new(self._chunks[2]),
		Tab:new(self._chunks[4], cx.active),
		Status:new(self._chunks[5], cx.active),
		Modal:new(self._area),
	}
end