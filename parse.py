import re

def dump_lua(data):
    if type(data) is str:
        return f'"{data}"'
    elif type(data) in (int, float):
        return f'{data}'
    elif type(data) is bool:
        return "true" if data else "false"
    elif type(data) is list:
        l = "{"
        l += ", ".join([dump_lua(item) for item in data])
        l += "}"
        return l
    elif type(data) is dict:
        t = "{"
        t += ", ".join([f'["{k}"]={dump_lua(v)}' for k,v in data.items()])
        t += "}"
        return t
    else:
        raise NotImplementedError()

class Parser:
    def __init__(self, string):
        self.string = string
        self.pos = 0

    def get_rest(self):
        return self.string[self.pos:]
    
    def peek(self):
        return self.string[self.pos]
    
    def read(self):
        value = self.string[self.pos]
        self.pos += 1
        return value

    def is_empty(self):
        return self.pos >= len(self.string)
    
    def skip_space(self):
        if self.peek() == " ":
            self.read()
    
    def read_expect(self, char):
        if self.is_empty():
            return False
        self.skip_space()

        value = (self.string[self.pos] == char)
        self.pos += 1

        return value
    
    def read_num(self):
        self.skip_space()

        number = ""

        while not self.is_empty() and self.peek().isdigit():
            number += self.read()

        return int(number)
    
    def read_string(self):
        self.skip_space()

        text = ""
        self.read_expect('"')
        while True:
            value = self.read()
            if value == '"':
                return text
            text += value
    
    def read_object(self):
        pass


with open("recipe.txt", "r") as f, open("recipes.lua", "w") as f2:
    recipes = {}

    for line in f:
        recipe = {}
        parser = Parser(line.strip())
        if parser.peek() == "[":
            parser.read()
            recipe["circuit"] = parser.read_num()
            parser.read_expect("]")
        
        recipe["amount"] = parser.read_num()
        target = parser.read_string()

        assert(parser.read_expect("="))
        
        ingredients = []

        while True:
            ingredient = {}
            ingredient["amount"] = parser.read_num()
            ingredient["name"] = parser.read_string()
            ingredients.append(ingredient)
            if not parser.read_expect("+"):
                break
        
        recipe["ingredients"] = ingredients
        recipes[target] = recipe
    
    f2.write("return {}".format(dump_lua(recipes)))
            
        

with open("stock.txt", "r") as f, open("stock.lua", "w") as f2:
    stock = {}

    for line in f:
        parser = Parser(line.strip())
        target = parser.read_string()
        parser.read_expect(":")
        stock[target] = parser.read_num()
    
    f2.write("return {}".format(dump_lua(stock)))