
-- EJERCICIO 1

CREATE TABLE imagenes (
    nombre   VARCHAR2(30) NOT NULL,
    imagen   ORDIMAGE,
    CONSTRAINT pk_imagenes PRIMARY KEY ( nombre )
);

CREATE OR REPLACE PROCEDURE cargarimagenes IS
    foto ordimage;
    CURSOR c1 IS
    SELECT
        *
    FROM
        dbdm_ivan.imagenes_blob;

BEGIN
    FOR fila IN c1 LOOP
        foto := ordsys.ordimage(ordsys.ordsource(fila.imagen, NULL, NULL, NULL, NULL, NULL), NULL, NULL, NULL, NULL, NULL, NULL, NULL
        );

        foto.setproperties();
        INSERT INTO imagenes VALUES (
            fila.nombre,
            foto
        );

    END LOOP;

    COMMIT;
END;




-- EJERCICIO 2

CREATE OR REPLACE PROCEDURE verpropiedades (
    nom VARCHAR2
) IS
    x_image ordimage;
BEGIN
    SELECT
        i.imagen
    INTO x_image
    FROM
        imagenes i
    WHERE
        i.nombre = nom;

    dbms_output.put_line('------------------------------------------');
    dbms_output.put_line('Propiedades de ' || nom);
    dbms_output.put_line('------------------------------------------');
    dbms_output.put_line('width = ' || x_image.getwidth());
    dbms_output.put_line('height = ' || x_image.getheight());
    dbms_output.put_line('size = ' || x_image.getcontentlength());
    dbms_output.put_line('file type = ' || x_image.getfileformat());
    dbms_output.put_line('compression = ' || x_image.getcompressionformat());
    dbms_output.put_line('mime type = ' || x_image.getmimetype());
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('No existe la imagen');
END;




-- EJERCICIO 3

CREATE OR REPLACE PROCEDURE ampliarx2 (
    nom VARCHAR2
) IS
    x_image ordimage;
BEGIN
    BEGIN
        SELECT
            imagen
        INTO x_image
        FROM
            imagenes
        WHERE
            nombre = nom
        FOR UPDATE;

        x_image.process('scale="2"');
        x_image.setproperties();
        UPDATE imagenes
        SET
            imagen = x_image
        WHERE
            nombre = nom;

    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('No existe la imagen');
        WHEN ordsys.ordimageexceptions.data_not_local THEN
            dbms_output.put_line('La imagen no esta almacenada en la BD sino externamente');
    END;

    COMMIT;
END;




-- EJERCICIO 4

CREATE OR REPLACE PROCEDURE girar90 (
    pnombre VARCHAR2
) IS
    x_img ordimage;
BEGIN
    BEGIN
        SELECT
            imagen
        INTO x_img
        FROM
            imagenes
        WHERE
            pnombre = nombre
        FOR UPDATE;

        x_img.process('rotate="90"');
        x_img.setproperties();
        UPDATE imagenes
        SET
            imagen = x_img
        WHERE
            nombre = pnombre;

    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('No existe la imagen');
        WHEN ordsys.ordimageexceptions.data_not_local THEN
            dbms_output.put_line('La imagen no esta almacenada en la BD sino externamente');
    END;

    COMMIT;
END;




-- EJERCICIO 5

DROP TABLE imagenes_blob2;
CREATE TABLE imagenes_blob2 (
    nombre   VARCHAR2(30),
    imagen   BLOB,
    CONSTRAINT pk_imagenes_blob2 PRIMARY KEY ( nombre )
);

CREATE OR REPLACE PROCEDURE cargarimagenes_enblob IS
    x_imagen BLOB;
    CURSOR c1 IS
    SELECT
        *
    FROM
        imagenes;

BEGIN
    FOR foto IN c1 LOOP
        x_imagen := foto.imagen.source.localdata;
        INSERT INTO imagenes_blob2 VALUES (
            foto.nombre,
            x_imagen
        );

    END LOOP;

    COMMIT;
END;