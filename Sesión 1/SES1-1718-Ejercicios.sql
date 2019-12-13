-- 1. Lista los email y nombre y apellidos de los usuarios ordenados por apellidos y nombre.
SELECT
    email,
    nombre,
    apellidos
FROM
    usuario
ORDER BY
    3,
    2;

-- 2. Toda la información (código y nombre) de las provincias de las que se tienen usuarios.

SELECT
    p.*
FROM
    provincia p,
    usuario u
WHERE
    p.codp = u.provincia;

-- 3. Toda la información (código y nombre) de las provincias de las que se tienen usuarios,eliminando duplicados y ordenando por nombre.

SELECT DISTINCT
    p.*
FROM
    provincia p,
    usuario u
WHERE
    p.codp = u.provincia
ORDER BY 2;

-- 4. Artículos que no tienen marca.

SELECT
    *
FROM
    articulo
WHERE
    marca IS NULL;

-- 5. Email de los usuarios de la provincia de Murcia que no tienen teléfono,acompañado en la salida por un mensaje que diga "No tiene teléfono".

SELECT
    u.email,
    'No tiene teléfono'
FROM
    usuario u,
    provincia p
WHERE
        u.provincia = codp
    AND
        p.nombre = 'Murcia'
    AND
        telefono IS NULL;

-- 6. Fecha y usuario del pedido,código,nombre,marca,pvp y precio de venta de los artículos solicitados en el pedido número 1 que
-- sean televisores.

SELECT
    fecha,
    usuario,
    cod,
    nombre,
    marca,
    pvp,
    precio
FROM
    pedido p,
    linped l,
    articulo a,
    tv
WHERE
        p.numpedido = l.numpedido
    AND
        a.cod = l.articulo
    AND
        tv.cod = a.cod
    AND
        p.numpedido = 1;

-- 7. Email de los usuarios cuyo código postal no sea 02012,02018 o 02032.

SELECT
    email
FROM
    usuario
WHERE
    codpos NOT IN (
        '02012','02018','02032'
    );

-- 8. Número de pedido,fecha y nombre y apellidos del usuario que solicita el pedido,para aquellos pedidos solicitados por algún
-- usuario de apellido MARTINEZ.

SELECT
    numpedido,
    fecha,
    nombre,
    apellidos
FROM
    usuario u,
    pedido p
WHERE
        u.email = p.usuario
    AND
        apellidos LIKE '%MARTINEZ%';

-- 9. Código,nombre y marca del artículo más caro.

SELECT
    cod,
    nombre,
    marca,
    pvp
FROM
    articulo
WHERE
    pvp = (
        SELECT
            MAX(pvp)
        FROM
            articulo
    );

-- 10. Código,nombre y pvp de la cámara más cara de entre las de tipo réflex.

SELECT
    cod,
    nombre,
    pvp
FROM
    articulo a,
    camara c
WHERE
        a.cod = c.cod
    AND
        tipo LIKE '%reflex%'
    AND
        pvp = (
            SELECT
                MAX(pvp)
            FROM
                articulo a,
                camara c
            WHERE
                    a.cod = c.cod
                AND
                    tipo LIKE '%reflex%'
        );

-- 11. Marcas de las que no existe ningún televisor en nuestra base de datos.

SELECT DISTINCT
    marca
FROM
    articulo
WHERE
    cod NOT IN (
        SELECT
            cod
        FROM
            tv
    );
 -- solución

SELECT
    marca
FROM
    marca
WHERE
    marca NOT IN (
        SELECT
            marca
        FROM
            articulo a,
            tv t
        WHERE
            a.cod = t.cod
    );

-- 12. Código,nombre,tipo y marca de las cámaras de marca Nikon,LG o Sigma.

SELECT
    a.cod,
    nombre,
    tipo,
    marca
FROM
    articulo a,
    camara c
WHERE
        a.cod = c.cod
    AND
        marca IN (
            'Nikon','LG','Sigma'
        );

-- 13. Código y nombre de los artículos,si además es una cámara,mostrar también la resolución y el sensor.

SELECT
    a.cod,
    nombre,
    resolucion,
    sensor
FROM
    articulo a
    LEFT JOIN camara c ON (
        c.cod = a.cod
    );

-- 14. Muestra las cestas del año 2010 junto con el nombre del artículo al que referencia y su precio de venta al público.

SELECT
    c.*,
    nombre,
    pvp
FROM
    cesta c,
    articulo a
WHERE
        c.articulo = a.cod
    AND
        TO_CHAR(
            fecha,
            'yyyy'
        ) = '2010';

-- 15. Muestra toda la información de los artículos. Si alguno aparece en una cesta del año 2010 muestra esta información.

SELECT
    a.*,
    c.*
FROM
    articulo a
    LEFT JOIN cesta c ON (
            c.articulo = a.cod
        AND
            TO_CHAR(
                fecha,
                'yyyy'
            ) = '2010'
    );

-- 16. Cantidad de usuarios de nuestra BD.

SELECT
    COUNT(*) usuarios
FROM
    usuario;

-- 17. Obtener la cantidad de provincias distintas de las que tenemos conocimiento de algún usuario.

SELECT
    COUNT(DISTINCT provincia) provincias
FROM
    usuario;

-- 18. Tamaño máximo de pantalla para las televisiones.

SELECT
    MAX(pantalla)
FROM
    tv;

-- 19. Fecha de nacimiento del usuario más viejo.

SELECT
    MIN(nacido) fecha
FROM
    usuario;

-- 20. Obtener el precio total por línea para el pedido 1,en la salida aparecerá los campos numlinea,articulo y el campo calculado total.

SELECT
    linea,
    articulo,
    ( cantidad * precio ) preciototalporlinea
FROM
    linped
WHERE
    numpedido = 1;

-- 21. Número de pedido,fecha y nombre y apellidos del usuario de las líneas de pedido cuyo total en euros es el más alto.

SELECT
    p.numpedido,
    p.fecha,
    u.nombre,
    u.apellidos
FROM
    pedido p,
    linped l,
    usuario u
WHERE
        p.numpedido = l.numpedido
    AND
        p.usuario = u.email
    AND
        ( cantidad * precio ) = (
            SELECT
                MAX(cantidad * precio)
            FROM
                linped
        );

-- 22. ¿Cuántos artículos de cada marca hay?

SELECT
    marca,
    COUNT(*)
FROM
    articulo
GROUP BY
    1;

-- 23. Dni,nombre,apellidos y email de los usuarios que han realizado más de un pedido.

SELECT
    dni,
    nombre,
    apellidos,
    email
FROM
    usuario u,
    pedido p
WHERE
    u.email = p.usuario
GROUP BY
    1,
    2,
    3,
    4
HAVING
    COUNT(*) > 1;

-- 24. Pedidos (número de pedido y usuario) que contengan más de cuatro artículos distintos.

SELECT
    numpedido,
    usuario,
    COUNT(DISTINCT articulo)
FROM
    pedido p,
    linped l
WHERE
    l.numpedido = p.numpedido
GROUP BY
    1,
    2
HAVING
    COUNT(DISTINCT articulo) > 4;

-- 25. Código y nombre de las provincias que tienen más de 50 usuarios (provincia del usuario,no de la dirección de envío).

SELECT
    codp,
    p.nombre
FROM
    provincia p,
    usuario u
WHERE
    p.codp = u.provincia
GROUP BY
    1,
    2
HAVING
    COUNT(email) > 50;

-- 26. Cantidad de artículos que no son ni memoria,ni tv,ni objetivo,ni cámara ni pack.

SELECT
    COUNT(*) articulos
FROM
    articulo
WHERE
        cod NOT IN (
            SELECT
                cod
            FROM
                memoria
        )
    AND
        cod NOT IN (
            SELECT
                cod
            FROM
                tv
        )
    AND
        cod NOT IN (
            SELECT
                cod
            FROM
                objetivo
        )
    AND
        cod NOT IN (
            SELECT
                cod
            FROM
                camara
        )
    AND
        cod NOT IN (
            SELECT
                cod
            FROM
                pack
        );

-- 27. ¿En cuántos pedidos se ha solicitado cada artículo? Si hubiese artículos que no se han incluido en pedido alguno
-- también se mostrarán. Mostrar el código y nombre del artículo junto con las veces que ha sido incluido en un pedido
-- (solo si ha sido incluido,no se trata de la "cantidad").

SELECT
    cod,
    nombre,
    COUNT(DISTINCT numpedido)
FROM
    articulo a
    LEFT JOIN linped l ON (
        l.articulo = a.cod
    )
GROUP BY
    1,
    2;

-- 28. Pedidos (número de pedido y usuario) de importe mayor a 4000 euros.

SELECT
    p.numpedido,
    p.usuario
FROM
    pedido p
    JOIN linped l ON (
        l.numpedido = p.numpedido
    )
GROUP BY
    1,
    2
HAVING
    SUM(cantidad * precio) > 4000;

-- 29. Código y precio de los artículos 'Samsung' que tengan pvp y que no tengan pedidos.

SELECT DISTINCT
    cod,
    pvp
FROM
    articulo
WHERE
        marca = 'Samsung'
    AND
        pvp IS NOT NULL
    AND
        cod NOT IN (
            SELECT
                articulo
            FROM
                linped
        );

-- 30. Códigos de artículos que están en alguna cesta o en alguna línea de pedido.

SELECT
    cod
FROM
    articulo
WHERE
        cod IN (
            SELECT
                articulo
            FROM
                cesta
        )
    OR
        cod IN (
            SELECT
                articulo
            FROM
                linped
        );
 -- solucion alternativa

SELECT
    articulo
FROM
    cesta
UNION
SELECT
    articulo
FROM
    linped;
 
 -- 31. Email y nombre de los usuarios que no han hecho ningún pedido o que han hecho sólo uno.

SELECT
    email,
    nombre
FROM
    usuario
WHERE
    email NOT IN (
        SELECT
            usuario
        FROM
            pedido
    )
UNION
SELECT
    email,
    nombre
FROM
    usuario,
    pedido
WHERE
    email = usuario
GROUP BY
    1,
    2
HAVING
    COUNT(*) = 1;
 
 -- 32. Email y nombre de los usuarios que no han pedido ninguna cámara.

SELECT
    email,
    nombre
FROM
    usuario u,
    pedido p
WHERE
        u.email = p.usuario
    AND
        numpedido NOT IN (
            SELECT
                numpedido
            FROM
                linped l,
                camara c
            WHERE
                l.articulo = c.cod
        );
 -- solucion

SELECT
    email,
    nombre
FROM
    usuario u
WHERE
    email NOT IN (
        SELECT
            usuario
        FROM
            linped l,
            pedido p,
            camara c
        WHERE
                l.numpedido = p.numpedido
            AND
                l.articulo = c.cod
    );
    
-- 33. Fecha actual.

SELECT
    SYSDATE
FROM
    dual;