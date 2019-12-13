-- EJERCICIO 1
SET SERVEROUTPUT ON

DECLARE
    num_cod        INT := 0;
    num_cod_pago   INT := 0;
    activo EXCEPTION;
BEGIN
    
    -- comprobamos si existe el recurso con código 8
    SELECT
        COUNT(*)
    INTO num_cod
    FROM
        recurso
    WHERE
        codigo = 8;

    SELECT
        COUNT(*)
    INTO num_cod_pago
    FROM
        recurso_pago
    WHERE
        codigo = 8;
    
    -- escribimos los condicionales

    IF num_cod = 0 THEN
        raise_application_error(-20200, 'No existe el recurso 8');
    ELSIF num_cod_pago = 1 THEN
        RAISE activo;
    ELSIF num_cod = 1 AND num_cod_pago = 0 THEN
        INSERT INTO recurso_gratuito (
            codigo,
            path
        ) VALUES (
            8,
            '\\SERVER1\CARPETA'
        );

        dbms_output.put_line('Recurso 8 incluido satisfactoriamente');
    END IF;

EXCEPTION
    WHEN activo THEN
        dbms_output.put_line('El recurso 8 ya existe como de pago');
END;



-- EJERCICIO 2

SET SERVEROUTPUT ON

DECLARE
    num_codec INT := 0;
    CURSOR c1 IS
    SELECT
        *
    FROM
        visor
    WHERE
        empresa = 'Microsoft';

BEGIN

    -- para cada visor
    FOR visor IN c1 LOOP
        
        -- comprobamos si tiene un codec en la tabla se_visualiza_con
        SELECT
            COUNT(*)
        INTO num_codec
        FROM
            se_visualiza_con
        WHERE
            nombre_visor = visor.nombre;

        IF num_codec = 0 THEN
            dbms_output.put_line('El visor '
                                 || visor.nombre
                                 || ' no se muestra por ningún códec');
        ELSE
            dbms_output.put_line('El visor '
                                 || visor.nombre
                                 || ' se muestra por algún códec');
        END IF;

    END LOOP;
END;



-- EJERCICIO 3

SET SERVEROUTPUT ON

DECLARE
    CURSOR c1 IS
    SELECT
        *
    FROM
        tienen;

    usuario tienen.identificador%TYPE;
    navegador_nuevo EXCEPTION;
BEGIN
    FOR nave IN c1 LOOP
        IF nave.nombre != 'Chrome' THEN
            usuario := nave.identificador;
            RAISE navegador_nuevo;
        END IF;
    END LOOP;

    COMMIT;
EXCEPTION
    WHEN navegador_nuevo THEN
        INSERT INTO tienen VALUES (
            1,
            'Chrome',
            usuario,
            'Terra'
        );

        dbms_output.put_line('Se ha actualizado un usuario');
END;