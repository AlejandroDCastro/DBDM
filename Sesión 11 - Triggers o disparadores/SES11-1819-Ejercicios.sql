
-- EJERCICIO 1

CREATE TABLE aud_navegadores (
    nombre   VARCHAR(50),
    anyo     DATE NOT NULL,
    accion   VARCHAR(1),
    fecha    DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT chk_accion CHECK ( accion IN (
        'I',
        'B',
        'M'
    ) )
);


CREATE OR REPLACE TRIGGER mantener_auditoria AFTER
    DELETE OR INSERT OR UPDATE ON navegadores
    FOR EACH ROW
BEGIN
    IF inserting THEN
        INSERT INTO aud_navegadores (
            nombre,
            anyo,
            accion
        ) VALUES (
            :new.nombre,
            :new.anyo,
            'I'
        );

    ELSIF deleting THEN
        INSERT INTO aud_navegadores (
            nombre,
            anyo,
            accion
        ) VALUES (
            :old.nombre,
            :old.anyo,
            'B'
        );

    ELSIF updating THEN
        INSERT INTO aud_navegadores (
            nombre,
            anyo,
            accion
        ) VALUES (
            :old.nombre,
            :old.anyo,
            'M'
        );

    END IF;
END;




-- EJERCICIO 2

CREATE OR REPLACE TRIGGER borrado_cascada BEFORE
    DELETE ON navegadores
    FOR EACH ROW
BEGIN
    DELETE FROM suministran
    WHERE
        nombre = :old.nombre;

END;




-- EJERCICIO 3

CREATE OR REPLACE TRIGGER comprueba_formato BEFORE
    INSERT ON recurso
    FOR EACH ROW
DECLARE
    num_formatos NUMBER := 0;
BEGIN
    SELECT
        COUNT(*)
    INTO num_formatos
    FROM
        formato
    WHERE
        :new.nombre_formato = nombre;

    IF num_formatos = 0 THEN
        INSERT INTO formato VALUES (
            :new.nombre_formato,
            :new.nombre_formato,
            NULL
        );

    END IF;

END;




-- EJERCICIO 4

CREATE OR REPLACE TRIGGER inserta_gratuito AFTER
    INSERT ON recurso
    FOR EACH ROW
BEGIN
    IF :new.nombre_formato = 'JPG' THEN
        INSERT INTO recurso_gratuito VALUES (
            :new.codigo,
            NULL,
            NULL
        );

    END IF;
END;
