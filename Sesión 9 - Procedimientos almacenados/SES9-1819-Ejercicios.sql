
-- EJERCICIO 1

CREATE OR REPLACE PROCEDURE insertarecurso (
    cod       NUMBER,
    des       VARCHAR2,
    formato   VARCHAR2,
    tipo      VARCHAR2,
    prec      NUMBER
) IS
BEGIN
    INSERT INTO recurso (
        codigo,
        descripcion,
        nombre_formato
    ) VALUES (
        cod,
        des,
        formato
    );

    IF tipo = 'GRATUITO' THEN
        INSERT INTO recurso_gratuito VALUES ( cod );

    ELSE
        INSERT INTO recurso_pago VALUES (
            cod,
            prec
        );

    END IF;

EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(-20001, 'Recurso existente');
END;




-- EJERCICIO 2

CREATE OR REPLACE PROCEDURE incrementaprecio (
    precurso       IN             NUMBER,
    pporcen        IN             NUMBER,
    ppreciofinal   OUT            NUMBER
) IS
    xprecio NUMBER(9, 2);
BEGIN
    BEGIN
        SELECT
            precio
        INTO xprecio
        FROM
            recurso_pago
        WHERE
            codigo = precurso;

    EXCEPTION
        WHEN no_data_found THEN
            raise_application_error(-20001, 'No existe el recurso');
    END;

    ppreciofinal := xprecio + ( xprecio * pporcen / 100 );
    UPDATE recurso_pago
    SET
        precio = ppreciofinal
    WHERE
        codigo = precurso;

END;

CREATE OR REPLACE PROCEDURE actualizaprecios (
    formato VARCHAR2,
    porcen NUMBER
) IS

    nuevo_precio NUMBER;
    CURSOR c1 IS
    SELECT
        rp.codigo,
        rp.precio,
        r.nombre_formato
    FROM
        recurso_pago   rp,
        recurso        r
    WHERE
        rp.codigo = r.codigo;

BEGIN
    FOR rec IN c1 LOOP
        IF formato = rec.nombre_formato AND rec.precio > 15 THEN
            incrementaprecio(rec.codigo, porcen, nuevo_precio);
            IF nuevo_precio > 100 THEN
                UPDATE recurso_pago
                SET
                    precio = 100
                WHERE
                    codigo = rec.codigo;

            END IF;

        END IF;
    END LOOP;
END;




-- EJERCICIO 3

SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE insacc (
    cod NUMBER,
    mes VARCHAR2
) IS
    CURSOR c1 IS
    SELECT
        *
    FROM
        usuarios;

    num_cod   NUMBER;
    num_mes   NUMBER;
BEGIN
    FOR usu IN c1 LOOP
        BEGIN
            INSERT INTO control_acceso VALUES (
                cod,
                usu.identificador,
                mes
            );

        EXCEPTION
            WHEN dup_val_on_index THEN
                dbms_output.put_line('obviando la inserción para el usuario ' || usu.identificador);
        END;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20101, 'Error en la inserción');
END;