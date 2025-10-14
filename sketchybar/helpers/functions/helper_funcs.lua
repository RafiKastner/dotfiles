local helpers = {}

function helpers.TableConcat(t1, t2)
	for i, v in pairs(t2) do
		t1[i] = v
	end
	return t1
end

function helpers.PrintTable(t)
	for i, v in pairs(t) do
		print(i, v)
	end
end

function helpers.shallow_copy(t)
	local copy = {}
	for i, v in pairs(t) do
		copy[i] = v
	end
	return copy
end

function helpers.map(t, func)
	local ret = {}
	for i, v in pairs(t) do
		ret[i] = func(v)
	end
	return ret
end

return helpers
