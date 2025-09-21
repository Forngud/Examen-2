-- a) ¿Cuántas canciones ha compuesto “JUANES”? (Tener en cuenta que el nombre del compositor viene completo (usar función CHARINDEX) )

SELECT COUNT(DISTINCT cc.IdCancion) AS CancionesCompuestasPor_Juanes
FROM Compositor c
JOIN CancionCompositor cc ON c.Id = cc.IdCompositor
WHERE CHARINDEX('JUANES', UPPER(c.Nombre)) > 0;

-- b) ¿Qué interpretaciones se tienen de la canción “Lluvia” y en qué ritmos?

SELECT 
  i.Id AS IdInterpretacion,
  interp.Nombre AS Interprete,
  i.Duracion,
  r.Ritmo
FROM Interpretacion i
JOIN Cancion c ON i.IdCancion = c.Id
JOIN Interprete interp ON i.IdInterprete = interp.Id
JOIN Ritmo r ON i.IdRitmo = r.Id
WHERE UPPER(c.Titulo) = 'LLUVIA';

-- c) ¿Qué canciones hay con el mismo Intérprete y Compositor del ritmo “Balada”? 
-- Tener en cuenta que solo aplica para solistas y que el nombre del compositor 
-- viene completo (nombre de pila y seudónimo) mientras que el del interprete es el 
-- seudónimo solamente. 

SELECT DISTINCT
  c.Titulo,
  interp.Nombre AS Interprete,
  comp.Nombre AS Compositor,
  r.Ritmo
FROM Interpretacion i
JOIN Cancion c ON i.IdCancion = c.Id
JOIN Interprete interp ON i.IdInterprete = interp.Id
JOIN Tipo t ON interp.IdTipo = t.Id
JOIN CancionCompositor cc ON c.Id = cc.IdCancion
JOIN Compositor comp ON cc.IdCompositor = comp.Id
JOIN Ritmo r ON i.IdRitmo = r.Id
WHERE UPPER(r.Ritmo) = 'BALADA'
  AND UPPER(t.Tipo) = 'SOLISTA'
  AND CHARINDEX(UPPER(interp.Nombre), UPPER(comp.Nombre)) > 0;

-- d) ¿Listar los países que tienen grupos del ritmo “Salsa”?

SELECT DISTINCT p.Pais
FROM Interprete interp
JOIN Tipo t ON interp.IdTipo = t.Id
JOIN Interpretacion i ON i.IdInterprete = interp.Id
JOIN Ritmo r ON i.IdRitmo = r.Id
JOIN Pais p ON interp.IdPais = p.Id
WHERE UPPER(r.Ritmo) = 'SALSA'
  AND UPPER(t.Tipo) = 'GRUPO';

-- e) ¿Quiénes interpretan las canciones “Candilejas” y “Malaguena”?

SELECT 
  c.Titulo,
  interp.Nombre AS Interprete
FROM Cancion c
JOIN Interpretacion i ON i.IdCancion = c.Id
JOIN Interprete interp ON i.IdInterprete = interp.Id
WHERE UPPER(c.Titulo) IN ('CANDILEJAS', 'MALAGUENA')
ORDER BY c.Titulo, interp.Nombre;

-- f) Listar artistas que son intérpretes y compositores a la vez y con cuantas canciones compuestas e interpretadas 

SELECT
  interp.Nombre AS Artista,
  COUNT(DISTINCT cc.IdCancion) AS Canciones_Compuestas,
  COUNT(DISTINCT i.IdCancion) AS Canciones_Interpretadas
FROM Interprete interp
JOIN Compositor comp ON CHARINDEX(UPPER(interp.Nombre), UPPER(comp.Nombre)) > 0
LEFT JOIN CancionCompositor cc ON cc.IdCompositor = comp.Id
LEFT JOIN Interpretacion i ON i.IdInterprete = interp.Id
GROUP BY interp.Nombre
HAVING COUNT(DISTINCT cc.IdCancion) > 0 OR COUNT(DISTINCT i.IdCancion) > 0
ORDER BY Canciones_Compuestas DESC, Canciones_Interpretadas DESC;