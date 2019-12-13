
-- EJERCICIO 1

CREATE OR REPLACE FUNCTION numvisitas (
    pnombre VARCHAR2
) RETURN NUMBER IS

    xtotal     NUMBER := 0;
    xvisitas   NUMBER;
    xportal    portales.nombre%TYPE;
    CURSOR c1 IS
    SELECT
        *
    FROM
        paginas
    WHERE
        pnombre = nombre_portal;

BEGIN
    SELECT
        nombre
    INTO xportal
    FROM
        portales
    WHERE
        pnombre = nombre;

    BEGIN
        FOR pag IN c1 LOOP
            SELECT
                SUM(num_visitas)
            INTO xvisitas
            FROM
                visitas
            WHERE
                id_pagina = pag.id_pagina
            GROUP BY
                id_pagina;

            xtotal := xtotal + xvisitas;
        END LOOP;

        RETURN xtotal;
    END;

EXCEPTION
    WHEN no_data_found THEN
        RETURN -1;
END;




-- EJERCICIO 2

CREATE OR REPLACE PROCEDURE modificacodificacion (
    pactual VARCHAR2,
    pnuevo VARCHAR2
) IS
BEGIN
    IF pactual IS NULL OR pnuevo IS NULL THEN
        raise_application_error(-20001, 'Codificación NO VALIDA');
    END IF;

    UPDATE paginas
    SET
        codificacion = pnuevo
    WHERE
        codificacion = pactual;

END;




-- EJERCICIO 3

CREATE OR REPLACE TRIGGER controlavisitas BEFORE
    INSERT OR UPDATE OR DELETE ON visitas
    FOR EACH ROW
BEGIN
    IF inserting OR updating THEN
        IF :new.num_visitas <= 0 THEN
            raise_application_error(-20001, 'operacion no válida');
        END IF;
    END IF;

    IF deleting THEN
        IF TO_CHAR(:old.fecha_visita, 'dd/mm/yyyy') = TO_CHAR(SYSDATE, 'dd/mm/yyyy') THEN
            raise_application_error(-20001, 'operacion no válida');
        END IF;

    END IF;

END;
        



-- EJERCICIO 4

CREATE OR REPLACE PROCEDURE estadisticavisitas (
    pportal VARCHAR2
) IS
    xid_pagina NUMBER;
    CURSOR c1 IS
    SELECT
        *
    FROM
        paginas
    WHERE
        pportal = nombre_portal;

BEGIN
    FOR pag IN c1 LOOP
        xid_pagina := pag.id_pagina;
        DECLARE
            CURSOR c2 IS
            SELECT
                *
            FROM
                visitas
            WHERE
                xid_pagina = id_pagina;

        BEGIN
            FOR vis IN c2 LOOP
                IF vis.num_visitas < 5 THEN
                    dbms_output.put_line('El portal '
                                         || pportal
                                         || ' ha tenido un número bajo de visitas el día '
                                         || TO_CHAR(vis.fecha_visita, 'dd/mm/yyyy'));

                ELSE
                    dbms_output.put_line('El portal '
                                         || pportal
                                         || ' ha tenido un número alto de visitas el día '
                                         || TO_CHAR(vis.fecha_visita, 'dd/mm/yyyy'));
                END IF;
            END LOOP;

        END;

    END LOOP;
END;




-- EJERCICIO 5

CREATE OR REPLACE PROCEDURE cambiarformato (
    pnum NUMBER
) IS
    ximagen ordimage;
    CURSOR c1 IS
    SELECT
        *
    FROM
        imagenes;

BEGIN
    FOR img IN c1 LOOP
        SELECT
            img.imagen
        INTO ximagen
        FROM
            imagenes
        WHERE
            img.nombre = nombre
        FOR UPDATE;

        IF ximagen.getfileformat() != 'PNGF' AND ximagen.getcontentlength() > pnum THEN
            ximagen.process('fileFormat=PNGF');
            dbms_output.put_line('Cambiada la imagen '
                                 || img.nombre
                                 || ' a PNG');
            UPDATE imagenes
            SET
                imagen = ximagen
            WHERE
                img.nombre = nombre;

        END IF;

    END LOOP;
END;




-- EJERCICIO 6

CREATE OR REPLACE FUNCTION dimemimetype (
    pnombre VARCHAR2
) RETURN VARCHAR2 IS
    ximagen ordimage;
BEGIN
    SELECT
        imagen
    INTO ximagen
    FROM
        imagenes
    WHERE
        pnombre = nombre;

    RETURN ximagen.getmimetype();
EXCEPTION
    WHEN no_data_found THEN
        RETURN 'XX';
END;


CREATE OR REPLACE VIEW v_mimetypes AS
    SELECT
        dimemimetype(nombre) mime,
        COUNT(*) cantidad
    FROM
        imagenes
    GROUP BY
        dimemimetype(nombre);

SELECT
    *
FROM
    v_mimetypes;