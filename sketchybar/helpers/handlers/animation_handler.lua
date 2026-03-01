-- TODO: make an animation handler module to queue animations
-- cause the reason the apple waits to indent is cause we have
-- the spaces taking priority
-- Regarding the menus, I believe it also waits for the spaces
-- to finish their animation before killing itself so even for
-- 0 length/non animations put at the front of queue
--
--
-- format:
-- queue = {
--    [{
--      callback = (props, duration) => ()
--    }]
-- }
--
--handler.add(item, connection, props: {}, duration, priority)
local handler = {}
print("In handler")
function handler.test(item)
	handler[item] = item
end
function handler.print()
	for i, v in pairs(handler) do
		print(i, v)
	end
end

handler._queue = {}

handler._item = sbar.add("item", { drawing = false })

function handler.add(item, connection, curve, duration, props, priority)
	if not handler._queue[connection] then
		handler._queue[connection] = {}
	end
	local new_table = {}
	new_table[priority] = { item = item, props = props, duration = duration, curve = curve }
	for i, listener in pairs(handler._queue[connection]) do
		if i >= priority then
			new_table[i + 1] = listener
		end
		new_table[i] = listener
		handler._queue[connection] = new_table
	end
end

function handler.execute(connection)
	if not connection then
		error("Specified connection does not exit: " .. connection, 1)
		return
	end
	for _, listener in pairs(handler._queue[connection]) do
		sbar.animate(listener.curve, listener.duration, function()
			listener.item:set(listener.props)
		end)
	end
end

return handler
