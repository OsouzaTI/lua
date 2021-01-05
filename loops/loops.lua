--[[
    Author: Ozeias Souza
    Data: 05/01/2021
    Hours:  10:23:16
]]--

print("Loop while com contador de 1 a 10")
local contador = 0
while contador < 10 do
    contador = contador + 1
    print(contador)
end

print("Loop for normal de 1 a 10")
for i = 1, 10, 1 do
    print(i)
end

print("Loop for normal de 1 a 10 com passo 2")
for i = 1, 10, 2 do
    print(i)
end

-- Array de nomes
local nomes = {
    "Kevin",
    "Laranjo",
    "Rafael",
    "Aeroporto de t..."
}
print("Loop for")
for i, v in ipairs(nomes) do
    print("Index: "..i..", Value: "..v)
end