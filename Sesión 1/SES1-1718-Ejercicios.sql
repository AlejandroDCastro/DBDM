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

-- 2. Toda la informaci�n (c�digo y nombre) de las provincias de las que se tienen usuarios.

SELECT
    p.*
FROM
    provincia p,
    usuario u
WHERE
    p.codp = u.provincia;

-- 3. Toda la informaci�n (c�digo y nombre) de las provincias de las que se tienen usuarios,eliminando duplicados y ordenando por nombre.

SELECT DISTINCT
    p.*
FROM
    provincia p,
    usuario u
WHERE
    p.codp = u.provincia
ORDER BY 2;

-- 4. Art�culos que no tienen marca.

SELECT
    *
FROM
    articulo
WHERE
    marca IS NULL;

-- 5. Email de los usuarios de la provincia de Murcia que no tienen tel�fono,acompa�ado en la salida por un mensaje que diga "No tiene tel�fono".

SELECT
    u.email,
    'No tiene tel�fono'
FROM
    usuario u,
    provincia p
WHERE
        u.provincia = codp
    AND
        p.nombre = 'Murcia'
    AND
        telefono IS NULL;

-- 6. Fecha y usuario del pedido,c�digo,nombre,marca,pvp y precio de venta de los art�culos solicitados en el pedido n�mero 1 que
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

-- 7. Email de los usuarios cuyo c�digo postal no sea 02012,02018 o 02032.

SELECT
    email
FROM
    usuario
WHERE
    codpos NOT IN (
        '02012','02018','02032'
    );

-- 8. N�mero de pedido,fecha y nombre y apellidos del usuario que solicita el pedido,para aquellos pedidos solicitados por alg�n
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

-- 9. C�digo,nombre y marca del art�culo m�s caro.

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

-- 10. C�digo,nombre y pvp de la c�mara m�s cara de entre las de tipo r�flex.

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

-- 11. Marcas de las que no existe ning�n televisor en nuestra base de datos.

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
 -- soluci�n

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

-- 12. C�digo,nombre,tipo y marca de las c�maras de marca Nikon,LG o Sigma.

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

-- 13. C�digo y nombre de los art�culos,si adem�s es una c�mara,mostrar tambi�n la resoluci�n y el sensor.

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

-- 14. Muestra las cestas del a�o 2010 junto con el nombre del art�culo al que referencia y su precio de venta al p�blico.

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

-- 15. Muestra toda la informaci�n de los art�culos. Si alguno aparece en una cesta del a�o 2010 muestra esta informaci�n.

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

-- 17. Obtener la cantidad de provincias distintas de las que tenemos conocimiento de alg�n usuario.

SELECT
    COUNT(DISTINCT provincia) provincias
FROM
    usuario;

-- 18. Tama�o m�ximo de pantalla para las televisiones.

SELECT
    MAX(pantalla)
FROM
    tv;

-- 19. Fecha de nacimiento del usuario m�s viejo.

SELECT
    MIN(nacido) fecha
FROM
    usuario;

-- 20. Obtener el precio total por l�nea para el pedido 1,en la salida aparecer� los campos numlinea,articulo y el campo calculado total.

SELECT
    linea,
    articulo,
    ( cantidad * precio ) preciototalporlinea
FROM
    linped
WHERE
    numpedido = 1;

-- 21. N�mero de pedido,fecha y nombre y apellidos del usuario de las l�neas de pedido cuyo total en euros es el m�s alto.

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

-- 22. �Cu�ntos art�culos de cada marca hay?

SELECT
    marca,
    COUNT(*)
FROM
    articulo
GROUP BY
    1;

-- 23. Dni,nombre,apellidos y email de los usuarios que han realizado m�s de un pedido.

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

-- 24. Pedidos (n�mero de pedido y usuario) que contengan m�s de cuatro art�culos distintos.

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

-- 25. C�digo y nombre de las provincias que tienen m�s de 50 usuarios (provincia del usuario,no de la direcci�n de env�o).

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

-- 26. Cantidad de art�culos que no son ni memoria,ni tv,ni objetivo,ni c�mara ni pack.

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

-- 27. �En cu�ntos pedidos se ha solicitado cada art�culo? Si hubiese art�culos que no se han incluido en pedido alguno
-- tambi�n se mostrar�n. Mostrar el c�digo y nombre del art�culo junto con las veces que ha sido incluido en un pedido
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

-- 28. Pedidos (n�mero de pedido y usuario) de importe mayor a 4000 euros.

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

-- 29. C�digo y precio de los art�culos 'Samsung' que tengan pvp y que no tengan pedidos.

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

-- 30. C�digos de art�culos que est�n en alguna cesta o en alguna l�nea de pedido.

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
 
 -- 31. Email y nombre de los usuarios que no han hecho ning�n pedido o que han hecho s�lo uno.

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
 
 -- 32. Email y nombre de los usuarios que no han pedido ninguna c�mara.

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