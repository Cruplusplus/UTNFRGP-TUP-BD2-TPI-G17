# Sistema de Gestión de Gimnasio y Club - TPI

## Descripción del Sistema
Este proyecto consiste en el diseño e implementación de una base de datos relacional para un **Sistema de Gestión de Gimnasio y Club de Alto Rendimiento**. El sistema está desarrollado sobre **SQL Server en Docker** como parte de la materia **Base de Datos II** de la Tecnicatura Universitaria en Programación (TUP) en la **Universidad Tecnológica Nacional - Facultad Regional General Pacheco (UTN FRGP)**.

[cite_start]El objetivo principal es resolver la problemática operativa y logística de un complejo deportivo a gran escala[cite: 519], permitiendo administrar de forma eficiente:
* [cite_start]**Identidad unificada de Personas:** Control centralizado de datos personales evitando redundancias, clasificando mediante roles si corresponden a socios, empleados o ambos en simultáneo[cite: 648, 649, 670].
* [cite_start]**Gestión de Recursos Humanos (Empleados y Roles):** Administración de todo el personal del club (profesores, administrativos, recepción, limpieza) bajo un esquema escalable basado en roles específicos[cite: 670, 671].
* [cite_start]**Control Financiero (Membresías y Pagos):** Seguimiento unívoco de los contratos de membresías activos, su historial de renovaciones y el procesamiento de pagos utilizando tipos de datos precisos para auditorías monetarias[cite: 657, 658, 659].
* [cite_start]**Logística de Actividades (Clases e Inscripciones):** Cronograma dinámico de actividades con control automatizado de cupos máximos y disponibles en tiempo real[cite: 600, 602].

---

## Modelo de Datos y Arquitectura
[cite_start]El sistema implementa una arquitectura relacional normalizada en **Tercera Forma Normal (3FN)** [cite: 624, 698][cite_start], diseñada estratégicamente para garantizar la máxima integridad referencial y performance en consultas complejas[cite: 697, 719].

### Decisiones Clave de Diseño Técnico
1.  [cite_start]**Generalización/Especialización (Herencia):** Se implementó la tabla madre `Personas` vinculada en relaciones `1:1` con `Socios` y `Empleados`[cite: 690]. [cite_start]Esto permite optimizar el almacenamiento de datos de contacto y resolver la condición de negocio donde un empleado es también socio del establecimiento[cite: 649, 691].
2.  [cite_start]**Estrategia de Claves Subrogadas e Índices Compuestos:** En la tabla intermedia `SocioMembresias` se optó por una clave primaria artificial (`IDSocioMembresia`) para agilizar los cruzamientos (`JOINs`) y mejorar la mantenibilidad del código[cite: 717, 719]. [cite_start]Para blindar la integridad del negocio y evitar cargas incoherentes o planes solapados, se aplicó una restricción de unicidad mediante un `CONSTRAINT UNIQUE` compuesto sobre `(IDSocio, IDMembresia, FechaInicio)`[cite: 718, 720].
3.  [cite_start]**Precisión Financiera:** Todos los campos referentes a flujos de dinero (`Precio` en membresías y `Monto` en pagos) están configurados estrictamente con el tipo de dato `MONEY` nativo de SQL Server[cite: 659].

---

## Requisitos Técnicos Implementados
[cite_start]Para satisfacer los requisitos mínimos exigidos por la cátedra, el sistema incluye los siguientes objetos de base de datos distribuidos en archivos independientes dentro del repositorio[cite: 523, 549, 550]:

* [cite_start]**Vistas (Mínimo 3):** Enfocadas en reportes críticos de administración, presentismo y popularidad de actividades[cite: 560].
* **Procedimientos Almacenados (Mínimo 2):**
    * [cite_start]*De Reporte (Parametrizado):* Extracción automatizada de asistencias e historiales de socios[cite: 563].
    * [cite_start]*De Acción:* Procesamiento transaccional de pagos y actualización de vigencias[cite: 564].
* **Triggers (Mínimo 2):**
    * [cite_start]`AFTER INSERT`: Automatización del descuento del cupo disponible al inscribir un socio a una clase[cite: 565].
    * [cite_start]`AFTER DELETE`: Devolución inmediata del cupo disponible ante la cancelación de una reserva[cite: 566].

---

## Estructura del Repositorio
[cite_start]Siguiendo las recomendaciones del profesor para una correcta gestión del proyecto[cite: 523], el código SQL está modularizado de la siguiente manera:

```text
├── README.md                  # Descripción general y documentación del TPI
├── SQL_Scripts
│   ├── 01_Creacion.sql        # Script de inicialización y estructura de tablas (DDL)
│   ├── 02_Datos.sql           # Carga de datos maestros e históricos de prueba (DML)
│   ├── 03_Vistas.sql          # Definición de las 3 vistas requeridas
│   ├── 04_Procedimientos.sql   # Lógica programada de reportes y acciones transaccionales
│   └── 05_Triggers.sql        # Automatizaciones de cupos e integridad mediante disparadores
└── Documentacion
    └── TPI_Gimnasio_DER.pdf    # Diagrama de Entidad-Relación exportado