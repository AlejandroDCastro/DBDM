DROP TABLE tabla_temporal;
CREATE TABLE tabla_temporal
  (
    codigo         NUMERIC CONSTRAINT PK_tabla_temporal PRIMARY KEY,
    tipo           VARCHAR2(6),
    descripcion    VARCHAR2(100),
    falta          DATE,
    nombre_formato VARCHAR2(10),
    tamanyo        NUMBER(8,2),
    tiempo_des     NUMBER(8,2)
  );
INSERT
INTO tabla_temporal
  (
    codigo,
    tipo,
    descripcion,
    falta,
    nombre_formato,
    tamanyo,
    tiempo_des
  )
  VALUES
  (
    1,
    'PAGO',
    'Zapatillas',
    '01/01/2013',
    'MP3',
    500.01,
    15.25
  );
INSERT
INTO tabla_temporal
  (
    codigo,
    tipo,
    descripcion,
    falta,
    nombre_formato,
    tamanyo,
    tiempo_des
  )
  VALUES
  (
    2,
    'PAGO',
    'Vídeo musical canción zapatillas',
    '01/02/2013',
    'MP4',
    7700.01,
    55.25
  );
INSERT
INTO tabla_temporal
  (
    codigo,
    tipo,
    descripcion,
    falta,
    nombre_formato,
    tamanyo,
    tiempo_des
  )
  VALUES
  (
    3,
    'PAGO',
    'Titanic',
    '01/01/2013',
    'MPEG4',
    4400.01,
    345.25
  );
INSERT
INTO tabla_temporal
  (
    codigo,
    tipo,
    descripcion,
    falta,
    nombre_formato,
    tamanyo,
    tiempo_des
  )
  VALUES
  (
    4,
    'PAGO',
    'Foto moda con derechos autor',
    '01/02/2013',
    'JPG',
    400.01,
    9.25
  );
INSERT
INTO tabla_temporal
  (
    codigo,
    tipo,
    descripcion,
    falta,
    nombre_formato,
    tamanyo,
    tiempo_des
  )
  VALUES
  (
    5,
    'GRATIS',
    'Melodía telediario',
    '01/02/2013',
    'MP3',
    300.01,
    8.25
  );
INSERT
INTO tabla_temporal
  (
    codigo,
    tipo,
    descripcion,
    falta,
    nombre_formato,
    tamanyo,
    tiempo_des
  )
  VALUES
  (
    6,
    'GRATIS',
    'Anuncio Universidad Alicante',
    '01/01/2013',
    'MPEG4',
    201.02,
    6.25
  );
INSERT
INTO tabla_temporal
  (
    codigo,
    tipo,
    descripcion,
    falta,
    nombre_formato,
    tamanyo,
    tiempo_des
  )
  VALUES
  (
    7,
    'GRATIS',
    'Foto profesores UA',
    '15/02/2013',
    'JPG',
    200.01,
    5.25
  );
  
  
COMMIT;