-- DROP TABLE SE_VISUALIZA_CON;
-- DROP TABLE VISOR;
-- DROP TABLE RECURSO_GRATUITO; 
-- DROP TABLE RECURSO_PAGO; 
-- DROP TABLE RECURSO;   
-- DROP TABLE FORMATO;
-- DROP TABLE CLAVES;


-- Ejericio 1 
CREATE TABLE CLAVES (clave VARCHAR2(256), 
            CONSTRAINT PK_clave PRIMARY KEY(clave) );
            
CREATE TABLE VISOR (nombre VARCHAR2(100), 
                    empresa VARCHAR2(100), 
                    clave varchar2(256) NOT NULL,
                    CONSTRAINT PK_VISOR PRIMARY KEY (nombre),
                    CONSTRAINT UK_CLAVE UNIQUE  (CLAVE),
                    CONSTRAINT FK_VISOR_CLAVE FOREIGN KEY (CLAVE) REFERENCES CLAVES(CLAVE) );
 
CREATE TABLE FORMATO (nombre VARCHAR2(10) , 
                      descrip VARCHAR2(100) NOT NULL, 
                      anyo INTEGER,
                      CONSTRAINT PK_FORMATO PRIMARY KEY(nombre));

CREATE TABLE SE_VISUALIZA_CON (nombre_visor VARCHAR2(100),  
                               nombre_formato VARCHAR2(10),
                               codec VARCHAR2(100) NOT NULL , 
                               CONSTRAINT PK_SE_VISUALIZA_CON PRIMARY KEY (nombre_visor, nombre_formato),
                               CONSTRAINT FK_SVCON_VISOR FOREIGN KEY (nombre_visor) REFERENCES VISOR(nombre),
                               CONSTRAINT FK_SVCON_FORMATO FOREIGN KEY (nombre_formato) REFERENCES FORMATO(nombre));

CREATE TABLE RECURSO (codigo VARCHAR2(50), 
                      descripcion VARCHAR2(100), 
                      falta date DEFAULT SYSDATE, 
                      tamanyo number(8,2), 
                      tiempo_des number(8,2),   
                      nombre_formato VARCHAR2(10) NOT NULL,
                      CONSTRAINT PK_RECURSO PRIMARY KEY (codigo),
                      CONSTRAINT FK_RECURSO_FORMATO FOREIGN KEY (nombre_formato)  REFERENCES FORMATO(nombre) );


CREATE TABLE  RECURSO_GRATUITO (CODIGO  VARCHAR2(50), 
                    CONSTRAINT PK_RECURSO_GRATUITO  PRIMARY KEY (CODIGO),                  
                    CONSTRAINT FK_RECURSO_GRA_RECURSO FOREIGN KEY (CODIGO) REFERENCES RECURSO(CODIGO) );

CREATE TABLE  RECURSO_PAGO (CODIGO  VARCHAR2(50), 
                             PRECIO NUMBER (10,2)  NOT NULL , 
                     CONSTRAINT PK_RECURSO_PAGO  PRIMARY KEY   (CODIGO)  ,            
                     CONSTRAINT FK_RECURSO_PAG_RECURSO FOREIGN KEY (CODIGO) REFERENCES RECURSO(CODIGO) );



--- Ejericicio 2
 
-- Tabla Claves

INSERT INTO CLAVES(Clave) VALUES ('ABCD');
INSERT INTO CLAVES(Clave) VALUES ('EFGH');
INSERT INTO CLAVES(Clave) VALUES ('IJKL');
INSERT INTO CLAVES(Clave) VALUES ('MNOP');
INSERT INTO CLAVES(Clave) VALUES ('QRST');

-- Tabla VISOR

INSERT INTO VISOR(nombre, empresa, clave) VALUES ('Internet Explorer','Microsoft', 'ABCD');
INSERT INTO VISOR(nombre, empresa, clave) VALUES ('Chrome','Google','EFGH');
INSERT INTO VISOR(nombre, empresa, clave) VALUES ('Corel Photoshop','Corel','IJKL');
INSERT INTO VISOR(nombre, empresa, clave) VALUES ('Windows Media Player','Microsoft','MNOP');

-- Tabla Formato

INSERT INTO FORMATO (nombre, descrip, anyo) VALUES ('JPG','Fotografías',1992);
INSERT INTO FORMATO (nombre, descrip, anyo) VALUES ('MP3','Audio digital',1995);
INSERT INTO FORMATO (nombre, descrip, anyo) VALUES ('MPEG4','Video digital',1998);
INSERT INTO FORMATO (nombre, descrip, anyo) VALUES ('MP4','Audio o video digital',1998);

-- Tabla SE_VISUALIZA_CON

INSERT INTO SE_VISUALIZA_CON (nombre_visor, nombre_formato, codec) VALUES ('Internet Explorer','JPG','IE_JPG.DLL');
INSERT INTO SE_VISUALIZA_CON (nombre_visor, nombre_formato, codec) VALUES ('Chrome','MP3','CH_MP3 .DLL');
INSERT INTO SE_VISUALIZA_CON (nombre_visor, nombre_formato, codec) VALUES ('Corel Photoshop','MPEG4','ADOBE_COD.DLL');
INSERT INTO SE_VISUALIZA_CON (nombre_visor, nombre_formato, codec) VALUES ('Windows Media Player','MP4','WIN_CODECS.DLL');

-- Tabla RECURSO

INSERT INTO RECURSO (codigo,descripcion,nombre_formato,falta,tamanyo,tiempo_des) VALUES ('Video1', 'Corporativo', 'MPEG4',to_date('01/01/2013','dd/mm/yyyy'),2000,10);
INSERT INTO RECURSO (codigo,descripcion,nombre_formato,falta,tamanyo,tiempo_des) VALUES ('Video2', 'Sede', 'MPEG4',to_date('01/04/2016','dd/mm/yyyy'),20000,100);
INSERT INTO RECURSO (codigo,descripcion,nombre_formato,falta,tamanyo,tiempo_des) VALUES ('Musica1', 'Centralita', 'MP3',to_date('01/01/2016','dd/mm/yyyy'),200,5);
INSERT INTO RECURSO (codigo,descripcion,nombre_formato,falta,tamanyo,tiempo_des) VALUES ('FOTO1', 'Paisaje bonito','JPG', to_date('01/10/2015','dd/mm/yyyy'),150,3);


commit;

-- ejercicio 3


INSERT INTO recurso
  (codigo,descripcion,falta,nombre_formato)
SELECT codigo,descripcion,falta,nombre_formato FROM tabla_temporal;
COMMIT;

 
INSERT INTO recurso_gratuito
  (codigo
  )
SELECT codigo FROM tabla_temporal WHERE tipo='GRATIS';
COMMIT;

INSERT INTO recurso_pago
  (codigo,precio
  )
SELECT codigo,10 FROM tabla_temporal WHERE tipo='PAGO';
COMMIT;



-- ejercicio 4


CREATE OR REPLACE VIEW recursos_de_pago as select r.*,p.precio from recurso r, recurso_pago p where r.codigo=p.codigo and p.precio > 5;

-- Ejercicio 5

CREATE OR REPLACE VIEW recursos_de_musica  as select r.* from recurso r where r.nombre_formato = 'MP3';

INSERT INTO recursos_de_musica  (codigo,descripcion,nombre_formato, falta) VALUES (8,'Fotografía chula','JPG','01/01/2013');
INSERT INTO recursos_de_musica  (codigo,descripcion,nombre_formato, falta) VALUES (9,'Fotos inédito ','JPG','01/02/2013');
INSERT INTO recursos_de_musica  (codigo,descripcion,nombre_formato, falta) VALUES (10,'Día en el Zoo','MPEG4','01/03/2012');

COMMIT;

select * from recursos_de_musica;

-- No salen ya que con son MP3 (lógico)

SELECT * FROM recurso;

-> Si salen, por tanto a traves de la vista  recursos_de_musica he conseguido meter rursos que no son MP3. 
-> La solucion sería creandola con with check option

CREATE OR REPLACE VIEW recursos_de_musica  as select r.* from recurso r where r.nombre_formato = 'MP3' with check option;

--si intento hacer un insert ahora que no sea MP3 sale 

-- ORA-01402: violación de la cláusula WHERE en la vista WITH CHECK OPTION



-- Ejercicio 6

-- Desde la sesión INVITADO

SELECT * FROM dbdm_xxxx.recurso;

-- Falla, ya que no tenemos permisos para realizar SELECT sobre esa tabla del usuario propietario.

-- Ejercicio 7

GRANT SELECT ON RECURSO TO invitado_dbdm_xxxx;

-- Desde la sesión del INVITADO, ejecutamos

SELECT * FROM dbdm_xxxx.recurso;

-- Ahora sí podemos ver todas las columnas y filas de la tabla RECURSO del propietario

-- Ejercicio 8

REVOKE SELECT ON RECURSO FROM invitado_dbdm_xxxx;

-- Ejercicio 9

EXPLAIN PLAN SET statement_id='SIN_INDICE' FOR SELECT * FROM RECURSO WHERE FALTA < '01/01/2013';
SELECT STATEMENT_ID,OPERATION,OPTIONS,OBJECT_NAME,POSITION FROM PLAN_TABLE;


(tambien boton de la derecha encima de la select y opcion "explicar")

-- Ejerciciio 10

CREATE INDEX IND_RECURSO_FALTA ON RECURSO(FALTA);

-- Ejercicio 11

EXPLAIN PLAN SET statement_id='CON_INDICE' FOR SELECT * FROM RECURSO WHERE FALTA < '01/01/2013';
SELECT STATEMENT_ID,OPERATION,OPTIONS,OBJECT_NAME,POSITION FROM PLAN_TABLE;

-- Ejercicio 12

-- En el primer caso haría una búsqueda secuencial por todas las filas, y en la segunda
-- utilizaría el índice que hemos creado.
