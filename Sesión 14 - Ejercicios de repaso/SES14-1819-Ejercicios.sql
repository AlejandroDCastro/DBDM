
-- Ejercicio 1

CREATE OR REPLACE FUNCTION tienenportales (
    pnombre VARCHAR2
) RETURN NUMBER IS
    num_registros   NUMBER;
    pportal         portales.nombre%TYPE;
BEGIN
    SELECT
        nombre
    INTO pportal
    FROM
        portales
    WHERE
        pnombre = nombre;

    BEGIN
        SELECT
            COUNT(*)
        INTO num_registros
        FROM
            tienen
        WHERE
            nombre_portal = pportal;

        IF num_registros = 0 THEN
            num_registros := -1;
        END IF;
    END;

    RETURN num_registros;
EXCEPTION
    WHEN no_data_found THEN
        RETURN -99;
END;




-- Ejercicio 2

CREATE OR REPLACE PROCEDURE multiplicar_precios (
    pcod NUMBER
) IS
    num_accesos NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO num_accesos
    FROM
        control_acceso
    WHERE
        pcod = cod_recurso;

    IF num_accesos > 2 THEN
        UPDATE recurso_pago
        SET
            precio = precio * 2
        WHERE
            pcod = codigo;

    END IF;

END;




-- Ejercicio 3

CREATE OR REPLACE TRIGGER estabilizaprecios BEFORE
    INSERT OR UPDATE ON recurso_pago
    FOR EACH ROW
BEGIN
    IF :new.precio > 200 THEN
        raise_application_error(-20101, 'No es posible precios tan altos');
    ELSIF :new.precio < 10 THEN
        :new.precio := 10;
    END IF;
END;




-- Ejercicio 4

CREATE OR REPLACE PROCEDURE borrarrecursos (
    pformato VARCHAR2
) IS

    CURSOR c1 IS
    SELECT
        r.*
    FROM
        recurso_pago   rp,
        recurso        r
    WHERE
        rp.codigo = r.codigo
        AND r.nombre_formato = pformato;

BEGIN
    FOR rec IN c1 LOOP
        BEGIN
            DELETE FROM recurso_pago
            WHERE
                rec.codigo = codigo;

        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line('No se ha podido borrar el recurso ' || rec.descripcion);
        END;
    END LOOP;
END;




-- Ejercicio 5

CREATE OR REPLACE TRIGGER controlaimagenes BEFORE
    DELETE OR UPDATE ON imagenes
    FOR EACH ROW
DECLARE
    pimagen       ordimage;
    pimagen_new   ordimage;
BEGIN
    pimagen := :old.imagen;
    IF deleting THEN
        IF pimagen.getupdatetime() < TO_DATE('01/05/2019', 'dd/mm/yyyy') THEN
            raise_application_error(-20010, 'Antes de mayo no bro...');
        END IF;

    ELSIF updating THEN
        pimagen_new := :new.imagen;
        IF pimagen.getmimetype() = 'image/png' AND pimagen_new.getmimetype() = 'image/jpeg' THEN
            raise_application_error(-20012, 'JPEG no mola nada');
        END IF;

    END IF;

END;




-- Ejercicio 6

CREATE OR REPLACE FUNCTION totalbytesmime (
    pmime VARCHAR2
) RETURN NUMBER IS
    totalbytes NUMBER := 0;
    CURSOR c1 IS
    SELECT
        *
    FROM
        imagenes;

BEGIN
    FOR img IN c1 LOOP IF img.imagen.getmimetype() = pmime THEN
        totalbytes := totalbytes + img.imagen.getcontentlength();
    END IF;
    END LOOP;

    RETURN totalbytes / 1024; -- Ks = KiloBytes
END;

