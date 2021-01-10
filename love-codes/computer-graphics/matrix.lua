local Module = {}

-- Essas multiplicações serão feitas em uma matriz
-- de 1 linha por 2 colunas que representara um vetor
-- no plano

function Module.mat2x2_mult(table2x2, vector2D)
    local a11 = table2x2[0]
    local a12 = table2x2[1]
    local a21 = table2x2[2]
    local a22 = table2x2[3]

    local x = vector2D.x
    local y = vector2D.y

    return {
        x = a11 * x + a12 * x,
        y = a21 * y + a22 * y 
    }
end

return Module