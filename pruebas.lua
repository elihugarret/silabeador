local utf8 = require"utf8"

local sep_silabas = {}

function a_tabla(s)
  local t = {}
  local i = 1
  for v in utf8.gmatch(s, ".") do
    t[i] = v
    i = i + 1
  end
  return t
end

function tiene_tilde(c)
  local tildes = "áéíóú"
  if utf8.find(tildes, c) then
    return true
  end
  return false
end

function es_vocal_fuerte(c)
  local fuertes = "aáAÁàÀeéEÉèÈíÍìÌoóOÓòÒúÚùÙ"
  if utf8.find(fuertes, c) then
    return true
  end
  return false
end

function es_consonante(c)
  local debiles = "iIuUüÜ"
  if not es_vocal_fuerte(c) then
    if utf8.find(debiles, c) then
      return false
    end
    return true
  end
  return false
end


function sep_silabas.ataque(pal, pos)
  local ultima_consonante = "a"
  local letra
  local palabra_t = a_tabla(pal)
  local lon_pal = utf8.len(pal)
  while pos <= lon_pal and es_consonante(palabra_t[pos]) and palabra_t[pos] ~= "y" do
    ultima_consonante = palabra_t[pos]
    pos = pos + 1
  end
  if pos < lon_pal then
    if palabra_t[pos] == "u" then
      if ultima_consonante == "q" then
        pos = pos + 1
      elseif ultima_consonante == "g" then
        letra = palabra_t[pos + 1]
        if letra == "e" or letra == "é" or letra == "i" or letra == "í" then
          pos = pos + 1
        end
      end
    elseif palabra_t[pos] == "ü" or pal[pos] == "Ü" then
      if ultima_consonante == "g" then
        pos = pos + 1
      end
    end
  end
  return pos
end

function sep_silabas.coda(pal, pos)
  local c1, c2, c3
  local lon_pal = utf8.len(pal)
  local palabra_t = a_tabla(pal)
  if pos > lon_pal or not es_consonante(palabra_t[pos]) then
    return pos
  else
    if pos == lon_pal then
      pos = pos + 1
      return pos
    end
    if not es_consonante(palabra_t[pos + 1]) then
      return pos
    end
    c1 = palabra_t[pos]
    c2 = palabra_t[pos + 1]
    if pos < lon_pal - 1 then
      c3 = palabra_t[pos + 2]
      if not es_consonante(c3) then
        if c1 == "l" and c2 == "l" then
          return pos
        end
        if c1 == "c" and c2 == "h" then
          return pos
        end
        if c1 == "r" and c2 == "r" then
          return pos
        end
        if c1 ~= "s" and c1 ~= "r" and c2 == "h" then
          return pos
        end
        if c2 == "y" then
          if c1 == "s" or c1 == "l" or c1 == "r" or c1 == "n" or c1 == "c" then
            return pos
          end
          pos = pos + 1
          return pos
        end
        if c1 == "b" or c1 == "v" or c1 == "c" or c1 == "d" or c1 == "k" or c1 == "f" or c1 == "g" or c1 == "p" or c1 == "t" and c2 == "l" then
          return pos
        end
        if (c1 == "b" or c1 == "v" or c1 == "c" or c1 == "d" or c1 == "k" or c1 == "f" or c1 == "g" or c1 == "p" or c1 == "t")
            and c2 == "r" then
          return pos
        end
        pos = pos + 1
        return pos
      else
        if (pos + 3) == lon_pal + 1 then
          if c2 == "y" then
            if c1 == "s" or c1 == "l" or c1 == "r" or c1 == "n" or c1 == "c" then
              return pos
            end
          end
          if c3 == "y" then
            pos = pos + 1
          else
            pos = pos + 3
          end
        end
        if c2 == "y" then
          if c1 == "s" or c1 == "l" or c1 == "r" or c1 == "n" or c1 == "c" then
            return pos
          end
          pos = pos + 1
          return pos
        end
        if (c2 == "p" and c3 == "t" or
          c2 == "c" and c3 == "t" or
          c2 == "c" and c3 == "n" or
          c2 == "p" and c3 == "s" or
          c2 == "m" and c3 == "n" or
          c2 == "g" and c3 == "n" or
          c2 == "f" and c3 == "t" or
          c2 == "p" and c3 == "n" or
          c2 == "c" and c3 == "z" or
          c2 == "t" and c3 == "s" or
          c2 == "t" and c3 == "s") then
          pos = pos + 1
          return pos
        end
        if c3 == "l" or c3 == "r" or (c2 == "c" and c3 == "h") or c3 == "y" then
          pos = pos + 1
        else
          pos = pos + 2
        end
      end
    else
      if c2 == "y" then
        return pos
      end
      pos = pos + 2
    end
  end
  return pos
end
