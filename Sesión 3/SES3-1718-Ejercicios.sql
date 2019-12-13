
-- EJERCICIO 1

create table claves (
    clave varchar2(256),
    constraint pk_claves primary key (clave)
);

create table visor (
    nombre varchar2(100),
    empresa varchar2(100),
    clave varchar2(256) not null,
    constraint pk_visor primary key (nombre),
    constraint uk_clave unique (clave),
    constraint fk_clave foreign key (clave) references claves
);

create table formato (
    nombre varchar2(10),
    descrip varchar2(100) not null,
    anyo integer,
    constraint pk_formato primary key (nombre)
);

create table se_visualiza_con (
    nombre_visor varchar2(100),
    nombre_formato varchar2(10),
    codec varchar2(100) not null,
    constraint pk_se_visualiza_con primary key (nombre_visor,nombre_formato),
    constraint fk_nombre_visor foreign key (nombre_visor) references visor,
    constraint fk_nombre_formato foreign key (nombre_formato) references formato
);

create table recurso (
    codigo varchar2(50),
    descrip varchar2(100),
    falta date default sysdate,
    tamanyo number(8,2),
    tiempo_des number(8,2),
    nombre_formato varchar2(10) not null,
    constraint pk_recurso primary key (codigo),
    constraint fk_nombre_formato2 foreign key (nombre_formato) references formato
);

create table recurso_gratuito (
    codigo varchar2(50),
    constraint pk_recurso_gratuito primary key (codigo),
    constraint fk_codigo foreign key (codigo) references recurso
);

create table recurso_pago (
    codigo varchar2(50),
    precio number(10,2) not null,
    constraint pk_recurso_pago primary key (codigo),
    constraint fk_codigo2 foreign key (codigo) references recurso
);



-- EJERCICIO 2

insert into claves values ('ABCD');
insert into claves values ('EFGH');
insert into claves values ('IJKL');
insert into claves values ('MNOP');
insert into claves values ('QRST');

insert into visor values ('Internet Explorer','Microsoft','ABCD');
insert into visor values ('Chrome','Google','EFGH');
insert into visor values ('COREL Photoshop','Corel','IJKL');
insert into visor values ('Windows Media Player','Microsoft','MNOP');

insert into formato values ('JPG','Fotografías',1992);
insert into formato values ('MP3','Audio digital',1995);
insert into formato values ('MPEG4','Video digital',1998);
insert into formato values ('MP4','Audio o video digital',1998);

insert into se_visualiza_con values ('Internet Explorer','JPG','IE_JPG.DLL');
insert into se_visualiza_con values ('Chrome','MP3','CH_MP3.DLL');
insert into se_visualiza_con values ('COREL Photoshop','MPEG4','ADOBE_COD.DLL');
insert into se_visualiza_con values ('Windows Media Player','MP4','WIN_CODECS.DLL');

insert into recurso values ('Vídeo1','Corporativo',to_date('01/01/2013','dd/mm/yyyy'),2000,10,'MPEG4');
insert into recurso values ('Vídeo2','Sede',to_date('01/04/2016','dd/mm/yyyy'),20000,100,'MPEG4');
insert into recurso values ('Musica1','Centralita',to_date('01/01/2016','dd/mm/yyyy'),200,5,'MP3');
insert into recurso values ('FOTO1','Paisaje bonito',to_date('01/10/2015','dd/mm/yyyy'),150,3,'JPG');



-- EJERCICIO 3

insert into recurso select codigo,descripcion,falta,tamanyo,tiempo_des,nombre_formato from tabla_temporal;
commit;

insert into recurso_gratuito select codigo from tabla_temporal where tipo='GRATIS';
insert into recurso_pago select codigo,10 from tabla_temporal where tipo='PAGO';
commit;



-- EJERCICIO 4

create or replace view recursos_de_pago as
select r.codigo, descrip, falta,nombre_formato,precio
from recurso r
join recurso_pago rp on (r.codigo=rp.codigo)
where precio >= 5;



-- EJERCICIO 5

create or replace view recursos_de_musica as
select * from recurso where nombre_formato='MP3';

insert into recursos_de_musica values ('8','Fotografía chula',to_date('01/01/2013','dd/mm/yyyy'),400.05,4.05,'JPG');
insert into recursos_de_musica values ('9','Fotos inéditos',to_date('01/02/2013','dd/mm/yyyy'),500.25,5.05,'JPG');
insert into recursos_de_musica values ('10','Día en el zoo',to_date('01/03/2012','dd/mm/yyyy'),5000.99,65.55,'MPEG4');

select * from recursos_de_musica; -- No aparecen las filas insertadas en la vista
select * from recurso; -- Aparecen las filas insertadas en la vista
-- Esto ocurre porque la vista solo filtra los recursos de formato MP3
-- La solución sería creando la vista con la opción with check option para visualizar siempre los insert adecuados



-- EJERCICIO 6

select * from dbdm_acv52.recurso; -- No se ejecuta correctamente



-- EJERCICIO 7

grant all on recurso to invitado_dbdm_acv52;
select * from dbdm_acv52.recurso; -- Se ejecuta correctamente



-- EJERCICIO 8

revoke all on recurso from invitado_dbdm_acv52;
select * from dbdm_acv52.recurso; -- No se ejecuta correctamente



-- EJERCICIO 9

explain plan set statement_id='SIN_INDICE'
for select * from recurso where to_char(falta,'yyyy')<2016;

select statement_id, operation, options, object_name, position
from plan_table
where statement_id='SIN_INDICE';



-- EJERCICIO 10

create index ind_falta_recurso on recurso(falta);



-- EJERCICIO 11

explain plan set statement_id='CON_INDICE'
for select * from recurso where to_char(falta,'yyyy')<2013;

select statement_id, operation, options, object_name, position
from plan_table
where statement_id='CON_INDICE';



-- EJERCICIO 12

-- En el primer caso haría una búsqueda secuencial por todas las filas, y en la segunda
-- utilizaría el índice que hemos creado.