
-- EJERCICIO 1

CREATE OR REPLACE FUNCTION encuentrarecurso (
    pformato VARCHAR2
) RETURN VARCHAR2 IS
    devuelve recurso.descripcion%TYPE;
BEGIN
    SELECT
        descripcion
    INTO devuelve
    FROM
        recurso
    WHERE
        nombre_formato = pformato;

    RETURN devuelve;
EXCEPTION
    WHEN no_data_found THEN
        RETURN 'No hay ningún recurso con ese formato';
    WHEN too_many_rows THEN
        RETURN 'Hay más de un recurso con ese formato';
END;




-- EJERCICIO 2

CREATE OR REPLACE FUNCTION numversiones (
    pnavegador VARCHAR2
) RETURN NUMBER IS
    num_versiones NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO num_versiones
    FROM
        versiones
    WHERE
        pnavegador = nombre;

    IF num_versiones = 0 THEN
        RETURN -1;
    ELSE
        RETURN num_versiones;
    END IF;
END;




-- EJERCICIO 3

CREATE OR REPLACE FUNCTION numerorecursos (
    pformato VARCHAR2
) RETURN NUMBER IS
    num_recursos NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO num_recursos
    FROM
        recurso
    WHERE
        nombre_formato = pformato;

    RETURN num_recursos;
END;

CREATE OR REPLACE VIEW v_formatos AS
    SELECT
        nombre,
        numerorecursos(nombre) n_recursos
    FROM
        formato;




-- EJERCICIO 4

CREATE OR REPLACE FUNCTION nmismoformato (
    pcodigo NUMBER
) RETURN NUMBER IS
    num_recursos   NUMBER;
    formato        recurso.nombre_formato%TYPE;
BEGIN
    SELECT
        nombre_formato
    INTO formato
    FROM
        recurso
    WHERE
        pcodigo = codigo;

    SELECT
        COUNT(*)
    INTO num_recursos
    FROM
        recurso
    WHERE
        nombre_formato = formato
        AND pcodigo != codigo;

    RETURN num_recursos;
END;




-- EJERCICIO 5

CREATE OR REPLACE FUNCTION dame_tamanyo_minmax (
    tipo NUMBER
) RETURN NUMBER IS
    tam_nav NUMBER := -1;
BEGIN
    IF tipo = 1 THEN
        SELECT
            MIN(tamanyo)
        INTO tam_nav
        FROM
            disponible_para;

    ELSIF tipo = 2 THEN
        SELECT
            MAX(tamanyo)
        INTO tam_nav
        FROM
            disponible_para;

    END IF;

    RETURN tam_nav;
END;