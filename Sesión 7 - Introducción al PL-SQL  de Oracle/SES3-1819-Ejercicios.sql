-- EJERCICIO 1
SET SERVEROUTPUT ON

DECLARE
    numrecursos INT;
BEGIN

    -- calculamos primero el n�mero de recursos existentes
    SELECT
        COUNT(*)
    INTO numrecursos
    FROM
        recurso;
    
    -- comprobamos si hay m�s de 5

    IF numrecursos > 5 THEN
        dbms_output.put_line('hay m�s de 5 recursos');
    ELSE
        dbms_output.put_line('hay 5 � menos recursos');
    END IF;

END;



-- EJERCICIO 2

SET SERVEROUTPUT ON

DECLARE
    numgratis   INT;
    numpago     INT;
BEGIN

    -- obtenemos el n�mero de recursos gratuitos y de pago
    SELECT
        COUNT(*)
    INTO numgratis
    FROM
        recurso_gratuito;

    SELECT
        COUNT(*)
    INTO numpago
    FROM
        recurso_pago;
    
    -- hacemos comprobaci�n y lanzamos el error

    IF numgratis >= numpago THEN
        raise_application_error('-20001', 'El n�mero de recursos gratuitos es mayor que los de pago');
    END IF;
END;



-- EJERCICIO 3

-- No s� por qu� pero no funciona
DECLARE
    -- declaramos las variables a trabajar con ellas
    aux_desc   recurso.descripcion%TYPE;
    aux_cod    recurso.codigo%TYPE;
    
    -- obtenemos un cursor que recorre a los recursos con formato MP3
    CURSOR c1 IS
    SELECT
        codigo,
        descripcion
    FROM
        recurso
    WHERE
        nombre_formato = 'MP3'
    ORDER BY
        descripcion;

BEGIN

    -- creamos un bucle para buscar los dos primeros
    OPEN c1;
    FETCH c1 INTO
        aux_cod,
        aux_desc;
    WHILE c1%rowcount < 3 LOOP
        UPDATE recurso
        SET
            descripcion = upper(aux_desc)
        WHERE
            ( codigo = aux_cod );

        FETCH c1 INTO
            aux_cod,
            aux_desc;
    END LOOP;

    CLOSE c1;
END;


DECLARE
    contador INT := 0;
    CURSOR c1 IS
    SELECT
        codigo,
        descripcion,
        nombre_formato
    FROM
        recurso
    ORDER BY
        descripcion;

BEGIN
    FOR rec IN c1 LOOP
        IF rec.nombre_formato = 'MP3' AND contador <= 2 THEN
            UPDATE recurso
            SET
                descripcion = upper(rec.descripcion)
            WHERE
                ( rec.codigo = codigo );

            contador := contador + 1;
        END IF;
    END LOOP;
    COMMIT;
END;



-- EJERCICIO 4

DECLARE
    num_rec INT;
    rec_existente EXCEPTION;
BEGIN
    INSERT INTO recurso (
        codigo,
        descripcion,
        nombre_formato
    ) VALUES (
        1,
        'recurso x',
        'MP3'
    );

EXCEPTION
    WHEN dup_val_on_index THEN
        SELECT
            MAX(codigo)
        INTO num_rec
        FROM
            recurso;

        num_rec := num_rec + 1;
        INSERT INTO recurso (
            codigo,
            descripcion,
            nombre_formato
        ) VALUES (
            num_rec,
            'recurso x',
            'MP3'
        );

END;