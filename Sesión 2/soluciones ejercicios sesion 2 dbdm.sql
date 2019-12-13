-- Si quieres limpiar la base de datos antes de probar los ejercicios
-- ejecuta las cinco sentencias que siguen


DROP TABLE LO_CONDUCE;
DROP TABLE AUTOBUSES;
DROP TABLE SALARIOS;   
DROP TABLE CONDUCTORES;
DROP TABLE PLAZAS_PARKING;

-- Ejercicio 1


CREATE TABLE PLAZAS_PARKING (clave VARCHAR2(256) CONSTRAINT PK_clave PRIMARY KEY);
CREATE TABLE AUTOBUSES (nombre VARCHAR2(100) CONSTRAINT PK_autobuses PRIMARY KEY, 
                    marca VARCHAR2(100), 
                    clave varchar2(256) NOT NULL,
                    CONSTRAINT UK_CLAVE UNIQUE  (CLAVE),
                    CONSTRAINT FK_AUTOBUSES_PLAZAS FOREIGN KEY (CLAVE) REFERENCES PLAZAS_PARKING(CLAVE)
 );
CREATE TABLE CONDUCTORES (dni VARCHAR2(9) CONSTRAINT PK_CONDUCTORES PRIMARY KEY, nombre VARCHAR2(100) NOT NULL, antiguedad INTEGER);
CREATE TABLE LO_CONDUCE (conductor VARCHAR2(9),  fecha DATE NOT NULL , CONSTRAINT PK_LO_CONDUCE PRIMARY KEY (conductor),CONSTRAINT FK_LO_CONDUCE_CONDUCTORES FOREIGN KEY (conductor) REFERENCES CONDUCTORES(dni));
CREATE TABLE SALARIOS (codigo VARCHAR2(50), nombre VARCHAR2(100), fecha_alta date, salario_fijo number(6,2), salario_complementos number(6,2),   CONSTRAINT PK_SALARIOS PRIMARY KEY (codigo));

-- Ejercicio 2

ALTER TABLE CONDUCTORES MODIFY nombre  NULL;

 
ALTER TABLE LO_CONDUCE ADD NOMBRE_AUTOBUS VARCHAR2(10) CONSTRAINT FK_LO_CONDUCE_AUTOBUS  REFERENCES AUTOBUSES;

ALTER TABLE LO_CONDUCE drop constraint PK_LO_CONDUCE;
ALTER TABLE LO_CONDUCE ADD (CONSTRAINT PK_LO_CONDUCE primary  key(conductor, nombre_autobus ));

ALTER TABLE SALARIOS ADD conductor VARCHAR2(9) CONSTRAINT FK_SALARIOS_CONDUCTORES REFERENCES CONDUCTORES;

-- Ejercicio 3

-- Tabla PLAZAS_PARKING

INSERT INTO PLAZAS_PARKING(Clave) VALUES ('PLAZA 1');
INSERT INTO PLAZAS_PARKING(Clave) VALUES ('PLAZA 2');
INSERT INTO PLAZAS_PARKING(Clave) VALUES ('PLAZA 3');
INSERT INTO PLAZAS_PARKING(Clave) VALUES ('PLAZA 4');
INSERT INTO PLAZAS_PARKING(Clave) VALUES ('PLAZA 5');

-- Tabla AUTOBUSES

INSERT INTO AUTOBUSES(nombre, marca, clave) VALUES ('Autob�s 1','Mercedes', 'PLAZA 1');
INSERT INTO AUTOBUSES(nombre, marca, clave) VALUES ('Autob�s 2','Ir�zar','PLAZA 2');
INSERT INTO AUTOBUSES(nombre, marca, clave) VALUES ('Autob�s 3','Renault','PLAZA 3');
INSERT INTO AUTOBUSES(nombre, marca, clave) VALUES ('Autob�s 4','Ir�zar','PLAZA 4');

-- Tabla CONDUCTORES

INSERT INTO CONDUCTORES (dni, nombre, antiguedad) VALUES ('11111111A','Juan Garc�a',5);
INSERT INTO CONDUCTORES (dni, nombre, antiguedad) VALUES ('22222222B','Pedro P�rez',1);
INSERT INTO CONDUCTORES (dni, nombre, antiguedad) VALUES ('33333333C','Diego S�nchez',10);
INSERT INTO CONDUCTORES (dni, nombre, antiguedad) VALUES ('44444444D','Ra�l Mart�nez',25);

-- Tabla LO_CONDUCE

INSERT INTO LO_CONDUCE (nombre_autobus, conductor, fecha) VALUES ('Autob�s 1','11111111A',to_date('01/01/2017','dd/mm/yyyy'));
INSERT INTO LO_CONDUCE (nombre_autobus, conductor, fecha) VALUES ('Autob�s 2','11111111A',to_date('02/01/2017','dd/mm/yyyy'));
INSERT INTO LO_CONDUCE (nombre_autobus, conductor, fecha) VALUES ('Autob�s 2','22222222B',to_date('01/01/2017','dd/mm/yyyy'));
INSERT INTO LO_CONDUCE (nombre_autobus, conductor, fecha) VALUES('Autob�s 3','33333333C',to_date('02/02/2013','dd/mm/yyyy'));

-- Tabla RECURSO

INSERT INTO SALARIOS (codigo, nombre, conductor, fecha_alta, salario_fijo, salario_complementos) VALUES ('S01', 'Salario base', '11111111A',to_date('01/01/2013','dd/mm/yyyy'),1200.50,500);
INSERT INTO SALARIOS (codigo, nombre, conductor, fecha_alta, salario_fijo, salario_complementos) VALUES ('S02', 'Antig�edad', '11111111A',to_date('01/04/2016','dd/mm/yyyy'),200.30,20.25);
INSERT INTO SALARIOS (codigo, nombre, conductor, fecha_alta, salario_fijo, salario_complementos) VALUES ('S03', 'Desplazamiento', '11111111A',to_date('01/01/2016','dd/mm/yyyy'),50.50,0);
INSERT INTO SALARIOS (codigo, nombre, conductor, fecha_alta, salario_fijo, salario_complementos) VALUES ('S04', 'Incentivos','11111111A', to_date('01/10/2015','dd/mm/yyyy'),60.25,30.50);

-- Ejercicio 4

CREATE TABLE CONDUCIENDO(cod_autobus VARCHAR2(100) CONSTRAINT PK_CONDUCIENDO PRIMARY KEY, notas VARCHAR2(150), supervisor VARCHAR2(100), pasajeros INTEGER);

-- Ejercicio 5

-- a)

DROP TABLE AUTOBUSES;

-- No nos permite borrarla, porque la integridad referencial nos lo impide. La tabla LO_CONDUCE tiene una clave ajena hacia AUTOBUSES.

-- b)

DROP TABLE CONDUCIENDO;

-- S� permite borrarla, ya que es una tabla independiente.

-- Ejercicio 6

DELETE SALARIOS WHERE nombre like '%base%';

-- Ejericio 7

UPDATE AUTOBUSES SET marca='Ir�zar' WHERE nombre='Autob�s 3';

-- Ejercicio 8

-- La sentencia ALTER TABLE sirve para modificar la estructura de las tablas, y la sentencia UPDATE para modificar la informaci�n de ellas, es decir,
-- datos de filas ya existentes. Aunque ambas sirven para modificar cosas, el significado de su ejecuci�n es totalmente distinto.

-- Ejercicio 9

CREATE TABLE EJERCICIO9 (col1 VARCHAR2(4) DEFAULT 'COL1' NULL,col2 VARCHAR2(4) NULL, col3 VARCHAR2(4) DEFAULT 'COL3' NOT NULL, col4 VARCHAR2(4) NOT NULL); 

-- En todos los casos supondremos que la sentencia de inserci�n es correcta para el resto de columnas.

-- INSERCI�N DE NULL

-- Si insertamos un NULO en la col1, el SGBD incluir� el valor NULL, ya que estamos forzando que se inserte ese valor. No tomar� el valor por defecto.
-- Si insertamos un NULO en la col2, el SGBD incluir� un NULO en esa fila por la misma raz�n que para col1, aunque �ste no tiene valor por defecto.
-- En ning�n caso podremos insertar nulos en las filas definidas como NOT NULL. Esto es en la col3 y col 4. La raz�n es obvia: est�n definidas para que no los admitan.

-- INSERCI�N DE DEFAULT

INSERT INTO EJERCICIO9(COL1,COL2,COL3,COL4) VALUES(DEFAULT, DEFAULT,DEFAULT,'DEFA');

-- El resultado es:    COL1,NULL,COL3,DEFA
-- En la col1 pondr� el valor COL1 porque tiene definida esa cadena por defecto.
-- En la col2 pondr� un nulo, porque no tiene valor por defecto.
-- En la col3 pondr� COL3, porque no tiene valor definido por defecto (caso similar al de col1).
-- En la col4 pondr� la cadena 'DEFA', ya que es el que le hemos puesto al no admitir nulos y no tener valor por defecto asignado. Lo hacemos as� para que no d� fallo la senencia insert.

-- NO PONIENDO VALOR A LA COLUMNA

-- Si no ponemos valor para la col1, el SGBD incluir� autom�ticamente el valor 'COL1', tal como est� definido en la restricci�n DEFAULT.
-- Si no ponemos valor para la col2, el SGBD incluir� un NULO en esa fila, ya que no hay definida restricci�n DEFAULT y adem�s la columna admite nulos.
-- Si no ponemos valor para la col3, el SGBD incluir� autom�ticamente el valor 'COL3', tal como est� definido en la restricci�n DEFAULT.
-- Si no ponemos valor para la col4, el SGBD nos dar� un error, y no nos dejar� insertar. El motivo es que al no haber valor, intenta insertar un NULL, y como esa columna no los admite
-- falla la sentencia

-- EJERCICIO 10

DROP TABLE EJERCICIO9;


-- EJERCICIO 11

insert into AUTOBUSES (nombre, marca, clave ) values ('PRUEBA','PRUEBA','PLAZA 5');

select * from AUTOBUSES;

-> S� que aparece

rollback;

select * from AUTOBUSES;
-> Ya no aparece pues la transacci�n ha sido anulada 


-- EJERCICIO 12

grant select on AUTOBUSES to dbdm_micompa�ero

insert into AUTOBUSES (nombre, marca, clave ) values ('PRUEBA','PRUEBA','PLAZA 5');

select * from AUTOBUSES;

-- > A ti s� debe salirte

-- Tu compa�ero ejecuta 

select * from dbdm_miusuario.AUTOBUSES

--> Y no le sale (l�gico, al no haberse producido el commit)

--> T� ejecutas el commit
commit;

--> A tu compa�ero ya le sale



