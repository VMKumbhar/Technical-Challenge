def findvalue(obj, key):
    if type(obj) != dict:
        return None
    if key in obj.keys():
        if type(obj[key]) == dict:
            return findvalue(obj[key], lastkey(obj[key]))
        else:
            return obj[lastkey(obj)]
    else:
        nested_key = lastkey(obj)
        return findvalue(obj[nested_key], key)

def lastkey(obj):
    if len(list(obj)) >= 1:
        return list(obj)[0]
    else:
        print("Wrong Value / Empty Dictionary Check again")

obj = {'x': {'y': {'z': 'a'}}}
value = findvalue(obj, 'y')
print("value =", value)
